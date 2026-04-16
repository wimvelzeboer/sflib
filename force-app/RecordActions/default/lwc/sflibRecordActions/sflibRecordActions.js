/**
 * SflibRecordActions LWC Component
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
import {RefreshEvent} from 'lightning/refresh';

export default class SflibRecordActions extends LightningElement {

    /**
     * The Icon name used in the UI
     * @param value {string}
     * @public
     */
    @api
    set iconName(value) {
        if (value === undefined) {
            this._iconName = 'custom:custom9';
        } else {
            this._iconName = value;
        }
    }

    /**
     * Returns the Icon name used in the UI
     * @public
     * @returns {string}
     */
    get iconName() {
        return this._iconName;
    }

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
     * The title used in the UI
     *
     * @type {string}
     * @public
     */
    @api
    set title(value) {
        if (value === undefined) {
            this._title = 'Actions';
        } else {
            this._title = value;
        }
    }

    /**
     * Returns the title used in the UI
     * @returns {string}
     * @public
     */
    get title() {
        return this._title;
    }

    /**
     * The variant of how the actions are displayed
     * @type {'list'|'tiles'}
     * @public
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
     * A list of `sflib_RecordAction.Id` values
     * @type {String[]}
     */
    actionIds = [];

    /**
     * The Icon name used in the UI
     * @type {string}
     * @private
     */
    _iconName = 'custom:custom9';

    /**
     * The title used in the UI
     * @type {string}
     * @private
     */
    _title = 'Actions';

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
    caseRecord({error, data}) {
        if (error) {
            console.error(error);
        }
        if (data) {
            // reload actions whenever the record changes
            this.loadActions();
        }
    }

    /**
     * Handles the change event from the child component
     * @param event
     */
    handleActionStatusChange(event) {
        this.dispatchEvent(new RefreshEvent());
    }

    /**
     * Loads the actions for the record
     */
    loadActions() {
        getActions({idString: this.recordId})
            .then(result => {
                this.actionIds = result;
            })
            .catch(error => {
                console.log(error);
            });
    }
}