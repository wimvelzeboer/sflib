/**
 * sflib_RecordActionConditionTriggerAction class
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
 * @see fflib_TriggerAction
 * @see sflib_RecordActionTrigger
 */
public with sharing class sflib_RecordActionTriggerAction extends fflib_TriggerAction {

    public override void onBeforeInsert() {
        sflib_IRecordActions actions = sflib_RecordActions.newInstance(triggerContext.getRecords());
        onStatusActiveAddError(actions);
    }

    public override void onBeforeUpdate() {
        sflib_RecordActionsService.validate((List<sflib_RecordAction__c>) triggerContext.getRecords());
    }

    public override void onAfterUnDelete() {
        sflib_IRecordActions actions = sflib_RecordActions.newInstance(triggerContext.getRecords());
        update actions.setStatus('Draft').getRecords();
    }

    private static void onStatusActiveAddError(sflib_IRecordActions actions) {
        actions.selectByStatus('Active')
                .addErrorMessage(Schema.sflib_RecordAction__c.Status__c, 'Active Record Actions required related conditions');
    }
}