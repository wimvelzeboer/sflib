/**
 * sflib_RecordActionHistoriesTest domain test class
 *
 * This class is testing the domain sflib_RecordActionHistories and all its methods.
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
 * @see sflib_RecordActionHistories
 */
@IsTest(IsParallel=true)
private class sflib_RecordActionHistoriesTest
{
	@IsTest
	static void testNewInstanceWithIds()
	{
		final Id recordId = fflib_IDGenerator.generate(Schema.sflib_RecordActionHistory__c.SObjectType);
		final Set<Id> ids = new Set<Id>{ recordId };
		final List<sflib_RecordActionHistory__c> records = new List<sflib_RecordActionHistory__c>{ new sflib_RecordActionHistory__c(Id = recordId) };

		fflib_ApexMocks mocks = new fflib_ApexMocks();
		sflib_IRecordActionHistorySelector selectorMock = (sflib_IRecordActionHistorySelector) mocks.mock(sflib_IRecordActionHistorySelector.class);
		mocks.startStubbing();
		mocks.when(selectorMock.selectById(ids)).thenReturn(records);
		mocks.stopStubbing();

		sflib_RecordActionHistorySelector.replaceWith(selectorMock);

		System.Test.startTest();
		sflib_IRecordActionHistories result = sflib_RecordActionHistories.newInstance(ids);
		System.Test.stopTest();

		System.assertEquals(records, result.getRecordActionHistories());
	}

	@IsTest
	static void testNewElevatedInstanceWithIds()
	{
		final Id recordId = fflib_IDGenerator.generate(Schema.sflib_RecordActionHistory__c.SObjectType);
		final Set<Id> ids = new Set<Id>{ recordId };
		final List<sflib_RecordActionHistory__c> records = new List<sflib_RecordActionHistory__c>{ new sflib_RecordActionHistory__c(Id = recordId) };

		fflib_ApexMocks mocks = new fflib_ApexMocks();
		sflib_IRecordActionHistorySelector selectorMock = (sflib_IRecordActionHistorySelector) mocks.mock(sflib_IRecordActionHistorySelector.class);

		mocks.startStubbing();
		mocks.when(selectorMock.selectById(ids)).thenReturn(records);
		mocks.stopStubbing();

		sflib_RecordActionHistorySelector.replaceWith(selectorMock);

		System.Test.startTest();
		sflib_IRecordActionHistories result = sflib_RecordActionHistories.newElevatedInstance(ids);
		System.Test.stopTest();

		System.Assert.areEqual(records, result.getRecordActionHistories());
	}

	@IsTest
	static void testNewInstanceWithRecords()
	{
	    // GIVEN a sflib_RecordActionHistory__c record
	    final Id recordId = fflib_IDGenerator.generate(Schema.sflib_RecordActionHistory__c.SObjectType);
		final List<sflib_RecordActionHistory__c> records =
		        new List<sflib_RecordActionHistory__c> {new sflib_RecordActionHistory__c(Id = recordId)};

		// WHEN we create a domain with the record
		System.Test.startTest();
		sflib_IRecordActionHistories result = sflib_RecordActionHistories.newInstance(records);
		System.Test.stopTest();

		// THEN the records should be added to the domain
		System.Assert.areEqual(records, result.getRecordActionHistories());
		System.Assert.isTrue(result.getById().containsKey(recordId));
		System.Assert.isTrue(result.selectById(new Set<Id> {recordId}).getRecordIds().contains(recordId));
    }

	@IsTest
	static void itShouldSelectRecords_blankAndWith()
	{
		// GIVEN a sflib_RecordActionHistory__c record with an Id and blank Status__c and one dummy record
		final Id recordId = fflib_IDGenerator.generate(Schema.sflib_RecordActionHistory__c.SObjectType);
		final List<sflib_RecordActionHistory__c> records =
				new List<sflib_RecordActionHistory__c>
				{
						new sflib_RecordActionHistory__c(Id = recordId, Status__c = '  '),
						new sflib_RecordActionHistory__c(Status__c = 'Started')
				};

		// WHEN we create a domain with the records
		System.Test.startTest();
		sflib_RecordActionHistories result = new sflib_RecordActionHistories(records);
		System.Test.stopTest();

		// THEN only the records with a blank Status__c should be in to the domain
		sflib_IRecordActionHistories blank = new sflib_RecordActionHistories(result.selectBlank(Schema.sflib_RecordActionHistory__c.Status__c));
		System.Assert.areEqual(1, blank.getRecordActionHistories().size());
		System.Assert.isTrue(blank.getById().containsKey(recordId));

		// THEN only the records with a Id should be in to the domain
		sflib_IRecordActionHistories with = new sflib_RecordActionHistories(result.selectWith(Schema.sflib_RecordActionHistory__c.Id));
		System.Assert.areEqual(1, with.getRecordActionHistories().size());
		System.Assert.isTrue(with.getById().containsKey(recordId));
	}

	@IsTest
	static void itShouldSelectRecords_nonBlankAndWithout()
	{
		// GIVEN a sflib_RecordActionHistory__c record without an Id and non-blank Status__c and one other dummy record
		final Id recordId = fflib_IDGenerator.generate(Schema.sflib_RecordActionHistory__c.SObjectType);
		final List<sflib_RecordActionHistory__c> records =
				new List<sflib_RecordActionHistory__c>
				{
						new sflib_RecordActionHistory__c(Id = recordId, Status__c = '  '),
						new sflib_RecordActionHistory__c(Status__c = 'Started')
				};

		// WHEN we create a domain with the records
		System.Test.startTest();
		sflib_RecordActionHistories result = new sflib_RecordActionHistories(records);
		System.Test.stopTest();

		// THEN only the records with a non-blank Status__c should be in to the domain
		sflib_IRecordActionHistories nonBlank = new sflib_RecordActionHistories(result.selectNonBlank(Schema.sflib_RecordActionHistory__c.Status__c));
		System.Assert.areEqual(1, nonBlank.getRecordActionHistories().size());
		System.Assert.areEqual('Started', nonBlank.getRecordActionHistories().get(0).Status__c);

		// THEN only the records without an id should be in to the domain
		sflib_IRecordActionHistories without = new sflib_RecordActionHistories(result.selectWithout(Schema.sflib_RecordActionHistory__c.Id));
		System.Assert.areEqual(1, without.getRecordActionHistories().size());
		System.Assert.areEqual('Started', without.getRecordActionHistories().get(0).Status__c);
	}
}
