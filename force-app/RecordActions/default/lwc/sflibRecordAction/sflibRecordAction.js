/**
 * SflibRecordAction LWC Component
 *
 * LWC component to display a single record action that can be performed on a record, by invoking a screen-flow.
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
 * <c-sflib-record-action
 *      record-id={recordId}
 *      action-id={actionId}
 *      variant="list"
 * ></c-sflib-record-actions>
 */
import {api, LightningElement, wire} from 'lwc';
import {getRecord, getFieldValue} from 'lightning/uiRecordApi';
import getSettings from '@salesforce/apex/sflib_RecordActionConfigController.getConfig';
import logAction from '@salesforce/apex/sflib_RecordActionHistoryController.logAction';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

import DESCRIPTION_FIELD from '@salesforce/schema/sflib_RecordAction__c.Description__c';
import FLOW_FIELD from '@salesforce/schema/sflib_RecordAction__c.FlowName__c';
import ICON_FIELD from '@salesforce/schema/sflib_RecordAction__c.Icon__c';
import NAME_FIELD from '@salesforce/schema/sflib_RecordAction__c.Name';

const FIELDS = [NAME_FIELD, DESCRIPTION_FIELD, ICON_FIELD, FLOW_FIELD];

export default class SflibRecordAction extends LightningElement {

    /**
     * The `sflib_RecordAction__c.Id` value
     *
     * @type {string}
     * @public
     * @required
     */
    @api actionId;

    /**
     * The record Id used while executing the action
     *
     * @type {string}
     * @public
     * @required
     */
    @api recordId;

    /**
     * The variant of how the action is displayed
     * @type {'list'|'tiles'}
     * @public
     * @required
     */
    @api variant;

    /**
     * Indicates whether the description is collapsed
     * @type {boolean}
     */
    collapsed = true;

    /**
     * Indicates whether the description is clamped
     * @type {boolean}
     */
    isClamped = false;

    /**
     * The `sflib_RecordAction__c` record
     * @type {sflib_RecordAction__c}
     */
    record = {};

    /**
     * Indicates whether the modal is shown
     * @type {boolean}
     */
    showModal = false;

    /**
     * Indicates whether the description is truncated and a button to expand is shown
     * @type {boolean}
     */
    showReadMore = false;

    /**
     * The Id of the sflib_RecordActionHistory__c record that is created when the action is executed.
     * @type {string|null}
     * @private
     */
    _actionLogId = null;

    /**
     * Holds the settings for the Record Actions feature
     * @type {{historyLog: boolean}}
     * @private
     */
    _settings = {
        historyLog: false
    };

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
        }
    }

    /**
     * Wires the record to the component
     */
    @wire(getRecord, {recordId: '$actionId', fields: FIELDS})
    wiredRecordAction({error, data}) {
        if (data) {
            this.record = data;
        } else if (error) {
            console.error('Error retrieving account:', error);
        }
    }

    /**
     * Adds a new sflib_RecordActionHistory__c record to the system.
     * The record is created with the current user as the owner.
     * @param status {'Started' | 'Completed' | 'Failed' | 'Cancelled'}
     * @param callback {function} Optional callback function to be executed after the record is created.
     */
    addHistoryLog(status, callback = null) {
        logAction({actionLogId: this._actionLogId, recordId: this.recordId, actionId: this.actionId, status: status})
            .then(result => {
                this._actionLogId = result;
                if (callback !== null) {
                    callback();
                }
            })
            .catch(error => {
                console.error('Error logging action: ' + error);
            });
    }

    /**
     * Returns the description of the action
     * @returns {string|null}
     */
    get description() {
        return this.record ? getFieldValue(this.record, DESCRIPTION_FIELD) : null;
    }

    /**
     * Returns the flow name of the action
     * @returns {string|null}
     */
    get flowName() {
        return this.record ? getFieldValue(this.record, FLOW_FIELD) : null;
    }

    /**
     * Returns the flow variables of the action
     * @returns {Object[]}
     */
    get flowVariables() {
        return [
            {name: 'recordId', type: 'String', value: this.recordId}
        ];
    }

    /**
     * Returns the icon name of the action
     * @returns {string|null}
     */
    get iconName() {
        let result = this.record ? getFieldValue(this.record, ICON_FIELD) : null;
        return result === null || result === undefined ? 'custom:custom9' : result;
    }

    /**
     * Returns true if the variant is tiles
     * @returns {boolean}
     */
    get showTiles() {
        return this.variant === 'tiles';
    }

    /**
     * Returns the title of the action
     * @returns {string|null}
     */
    get title() {
        return this.record ? getFieldValue(this.record, NAME_FIELD) : null;
    }

    /**
     * Handles the click event of the action
     */
    handleClick() {
        let flowName = getFieldValue(this.record, FLOW_FIELD);
        if (flowName === undefined || flowName === null) {
            this.showError('There is no flow assigned to the selected action');
            return;
        }
        this.showMessage('Info', 'info', 'Running flow: ' + flowName);

        if (this._settings.historyLog) {
            this.addHistoryLog('Started', () => this.showModal = true);
        } else {
            this.showModal = true;
        }
    }

    /**
     * Handles the close event of the modal
     */
    handleCloseModal() {
        this.showModal = false;
    }

    /**
     * Handles the flow status change event
     * @param event
     */
    handleFlowStatusChange(event) {
        // Handle flow status changes
        if (event.detail.status === 'FINISHED_SCREEN') {
            this.showMessage('Success', 'success', 'Flow finished successfully');
            this.showModal = false;

            if (this._actionLogId !== undefined && this._actionLogId !== null) {
                this.addHistoryLog('Completed',
                    () => this.publishStatusChange(event.detail.status));
            } else {
                this.publishStatusChange(event.detail.status);
            }
        } else if (event.detail.status === 'ERROR') {
            if (this._actionLogId !== undefined && this._actionLogId !== null) {
                this.addHistoryLog('Failed');
            }
            this.showError(event.detail.errors[0].message);
            this.showModal = false;
        }
    }

    /**
     * Handles the click event of the read more/less button
     */
    handleToggleReadMore() {
        const textElement = this.template.querySelector('.content');
        const button = this.template.querySelector('.read-more-btn');

        if (this.collapsed) {
            // Expand: Remove clamp
            textElement.style.webkitLineClamp = 'none';
            textElement.style.display = 'block'; // Or remove class
            button.textContent = 'Read Less';
            this.collapsed = false;
        } else {
            // Collapse: Re-apply clamp
            textElement.style.webkitLineClamp = '4';
            textElement.style.display = '-webkit-box';
            button.textContent = 'Read More';
            this.collapsed = true;
        }
    }

    /**
     * Publishes the status change event to the parent component
     * @param status
     */
    publishStatusChange(status) {
        const myEvent = new CustomEvent('changestatus', {
            detail: {data: status},
        });
        this.dispatchEvent(myEvent);
    }

    /**
     * Checks if the description is clamped and shows the read more button if needed
     */
    renderedCallback() {
        if (this.isClamped) return; // Prevent re-calculation

        const textElement = this.template.querySelector('.content');
        if (textElement) {
            if (textElement.offsetHeight < textElement.scrollHeight) {
                this.isClamped = true;
                this.showReadMore = true;
            }
        }
    }

    /**
     * Shows an error message
     *
     * @param message
     */
    showError(message) {
        this.showMessage('Error', 'error', message);
    }

    /**
     * Shows a toast message
     *
     * @param title {string}
     * @param variant {'info' | 'success' | 'warning' | 'error'}
     * @param message {string}
     */
    showMessage(title, variant, message) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant,
                mode: 'dismissable'
            })
        );
    }
}