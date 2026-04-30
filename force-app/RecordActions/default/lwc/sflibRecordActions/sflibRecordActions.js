/**
 * SflibRecordActions LWC Component
 *
 * LWC component to display a card containing a list of record actions that can be performed on a record, by invoking a screen-flow.
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
import getSettings from '@salesforce/apex/sflib_RecordActionConfigController.getConfig';
import hasAdminPermission from '@salesforce/customPermission/sflib_RecordActionAdmin';
import historyModal from 'c/sflibRecordActionHistory';
import {NavigationMixin} from 'lightning/navigation';
import {ShowToastEvent} from "lightning/platformShowToastEvent";

export default class SflibRecordActions extends NavigationMixin(LightningElement) {

    /**
     * The Icon name used in the UI
     * @param value {string}
     * @default `custom:custom9`
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
     * @default `Actions`
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
     * @default 'list'
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
     * Show a search bar at the top of the component to filter the actions,
     * @default false, which shows only a search icon in the card actions slot
     * @param value {boolean}
     * @public
     */
    @api
    set showSearch(value) {
        this._enableSearch = value === true;
    }

    get showSearch() {
        return this._enableSearch;
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
     * See all actions, unrelated to the conditions
     * @type {boolean}
     */
    seeAll = false;

    /**
     * Show a search bar at the top of the component to filter the actions,
     * @param value {boolean}
     * @private
     */
    _enableSearch = false;

    /**
     * The Icon name used in the UI
     * @type {string}
     * @private
     */
    _iconName = 'custom:custom9';

    /**
     * Holds the settings for the Record Actions feature
     * @type {{
     *      highlight:boolean,
     *      historyLog:boolean,
     *      militaryTime:boolean,
     *      seeAll:boolean,
     * }}
     * @private
     */
    _settings = {
        highlight: false,
        historyLog: false,
        militaryTime: false,
        seeAll: false,
    };

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
     * Loads the actions settings
     */
    @wire(getSettings, {})
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
     * Returns true if the history log is enabled
     * @return {boolean}
     */
    get historyEnabled() {
        return this._settings.historyLog;
    }

    /**
     * Returns true if the user has the administrator permission for the Record Actions feature
     * @return {boolean}
     */
    get isAdministrator() {
        return hasAdminPermission;
    }

    /**
     * Returns true if the See All is enabled
     * @return {boolean}
     */
    get seeAllEnabled() {
        return this._settings.seeAll;
    }

    /**
     * Returns the name of the see all menu item, toggles between Applicable and All
     * @return {String}
     */
    get seeAllLabel() {
        return this.seeAll === true ? 'See Applicable Actions' : 'See All Actions'
    }

    /**
     * Returns true if the menu needs to be displayed.
     * It shows if the user has the administrator permission for the Record Actions feature
     * or the history log is enabled
     *
     * @return {boolean}
     */
    get showMenu() {
        return this._settings.historyLog || this._settings.seeAll || hasAdminPermission;
    }

    /**
     * Returns true if the search icon should be displayed.
     * @return {boolean}
     */
    get showSearchIcon() {
        return !this._enableSearch;
    }

    /**
     * Handles the click event of the card search icon
     */
    handleSearchToggle() {
        console.log('Toggle search');
        this._enableSearch = !this._enableSearch;
    }

    /**
     * Handles the click event of the show history menu item
     * @return {Promise<void>}
     */
    async handleShowHistory() {
        await historyModal.open({
            size: 'full',
            heading: 'Record Action History',
            recordId: this.recordId,
        });
    }

    /**
     * Handles the click event of the See All menu item
     * @return {Promise<void>}
     */
    async handleSeeAll() {
        this.seeAll = this.seeAll !== true;
    }

    /**
     * Handles the click event of the show settings menu item
     */
    handleShowSettings() {
        this[NavigationMixin.Navigate]({
            type: 'standard__navItemPage',
            attributes: {
                apiName: 'sflib_RecordActionConfig'
            }
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
}