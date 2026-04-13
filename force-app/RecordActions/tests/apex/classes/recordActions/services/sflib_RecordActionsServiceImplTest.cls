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
        final sflib_RecordAction__c action1 = generateRecordAction('Action 1', Schema.Case.SObjectType, '1');
        final sflib_RecordAction__c action2 = generateRecordAction('Action 2', Schema.Case.SObjectType, '1');
        final sflib_RecordAction__c action3 = generateRecordAction('Action 3', Schema.Case.SObjectType, '1');
        action2.Order__c = 2;
        action3.Order__c = 1;

        sflib_RecordActionCondition__c condition1 = generateRecordActionCondition(1, 'Status = "New"', action1, Schema.Case.SObjectType);
        sflib_RecordActionCondition__c condition2 = generateRecordActionCondition(1, 'Status = "New"', action2, Schema.Case.SObjectType);
        sflib_RecordActionCondition__c condition3 = generateRecordActionCondition(1, 'Status = "New"', action3, Schema.Case.SObjectType);

        // WHEN we request the record actions
        System.Test.startTest();
        final Map<Id, sflib_RecordActions> results = sflib_RecordActionsService.getActions(caseIds);
        System.Test.stopTest();

        // THEN it should return two sets of actions, one set for each record
        System.Assert.areEqual(2, results.size(), 'Expected two sets, one for each record');
        System.Assert.isTrue(results.containsKey(caseIdA), 'Expected case A to be part of the result');
        System.Assert.isTrue(results.containsKey(caseIdB), 'Expected case B to be part of the result');

        // THEN case A should have one action for the new status
        System.Assert.areEqual(1, results.get(caseIdA).size(), 'Expected only one action for case A');
        System.Assert.areEqual(condition1.Id, results.get(caseIdA).getRecords().get(0).Id, 'Incorrect action assigned to case A');

        // THEN case B should have two actions for the open status
        System.Assert.areEqual(2, results.get(caseIdB).size(), 'Expected only one action for case B');
        System.Assert.areEqual(condition3.Id, results.get(caseIdB).getRecords().get(0).Id, 'Incorrect first action assigned to case B');
        System.Assert.areEqual(condition2.Id, results.get(caseIdB).getRecords().get(0).Id, 'Incorrect second action assigned to case B');
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
 