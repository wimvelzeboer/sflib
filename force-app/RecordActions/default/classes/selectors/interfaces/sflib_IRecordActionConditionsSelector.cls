/**
 * sflib_IRecordActionConditionsSelector interface class
 *
 * Selector Class providing common database query support for abstracting and encapsulating query logic
 */
public interface sflib_IRecordActionConditionsSelector
		extends fflib_ISObjectSelector
{
	/**
	 * Queries sflib_RecordActionCondition__c records by their record Id
	 *
	 * @param idSet A set of `sflib_RecordActionCondition__c.Id` values
	 *
	 * @return A list of `sflib_RecordActionCondition__c` records
	 */
	List<sflib_RecordActionCondition__c> selectById(Set<Id> idSet);

	fflib_SObjectSelector setDataAccess(fflib_SObjectSelector.DataAccess access);
}
