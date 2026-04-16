import {LightningElement} from 'lwc';
import getConfig from '@salesforce/apex/sflib_RecordActionConfigController.getConfig';
import saveConfig from '@salesforce/apex/sflib_RecordActionConfigController.saveConfig';

export default class SflibRecordActionConfig extends LightningElement {

    isLoading = false;

    /**
     * Object that hold all the setting values
     * @type {{historyLog:boolean}}
     */
    settings = {};

    connectedCallback() {
        this.loadConfig();
    }

    async loadConfig() {
        this.isLoading = true;
        getConfig()
            .then(result => {
                this.settings = result;
                this.isLoading = false;
            })
            .catch(error => {
                console.log(error);
                this.isLoading = false;
            });
    }

    get historyLog() {
        return this.settings.historyLog;
    }

    handleHistoryLogChange(event) {
        this.isLoading = true;
        this.settings = { ...this.settings, historyLog: event.target.checked };

        console.log('state:' + JSON.stringify(this.settings));

        saveConfig({settings: this.settings})
            .then(result => {
                console.log('Success');
                this.isLoading = false;
            })
            .catch(error => {
                console.log('Error saving config');
                console.log(error);
                this.isLoading = false;
            });
    }
}