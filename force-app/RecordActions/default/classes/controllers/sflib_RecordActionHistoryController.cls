/**
 * sflib_RecordActionHistoryController
 *
 * Controller for the LWC sflibRecordActionHistory and for generic history functions
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
 * @see sflibRecordActionHistory
 * @see sflibRecordAction
 */
public with sharing class sflib_RecordActionHistoryController {

    /**
     * Gets a list of record action history
     *
     * @param recordIdString The record Id for which to get the history
     *
     * @return Returns a list of sflib_RecordActionHistory DTOs
     *
     * @see sflib_RecordActionHistoryController.sflib_RecordActionHistory
     */
    @AuraEnabled(Cacheable=true)
    public static List<sflib_RecordActionHistory> getHistory(String recordIdString) {
        try {
            Id recordId = Id.valueOf(recordIdString);

            List<sflib_RecordActionHistory> result = new List<sflib_RecordActionHistory>();
            for (sflib_RecordActionHistory__c record :
                    sflib_RecordActionHistorySelector.newInstance()
                            .selectByRecordId(new Set<Id>{
                                    recordId
                            })) {
                result.add(new sflib_RecordActionHistory(record));
            }
            return result;
        } catch (Exception e) {
            AuraHandledException auraHandledException = new AuraHandledException(e.getMessage());
            auraHandledException.setMessage(e.getMessage());
            throw auraHandledException;
        }
    }

    /**
     * Gets a list of record action history
     *
     * @param actionLogId The `sflib_RecordActionHistory__c.Id` value when updating a history record, use null for new records
     * @param recordId The record Id for which to get the history
     * @param actionId The `sflib_RecordAction__c.Id` value of the action to log
     * @param status The (new) status value to store
     *
     * @return Returns a list of sflib_RecordActionHistory DTOs
     *
     * @see sflib_RecordActionHistoryController.sflib_RecordActionHistory
     */
    @AuraEnabled(Cacheable=false)
    public static String logAction(String actionLogId, String recordId, String actionId, String status) {
        try {
            sflib_RecordActionHistory__c record = new sflib_RecordActionHistory__c(
                    Id = String.isNotBlank(actionLogId) ? Id.valueOf(actionLogId) : null,
                    RecordId__c = Id.valueOf(recordId),
                    RecordAction__c = Id.valueOf(actionId),
                    Status__c = status
            );
            upsert record;
            return record.Id;
        } catch (Exception e) {
            AuraHandledException auraHandledException = new AuraHandledException(e.getMessage());
            auraHandledException.setMessage(e.getMessage());
            throw auraHandledException;
        }
    }

    /**
     * Data Transfer Object with the History details
     */
    public class sflib_RecordActionHistory {

        /**
         * The `sflib_RecordAction__c.Id` value that was executed
         */
        @AuraEnabled public Id actionId { get; set; }

        /**
         * The `sflib_RecordAction__c.Name` value
         */
        @AuraEnabled public String actionName { get; set; }

        /**
         * The `User.Id` value of the user that created the history log item
         */
        @AuraEnabled public Id createdById { get; set; }

        /**
         * The created date of the history log item
         */
        @AuraEnabled public Datetime createdDate { get; set; }

        /**
         * The `sflib_RecordActionHistory__c.Id` value
         */
        @AuraEnabled public Id id { get; set; }

        /**
         * The `sflib_RecordActionHistory__c.RecordId__c` value of the record used by the record action
         */
        @AuraEnabled public String recordId { get; set; }

        /**
         * The `sflib_RecordAction__c.Status__c` value
         */
        @AuraEnabled public String status { get; set; }

        /**
         * The name of the the user that created the history log item
         */
        @AuraEnabled public String userName { get; set; }


        /**
         * DTO class constructor
         * @param record The sflib_RecordActionHistory__c used for constructing the DTO
         */
        public sflib_RecordActionHistory(sflib_RecordActionHistory__c record) {
            Security.stripInaccessible(
                    AccessType.READABLE,
                    new List<sflib_RecordActionHistory__c>{ record }
            );
            this.actionId = record.RecordAction__c;
            this.actionName = record.RecordAction__r.Name;
            this.createdById = record.CreatedById;
            this.createdDate = record.CreatedDate;
            this.id = record.Id;
            this.recordId = record.RecordId__c;
            this.status = record.Status__c;
            this.userName = record.CreatedBy.Name;
        }
    }
}