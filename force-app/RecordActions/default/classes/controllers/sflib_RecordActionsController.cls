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
     *
     * @return Returns the applicable `sflib_RecordAction__c.Id` values
     */
    @AuraEnabled(Cacheable=false)
    public static List<ActionData> getActions(String idString)  {
        try {
            final Id recordId = Id.valueOf(idString);
            final Set<Id> recordIds = new Set<Id>{recordId};

            final Map<Id, sflib_IRecordActions> recordActionsById =
                    sflib_RecordActionsService.getActions(recordIds);

            if (recordActionsById.containsKey(recordId) == false) return new List<ActionData>(); // No actions

            List<Id> actionIds = recordActionsById.get(recordId).getRecordIdList();

            List<sflib_RecordActionHistory__c> history =
                    sflib_RecordActionSettings.newInstance().highlight ?
                            getHistory(recordId, actionIds) : new List<sflib_RecordActionHistory__c>();

            return getResponse(actionIds, history);
        } catch (Exception e) {
            AuraHandledException auraHandledException = new AuraHandledException(e.getMessage());
            auraHandledException.setMessage(e.getMessage());
            throw auraHandledException;
        }
    }

    /**
     * Fetch the record history for the provided record id and record action ids
     *
     * @param recordId
     * @param actionIds
     *
     * @return Returns a list of related history record
     */
    private static List<sflib_RecordActionHistory__c> getHistory(Id recordId, List<Id> actionIds) {
        return sflib_RecordActionHistorySelector.newElevatedInstance()
                .selectByRecordIdAndActionId(
                        new Set<Id>{recordId},
                        new Set<Id>(actionIds)
                );
    }

    /**
     * Construct a response for the get request
     * @param actionIds
     * @param history
     *
     * @return Returns a list of ActionData DTOs
     *
     * @see sflib_RecordActionsController.ActionData
     */
    private static List<ActionData> getResponse(List<Id> actionIds, List<sflib_RecordActionHistory__c> history) {
        Map<Id, sflib_RecordActionHistory__c> latestByActionId =
                sflib_RecordActionHistories.newInstance(history)
                        .getLatestByActionId();

        List<ActionData> result = new List<ActionData>();
        for (Id actionId : actionIds) {
            if (latestByActionId.containsKey(actionId)) {
                result.add(new ActionData(actionId, latestByActionId.get(actionId).Status__c));
            } else {
                result.add(new ActionData(actionId));
            }
        }
        return result;
    }


    public class ActionData {
        @AuraEnabled public Id actionId { get; set; }
        @AuraEnabled public String state { get; set; }

        public ActionData(Id actionId) {
            this.actionId = actionId;
            this.state = ActionState.IDLE.toString().toLowerCase();
        }

        public ActionData(Id actionId, String status) {
            this.actionId = actionId;
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