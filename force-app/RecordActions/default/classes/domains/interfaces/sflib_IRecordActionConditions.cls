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
 * @see sflib_RecordActionConditions
 */
public interface sflib_IRecordActionConditions extends fflib_ISObjects2
{
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
	 * Gets a sub-selection of the `sflib_RecordActionCondition__c` records matching the given ids
	 *
	 * @param ids A set of `sflib_RecordActionCondition__c.Id` values
	 *
	 * @return Returns a new instance of the sflib_RecordActionConditions domain containing the matching records
	 *
	 * @example sflib_IRecordActionConditions subset = recordActionConditions.selectById(recordIds);
	 */
	sflib_IRecordActionConditions selectById(Set<Id> ids);
}
