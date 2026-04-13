/**
 * sflib_RecordActionsService class
 *
 * This service class is providing a single access point for high level business services functionality,
 * every entry point (e.g. WebService, Trigger) should be able to invoke these service methods.
 * Therefore there are many method overloads, to support different entry points
 *
 * @see sflib_IRecordActionsService Interface with method definitions
 * @see sflib_RecordActionsServiceImpl The default implementation
 */
public with sharing class sflib_RecordActionsService
{
	/**
	 * The current implementation type of the service,
	 * defaults to sflib_RecordActionsServiceImpl.class
	 *
	 * @see sflib_RecordActionsServiceImpl
	 */
	private static System.Type implementationType = sflib_RecordActionsServiceImpl.class;

	/**
	 * The implementation replacement for the service,
	 */
	private static sflib_IRecordActionsService implementationReplacement;

	/**
	 * Sample
	 *
	 * @param idSet A set of `sflib_RecordAction__c.Id` values
	 *
	 * @return Returns Something
	 *
	 * @throws sflib_RecordActionsService.ServiceException on invalid Ids
	 */
	public static Boolean doSomething(Set<Id> idSet)
	{
		return newInstance().doSomething(idSet);
	}

	/**
	 * Sample
	 *
	 * @param records A List of `sflib_RecordAction__c` records
	 *
	 * @return Returns Something
	 */
	public static Boolean doSomething(List<sflib_RecordAction__c> records)
	{
		return newInstance().doSomething(records);
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
	public static Boolean doSomething(sflib_IRecordActions recordActions)
	{
		return newInstance().doSomething(recordActions);
	}

	/**
	 * Sample
	 *
	 * @param unitOfWork An instance of fflib_ISObjectUnitOfWork
	 * @param recordActions A domain with `sflib_RecordAction__c` records
	 *
	 * @return Returns Something
	 */
	public static Boolean doSomething(fflib_ISObjectUnitOfWork unitOfWork, sflib_IRecordActions recordActions)
	{
		return newInstance().doSomething(unitOfWork, recordActions);
	}

	/**
	 * Replace the default implementation of the service
	 *
	 * @param systemType The System.Type of the replacement class which should be extended from sflib_IRecordActionsService
	 */
	public static void replaceWith(System.Type systemType)
	{
		sflib_RecordActionsService.implementationType = systemType;
	}

	/**
	 * Replace the default implementation of the service
	 *
	 * @param replacement A replacement which is an instance of sflib_IRecordActionsService
	 *
	 * @see sflib_IRecordActionsService
	 */
	@TestVisible
	private static void replaceWith(sflib_IRecordActionsService replacement)
	{
		sflib_RecordActionsService.implementationReplacement = replacement;
	}

	/**
	 * Creates a new instance of sflib_IRecordActionsService
	 *
	 * @return Returns either the default implementation sflib_RecordActionsServiceImpl or a replacement
	 *
	 * @see sflib_IRecordActionsService
	 */
	@TestVisible
	private static sflib_IRecordActionsService newInstance()
	{
		return (implementationReplacement == null) ? (sflib_IRecordActionsService) implementationType.newInstance() : implementationReplacement;
	}

	public class ServiceException extends System.Exception {}
}
 