/**
 * sflib_RecordActionConditionsTest domain test class
 *
 * This class is testing the domain sflib_RecordActionConditions and all its methods.
 *
 * @see sflib_RecordActionConditions
 */
@IsTest(IsParallel=true)
private class sflib_RecordActionConditionsTest
{
	@IsTest
	static void testNewInstanceWithIds()
	{
		final Id recordId = fflib_IDGenerator.generate(Schema.sflib_RecordActionCondition__c.SObjectType);
		final Set<Id> ids = new Set<Id>{ recordId };
		final List<sflib_RecordActionCondition__c> records = new List<sflib_RecordActionCondition__c>{ new sflib_RecordActionCondition__c(Id = recordId) };

		fflib_ApexMocks mocks = new fflib_ApexMocks();
		sflib_IRecordActionConditionsSelector selectorMock = (sflib_IRecordActionConditionsSelector) mocks.mock(sflib_IRecordActionConditionsSelector.class);

		mocks.startStubbing();
		mocks.when(selectorMock.selectById(ids)).thenReturn(records);
		mocks.stopStubbing();

		sflib_RecordActionConditionsSelector.replaceWith(selectorMock);

		System.Test.startTest();
		sflib_IRecordActionConditions result = sflib_RecordActionConditions.newInstance(ids);
		System.Test.stopTest();

		System.assertEquals(records, result.getRecordActionConditions());
	}

	@IsTest
	static void testNewElevatedInstanceWithIds()
	{
		final Id recordId = fflib_IDGenerator.generate(Schema.sflib_RecordActionCondition__c.SObjectType);
		final Set<Id> ids = new Set<Id>{ recordId };
		final List<sflib_RecordActionCondition__c> records = new List<sflib_RecordActionCondition__c>{ new sflib_RecordActionCondition__c(Id = recordId) };

		fflib_ApexMocks mocks = new fflib_ApexMocks();
		sflib_IRecordActionConditionsSelector selectorMock = (sflib_IRecordActionConditionsSelector) mocks.mock(sflib_IRecordActionConditionsSelector.class);

		mocks.startStubbing();
		mocks.when(selectorMock.selectById(ids)).thenReturn(records);
		mocks.stopStubbing();

		sflib_RecordActionConditionsSelector.replaceWith(selectorMock);

		System.Test.startTest();
		sflib_IRecordActionConditions result = sflib_RecordActionConditions.newElevatedInstance(ids);
		System.Test.stopTest();

		System.Assert.areEqual(records, result.getRecordActionConditions());
	}

	@IsTest
	static void testNewInstanceWithRecords()
	{
	    // GIVEN a sflib_RecordActionCondition__c record
	    final Id recordId = fflib_IDGenerator.generate(Schema.sflib_RecordActionCondition__c.SObjectType);
		final List<sflib_RecordActionCondition__c> records =
		        new List<sflib_RecordActionCondition__c> {new sflib_RecordActionCondition__c(Id = recordId)};

		// WHEN we create a domain with the record
		System.Test.startTest();
		sflib_IRecordActionConditions result = sflib_RecordActionConditions.newInstance(records);
		System.Test.stopTest();

		// THEN the records should be added to the domain
		System.Assert.areEqual(records, result.getRecordActionConditions());
		System.Assert.isTrue(result.getById().containsKey(recordId));
		System.Assert.isTrue(result.selectById(new Set<Id> {recordId}).getRecordIds().contains(recordId));
    }

	@IsTest
	static void itShouldSelectRecords_blankAndWith()
	{
		// GIVEN a sflib_RecordActionCondition__c record with an Id and blank Formula__c and one dummy record
		final Id recordId = fflib_IDGenerator.generate(Schema.sflib_RecordActionCondition__c.SObjectType);
		final List<sflib_RecordActionCondition__c> records =
				new List<sflib_RecordActionCondition__c>
				{
						new sflib_RecordActionCondition__c(Id = recordId, Formula__c = '  '),
						new sflib_RecordActionCondition__c(Formula__c = 'Test')
				};

		// WHEN we create a domain with the records
		System.Test.startTest();
		sflib_RecordActionConditions result = new sflib_RecordActionConditions(records);
		System.Test.stopTest();

		// THEN only the records with a blank Formula__c should be in to the domain
		sflib_IRecordActionConditions blank = new sflib_RecordActionConditions(result.selectBlank(Schema.sflib_RecordActionCondition__c.Formula__c));
		System.Assert.areEqual(1, blank.getRecordActionConditions().size());
		System.Assert.isTrue(blank.getById().containsKey(recordId));

		// THEN only the records with a Id should be in to the domain
		sflib_IRecordActionConditions with = new sflib_RecordActionConditions(result.selectWith(Schema.sflib_RecordActionCondition__c.Id));
		System.Assert.areEqual(1, with.getRecordActionConditions().size());
		System.Assert.isTrue(with.getById().containsKey(recordId));
	}

	@IsTest
	static void itShouldSelectRecords_nonBlankAndWithout()
	{
		// GIVEN a sflib_RecordActionCondition__c record without an Id and non-blank Formula__c and one other dummy record
		final Id recordId = fflib_IDGenerator.generate(Schema.sflib_RecordActionCondition__c.SObjectType);
		final List<sflib_RecordActionCondition__c> records =
				new List<sflib_RecordActionCondition__c>
				{
						new sflib_RecordActionCondition__c(Id = recordId, Formula__c = '  '),
						new sflib_RecordActionCondition__c(Formula__c = 'Test')
				};

		// WHEN we create a domain with the records
		System.Test.startTest();
		sflib_RecordActionConditions result = new sflib_RecordActionConditions(records);
		System.Test.stopTest();

		// THEN only the records with a non-blank Formula__c should be in to the domain
		sflib_IRecordActionConditions nonBlank = new sflib_RecordActionConditions(result.selectNonBlank(Schema.sflib_RecordActionCondition__c.Formula__c));
		System.Assert.areEqual(1, nonBlank.getRecordActionConditions().size());
		System.Assert.areEqual('Test', nonBlank.getRecordActionConditions().get(0).Formula__c);

		// THEN only the records without an id should be in to the domain
		sflib_IRecordActionConditions without = new sflib_RecordActionConditions(result.selectWithout(Schema.sflib_RecordActionCondition__c.Id));
		System.Assert.areEqual(1, without.getRecordActionConditions().size());
		System.Assert.areEqual('Test', without.getRecordActionConditions().get(0).Formula__c);
	}
}
