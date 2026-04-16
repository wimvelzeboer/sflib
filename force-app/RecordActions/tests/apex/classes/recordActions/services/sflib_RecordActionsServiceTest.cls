/**
 * sflib_RecordActionsService test class
 *
 * This class tests the static entry point of the sflib_RecordActionsService class
 *
 * @see sflib_RecordActionsService
 */
@IsTest
private class sflib_RecordActionsServiceTest
{
	@IsTest
	static void itShouldCallTheImplementation_withIds()
	{
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		sflib_IRecordActionsService serviceMock = (sflib_IRecordActionsService) mocks.mock(sflib_IRecordActionsService.class);

		sflib_RecordActionsService.replaceWith(sflib_RecordActionsServiceImpl.class);
		sflib_RecordActionsService.replaceWith(serviceMock);

		final Id recordActionsId = fflib_IDGenerator.generate(Schema.sflib_RecordAction__c.SObjectType);

		System.Test.startTest();
		sflib_RecordActionsService.getActions(new Set<Id>{recordActionsId});
		System.Test.stopTest();

		((sflib_IRecordActionsService) mocks.verify(serviceMock)).getActions(new Set<Id> {recordActionsId});
	}
}
