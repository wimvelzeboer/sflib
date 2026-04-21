/**
 * sflib_IRecordActionConditions domain interface
 *
 * This domain interface defines the public accessible methods for the sflib_RecordActionConditions
 * domain which is a wrapper around `sflib_RecordActionCondition__c` records,
 * containing getter, setter and filter (selector) methods
 *
 * When method accept or return objects (DTOs) then these should be publicly
 * accessible (avoid using sub-classes located in implementations)
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
 * @see sflib_RecordActionConditions
 */
public interface sflib_IRecordActionConditions extends fflib_ISObjects2
{
	/**
	 * Adds the given records to the existing domain, if records are already present then they are replaced
	 *
	 * @param conditions The conditions to be added.
	 *
	 * @return Returns a new instance of the domain with the added records
	 */
	sflib_IRecordActionConditions add(sflib_IRecordActionConditions conditions);

	/**
	 * Adds a DML error message to each record in the domain
	 *
	 * @param sObjectField The SObjectField to which the error message should be linked
	 * @param message The error message
	 *
	 * @return Returns an instance of itself to allow for method chaining
	 */
	sflib_IRecordActionConditions addErrorMessage(SObjectField sObjectField, String message);

	/**
	 * Get the `sflib_RecordActionCondition__c` records the domain contains
	 *
	 * @return Returns the list of `sflib_RecordActionCondition__c` records
	 *
	 * @see sflib_RecordActionCondition__c
	 *
	 * @example
	 * List<sflib_RecordActionCondition__c> filteredRecordActionConditions =
	 *         RecordActionConditions.newInstance(recordIds)
	 *                 .selectBySomeField('Holland')
	 *                 .getRecordActionConditions();
	 */
	List<sflib_RecordActionCondition__c> getRecordActionConditions();

	/**
	 * Get the `sflib_RecordActionCondition__c` records by their Id
	 *
	 * @return Returns a map of the `sflib_RecordActionCondition__c` record by its `sflib_RecordActionCondition__c.Id`
	 *
	 * @see sflib_RecordActionCondition__c
	 *
	 * @example
	 * Map<Id, sflib_RecordActionCondition__c> recordActionConditionsById =
	 *         sflib_RecordActionConditions.newInstance(recordIds)
	 *                 .getById();
	 */
	Map<Id, sflib_RecordActionCondition__c> getById();

	/**
	 * Get a list of all the condition numbers
	 *
	 * @return Returns a list of `sflib_RecordActionCondition__c.Number__c` values
	 *
	 * @see sflib_RecordActionCondition__c
	 *
	 * @example
	 * List<Integer> numbers =
	 *         sflib_RecordActionConditions.newInstance(recordIds)
	 *                 .getNumberList();
	 */
	List<Integer> getNumberList();

	/**
	 * Get the condition numbers
	 *
	 * @return Returns a set of `sflib_RecordActionCondition__c.Number__c` values
	 *
	 * @see sflib_RecordActionCondition__c
	 *
	 * @example
	 * Set<Integer> numbers =
	 *         sflib_RecordActionConditions.newInstance(recordIds)
	 *                 .getNumbers();
	 */
	Set<Integer> getNumbers();
	/**
	 * Get the condition numbers by their related record action Id
	 *
	 * @return Returns a map of the `sflib_RecordActionCondition__c.Number__c` values by the `sflib_RecordActionCondition__c.RecordAction__c` value
	 *
	 * @see sflib_RecordActionCondition__c
	 *
	 * @example
	 * Map<Id, List<Integer>> numbersByRecordActionId =
	 *         sflib_RecordActionConditions.newInstance(recordIds)
	 *                 .getNumbersByRecordActionId();
	 */
	Map<Id, List<Integer>> getNumbersByRecordActionId();

	/**
	 * Gets the related Record Action Id values from the records in the domain
	 *
	 * @return Returns a set of `RecordAction__c` values
	 *
	 * @see sflib_RecordActionCondition__c
	 *
	 * @example
	 * Set<Id> recordActionIds =
	 *         RecordActionConditions.newInstance(recordIds)
	 *                 .getRecordActionIds();
	 */
	Set<Id> getRecordActionIds();

	/**
	 * Gets a sub-selection of the `sflib_RecordActionCondition__c` records matching the given ids
	 *
	 * @param ids A set of `sflib_RecordActionCondition__c.Id` values
	 *
	 * @return Returns a new instance of the sflib_RecordActionConditions domain containing the matching records
	 *
	 * @example sflib_IRecordActionConditions subset = recordActionConditions.selectById(recordIds);
	 */
	sflib_IRecordActionConditions selectById(Set<Id> ids);

	/**
	 * Gets the duplicate condition numbers for each record action
	 *
	 * @return Returns an instance of the domain containing only the records with duplicate numbers
	 */
	sflib_IRecordActionConditions selectByDuplicateNumbers();

	/**
	 * Gets a sub-selection of the `sflib_RecordActionCondition__c` records matching the given record action ids
	 *
	 * @param recordActionIds A set of `sflib_RecordActionCondition__c.RecordAction__c` values
	 *
	 * @return Returns a new instance of the sflib_RecordActionConditions domain containing the matching records
	 *
	 * @example sflib_IRecordActionConditions subset = recordActionConditions.selectByRecordActionId(recordIds);
	 */
	sflib_IRecordActionConditions selectByRecordActionId(Set<Id> recordActionIds);

	/**
	 * Validates is the formula compiles, if not a DML error is added to the record
	 *
	 * @return Returns an instance of itself to allow for method chaining
	 */
	sflib_IRecordActionConditions validateFormula();
}
