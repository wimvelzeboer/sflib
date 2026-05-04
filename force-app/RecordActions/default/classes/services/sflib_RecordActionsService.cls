/**
 * sflib_RecordActionsService class
 *
 * Service for the LWC sflibRecordActions functionality,
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
 * @see sflib_RecordActions Domain class holding `sflib_RecordAction__c` records
 * @see sflib_IRecordActionsService Interface with method definitions
 * @see sflib_RecordActionsServiceImpl The default implementation
 */
public with sharing class sflib_RecordActionsService
{
	/**
	 * The current implementation type of the service,
	 * defaults to sflib_RecordActionsServiceImpl.class
	 *
	 * @see sflib_RecordActionsServiceImpl
	 */
	private static System.Type implementationType = sflib_RecordActionsServiceImpl.class;

	/**
	 * The implementation replacement for the service,
	 */
	private static sflib_IRecordActionsService implementationReplacement;

    /**
     * Get a list of available record actions for the given record ids
     *
     * @param idSet A set of `Id` values for which to return their record actions
     *
     * @return Returns A domain with record actions grouped in by the record id
     *
     * @see sflib_IRecordActions
     * @see sflib_RecordActions
     */
	public static Map<Id, sflib_IRecordActions> getActions(Set<Id> idSet)
	{
		return newInstance().getActions(idSet);
	}

	/**
	 * Validates the given record action conditions and their related record action,
	 * a record DML error is added with a message if a problem is found
	 *
	 * @param records A list of `sflib_RecordActionCondition__c` records to validate
	 */
	public static void validate(List<sflib_RecordActionCondition__c> records)
	{
		newInstance().validate(records);
	}

	/**
	 * Validates the given record action and their related record action conditions,
	 * a record DML error is added with a message if a problem is found
	 *
	 * @param records A list of `sflib_RecordAction__c` records to validate
	 */
	public static void validate(List<sflib_RecordAction__c> records)
	{
		newInstance().validate(records);
	}

	/**
	 * Replace the default implementation of the service
	 *
	 * @param systemType The System.Type of the replacement class which should be extended from sflib_IRecordActionsService
	 */
	public static void replaceWith(System.Type systemType)
	{
		sflib_RecordActionsService.implementationType = systemType;
	}

	/**
	 * Replace the default implementation of the service
	 *
	 * @param replacement A replacement which is an instance of sflib_IRecordActionsService
	 *
	 * @see sflib_IRecordActionsService
	 */
	@TestVisible
	private static void replaceWith(sflib_IRecordActionsService replacement)
	{
		sflib_RecordActionsService.implementationReplacement = replacement;
	}

	/**
	 * Creates a new instance of sflib_IRecordActionsService
	 *
	 * @return Returns either the default implementation sflib_RecordActionsServiceImpl or a replacement
	 *
	 * @see sflib_IRecordActionsService
	 */
	@TestVisible
	private static sflib_IRecordActionsService newInstance()
	{
		return (implementationReplacement == null) ? (sflib_IRecordActionsService) implementationType.newInstance() : implementationReplacement;
	}
}
 