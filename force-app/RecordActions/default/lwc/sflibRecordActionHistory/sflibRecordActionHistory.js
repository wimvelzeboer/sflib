/**
 * SflibRecordActionHistory LWC Modal
 *
 * Modal that lists the record action history for the given record Id
 *
 * @author architect ir. Wilhelmus G.J. Velzeboer
 *
 * Copyright (c), W.G.J. Velzeboer,
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 *   are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above author notice,
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice,
 *      this list of conditions and the following disclaimer in the documentation
 *      and/or other materials provided with the distribution.
 * - Neither the name of the author nor the names of its contributors
 *      may be used to endorse or promote products derived from this software without
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
 * THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 *
 * @example
 * import historyModal from 'c/sflibRecordActionHistory';
 * export default class SflibRecordActions extends LightningElement {
 *     async openModal(event) {
 *         const result = await historyModal.open({
 *             size: 'full',
 *             heading: 'Record Action History',
 *             recordId: this.recordId,
 *         });
 *     }
 * }
 */

import {api, wire} from "lwc";
import LightningModal from 'lightning/modal';
import getHistory from '@salesforce/apex/sflib_RecordActionHistoryController.getHistory';
import getSettings from '@salesforce/apex/sflib_RecordActionConfigController.getConfig';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class SflibRecordActionHistory extends LightningModal {

    /**
     * The record Id for which to show the Record Action history
     */
    @api recordId;

    @api militaryTime = false;

    /**
     * The columns to display in the lightning data table
     * @type {{
     *      label: string,
     *      fieldName: string,
     *      sortable: boolean,
     *      type: string,
     *      typeAttributes: {
     *          day: string,
     *          month: string,
     *          year: string,
     *          hour: string,
     *          minute: string,
     *          second: string,
     *          hour12: boolean},
     *      sortable: boolean}[]}
     */
    columns =[
        {label: 'Action Name', fieldName: 'actionName', sortable: true},
        {
            label: 'Date',
            fieldName: 'createdDate',
            type: 'date',
            typeAttributes: {
                day: '2-digit',
                month: '2-digit',
                year: 'numeric',
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit',
                hour12: false,
            },
            sortable: true,
        },
        {label: 'Status', fieldName: 'status', sortable: true},
        {label: 'User', fieldName: 'userName', sortable: true},
    ];

    /**
     * Holds the history of the record actions
     * @type {sflib_RecordActionHistory[]}
     */
    data = [];

    /**
     * Indicates whether the history is currently being loaded
     * @type {boolean}
     */
    isLoading = true;

    /**
     * The fieldName of the column that is currently sorted
     * @type {string}
     */
    sortedBy = 'createdDate';

    /**
     * The sort direction of the column that is currently sorted
     * @type {string}
     */
    sortedDirection = 'asc';

    /**
     * Holds the settings for the Record Actions feature
     * @type {{
     *      historyLog:boolean,
     *      militaryTime:boolean
     * }}
     * @private
     */
    _settings = {
        historyLog: false
    };

    /**
     * Wires the history list to the component
     * @param error
     * @param data
     */
    @wire(getHistory, {recordIdString: "$recordId"})
    getWiredHistory({error, data}) {
        if (error) {
            console.error(error);
            this.showError(error.body.message);
        }
        if (data) {
            this.data = data;
        }
        this.isLoading = false;
    }

    /**
     * Loads the actions settings
     */
    @wire(getSettings, {})
    getWiredSettings({error, data}) {
        if (error) {
            console.error(error);
        }
        if (data) {
            // reload actions whenever the record changes
            this._settings = data;
            this.rebuildColumns();
        }
    }

    /**
     * Handles the close button click event
     */
    handleCloseClick() {
        this.close();
    }

    /**
     * Handles the sort event of the lightning data table
     * @param event
     */
    handleSort(event) {
        this.sortedBy = event.detail.fieldName;
        this.sortedDirection = event.detail.sortDirection;
        this.sortData(this.sortedBy, this.sortedDirection);
    }

    /**
     * Indicates whether the history has data
     * @return {boolean}
     */
    get hasData() {
        return this.data.length > 0;
    }

    /**
     * Indicates whether the military time format is enabled
     * @return {boolean}
     */
    get isMilitaryTime() {
        return this._settings.militaryTime ?? false;
    }

    /**
     * Re applies the columns based on the settings
     */
    rebuildColumns() {
        this.columns = [
            {label: 'Action Name', fieldName: 'actionName', sortable: true},
            {
                label: 'Date',
                fieldName: 'createdDate',
                type: 'date',
                typeAttributes: {
                    day: '2-digit',
                    month: '2-digit',
                    year: 'numeric',
                    hour: '2-digit',
                    minute: '2-digit',
                    second: '2-digit',
                    // hour12: true,
                    hour12: !this._settings.militaryTime
                },
                sortable: true,
            },
            {label: 'Status', fieldName: 'status', sortable: true},
            {label: 'User', fieldName: 'userName', sortable: true},
        ];
    }

    /**
     * Sorts the data based on the given fieldName and direction
     * @param fieldname
     * @param direction
     */
    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.data));
        let isReverse = direction === 'asc' ? 1 : -1;
        parseData.sort((x, y) => {
            let valX = x[fieldname] ? x[fieldname] : '';
            let valY = y[fieldname] ? y[fieldname] : '';
            return isReverse * ((valX > valY) - (valY > valX));
        });
        this.data = parseData;
    }

    /**
     * Shows an error message
     *
     * @param message
     */
    showError(message) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: message,
                variant: 'error',
                mode: 'sticky'
            })
        );
    }
}