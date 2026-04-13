/**
 * sflib_RecordActionsService interface
 *
 * This service class is providing a single access point for high level business services functionality,
 * every entry point (e.g. WebService, Trigger) should be able to invoke these service methods.
 * Therefore there are many method overloads, to support different entry points
 *
 * @see sflib_RecordActionsServiceImpl The default implementation
 */
public interface sflib_IRecordActionsService
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
	Boolean doSomething(Set<Id> idSet);

	/**
	 * Sample
	 *
	 * @param records A List of `sflib_RecordAction__c` records
	 *
	 * @return Returns Something
	 */
	Boolean doSomething(List<sflib_RecordAction__c> records);

	/**
	 * Sample
	 *
	 * @param recordActions A domain with `sflib_RecordAction__c` records
	 *
	 * @return Returns Something
	 *
	 * @see	sflib_IRecordActions
	 */
	Boolean doSomething(sflib_IRecordActions recordActions);

	/**
	 * Sample
	 *
	 * @param unitOfWork An instance of fflib_ISObjectUnitOfWork
	 * @param recordActions A domain with `sflib_RecordAction__c` records
	 *
	 * @return Returns Something
	 */
	Boolean doSomething(fflib_ISObjectUnitOfWork unitOfWork, sflib_IRecordActions recordActions);
}
 