/**
 * sflib_RecordActionsService implementation
 *
 * Service implementation for the LWC sflibRecordActions functionality,
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
 * @see sflib_RecordActionsService Static entry point for the application
 */
public inherited sharing class sflib_RecordActionsServiceImpl implements sflib_IRecordActionsService
{
	/**
	 * Get a list of available record actions for the given record ids
	 *
	 * @param idSet A set of `Id` values for which to return their record actions
	 *
	 * @return Returns A domain with record actions grouped in by the record id
	 *
	 * @throws sflib_RecordActionsService.ServiceException on errors
	 *
	 * @see sflib_IRecordActions
	 * @see sflib_RecordActions
	 */
	public Map<Id, sflib_IRecordActions> getActions(Set<Id> idSet)
	{
		Map<String, Set<Id>> idsBySObjectName = getSObjectTypes(idSet);
		sflib_IRecordActions recordActions = sflib_RecordActions.newInstance(
				sflib_RecordActionsSelector.newElevatedInstance()
						.selectBySObjectType(idsBySObjectName.keySet())
		);

		FormulaInstances formulaInstances = new FormulaInstances(recordActions);

		Map<Id, SObject> sObjectById = queryRecords(idsBySObjectName, formulaInstances);
		return formulaInstances.evaluate(sObjectById);
	}

	/**
	 * Validates the given record action conditions and their related record action,
	 * a record DML error is added with a message if a problem is found.
	 * Note: The provided records must have a record Id value
	 *
	 * @param records A list of `sflib_RecordActionCondition__c` records to validate
	 *
	 * @return Returns a map of `sflib_RecordActionCondition__c.Id` value and if no errors found a TRUE boolean
	 */
	public Map<Id, Boolean> validate(List<sflib_RecordActionCondition__c> records) {

		// Validate the formula
		sflib_IRecordActionConditions conditions = sflib_RecordActionConditions.newInstance(records);
		conditions.validateFormula();

		// Check for duplicate numbers for active Record Actions
		sflib_IRecordActions actions = sflib_RecordActions.newInstance(conditions.getRecordActionIds());
		sflib_IRecordActions activeActions = actions.selectByStatus('Active');
		sflib_IRecordActionConditions allConditions = getAllConditions(newConditions.getRecordActionIds());
		conditions.selectById(
				allConditions.selectByRecordActionId(activeActions.getRecordIds())
						.selectByDuplicateNumbers()
						.getRecordIds()
		)
				.addError(sflib_RecordActionCondition__c.Number__c, 'Active Record Action cannot have duplicates in condition numbers');

		// Check for missing numbers in active Record Actions


		// Fetch all conditions for the related record actions
		sflib_IRecordActionConditions allConditions = existing.add(newConditions);

		Map<Id, Boolean> result = new Map<Id, Boolean>();
		for (sflib_RecordAction__c action : actions.getRecordActions()) {
			sflib_IRecordActionConditions conditions = allConditions.selectByRecordActionId(new Set<Id>{
					action.Id
			});


			result.put(action.Id, false);
			if (isActive(action)) {
				if (hasMissingNumbers(action, conditions)) {
					action.addError(
							sflib_RecordAction__c.Formula__c,
							'Not all referenced numbers have a Record Action Condition');
					action.addError(
							sflib_RecordAction__c.Status__c,
							'Active actions require a valid formula');
				} else if (hasDuplicateNumbers(action, conditions, result)) {
					action.addError(
							sflib_RecordAction__c.Status__c,
							'Active actions require unique numbers for their related conditions');

				}
			} else if (isActiveWithFailingConditionFormulas(action, conditions, result)) {
				action.addError(
						sflib_RecordAction__c.Status__c,
						'Active actions require a valid formulas in their related conditions');
			} else {
				result.put(action.Id, true);
			}
		}
		return result;


		return validate(recordActions, allConditions);
	}

	/**
	 * Validates the given record action and their related record action conditions,
	 * a record DML error is added with a message if a problem is found
	 * Note: The provided records must have a record Id value
	 *
	 * @param records A list of `sflib_RecordAction__c` records to validate
	 *
	 * @return Returns a map of `sflib_RecordAction__c.Id` value and if no errors found a TRUE boolean
	 */
	public Map<Id, Boolean> validate(List<sflib_RecordAction__c> records) {
		sflib_IRecordActions recordActions = sflib_RecordActions.newInstance(records);
		sflib_IRecordActionConditions conditions = getAllConditions(recordActions.getRecordIds());
		return validate(recordActions, conditions);
	}

	private static sflib_IRecordActionConditions getAllConditions(Set<Id> recordActionIds) {
		sflib_IRecordActionConditions existing = sflib_RecordActionConditions.newInstance(
				sflib_RecordActionConditionsSelector.newElevatedInstance()
						.selectByRecordActionId(recordActionIds)
		);
		return existing;
	}

	private static Map<Id, Boolean> validate(sflib_IRecordActions actions, sflib_IRecordActionConditions actionConditions) {
		Map<Id, Boolean> result = new Map<Id, Boolean>();
		for (sflib_RecordAction__c action : actions.getRecordActions()) {
			sflib_IRecordActionConditions conditions = actionConditions.selectByRecordActionId(new Set<Id>{
					action.Id
			});

			result.put(action.Id, false);
			if (isActive(action)) {
				if (conditions.isEmpty()) {
					action.addError(
							sflib_RecordAction__c.Status__c,
							'A Record Action requires conditions before it can be active', true);
				} else if (hasMissingNumbers(action, conditions)) {
					action.addError(
							sflib_RecordAction__c.Formula__c,
							'Not all referenced numbers have a Record Action Condition');
					action.addError(
							sflib_RecordAction__c.Status__c,
							'Active actions require a valid formula');
				} else if (hasDuplicateNumbers(action, conditions, result)) {
					action.addError(
							sflib_RecordAction__c.Status__c,
							'Active actions require unique numbers for their related conditions');

				}
			} else if (isActiveWithFailingConditionFormulas(action, conditions, result)) {
				action.addError(
						sflib_RecordAction__c.Status__c,
						'Active actions require a valid formulas in their related conditions');
			} else {
				result.put(action.Id, true);
			}
		}
		return result;
	}

	private static Boolean isActive(sflib_RecordAction__c action) {
		return action.Status__c == 'Active';
	}

	private static Boolean hasDuplicateNumbers(
			sflib_RecordAction__c action,
			sflib_IRecordActionConditions conditions,
			Map<Id, Boolean> report) {
		List<Integer> numbers = conditions.getNumberList();
		Set<Integer> duplicates = new Set<Integer>();
		while (numbers.isEmpty() == false) {
			Integer aNumber = numbers.remove(0);
			if (numbers.contains(aNumber)) duplicates.add(aNumber);
		}
		if (duplicates.isEmpty()) return false;

		action.addError('Active Record Actions cannot have duplicate condition numbers: ' + String.join(duplicates, ', '));
		for (sflib_RecordActionCondition__c record : conditions.getRecordActionConditions()) {
			if (duplicates.contains(Integer.valueOf(record.Number__c))) {
				report.put(record.Id, false);
				record.addError(sflib_RecordActionCondition__c.Number__c, 'Duplicate numbers are not allowed on active Record Actions');
			} else {
				report.put(record.Id, true);
			}
		}
		return true;
	}


	private static Boolean hasMissingNumbers(sflib_RecordAction__c action, sflib_IRecordActionConditions conditions) {
		return conditions.getNumbers().containsAll(getNumbers(action.Formula__c)) == false;
	}

	private static Set<Integer> getNumbers(String formula) {
		Matcher matcher = Pattern.compile('\\d++').matcher(formula);

		Set<Integer> result = new Set<Integer>();
		while (matcher.find()) {
			result.add(Integer.valueOf(matcher.group()));
		}
		return result;
	}


	/**
	 * Queries the records for each SObjectType with the fields referenced ins the formula instances
	 *
	 * @param idsBySObjectName
	 * @param formulaInstances
	 *
	 * @return Returns the queries records by their Id
	 */
	private static Map<Id, SObject> queryRecords(Map<String, Set<Id>> idsBySObjectName, FormulaInstances formulaInstances) {

		Map<String, Set<String>> fieldsBySObjectName = formulaInstances.getFieldsBySObjectName();

		Map<Id, SObject> result = new Map<Id, SObject>();
		Map<String, SObjectType> sObjectTypesByName = Schema.getGlobalDescribe();
		for (String sObjectName : idsBySObjectName.keySet()) {
			if (fieldsBySObjectName.containsKey(sObjectName) == false
					|| fieldsBySObjectName.get(sObjectName).isEmpty()
					|| idsBySObjectName.get(sObjectName).isEmpty()
					|| sObjectTypesByName.containsKey(sObjectName) == false) continue;

			List<SObject> records = fflib_SObjectsSelector.newElevatedInstance(
					fflib_SObjectDescribe.getDescribe(sObjectName).getSObjectType(),
					fieldsBySObjectName.get(sObjectName)
			)
					.selectById(idsBySObjectName.get(sObjectName));

			for (SObject record : records) {
				result.put(record.Id, record);
			}
		}
		return result;
	}

	/**
	 * Gets all the SObject names for the given ids,
	 * including 'User' => currentUserId
	 *
	 * @param ids The Ids to process
	 *
	 * @return Returns a set of Id by their SObject name of the given Ids
	 */
	private static Map<String, Set<Id>> getSObjectTypes(Set<Id> ids) {
		Map<String, Set<Id>> result = new Map<String, Set<Id>>{
				'User' => new Set<Id>{
						UserInfo.getUserId()
				}
		};

		for (Id id : ids) {
			String sObjectName = id.getSobjectType().getDescribe().getName();
			if (result.containsKey(sObjectName) == false) {
				result.put(sObjectName, new Set<Id>());
			}
			result.get(sObjectName).add(id);
		}
		return result;
	}

	private class FormulaInstances {

		final sflib_IRecordActions recordActions;
		final Map<Id, FormulaEval.FormulaInstance> elements;

		private FormulaInstances(sflib_IRecordActions recordActions) {
			this.recordActions = recordActions;

			Map<Id, FormulaEval.FormulaInstance> elements = new Map<Id, FormulaEval.FormulaInstance>();
			for (sflib_RecordAction__c record : recordActions.getRecordActions()) {
				for (sflib_RecordActionCondition__c condition : record.RecordActionConditions__r) {
					Type sObjectTypeClass = System.Type.forName(condition.SObjectType__c);
					if (sObjectTypeClass == null) continue;

					FormulaEval.FormulaInstance formulaInstance =
							Formula.builder()
									.withType(sObjectTypeClass)
									.withReturnType(FormulaEval.FormulaReturnType.BOOLEAN)
									.withFormula(condition.Formula__c)
									.build();
					elements.put(condition.Id, formulaInstance);
				}
			}
			this.elements = elements;
		}

		private Map<String, Set<String>> getFieldsBySObjectName() {
			Map<String, Set<String>> result = new Map<String, Set<String>>();

			Map<Id, sflib_RecordAction__c> recordActionsById = recordActions.getById();

			for (Id recordActionId : recordActions.getById().keySet()) {
				sflib_RecordAction__c recordAction = recordActionsById.get(recordActionId);
				for (sflib_RecordActionCondition__c condition : recordAction.RecordActionConditions__r) {
					if (this.elements.containsKey(condition.Id) == false) continue;

					if (result.containsKey(condition.SObjectType__c) == false) {
						result.put(condition.SObjectType__c, new Set<String>());
					}

					result.get(condition.SObjectType__c).addAll(this.elements.get(condition.Id).getReferencedFields());
				}
			}
			return result;
		}

		private Map<Id, sflib_IRecordActions> evaluate(Map<Id, SObject> sObjectsByIds) {
			Map<Id, sflib_IRecordActions> result = new Map<Id, sflib_RecordActions>();

			for (Id recordId : sObjectsByIds.keySet()) {
				SObject record = sObjectsByIds.get(recordId);
				String sObjectName = recordId.getSobjectType().getDescribe().getName();

				List<sflib_RecordAction__c> actions = new List<sflib_RecordAction__c>();
				for (sflib_RecordAction__c recordAction : this.recordActions.selectBySObjectType(sObjectName).getRecordActions()) {
					Map<Integer, fflib_Formula.FormulaExpression> formulaByNumber = new Map<Integer, fflib_Formula.FormulaExpression>();
					for (sflib_RecordActionCondition__c condition : recordAction.RecordActionConditions__r) {
						if (this.elements.containsKey(condition.Id) == false) continue;

						formulaByNumber.put(
								Integer.valueOf(condition.Number__c),
								new fflib_Formula.FormulaExpression(
										this.elements.get(condition.Id),
										record
								)
						);
					}
					if (new fflib_Formula(recordAction.Formula__c, formulaByNumber).evaluate() == false) continue;

					actions.add(recordAction);
				}

				result.put(recordId, sflib_RecordActions.newInstance(actions));
			}

			return result;
		}
	}
}
