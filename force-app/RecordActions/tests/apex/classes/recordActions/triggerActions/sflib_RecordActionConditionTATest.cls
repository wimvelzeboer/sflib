/**
 * sflib_RecordActionConditionTATest class
 *
 * Unit test class for the sflib_RecordActionConditionTriggerAction class
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
 * @see sflib_RecordActionConditionTriggerAction
 */
@IsTest
private class sflib_RecordActionConditionTATest {

    @IsTest
    static void itShouldCheckForUniqueNumbers() {

        final Id recordActionId = fflib_IDGenerator.generate(sflib_RecordAction__c.SObjectType);
        sflib_RecordActionCondition__c recordA = generateRecordActionCondition(recordActionId, 1);
        sflib_RecordActionCondition__c recordB = generateRecordActionCondition(recordActionId, 2);
        List<sflib_RecordActionCondition__c> records = new List<sflib_RecordActionCondition__c>{recordA, recordB};

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        sflib_IRecordActionConditionsSelector selectorMock = (sflib_IRecordActionConditionsSelector) mocks.mock(sflib_IRecordActionConditionsSelector.class);

        mocks.startStubbing();
        mocks.when(selectorMock.selectByRecordActionId(new Set<Id>{recordActionId}))
                .thenReturn(records);
        mocks.stopStubbing();
        sflib_RecordActionConditionsSelector.replaceWith(selectorMock);

        fflib_TriggerContext triggerContext = new fflib_TriggerContext(records);
        triggerContext.triggerOperation = TriggerOperation.AFTER_INSERT;
        sflib_RecordActionConditionTriggerAction triggerAction = new sflib_RecordActionConditionTriggerAction();
        triggerAction.setContext(triggerContext);

        System.Test.startTest();
        triggerAction.doWork();
        System.Test.stopTest();

        System.Assert.isTrue(recordA.getErrors().isEmpty(), 'Did not expect DML error, but got some');
    }

    @IsTest
    static void itShouldCheckForUniqueNumbers_failing() {

        final Id recordActionId = fflib_IDGenerator.generate(sflib_RecordAction__c.SObjectType);
        sflib_RecordActionCondition__c recordA = generateRecordActionCondition(recordActionId, 1);
        sflib_RecordActionCondition__c recordB = generateRecordActionCondition(recordActionId, 1);
        List<sflib_RecordActionCondition__c> records = new List<sflib_RecordActionCondition__c>{recordA, recordB};

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        sflib_IRecordActionConditionsSelector selectorMock = (sflib_IRecordActionConditionsSelector) mocks.mock(sflib_IRecordActionConditionsSelector.class);

        mocks.startStubbing();
        mocks.when(selectorMock.selectByRecordActionId(new Set<Id>{recordActionId}))
                .thenReturn(records);
        mocks.stopStubbing();
        sflib_RecordActionConditionsSelector.replaceWith(selectorMock);

        fflib_TriggerContext triggerContext = new fflib_TriggerContext(records);
        triggerContext.triggerOperation = TriggerOperation.AFTER_UPDATE;
        sflib_RecordActionConditionTriggerAction triggerAction = new sflib_RecordActionConditionTriggerAction();
        triggerAction.setContext(triggerContext);

        System.Test.startTest();
        triggerAction.doWork();
        System.Test.stopTest();

        System.Assert.isFalse(recordA.getErrors().isEmpty(), 'Expected DML errors, but got none');
    }

    private static sflib_RecordActionCondition__c generateRecordActionCondition(Id recordActionId, Decimal conditionNumber) {
        return new sflib_RecordActionCondition__c(
                Id = fflib_IDGenerator.generate(sflib_RecordActionCondition__c.SObjectType),
                RecordAction__c = recordActionId,
                Number__c = conditionNumber
        );
    }
}