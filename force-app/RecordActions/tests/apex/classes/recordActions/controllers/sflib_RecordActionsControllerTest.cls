/**
 * sflib_RecordActionsControllerTest
 *
 * Unit test class for sflib_RecordActionsController
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
 * @see sflib_RecordActionsController
 */
@IsTest
private class sflib_RecordActionsControllerTest {

    @IsTest
    static void testBehavior() {
        // GIVEN a case record
        final Id recordId = fflib_IDGenerator.generate(Schema.Case.SObjectType);
        final Set<Id> recordIds = new Set<Id>{recordId};
        sflib_RecordActionSettings settings = sflib_RecordActionSettings.newInstance();
        settings.highlight = true;
        sflib_RecordActionSettings.replaceWith(settings);

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        sflib_IRecordActionsService serviceMock = (sflib_IRecordActionsService) mocks.mock(sflib_IRecordActionsService.class);

        final Id actionIdA = fflib_IDGenerator.generate(sflib_RecordAction__c.SObjectType);
        final Id actionIdB = fflib_IDGenerator.generate(sflib_RecordAction__c.SObjectType);
        final Id actionIdC = fflib_IDGenerator.generate(sflib_RecordAction__c.SObjectType);

        mocks.startStubbing();
        mocks.when(serviceMock.getActions(recordIds)).thenReturn(
                new Map<Id, sflib_IRecordActions>{
                        recordId => new sflib_RecordActions(
                                new List<sflib_RecordAction__c>{
                                        new sflib_RecordAction__c(Id = actionIdA),
                                        new sflib_RecordAction__c(Id = actionIdB),
                                        new sflib_RecordAction__c(Id = actionIdC)
                                }
                        )
                });
        mocks.stopStubbing();
        sflib_RecordActionsService.replaceWith(serviceMock);

        // WHEN we want to list the record actions
        System.Test.startTest();
        List<sflib_RecordActionsController.ActionData> result = sflib_RecordActionsController.getActions(recordId, false);
        System.Test.stopTest();

        // THEN we get the list of actions
        System.Assert.areEqual(actionIdA, result.get(0).actionId);
        System.Assert.areEqual(actionIdB, result.get(1).actionId);
        System.Assert.areEqual(actionIdC, result.get(2).actionId);
    }

    @IsTest
    static void testBehavior_failing() {
        // GIVEN a case record
        final Id recordId = fflib_IDGenerator.generate(Schema.Case.SObjectType);
        final Set<Id> recordIds = new Set<Id>{recordId};

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        sflib_IRecordActionsService serviceMock = (sflib_IRecordActionsService) mocks.mock(sflib_IRecordActionsService.class);

        mocks.startStubbing();
        mocks.when(serviceMock.getActions(recordIds)).thenThrow(new DmlException());
        mocks.stopStubbing();
        sflib_RecordActionsService.replaceWith(serviceMock);

        // WHEN we want to list the record actions
        System.Test.startTest();
        try {
            sflib_RecordActionsController.getActions(recordId, false);
            System.Assert.fail('Expected an exception');
        } catch (AuraHandledException e) {

        } catch (Exception e) {
            System.Assert.fail('Incorrect exception thrown');
        }
        System.Test.stopTest();
    }

    @IsTest
    static void testActionData() {
        sflib_RecordActionsController.ActionData actionDataA = new sflib_RecordActionsController.ActionData(
                new sflib_RecordAction__c(
                        Id = fflib_IDGenerator.generate(sflib_RecordAction__c.SObjectType),
                        Name = 'Action A'
                ),
                'Started'
        );
        sflib_RecordActionsController.ActionData actionDataB = new sflib_RecordActionsController.ActionData(
                new sflib_RecordAction__c(
                        Id = fflib_IDGenerator.generate(sflib_RecordAction__c.SObjectType),
                        Name = 'Action B'
                ),
                'Completed'
        );
        sflib_RecordActionsController.ActionData actionDataC = new sflib_RecordActionsController.ActionData(
                new sflib_RecordAction__c(
                        Id = fflib_IDGenerator.generate(sflib_RecordAction__c.SObjectType),
                        Name = 'Action C'
                ),
                'Failed'
        );
        sflib_RecordActionsController.ActionData actionDataD = new sflib_RecordActionsController.ActionData(
                new sflib_RecordAction__c(
                        Id = fflib_IDGenerator.generate(sflib_RecordAction__c.SObjectType),
                        Name = 'Action D'
                ),
                'Idle'
        );

        System.Assert.areEqual(sflib_RecordActionsController.ActionState.RUNNING.toString().toLowerCase(), actionDataA.state);
        System.Assert.areEqual(sflib_RecordActionsController.ActionState.COMPLETED.toString().toLowerCase(), actionDataB.state);
        System.Assert.areEqual(sflib_RecordActionsController.ActionState.FAILED.toString().toLowerCase(), actionDataC.state);
        System.Assert.areEqual(sflib_RecordActionsController.ActionState.IDLE.toString().toLowerCase(), actionDataD.state);
    }
}