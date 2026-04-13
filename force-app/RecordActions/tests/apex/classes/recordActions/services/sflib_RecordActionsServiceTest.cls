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
		Boolean result = sflib_RecordActionsService.doSomething(new Set<Id> {recordActionsId});
		System.Test.stopTest();

		((sflib_IRecordActionsService) mocks.verify(serviceMock)).doSomething(new Set<Id> {recordActionsId});
	}

	@IsTest
	static void itShouldCallTheImplementation_withRecords()
	{
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		sflib_IRecordActionsService serviceMock = (sflib_IRecordActionsService) mocks.mock(sflib_IRecordActionsService.class);

		sflib_RecordActionsService.replaceWith(sflib_RecordActionsServiceImpl.class);
		sflib_RecordActionsService.replaceWith(serviceMock);

		final Id recordActionsId = fflib_IDGenerator.generate(Schema.sflib_RecordAction__c.SObjectType);
		sflib_RecordAction__c record = new sflib_RecordAction__c(Id = recordActionsId);

		System.Test.startTest();
		Boolean result = sflib_RecordActionsService.doSomething(new List<sflib_RecordAction__c> {record});
		System.Test.stopTest();

		((sflib_IRecordActionsService) mocks.verify(serviceMock)).doSomething(new List<sflib_RecordAction__c> {record});
	}
}
