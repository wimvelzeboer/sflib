/**
 * sflib_RecordActionsService interface
 *
 * This service class is providing a single access point for high level business services functionality,
 * every entry point (e.g. WebService, Trigger) should be able to invoke these service methods.
 * Therefore there are many method overloads, to support different entry points
 *
 * @see sflib_IRecordActionsService Interface with method definitions
 * @see sflib_RecordActionsService Static entry point for the application
 */
public inherited sharing class sflib_RecordActionsServiceImpl implements sflib_IRecordActionsService
{
	/**
	 * Sample
	 *
	 * @param idSet A set of `sflib_RecordAction__c.Id` values
	 *
	 * @return Returns Something
	 *
	 * @throws sflib_RecordActionsService.ServiceException on invalid Ids
	 */
	public Boolean doSomething(Set<Id> idSet)
	{
		return doSomething(sflib_RecordActions.newInstance(idSet));
	}

	/**
	 * Sample
	 *
	 * @param records A List of `sflib_RecordAction__c` records
	 *
	 * @return Returns Something
	 */
	public Boolean doSomething(List<sflib_RecordAction__c> records)
	{
		return doSomething(sflib_RecordActions.newInstance(records));
	}

	/**
	 * Sample
	 *
	 * @param recordActions A domain with `sflib_RecordAction__c` records
	 *
	 * @return Returns Something
	 *
	 * @see	sflib_IRecordActions
	 */
	public Boolean doSomething(sflib_IRecordActions recordActions)
	{
	    fflib_ISObjectUnitOfWork unitOfWork = new fflib_SObjectUnitOfWork(new List<SObjectType> {Schema.sflib_RecordAction__c.SObjectType});
	    Boolean result = doSomething(unitOfWork, recordActions);
	    unitOfWork.commitWork();
		return result;
	}

	/**
	 * Sample
	 *
	 * @param unitOfWork An instance of fflib_ISObjectUnitOfWork
	 * @param recordActions A domain with `sflib_RecordAction__c` records
	 *
	 * @return Returns Something
	 */
	public Boolean doSomething(fflib_ISObjectUnitOfWork unitOfWork, sflib_IRecordActions recordActions)
	{
		return true;
	}
}
