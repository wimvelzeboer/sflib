/**
 * sflib_IRecordActions domain interface
 *
 * This domain interface defines the public accessible methods for the sflib_RecordActions
 * domain which is a wrapper around `sflib_RecordAction__c` records,
 * containing getter, setter and filter (selector) methods
 *
 * When method accept or return objects (DTOs) then these should be publicly
 * accessible (avoid using sub-classes located in implementations)
 *
 * @see sflib_RecordActions
 */
public interface sflib_IRecordActions extends fflib_ISObjects2
{
	/**
	 * Adds a DML error message to each record in the domain
	 *
	 * @param sObjectField The SObjectField to which the error message should be linked
	 * @param message The error message
	 *
	 * @return Returns an instance of itself to allow for method chaining
	 */
	sflib_IRecordActions addErrorMessage(SObjectField sObjectField, String message);

	/**
	 * Get the `sflib_RecordAction__c` records the domain contains
	 *
	 * @return Returns the list of `sflib_RecordAction__c` records
	 *
	 * @see sflib_RecordAction__c
	 *
	 * @example
	 * List<sflib_RecordAction__c> filteredRecordActions =
	 *         RecordActions.newInstance(recordIds)
	 *                 .selectBySomeField('Holland')
	 *                 .getRecordActions();
	 */
	List<sflib_RecordAction__c> getRecordActions();

	/**
	 * Gets the record Id List in the order which they are stored inside the domain
	 *
	 * @return Returns an ordered list of `sflib_RecordAction__c.Id` values
	 */
	List<Id> getRecordIdList();

	/**
	 * Get the `sflib_RecordAction__c` records by their Id
	 *
	 * @return Returns a map of the `sflib_RecordAction__c` record by its `sflib_RecordAction__c.Id`
	 *
	 * @see sflib_RecordAction__c
	 *
	 * @example
	 * Map<Id, sflib_RecordAction__c> recordActionsById =
	 *         sflib_RecordActions.newInstance(recordIds)
	 *                 .getById();
	 */
	Map<Id, sflib_RecordAction__c> getById();

	/**
	 * Get a set of referenced formula numbers by their record Id
	 *
	 * @return Returns the numbers referenced in the `Formula__c` field by their record Id
	 */
	Map<Id, Set<Integer>> getFormulaNumbersById();

	/**
	 * Gets a sub-selection of the `sflib_RecordAction__c` records matching the given ids
	 *
	 * @param ids A set of `sflib_RecordAction__c.Id` values
	 *
	 * @return Returns a new instance of the sflib_RecordActions domain containing the matching records
	 *
	 * @example sflib_IRecordActions subset = recordActions.selectById(recordIds);
	 */
	sflib_IRecordActions selectById(Set<Id> ids);

	/**
	 * Gets a sub-selection of the `sflib_RecordAction__c` records matching the given SObject name
	 *
	 * @param sObjectName A `sflib_RecordAction__c.SObjectType__c` value
	 *
	 * @return Returns a new instance of the sflib_RecordActions domain containing the matching records
	 *
	 * @example sflib_IRecordActions subset = recordActions.selectBySObjectType('Account');
	 */
	sflib_IRecordActions selectBySObjectType(String sObjectName);

	/**
	 * Gets a sub-selection of the `sflib_RecordAction__c` records matching the given Status value
	 *
	 * @param statusValue A `sflib_RecordAction__c.Status__c` value
	 *
	 * @return Returns a new instance of the sflib_RecordActions domain containing the matching records
	 *
	 * @example sflib_IRecordActions subset = recordActions.selectByStatus('Draft');
	 */
	sflib_IRecordActions selectByStatus(String statusValue);

	/**
	 * Sets a new value for the Status field
	 *
	 * @param statusValue The new value for the `Status__c` field
	 *
	 * @return Returns an instance of itself to allow for method chaining
	 */
	sflib_IRecordActions setStatus(String statusValue);
}
