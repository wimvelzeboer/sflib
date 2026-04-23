/**
 * sflib_RecordActionConditions domain class
 *
 * This domain is a wrapper around sflib_RecordActionCondition__c records, and it contains getter,
 * setter and filter (selector) methods.
 *
 * Getters retrieve field values from all the sflib_RecordActionCondition__c records in this domain
 * Setters change field values on all the sflib_RecordActionCondition__c records in this domain
 * Selectors filter the contents of this domain
 *
 * The getter, setter and selector methods always targets (iterate over)
 * all the records the domain contains.
 * First use a selector, when a certain setter or getter method should target
 * only a subset.
 *
 * The only concern/context known to this domain is the List of sflib_RecordActionCondition__c records
 * it encapsulates. It is not aware of anything outside this domain,
 * so there should be no references to other classes or object types besides
 * the classes it is extended from
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
 * @see sflib_IRecordActionConditions
 *
 * @example
 * Map<Id, sflib_RecordActionCondition__c> recordActionConditionsById =
 *              sflib_RecordActionConditions.newInstance(recordIds)
 *                      .selectBySomeField('Holland')
 *                      .getById();
 */
public virtual inherited sharing class sflib_RecordActionConditions extends fflib_SObjects2 implements sflib_IRecordActionConditions
{
	/**
	 * Class constructor
	 *
	 * @param records Constructs the domain with the given records
	 *
	 * @return Returns a new instance of the sflib_RecordActionConditions domain
	 *
	 * @see sflib_IRecordActionConditions
	 */
	public static sflib_IRecordActionConditions newInstance(List<sflib_RecordActionCondition__c> records)
	{
		return new sflib_RecordActionConditions(records);
	}

	/**
	 * Class constructor
	 *
	 * @param ids Constructs the domain by querying the given record Ids
	 *
	 * @return Returns a new instance of the sflib_RecordActionConditions domain
	 *
	 * @see sflib_IRecordActionConditions
	 * @see sflib_RecordActionConditionsSelector
	 */
	public static sflib_IRecordActionConditions newInstance(Set<Id> ids)
	{
		return new sflib_RecordActionConditions(sflib_RecordActionConditionsSelector.newInstance().selectById(ids));
	}

	/**
	 * Class constructor
	 *
	 * @param ids Constructs the domain by querying the given record Ids in a SYSTEM_MODE context
	 *
	 * @return Returns a new instance of the sflib_RecordActionConditions domain
	 *
	 * @see sflib_IRecordActionConditions
	 * @see sflib_RecordActionConditionsSelector
	 */
	public static sflib_IRecordActionConditions newElevatedInstance(Set<Id> ids)
	{
		return new sflib_RecordActionConditions(sflib_RecordActionConditionsSelector.newElevatedInstance().selectById(ids));
	}

	/**
	 * Class constructor
	 *
	 * Avoid instantiating this constructor directly, instead use the static newInstance methods
	 *
	 * @param records A list of `sflib_RecordActionCondition__c` records
	 *
	 * @see sflib_RecordActionCondition__c
	 */
	@TestVisible
	protected sflib_RecordActionConditions(List<sflib_RecordActionCondition__c> records)
	{
		super(records, Schema.sflib_RecordActionCondition__c.SObjectType);
	}

	/**
	 * Adds the given records to the existing domain, if records are already present then they are replaced
	 *
	 * @param toAdd The conditions to be added.
	 *
	 * @return Returns a new instance of the domain with the added records
	 */
	public sflib_IRecordActionConditions add(sflib_IRecordActionConditions toAdd) {

		Map<Id, sflib_RecordActionCondition__c> newById = toAdd.getById();
		Map<Id, sflib_RecordActionCondition__c> existingById = this.getById();
		List<sflib_RecordActionCondition__c> results = new List<sflib_RecordActionCondition__c>();
		for (Id conditionId : existingById.keySet()) {
			if (newById.containsKey(conditionId)) {
				results.add(newById.get(conditionId));
			} else {
				results.add(existingById.get(conditionId));
			}
		}
		return new sflib_RecordActionConditions(results);
	}

	/**
	 * Adds a DML error message to each record in the domain
	 *
	 * @param sObjectField The SObjectField to which the error message should be linked
	 * @param message The error message
	 *
	 * @return Returns an instance of itself to allow for method chaining
	 */
	public sflib_IRecordActionConditions addErrorMessage(SObjectField sObjectField, String message) {
		for (SObject record : this.getRecords()) {
			record.addError(sObjectField, message);
		}
		return this;
	}

	/**
	 * Get the `sflib_RecordActionCondition__c` records the domain contains
	 *
	 * @return Returns the list of `sflib_RecordActionCondition__c` records
	 *
	 * @see sflib_RecordActionCondition__c
	 *
	 * @example
	 * List<sflib_RecordActionCondition__c> filteredRecordActionConditions =
	 *         sflib_RecordActionConditions.newInstance(recordIds)
	 *                 .selectBySomeField('Holland')
	 *                 .getRecordActionConditions();
	 */
	public List<sflib_RecordActionCondition__c> getRecordActionConditions()
	{
		return getRecords();
	}

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
	public Map<Id, sflib_RecordActionCondition__c> getById()
	{
		return new Map<Id, sflib_RecordActionCondition__c>(getRecordActionConditions());
	}

	/**
	 * Get a list of all the condition numbers, which may contain duplicates
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
	public List<Integer> getNumberList() {
		return getIntegerFieldValues(sflib_RecordActionCondition__c.Number__c).getIntegers();
	}

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
	public Set<Integer> getNumbers() {
		return getIntegerFieldValues(sflib_RecordActionCondition__c.Number__c).getIntegerSet();
	}

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
	public Map<Id, List<Integer>> getNumbersByRecordActionId() {
		Map<Id, List<Integer>> result = new Map<Id, List<Integer>>();
		for (sflib_RecordActionCondition__c record : getRecordActionConditions()) {
			if (record.Number__c == null) continue;

			if (result.containsKey(record.RecordAction__c) == false) {
				result.put(record.RecordAction__c, new List<Integer>());
			}

			result.get(record.RecordAction__c).add(record.Number__c.intValue());
		}
		return result;
	}

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
	public Set<Id> getRecordActionIds() {
		return getIdFieldValues(Schema.sflib_RecordActionCondition__c.RecordAction__c, true);
	}

	/**
	 * Gets a sub-selection of the `sflib_RecordActionCondition__c` records matching the given ids
	 *
	 * @param ids A set of `sflib_RecordActionCondition__c.Id` values
	 *
	 * @return Returns a new instance of the sflib_RecordActionConditions domain containing the matching records
	 *
	 * @see sflib_IRecordActionConditions
	 *
	 * @example sflib_IRecordActionConditions subset = recordActionConditions.selectById(recordIds);
	 */
	public sflib_IRecordActionConditions selectById(Set<Id> ids)
	{
		return new sflib_RecordActionConditions(getRecords(ids));
	}

	/**
	 * Gets the duplicate condition numbers for each record action
	 *
	 * @return Returns an instance of the domain containing only the records with duplicate numbers
	 */
	public sflib_IRecordActionConditions selectByDuplicateNumbers() {
		Map<Id, List<sflib_RecordActionCondition__c>> recordsByRecordActionId = this.getByRecordActionId();
		Set<Id> duplicates = new Set<Id>();
		for (Id recordActionId : recordsByRecordActionId.keySet()) {
			sflib_RecordActionConditions conditions =
					new sflib_RecordActionConditions( recordsByRecordActionId.get(recordActionId));
			if (conditions.getNumbers().size() == conditions.getNumberList().size()) continue; // There are no duplicates

			Map<Integer, Id> idByNumber = new Map<Integer, Id>();
			for (sflib_RecordActionCondition__c record : conditions.getRecordActionConditions()) {
				Integer i = Integer.valueOf(record.Number__c);
				if (idByNumber.containsKey(i)) {
					duplicates.add(idByNumber.get(i));
					duplicates.add(record.Id);
				} else {
					idByNumber.put(i, record.Id);
				}
			}
		}
		return this.selectById(duplicates);
	}

	public Map<Id, List<sflib_RecordActionCondition__c>> getByRecordActionId() {
		return getSObjectsByIdField(Schema.sflib_RecordActionCondition__c.RecordAction__c);
	}

	/**
	 * Gets a sub-selection of the `sflib_RecordActionCondition__c` records matching the given record action ids
	 *
	 * @param recordActionIds A set of `sflib_RecordActionCondition__c.RecordAction__c` values
	 *
	 * @return Returns a new instance of the sflib_RecordActionConditions domain containing the matching records
	 *
	 * @example sflib_IRecordActionConditions subset = recordActionConditions.selectByRecordActionId(recordIds);
	 */
	public sflib_IRecordActionConditions selectByRecordActionId(Set<Id> recordActionIds) {
		return new sflib_RecordActionConditions(getRecords(
				Schema.sflib_RecordActionCondition__c.RecordAction__c,
				recordActionIds));
	}

	/**
	 * Validates is the formula compiles, if not a DML error is added to the record
	 *
	 * @return Returns an instance of itself to allow for method chaining
	 */
	public sflib_IRecordActionConditions validateFormula() {
		for (sflib_RecordActionCondition__c record : this.getRecordActionConditions()) {
			// Validate Type
			Type sObjectTypeClass = System.Type.forName(record.SObjectType__c);
			if (sObjectTypeClass == null) {
				record.addError(
						sflib_RecordActionCondition__c.SObjectType__c,
						'Please provide a valid Object');
				continue;
			}

			// Validate Formula
			try {
				Formula.builder()
						.withType(sObjectTypeClass)
						.withReturnType(FormulaEval.FormulaReturnType.BOOLEAN)
						.withFormula(record.Formula__c)
						.build();
			} catch (Exception e) {
				record.addError(
						sflib_RecordActionCondition__c.Formula__c,
						'Invalid formula: ' + e.getMessage());
			}
		}
		return this;
	}

	/**
	 * Gets a sub-selection of the sflib_RecordActionConditions records where the given (String) field is blank
	 *
	 * @param sObjectField A String field on the `sflib_RecordActionCondition__c` object
	 *
	 * @return Returns a list of `sflib_RecordActionCondition__c` records containing only the matching records
	 *
	 * @see sflib_IRecordActionConditions
	 * @see Schema.SObjectField
	 *
	 * @example
	 * public sflib_IRecordActionConditions selectWithBlankName()
	 * {
	 *     return new sflib_RecordActionConditions(selectBlank(Schema.sflib_RecordActionCondition__c.Name));
	 * }
	 */
	@TestVisible
	protected List<sflib_RecordActionCondition__c> selectBlank(Schema.SObjectField sObjectField)
	{
		List<sflib_RecordActionCondition__c> result = new List<sflib_RecordActionCondition__c>();
		for (sflib_RecordActionCondition__c record : getRecordActionConditions())
		{
			if (String.isNotBlank(String.valueOf(record.get(sObjectField)))) continue;

			result.add(record);
		}
		return result;
	}

	/**
	 * Gets a sub-selection of the sflib_RecordActionConditions records where the given (String) field is not blank
	 *
	 * @param sObjectField A String field on the `sflib_RecordActionCondition__c` object
	 *
	 * @return Returns a list of `sflib_RecordActionCondition__c` records containing only the matching records
	 *
	 * @see sflib_IRecordActionConditions
	 * @see Schema.SObjectField
	 *
	 * @example
	 * public sflib_IRecordActionConditions selectWithName()
	 * {
	 *     return new sflib_RecordActionConditions(selectNonBlank(Schema.sflib_RecordActionCondition__c.Name));
	 * }
	 */
	@TestVisible
	protected List<sflib_RecordActionCondition__c> selectNonBlank(Schema.SObjectField sObjectField)
	{
		List<sflib_RecordActionCondition__c> result = new List<sflib_RecordActionCondition__c>();
		for (sflib_RecordActionCondition__c record : getRecordActionConditions())
		{
			if (String.isBlank(String.valueOf(record.get(sObjectField)))) continue;

			result.add(record);
		}
		return result;
	}

	/**
	 * Gets a sub-selection of the sflib_RecordActionConditions records where the given field is not null
	 * Tip: use selectNonBlank for String fields
	 *
	 * @param sObjectField A field on the `sflib_RecordActionCondition__c` object
	 *
	 * @return Returns a list of `sflib_RecordActionCondition__c` records containing only the matching records
	 *
	 * @see sflib_IRecordActionConditions
	 * @see Schema.SObjectField
	 *
	 * @example
	 * public sflib_IRecordActionConditions selectExistingRecords()
	 * {
	 *     return new sflib_RecordActionConditions(selectWith(Schema.sflib_RecordActionCondition__c.Name));
	 * }
	 */
	@TestVisible
	protected List<sflib_RecordActionCondition__c> selectWith(Schema.SObjectField sObjectField)
	{
		List<sflib_RecordActionCondition__c> result = new List<sflib_RecordActionCondition__c>();
		for (sflib_RecordActionCondition__c record : getRecordActionConditions())
		{
			if (record.get(sObjectField) == null) continue;

			result.add(record);
		}
		return result;
	}

	/**
	 * Gets a sub-selection of the sflib_RecordActionConditions records where the given field is null
	 * Tip: use selectBlank for String fields
	 *
	 * @param sObjectField A field on the `sflib_RecordActionCondition__c` object
	 *
	 * @return Returns a list of `sflib_RecordActionCondition__c` records containing only the matching records
	 *
	 * @see sflib_IRecordActionConditions
	 * @see Schema.SObjectField
	 *
	 * @example
	 * public sflib_IRecordActionConditions selectNewRecords()
	 * {
	 *     return new sflib_RecordActionConditions(selectWithout(Schema.sflib_RecordActionCondition__c.Name));
	 * }
	 */
	@TestVisible
	protected List<sflib_RecordActionCondition__c> selectWithout(Schema.SObjectField sObjectField)
	{
		List<sflib_RecordActionCondition__c> result = new List<sflib_RecordActionCondition__c>();
		for (sflib_RecordActionCondition__c record : getRecordActionConditions())
		{
			if (record.get(sObjectField) != null) continue;

			result.add(record);
		}
		return result;
	}
}
