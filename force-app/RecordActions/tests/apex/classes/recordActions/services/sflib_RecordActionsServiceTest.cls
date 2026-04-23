/**
 * sflib_RecordActionsService test class
 *
 * This class tests the static entry point of the sflib_RecordActionsService class
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

	@IsTest
	static void itShouldCallTheImplementation_validate()
	{
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		sflib_IRecordActionsService serviceMock = (sflib_IRecordActionsService) mocks.mock(sflib_IRecordActionsService.class);

		sflib_RecordActionsService.replaceWith(sflib_RecordActionsServiceImpl.class);
		sflib_RecordActionsService.replaceWith(serviceMock);


		List<sflib_RecordAction__c> actions = new List<sflib_RecordAction__c>{new sflib_RecordAction__c()};
		List<sflib_RecordActionCondition__c> conditions = new List<sflib_RecordActionCondition__c>{new sflib_RecordActionCondition__c()};
		System.Test.startTest();
		sflib_RecordActionsService.validate(actions);
		sflib_RecordActionsService.validate(conditions);
		System.Test.stopTest();

		((sflib_IRecordActionsService) mocks.verify(serviceMock)).validate(actions);
		((sflib_IRecordActionsService) mocks.verify(serviceMock)).validate(conditions);
	}
}
