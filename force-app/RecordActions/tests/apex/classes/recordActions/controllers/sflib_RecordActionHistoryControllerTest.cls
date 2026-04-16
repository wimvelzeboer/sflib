/**
 * sflib_RecordActionHistoryController
 *
 * Unit test class for sflib_RecordActionHistoryController
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
 * @see sflib_RecordActionHistoryController
 */
@IsTest
private class sflib_RecordActionHistoryControllerTest {

    @IsTest
    static void itShouldGetHistory() {

        final String recordIdString = fflib_IDGenerator.generate(Schema.sflib_RecordAction__c.SObjectType);
        final Id recordId = Id.valueOf(recordIdString);

        sflib_RecordActionHistory__c record = new sflib_RecordActionHistory__c(
                Id = fflib_IDGenerator.generate(Schema.sflib_RecordActionHistory__c.SObjectType),
                RecordId__c = recordIdString
        );

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        sflib_IRecordActionHistorySelector selectorMock = (sflib_IRecordActionHistorySelector) mocks.mock(sflib_IRecordActionHistorySelector.class);

        mocks.startStubbing();
        mocks.when(selectorMock.selectByRecordId(new Set<Id>{recordId}))
                .thenReturn(new List<sflib_RecordActionHistory__c> {record});
        mocks.stopStubbing();

        sflib_RecordActionHistorySelector.replaceWith(selectorMock);

        System.Test.startTest();
        List<sflib_RecordActionHistoryController.sflib_RecordActionHistory> result =
                sflib_RecordActionHistoryController.getHistory(recordIdString);
        System.Test.stopTest();

        System.Assert.areEqual(1, result.size());
        System.Assert.areEqual(recordIdString, result.get(0).recordId);
    }

    @IsTest
    static void itShouldGetHistory_failing() {

        final String recordIdString = fflib_IDGenerator.generate(Schema.sflib_RecordAction__c.SObjectType);
        final Id recordId = Id.valueOf(recordIdString);

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        sflib_IRecordActionHistorySelector selectorMock = (sflib_IRecordActionHistorySelector) mocks.mock(sflib_IRecordActionHistorySelector.class);
        mocks.startStubbing();
        mocks.when(selectorMock.selectByRecordId(new Set<Id>{recordId}))
                .thenThrow(new DmlException());
        mocks.stopStubbing();
        sflib_RecordActionHistorySelector.replaceWith(selectorMock);

        System.Test.startTest();
        try {
            sflib_RecordActionHistoryController.getHistory(recordIdString);
            System.Assert.fail('Expected an exception, but got none');
        } catch (Exception e) {
            System.Assert.areEqual('Script-thrown exception', e.getMessage());
        }
        System.Test.stopTest();
    }

    @IsTest
    static void itShouldLogHistory() {

        final String recordIdString = fflib_IDGenerator.generate(Schema.Account.SObjectType);

        sflib_RecordAction__c recordAction = new sflib_RecordAction__c(
                FlowName__c = 'Test',
                SObjectType__c = 'Account'
        );
        insert recordAction;

        System.Test.startTest();
        String result =
                sflib_RecordActionHistoryController.logAction(
                        null,
                        recordIdString,
                        (String) recordAction.Id,
                        'Started'
                        );
        System.Test.stopTest();

        sflib_RecordActionHistory__c record = [SELECT Id, RecordId__c FROM sflib_RecordActionHistory__c WHERE Id = :result LIMIT 1];

        System.Assert.isNotNull(record);
        System.Assert.areEqual(recordIdString, record.RecordId__c);
    }

    @IsTest
    static void itShouldLogHistory_failing() {

        sflib_RecordAction__c recordAction = new sflib_RecordAction__c(
                FlowName__c = 'Test',
                SObjectType__c = 'Account'
        );
        insert recordAction;

        System.Test.startTest();
        try {
            sflib_RecordActionHistoryController.logAction(null, null, null, 'Started');
            System.Assert.fail('Expected an exception, but got none');
        } catch (Exception e) {
            System.Assert.areEqual('Argument cannot be null.', e.getMessage());
        }
        System.Test.stopTest();
    }
}