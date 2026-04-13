/**
 * sflib_IRecordActionsSelector interface class
 *
 * Selector Class providing common database query support for abstracting and encapsulating query logic
 */
public interface sflib_IRecordActionsSelector
		extends fflib_ISObjectSelector
{
	/**
	 * Queries sflib_RecordAction__c records by their record Id
	 *
	 * @param idSet A set of `sflib_RecordAction__c.Id` values
	 *
	 * @return A list of `sflib_RecordAction__c` records
	 */
	List<sflib_RecordAction__c> selectById(Set<Id> idSet);

	fflib_SObjectSelector setDataAccess(fflib_SObjectSelector.DataAccess access);
}
