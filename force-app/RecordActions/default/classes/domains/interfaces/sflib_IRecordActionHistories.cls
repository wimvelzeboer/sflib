/**
 * sflib_IRecordActionHistories domain interface
 *
 * This domain interface defines the public accessible methods for the sflib_RecordActionHistories
 * domain which is a wrapper around `sflib_RecordActionHistory__c` records,
 * containing getter, setter and filter (selector) methods
 *
 * When method accept or return objects (DTOs) then these should be publicly
 * accessible (avoid using sub-classes located in implementations)
 *
 * @see sflib_RecordActionHistories
 */
public interface sflib_IRecordActionHistories extends fflib_ISObjects2
{
	/**
	 * Get the `sflib_RecordActionHistory__c` records the domain contains
	 *
	 * @return Returns the list of `sflib_RecordActionHistory__c` records
	 *
	 * @see sflib_RecordActionHistory__c
	 *
	 * @example
	 * List<sflib_RecordActionHistory__c> filteredRecordActionHistories =
	 *         RecordActionHistories.newInstance(recordIds)
	 *                 .selectBySomeField('Holland')
	 *                 .getRecordActionHistories();
	 */
	List<sflib_RecordActionHistory__c> getRecordActionHistories();

	/**
	 * Get the `sflib_RecordActionHistory__c` records by their Id
	 *
	 * @return Returns a map of the `sflib_RecordActionHistory__c` record by its `sflib_RecordActionHistory__c.Id`
	 *
	 * @see sflib_RecordActionHistory__c
	 *
	 * @example
	 * Map<Id, sflib_RecordActionHistory__c> recordActionHistoriesById =
	 *         sflib_RecordActionHistories.newInstance(recordIds)
	 *                 .getById();
	 */
	Map<Id, sflib_RecordActionHistory__c> getById();

	/**
	 * Get the `sflib_RecordActionHistory__c` records by their related Record Action Id
	 *
	 * @return Returns a map of the `sflib_RecordActionHistory__c` record by its `sflib_RecordActionHistory__c.RecordAction__c`
	 *
	 * @see sflib_RecordActionHistory__c
	 *
	 * @example
	 * Map<Id, sflib_RecordActionHistory__c> latestRecordActionHistoryByRecordActionId =
	 *         sflib_RecordActionHistories.newInstance(recordIds)
	 *                 .getLatestByActionId();
	 */
	Map<Id, sflib_RecordActionHistory__c> getLatestByActionId();

	/**
	 * Gets a sub-selection of the `sflib_RecordActionHistory__c` records matching the given ids
	 *
	 * @param ids A set of `sflib_RecordActionHistory__c.Id` values
	 *
	 * @return Returns a new instance of the sflib_RecordActionHistories domain containing the matching records
	 *
	 * @example sflib_IRecordActionHistories subset = recordActionHistories.selectById(recordIds);
	 */
	sflib_IRecordActionHistories selectById(Set<Id> ids);
}
