/**
 * SflibRecordActions List LWC Component
 *
 * LWC component to display a list of record actions that can be performed on a record, by invoking a screen-flow.
 * Listed actions are filtered based on a configured set of criteria.
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
 * @see SflibRecordAction
 *
 * @example
 * <c-sflib-record-actions
 *      record-id={recordId}
 *      variant="list"
 * ></c-sflib-record-actions>
 */
import {api, LightningElement, wire} from 'lwc';
import getActions from '@salesforce/apex/sflib_RecordActionsController.getActions';
import {getRecord} from "lightning/uiRecordApi";
import getSettings from '@salesforce/apex/sflib_RecordActionConfigController.getConfig';
import {RefreshEvent} from 'lightning/refresh';
import {ShowToastEvent} from "lightning/platformShowToastEvent";

export default class SflibRecordActionList extends LightningElement {

    /**
     * Indicates if the component is still loading
     * @type {boolean}
     * @private
     */
    _isLoading = true;

    /**
     * A unique identifier for a specific record in the system
     *
     * @type {string}
     * @public
     * @required
     */
    // @ts-ignore
    @api recordId;

    /**
     * When See All is enabled all record action will show, unrelated to the conditions
     * @public
     * @required
     * @type {boolean}
     */
    @api
    set seeAll(value) {
        this._seeAll = value === true;
        if (this._isLoading === false) { this.loadActions()}
    }

    get seeAll() {
        return this._seeAll;
    }

    /**
     * Displays the search bar, otherwise an icon os shown to open the search bar
     * @type {boolean}
     */
    @api showSearchBar = false;

    /**
     * The variant of how the actions are displayed
     * @type {'list'|'tiles'}
     * @public
     * @return void
     */
    @api
    set variant(value) {
        if (value === 'tiles') {
            this._variant = 'tiles';
        } else {
            this._variant = 'list';
        }
    }

    /**
     * Returns the variant of how the actions are displayed
     * @returns {string}
     * @public
     */
    get variant() {
        return this._variant;
    }

    /**
     * A list of `sflib_RecordActionsController.ActionData` DTOs
     * @type {{
     *     actionId: string,
     *     state: 'idle'|'running'|'completed'|'failed',
     * }[]}
     */
    actions = [];

    /**
     * The current pagination page
     * @type {number}
     */
    currentPage = 1;

    /**
     * The number of action on each pagination page
     * @type {number}
     */
    pageSize = 6;

    /**
     * The paginated actions displayed in the component
     * @type {{
     *     actionId: string,
     *     state: 'idle'|'running'|'completed'|'failed',
     * }[]}
     */
    paginatedData = [];

    /**
     * The total amount of pagination pages
     * @type {number}
     */
    totalPages = 0;

    /**
     * Holds the visible actions in the UI (source for the pagination)
     * @type {{
     *     actionId: string,
     *     state: 'idle'|'running'|'completed'|'failed',
     * }[]}
     */
    data = [];

    /**
     * Indicates if all actions are visible
     * @type {boolean}
     * @private
     */
    _seeAll = false;

    /**
     * The search term used to filter the actions
     * @type {string}
     * @private
     */
    _searchTerm = '';

    /**
     * The variant of how the actions are displayed
     * @type {string}
     * @private
     */
    _variant = 'list';

    /**
     * Loads the actions when the component is done loading
     */
    @wire(getRecord, {recordId: "$recordId", fields: ['Id']})
    // @ts-ignore
    getWiredRecord({error, data}) {
        if (error) {
            console.error(error);
            this.showError('Error retrieving Record data: ' + error.body.message);
        }
        if (data) {
            // reload actions whenever the record changes
            this.loadActions();
        }
    }

    /**
     * Loads the actions settings
     */
    @wire(getSettings, {})
    // @ts-ignore
    getWiredSettings({error, data}) {
        if (error) {
            console.error(error);
            this.showError('Error retrieving Record Actions settings: ' + error.body.message);
        }
        if (data) {
            // reload actions whenever the record changes
            this._settings = data;
        }
    }

    /**
     * Returns the class name for the c-sflib-record-action component wrapper based on the variant
     * @returns {string}
     */
    get className() {
        return 'slds-col slds-m-bottom_small '
            + (this._variant === 'list' ?
                'slds-size_1-of-1' :
                'slds-small-size_1-of-1 slds-medium-size_1-of-2 slds-large-size_1-of-3');
    }

    /**
     * Checks if the "Next" pagination option should be disabled
     * @return {boolean}
     */
    get isNextDisabled() {
        return this.currentPage === this.totalPages;
    }

    /**
     * Checks if the "Previous" pagination option should be disabled
     * @return {boolean}
     */
    get isPreviousDisabled() {
        return this.currentPage === 1;
    }

    get showPagination() {
        return this.totalPages > 1;
    }

    /**
     * Show a spinner in the component when the component is loading
     * @return {boolean}
     */
    get showSpinner() {
        return this._isLoading;
    }

    /**
     * Handles the change event from the child component
     */
    handleActionStatusChange() {
        this.dispatchEvent(new RefreshEvent());
    }

    /**
     * Show the next page in the pagination
     */
    handleNext() {
        if (this.currentPage < this.totalPages) {
            this.currentPage++;
            this.updatePaginatedData();
        }
    }

    /**
     * Show the previous page in the pagination
     */
    handlePrevious() {
        if (this.currentPage > 1) {
            this.currentPage--;
            this.updatePaginatedData();
        }
    }

    /**
     * Filters the actions based on the search term
     * @param event
     */
    handleSearch(event) {
        this._isLoading = true;
        this._searchTerm = event.target.value.toLowerCase().trim();

        if (this._searchTerm === '') {
            this.data = this.actions;
        } else {
            this.data = this.actions.filter(item => item.actionName.toLowerCase().includes(this._searchTerm));
        }

        this.updatePaginatedData();
        this._isLoading = false;
    }

    /**
     * Loads the actions for the record
     */
    loadActions() {
        this._isLoading = true;
        getActions({idString: this.recordId, seeAllRecords: this._seeAll})
            .then(result => {
                this.actions = result;
                this.data = result;
                this.updatePaginatedData();
                this._isLoading = false;
            })
            .catch(error => {
                console.error(error);
                this.showError('Error retrieving Record Actions: ' + error.body.message);
            });
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

    /**
     * Updates the paginated data that is displayed in the UI
     */
    updatePaginatedData() {
        this.totalPages = Math.ceil(this.data.length / this.pageSize);
        const start = (this.currentPage - 1) * this.pageSize;
        const end = start + this.pageSize;
        this.paginatedData = this.data.slice(start, end);
    }

}