/**
 * sflib_RecordActionConfigController
 *
 * Controller for the LWC sflibRecordAction Custom Settings
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
 * @see sflib_RecordActions
 */
public with sharing class sflib_RecordActionConfigController {

    @AuraEnabled(Cacheable=true)
    public static RecordActionSettings getConfig() {
        sflib_RecordActionConfig__c settings = sflib_RecordActionConfig__c.getInstance();
        RecordActionSettings result = new RecordActionSettings();
        result.historyLog = settings.HistoryLog__c ?? false;
        return result;
    }

    @AuraEnabled
    public static void saveConfig(RecordActionSettings settings) {
        sflib_RecordActionConfig__c cfg = sflib_RecordActionConfig__c.getInstance();
        if (cfg == null) {
            cfg = new sflib_RecordActionConfig__c();
        }

        cfg.HistoryLog__c = settings.historyLog;

        upsert cfg;
    }

    public class RecordActionSettings {
        @AuraEnabled public Boolean historyLog { get; set; }
    }
}
