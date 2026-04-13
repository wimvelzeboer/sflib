/**
 * sflib_RecordActionsService test class
 *
 * This class tests the implementation of sflib_RecordActionsServiceImpl
 *
 * @see sflib_RecordActionsServiceImpl
 */
@IsTest
private class sflib_RecordActionsServiceImplTest
{
    /**
     * Tests Record Actions with two case records to see if:
     * - the first record has one action
     * - the second record has two actions in the right order
     */
    @IsTest
    static void itShouldReturnRecordActions() {
        // GIVEN two record Ids of a new case and an open case record
        final Id caseIdA = fflib_IDGenerator.generate(Case.SObjectType);
        final Id caseIdB = fflib_IDGenerator.generate(Case.SObjectType);
        final Set<Id> caseIds = new Set<Id>{caseIdA, caseIdB};

        // GIVEN three actions
        // - one for new cases
        // - two for open case records
        sflib_RecordAction__c action1 = generateRecordAction('Action 1', Schema.Case.SObjectType, '1');
        sflib_RecordAction__c action2 = generateRecordAction('Action 2', Schema.Case.SObjectType, '1');
        sflib_RecordAction__c action3 = generateRecordAction('Action 3', Schema.Case.SObjectType, '1');
        action2.Order__c = 2;
        action3.Order__c = 1;

        sflib_RecordActionCondition__c condition1 = generateRecordActionCondition(1, 'TEXT(Status) = "New"', action1, Schema.Case.SObjectType);
        sflib_RecordActionCondition__c condition2 = generateRecordActionCondition(1, 'TEXT(Status) = "Open"', action2, Schema.Case.SObjectType);
        sflib_RecordActionCondition__c condition3 = generateRecordActionCondition(1, 'TEXT(Status) = "Open"', action3, Schema.Case.SObjectType);

        // Relate conditions to actions
        List<sflib_RecordAction__c> actions = (List<sflib_RecordAction__c>) fflib_ApexMocksUtils.makeRelationship(
                List<sflib_RecordAction__c>.class,
                new List<sflib_RecordAction__c>{ action1, action2, action3 },
                sflib_RecordActionCondition__c.RecordAction__c,
                new List<List<sflib_RecordActionCondition__c>>{
                    new List<sflib_RecordActionCondition__c>{ condition1 },
                    new List<sflib_RecordActionCondition__c>{ condition2 },
                    new List<sflib_RecordActionCondition__c>{ condition3 }
                }
        );
        action1 = actions.get(0);
        action2 = actions.get(1);
        action3 = actions.get(2);

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        sflib_IRecordActionsSelector actionsSelectorMock = (sflib_IRecordActionsSelector) mocks.mock(sflib_IRecordActionsSelector.class);
        fflib_SObjectsSelector selectorMock = (fflib_SObjectsSelector) mocks.mock(fflib_SObjectsSelector.class);

        mocks.startStubbing();
        mocks.when(actionsSelectorMock.selectBySObjectType(new Set<String> {'Case', 'User'}))
                .thenReturn(new List<sflib_RecordAction__c> {action1, action2, action3});

        mocks.when(selectorMock.selectById(new Set<Id>{ caseIdA, caseIdB}))
                .thenReturn(new List<Case> {
                        new Case(Id = caseIdA, Status = 'New'),
                        new Case(Id = caseIdB, Status = 'Open')
                });
        mocks.when(selectorMock.selectById(new Set<Id>{ UserInfo.getUserId()}))
                .thenReturn(new List<User> {
                        new User(Id = UserInfo.getUserId())
                });
        mocks.stopStubbing();

        sflib_RecordActionsSelector.replaceWith(actionsSelectorMock);
        fflib_SObjectsSelector.replaceWith(selectorMock);

        // WHEN we request the record actions
        System.Test.startTest();
        final Map<Id, sflib_IRecordActions> results = sflib_RecordActionsService.getActions(caseIds);
        System.Test.stopTest();

        // THEN it should return two sets of actions, one set for each record
        System.Assert.areEqual(2, results.size(), 'Expected two sets, one for each record');
        System.Assert.isTrue(results.containsKey(caseIdA), 'Expected case A to be part of the result');
        System.Assert.isTrue(results.containsKey(caseIdB), 'Expected case B to be part of the result');

        // THEN case A should have one action for the new status
        System.Assert.areEqual(1, results.get(caseIdA).size(), 'Expected only one action for case A');
        System.Assert.areEqual(action1.Id, results.get(caseIdA).getRecords().get(0).Id, 'Incorrect action assigned to case A');

        // THEN case B should have two actions for the open status
        System.Assert.areEqual(2, results.get(caseIdB).size(), 'Expected only one action for case B');
        System.Assert.areEqual(action3.Id, results.get(caseIdB).getRecords().get(0).Id, 'Incorrect first action assigned to case B');
        System.Assert.areEqual(action2.Id, results.get(caseIdB).getRecords().get(1).Id, 'Incorrect second action assigned to case B');
    }

    /**
     * Creates a mock sflib_RecordAction__c with the given action name and for the given record SObjectType
     *
     * @param actionName The Action Name
     * @param sObjectType The SObjectType to use
     * @param formula The condition formula
     *
     * @return Returns a sflib_RecordAction__c record mock
     */
    private static sflib_RecordAction__c generateRecordAction(String actionName, SObjectType sObjectType, String formula) {
        return new sflib_RecordAction__c(
                Id = fflib_IDGenerator.generate(sflib_RecordAction__c.SObjectType),
                FlowName__c = 'unit-test',
                Formula__c = formula,
                Name = actionName,
                Order__c = 1,
                SObjectType__c = sObjectType.getDescribe().getName(),
                Status__c = 'Active'
         );
    }

    /**
     * Creates a mock sflib_RecordActionCondition__c with the given action name and for the given record SObjectType
     *
     * @param formulaNumber The number of the condition
     * @param formula The formula to evaluate
     * @param sflibRecordAction The parent `sflib_RecordAction__c` record
     * @param sObjectType The SObjectType used for the formula evaluation
     *
     * @return Returns a sflib_RecordActionCondition__c record mock
     */
    private static sflib_RecordActionCondition__c generateRecordActionCondition(
            Decimal formulaNumber,
            String formula,
            sflib_RecordAction__c sflibRecordAction,
            SObjectType sObjectType) {
        return new sflib_RecordActionCondition__c(
                Id = fflib_IDGenerator.generate(sflib_RecordActionCondition__c.SObjectType),
                Formula__c = formula,
                Number__c = formulaNumber,
                RecordAction__c = sflibRecordAction.Id,
                SObjectType__c = sObjectType.getDescribe().getName()
        );
    }
}
 