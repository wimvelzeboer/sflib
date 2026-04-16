/**
 * sflib_RecordActionSettings
 *
 * Data Transer Class that hold Record Action Settings
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
 */
public class sflib_RecordActionSettings {
    @AuraEnabled public Boolean historyLog { get; set; }

    /**
     * The implementation replacement for the service,
     */
    private static sflib_RecordActionSettings implementationReplacement;

    /**
     * Runs the query in User Mode, respecting FLS, CRUD & sharing rules
     *
     * @return New instance of the selector
     */
    public static sflib_RecordActionSettings newInstance()
    {
        return (implementationReplacement == null)
                ? new sflib_RecordActionSettings()
                : implementationReplacement;
    }

    /**
     * Class constructor
     * Use the newInstance method for instantiation
     */
    public sflib_RecordActionSettings() {
        this(sflib_RecordActionConfig__c.getInstance());
    }

    /**
     * Class constructor
     * Use the newInstance method for instantiation
     *
     * @param config Instance of sflib_RecordActionConfig__c
     */
    public sflib_RecordActionSettings(sflib_RecordActionConfig__c config) {
        this.historyLog = config.HistoryLog__c ?? false;
    }

    /**
     * Replace the default implementation of the service
     *
     * @param replacement A replacement instance
     *
     * @see sflib_IRecordActionHistorySelector
     */
    public static void replaceWith(sflib_RecordActionSettings replacement)
    {
        sflib_RecordActionSettings.implementationReplacement = replacement;
    }

    /**
     * Gets the setting values
     *
     * @return Returns a cloned instance of itself
     */
    public sflib_RecordActionSettings get() {
        return this.clone();
    }

    /**
     * Saves the configuration to the custom setting sflib_RecordActionConfig__c
     *
     * @return Returns an instance of itself
     */
    public sflib_RecordActionSettings save() {
        sflib_RecordActionConfig__c setting = sflib_RecordActionConfig__c.getInstance();

        if (setting == null) setting = new sflib_RecordActionConfig__c();

        setting.HistoryLog__c = this.historyLog ?? false;

        upsert setting;
        return this;
    }
}