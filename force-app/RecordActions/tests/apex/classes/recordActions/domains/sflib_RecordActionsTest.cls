/**
 * sflib_RecordActionsTest domain test class
 *
 * This class is testing the domain sflib_RecordActions and all its methods.
 *
 * @see sflib_RecordActions
 */
@IsTest(IsParallel=true)
private class sflib_RecordActionsTest
{
	@IsTest
	static void testNewInstanceWithIds()
	{
		final Id recordId = fflib_IDGenerator.generate(Schema.sflib_RecordAction__c.SObjectType);
		final Set<Id> ids = new Set<Id>{ recordId };
		final List<sflib_RecordAction__c> records = new List<sflib_RecordAction__c>{ new sflib_RecordAction__c(Id = recordId) };

		fflib_ApexMocks mocks = new fflib_ApexMocks();
		sflib_IRecordActionsSelector selectorMock = (sflib_IRecordActionsSelector) mocks.mock(sflib_IRecordActionsSelector.class);

		mocks.startStubbing();
		mocks.when(selectorMock.selectById(ids)).thenReturn(records);
		mocks.stopStubbing();

		sflib_RecordActionsSelector.replaceWith(selectorMock);

		System.Test.startTest();
		sflib_IRecordActions result = sflib_RecordActions.newInstance(ids);
		System.Test.stopTest();

		System.assertEquals(records, result.getRecordActions());
	}

	@IsTest
	static void testNewElevatedInstanceWithIds()
	{
		final Id recordId = fflib_IDGenerator.generate(Schema.sflib_RecordAction__c.SObjectType);
		final Set<Id> ids = new Set<Id>{ recordId };
		final List<sflib_RecordAction__c> records = new List<sflib_RecordAction__c>{ new sflib_RecordAction__c(Id = recordId) };

		fflib_ApexMocks mocks = new fflib_ApexMocks();
		sflib_IRecordActionsSelector selectorMock = (sflib_IRecordActionsSelector) mocks.mock(sflib_IRecordActionsSelector.class);

		mocks.startStubbing();
		mocks.when(selectorMock.selectById(ids)).thenReturn(records);
		mocks.stopStubbing();

		sflib_RecordActionsSelector.replaceWith(selectorMock);

		System.Test.startTest();
		sflib_IRecordActions result = sflib_RecordActions.newElevatedInstance(ids);
		System.Test.stopTest();

		System.Assert.areEqual(records, result.getRecordActions());
	}

	@IsTest
	static void testNewInstanceWithRecords()
	{
	    // GIVEN a sflib_RecordAction__c record
	    final Id recordId = fflib_IDGenerator.generate(Schema.sflib_RecordAction__c.SObjectType);
		final List<sflib_RecordAction__c> records =
		        new List<sflib_RecordAction__c> {new sflib_RecordAction__c(Id = recordId)};

		// WHEN we create a domain with the record
		System.Test.startTest();
		sflib_IRecordActions result = sflib_RecordActions.newInstance(records);
		System.Test.stopTest();

		// THEN the records should be added to the domain
		System.Assert.areEqual(records, result.getRecordActions());
		System.Assert.isTrue(result.getById().containsKey(recordId));
		System.Assert.isTrue(result.selectById(new Set<Id> {recordId}).getRecordIds().contains(recordId));
    }

	@IsTest
	static void itShouldSelectRecords_blankAndWith()
	{
		// GIVEN a sflib_RecordAction__c record with an Id and blank name and one dummy record
		final Id recordId = fflib_IDGenerator.generate(Schema.sflib_RecordAction__c.SObjectType);
		final List<sflib_RecordAction__c> records =
				new List<sflib_RecordAction__c>
				{
						new sflib_RecordAction__c(Id = recordId, Name = '  '),
						new sflib_RecordAction__c(Name = 'Test')
				};

		// WHEN we create a domain with the records
		System.Test.startTest();
		sflib_RecordActions result = new sflib_RecordActions(records);
		System.Test.stopTest();

		// THEN only the records with a blank name should be in to the domain
		sflib_IRecordActions blank = new sflib_RecordActions(result.selectBlank(Schema.sflib_RecordAction__c.Name));
		System.Assert.areEqual(1, blank.getRecordActions().size());
		System.Assert.isTrue(blank.getById().containsKey(recordId));

		// THEN only the records with a Id should be in to the domain
		sflib_IRecordActions with = new sflib_RecordActions(result.selectWith(Schema.sflib_RecordAction__c.Id));
		System.Assert.areEqual(1, with.getRecordActions().size());
		System.Assert.isTrue(with.getById().containsKey(recordId));
	}

	@IsTest
	static void itShouldSelectRecords_nonBlankAndWithout()
	{
		// GIVEN a sflib_RecordAction__c record without an Id and non-blank name and one other dummy record
		final Id recordId = fflib_IDGenerator.generate(Schema.sflib_RecordAction__c.SObjectType);
		final List<sflib_RecordAction__c> records =
				new List<sflib_RecordAction__c>
				{
						new sflib_RecordAction__c(Id = recordId, Name = '  '),
						new sflib_RecordAction__c(Name = 'Test')
				};

		// WHEN we create a domain with the records
		System.Test.startTest();
		sflib_RecordActions result = new sflib_RecordActions(records);
		System.Test.stopTest();

		// THEN only the records with a non-blank name should be in to the domain
		sflib_IRecordActions nonBlank = new sflib_RecordActions(result.selectNonBlank(Schema.sflib_RecordAction__c.Name));
		System.Assert.areEqual(1, nonBlank.getRecordActions().size());
		System.Assert.areEqual('Test', nonBlank.getRecordActions().get(0).Name);

		// THEN only the records without an id should be in to the domain
		sflib_IRecordActions without = new sflib_RecordActions(result.selectWithout(Schema.sflib_RecordAction__c.Id));
		System.Assert.areEqual(1, without.getRecordActions().size());
		System.Assert.areEqual('Test', without.getRecordActions().get(0).Name);
	}
}
