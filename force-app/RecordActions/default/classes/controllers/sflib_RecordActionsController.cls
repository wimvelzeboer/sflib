/**
 * sflib_RecordActionsController
 *
 * Controller for the LWC sflibRecordActions
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
public with sharing class sflib_RecordActionsController {

    /**
     * Gets the Record Action Ids for the given record Id
     *
     * @param idString The record Id
     * @param seeAllRecords if TRUE, Record Action will be displayed without applying the conditions
     *
     * @return Returns the applicable `sflib_RecordAction__c.Id` values
     */
    @AuraEnabled(Cacheable=false)
    public static List<ActionData> getActions(String idString, Boolean seeAllRecords) {
        try {
            final Boolean seeAll = seeAllRecords == true;
            final Id recordId = Id.valueOf(idString);

            sflib_IRecordActions actions = getRecordActions(recordId, seeAll);
            if (actions == null) return new List<ActionData>();

            List<sflib_RecordActionHistory__c> history =
                    sflib_RecordActionSettings.newInstance().highlight ?
                            getHistory(recordId, actions.getRecordIds()) : new List<sflib_RecordActionHistory__c>();

            return getResponse(actions, history);
        } catch (Exception e) {
            AuraHandledException auraHandledException = new AuraHandledException(e.getMessage());
            auraHandledException.setMessage(e.getMessage());
            throw auraHandledException;
        }
    }

    /**
     * Fetch the record history for the provided record id and record action ids
     *
     * @param recordId The record Id
     * @param actionIds The `sflib_RecordAction__c.Id` values
     *
     * @return Returns a list of related history record
     */
    private static List<sflib_RecordActionHistory__c> getHistory(Id recordId, Set<Id> actionIds) {
        return sflib_RecordActionHistorySelector.newElevatedInstance()
                .selectByRecordIdAndActionId(
                        new Set<Id>{recordId},
                        actionIds
                );
    }

    /**
     * Retrieves the applicable record actions
     *
     * @param recordId The record Id
     * @param seeAll if TRUE, Record Action will be displayed without applying the conditions
     *
     * @return Returns the `sflib_RecordAction__c` wrapped in a domain, or null when no actions could be found
     */
    private static sflib_IRecordActions getRecordActions(Id recordId, Boolean seeAll) {

        if (seeAll) {
            return sflib_RecordActions.newInstance(
                    sflib_RecordActionsSelector.newInstance()
                            .selectBySObjectType(new Set<String>{
                                    'User',
                                    recordId.getSobjectType().getDescribe().getName()
                            })
            );
        }

        final Map<Id, sflib_IRecordActions> recordActionsById =
                sflib_RecordActionsService.getActions(new Set<Id>{recordId});

        if (recordActionsById.containsKey(recordId) == false) return null;

        return recordActionsById.get(recordId);
    }

    /**
     * Construct a response for the get request
     *
     * @param actions An instance of `sflib_IRecordActions` containing the action records
     * @param history A list of `sflib_RecordActionHistory__c` records
     *
     * @return Returns a list of ActionData DTOs
     *
     * @see sflib_RecordActionsController.ActionData
     */
    private static List<ActionData> getResponse(sflib_IRecordActions actions, List<sflib_RecordActionHistory__c> history) {
        Map<Id, sflib_RecordActionHistory__c> latestByActionId =
                sflib_RecordActionHistories.newInstance(history)
                        .getLatestByActionId();

        List<ActionData> result = new List<ActionData>();
        for (sflib_RecordAction__c action : actions.getRecordActions()) {
            if (latestByActionId.containsKey(action.Id)) {
                result.add(new ActionData(action, latestByActionId.get(action.Id).Status__c));
            } else {
                result.add(new ActionData(action));
            }
        }
        return result;
    }


    public class ActionData {
        @AuraEnabled public Id actionId { get; set; }
        @AuraEnabled public String actionName { get; set; }
        @AuraEnabled public String state { get; set; }

        public ActionData(sflib_RecordAction__c action) {
            this.actionId = action.Id;
            this.actionName = action.Name;
            this.state = ActionState.IDLE.toString().toLowerCase();
        }

        public ActionData(sflib_RecordAction__c action, String status) {
            this(action);
            switch on status {
                when 'Started' {
                    this.state = ActionState.RUNNING.toString().toLowerCase();
                }
                when 'Completed' {
                    this.state = ActionState.COMPLETED.toString().toLowerCase();
                }
                when 'Failed' {
                    this.state = ActionState.FAILED.toString().toLowerCase();
                }
                when else {
                    this.state = ActionState.IDLE.toString().toLowerCase();
                }
            }
        }
    }

    public enum ActionState {
        IDLE,
        RUNNING,
        COMPLETED,
        FAILED
    }
}