/**
 * SflibRecordActionConfig LWC Component
 *
 * LWC component to display configurable settings used in the the Record Action feature
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
 * @see sflib_RecordActionConfigController
 */
import {LightningElement} from 'lwc';
import getConfig from '@salesforce/apex/sflib_RecordActionConfigController.getConfig';
import saveConfig from '@salesforce/apex/sflib_RecordActionConfigController.saveConfig';

export default class SflibRecordActionConfig extends LightningElement {

    /**
     * Indicates whether the settings are currently being loaded
     * @type {boolean}
     */
    isLoading = false;

    /**
     * Object that hold all the setting values
     * @type {{
     *      historyLog:boolean,
     *      militaryTime:boolean
     * }}
     */
    settings = {};

    /**
     * Loads the settings when the component is done loading
     */
    connectedCallback() {
        this.loadConfig();
    }

    /**
     * Fetch the settings from the backend
     * @return {Promise<void>}
     */
    async loadConfig() {
        this.isLoading = true;
        getConfig()
            .then(result => {
                this.settings = result;
                this.isLoading = false;
            })
            .catch(error => {
                console.error(error);
                this.isLoading = false;
            });
    }

    /**
     * Get the value of the history log setting
     * @return {boolean}
     */
    get historyLog() {
        return this.settings.historyLog;
    }

    /**
     * Get the value of the military time setting
     * @return {boolean}
     */
    get militaryTime() {
        return this.settings.militaryTime;
    }

    /**
     * Handles the change event of the history log setting
     * @param event
     */
    handleHistoryLogChange(event) {
        this.settings = { ...this.settings, historyLog: event.target.checked };
        this.saveSettings();
    }

    /**
     * Handles the change event of the military time setting
     * @param event
     */
    handleMilitaryTimeChange(event) {
        this.settings = { ...this.settings, militaryTime: event.target.checked };
        this.saveSettings();
    }

    /**
     * Saves the settings to the backend
     */
    saveSettings() {
        this.isLoading = true;
        saveConfig({settings: this.settings})
            .then(result => {
                this.isLoading = false;
            })
            .catch(error => {
                console.error(error);
                this.isLoading = false;
            });
    }
}