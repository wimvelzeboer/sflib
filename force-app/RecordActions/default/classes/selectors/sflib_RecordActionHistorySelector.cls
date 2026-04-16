/**
 * sflib_RecordActionHistorySelector class
 *
 * Selector Class providing common database query support for abstracting and encapsulating query logic
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
 * @see fflib_SObjectSelector
 * @see sflib_IRecordActionHistorySelector
 */
public virtual without sharing class sflib_RecordActionHistorySelector
		extends fflib_SObjectSelector
		implements sflib_IRecordActionHistorySelector
{
	/**
	 * The current implementation type of the service
	 */
	private static System.Type implementationType = sflib_RecordActionHistorySelector.class;

	/**
	 * The implementation replacement for the service,
	 */
	private static sflib_IRecordActionHistorySelector implementationReplacement;

	/**
	 * Runs the query in User Mode, respecting FLS, CRUD & sharing rules
	 *
	 * @return New instance of the selector
	 */
	public static sflib_IRecordActionHistorySelector newInstance()
	{
		sflib_IRecordActionHistorySelector selector =
				(implementationReplacement == null) ? (sflib_IRecordActionHistorySelector) implementationType.newInstance() : implementationReplacement;
		selector.setDataAccess(fflib_SObjectSelector.DataAccess.USER_MODE);
		return selector;
	}

	/**
	 * Runs the query in System Mode, disabling FLS, CRUD & sharing rules
	 *
	 * @return New instance of the selector
	 */
	public static sflib_IRecordActionHistorySelector newElevatedInstance()
	{
		sflib_IRecordActionHistorySelector selector =
				(implementationReplacement == null) ? (sflib_IRecordActionHistorySelector) implementationType.newInstance() : implementationReplacement;
		selector.setDataAccess(fflib_SObjectSelector.DataAccess.SYSTEM_MODE);
		return selector;
	}

	/**
	 * Class constructor
	 * This should not be used directly by an application but only by fflib
	 */
	public sflib_RecordActionHistorySelector()
	{
		super();
	}

	/**
	 * The fields to always include in all queries
	 *
	 * @return Returns a list of default fields that are always queried
	 */
	public virtual List<Schema.SObjectField> getSObjectFieldList()
	{
		List<SObjectField> result = new List<Schema.SObjectField>
		{
				sflib_RecordActionHistory__c.Id,
				sflib_RecordActionHistory__c.CreatedById,
				sflib_RecordActionHistory__c.CreatedDate,
				sflib_RecordActionHistory__c.RecordAction__c,
				sflib_RecordActionHistory__c.RecordId__c,
				sflib_RecordActionHistory__c.Status__c
		};
		// Uncomment the line below if the selector is extend from another selector,
		// result.addAll(super.getSObjectFieldList());
		return result;
	}

	/**
	 * Defines the SObjectType for this selector
	 *
	 * @return the SObjectType of this selector
	 */
	public Schema.SObjectType getSObjectType()
	{
		return Schema.sflib_RecordActionHistory__c.SObjectType;
	}

	/**
	 * Replace the default implementation of the service
	 *
	 * @param systemType The System.Type of the replacement class
	 */
	public static void replaceWith(System.Type systemType)
	{
		sflib_RecordActionHistorySelector.implementationType = systemType;
	}

	/**
	 * Replace the default implementation of the service
	 *
	 * @param replacement A replacement instance
	 *
	 * @see sflib_IRecordActionHistorySelector
	 */
	public static void replaceWith(sflib_IRecordActionHistorySelector replacement)
	{
		sflib_RecordActionHistorySelector.implementationReplacement = replacement;
	}

	/**
	 * Queries sflib_RecordActionHistory__c records by their record Id
	 *
	 * @param idSet A set of `sflib_RecordActionHistory__c.Id` values
	 *
	 * @return A list of `sflib_RecordActionHistory__c` records
	 */
	public virtual List<sflib_RecordActionHistory__c> selectById(Set<Id> idSet)
	{
		return Database.query(
				newQueryFactory()
						.setCondition('Id IN :idSet')
						.toSOQL()
		);
	}

	/**
	 * Queries sflib_RecordActionHistory__c records by their record Id field
	 *
	 * @param recordIds A set of `sflib_RecordActionHistory__c.RecordId__c` values
	 *
	 * @return A list of `sflib_RecordActionHistory__c` records
	 */
	public List<sflib_RecordActionHistory__c> selectByRecordId(Set<Id> recordIds) {
		return Database.query(
				newQueryFactory()
						.selectField('CreatedBy.Name')
						.selectField('RecordAction__r.Name')
						.setCondition('RecordId__c IN :recordIds')
						.toSOQL()
		);
	}

	public override String getOrderBy() {
		return 'CreatedDate ASC';
	}
}
