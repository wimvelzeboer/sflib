@IsTest
private class sflib_RecordActionsControllerTest {

    @IsTest
    static void testBehavior() {
        // GIVEN a case record
        final Id recordId = fflib_IDGenerator.generate(Schema.Case.SObjectType);
        final Set<Id> recordIds = new Set<Id>{recordId};

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
        List<String> result = sflib_RecordActionsController.getActions(recordId);
        System.Test.stopTest();

        // THEN we get the list of actions
        System.Assert.isTrue(result.contains(actionIdA));
        System.Assert.isTrue(result.contains(actionIdB));
        System.Assert.isTrue(result.contains(actionIdC));
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
            sflib_RecordActionsController.getActions(recordId);
            System.Assert.fail('Expected an exception');
        } catch (AuraHandledException e) {

        } catch (Exception e) {
            System.Assert.fail('Incorrect exception thrown');
        }
        System.Test.stopTest();
    }
}