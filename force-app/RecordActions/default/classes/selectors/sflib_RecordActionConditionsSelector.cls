/**
 * sflib_RecordActionConditionsSelector class
 *
 * Selector Class providing common database query support for abstracting and encapsulating query logic
 */
public virtual without sharing class sflib_RecordActionConditionsSelector
		extends fflib_SObjectSelector
		implements sflib_IRecordActionConditionsSelector
{
	/**
	 * The current implementation type of the service
	 */
	private static System.Type implementationType = sflib_RecordActionConditionsSelector.class;

	/**
	 * The implementation replacement for the service,
	 */
	private static sflib_IRecordActionConditionsSelector implementationReplacement;

	/**
	 * Runs the query in User Mode, respecting FLS, CRUD & sharing rules
	 *
	 * @return New instance of the selector
	 */
	public static sflib_IRecordActionConditionsSelector newInstance()
	{
		sflib_IRecordActionConditionsSelector selector =
				(implementationReplacement == null) ? (sflib_IRecordActionConditionsSelector) implementationType.newInstance() : implementationReplacement;
		selector.setDataAccess(fflib_SObjectSelector.DataAccess.USER_MODE);
		return selector;
	}

	/**
	 * Runs the query in System Mode, disabling FLS, CRUD & sharing rules
	 *
	 * @return New instance of the selector
	 */
	public static sflib_IRecordActionConditionsSelector newElevatedInstance()
	{
		sflib_IRecordActionConditionsSelector selector =
				(implementationReplacement == null) ? (sflib_IRecordActionConditionsSelector) implementationType.newInstance() : implementationReplacement;
		selector.setDataAccess(fflib_SObjectSelector.DataAccess.SYSTEM_MODE);
		return selector;
	}

	/**
	 * Class constructor
	 * This should not be used directly by an application but only by fflib
	 */
	public sflib_RecordActionConditionsSelector()
	{
		super();
	}

	/**
	 * The fields to always include in all queries
	 *
	 * @return Returns a list of default fields that are always queried
	 */
	public virtual List<Schema.SObjectField> getSObjectFieldList()
	{
		List<SObjectField> result = new List<Schema.SObjectField>
		{
				sflib_RecordActionCondition__c.Id,
				sflib_RecordActionCondition__c.Formula__c,
				sflib_RecordActionCondition__c.Number__c,
				sflib_RecordActionCondition__c.RecordAction__c,
				sflib_RecordActionCondition__c.SObjectType__c
		};
		// Uncomment the line below if the selector is extend from another selector,
		// result.addAll(super.getSObjectFieldList());
		return result;
	}

	/**
	 * Defines the SObjectType for this selector
	 *
	 * @return the SObjectType of this selector
	 */
	public Schema.SObjectType getSObjectType()
	{
		return Schema.sflib_RecordActionCondition__c.SObjectType;
	}

	/**
	 * Replace the default implementation of the service
	 *
	 * @param systemType The System.Type of the replacement class
	 */
	public static void replaceWith(System.Type systemType)
	{
		sflib_RecordActionConditionsSelector.implementationType = systemType;
	}

	/**
	 * Replace the default implementation of the service
	 *
	 * @param replacement A replacement instance
	 *
	 * @see sflib_IRecordActionConditionsSelector
	 */
	public static void replaceWith(sflib_IRecordActionConditionsSelector replacement)
	{
		sflib_RecordActionConditionsSelector.implementationReplacement = replacement;
	}

	/**
	 * Queries sflib_RecordActionCondition__c records by their record Id
	 *
	 * @param idSet A set of `sflib_RecordActionCondition__c.Id` values
	 *
	 * @return A list of `sflib_RecordActionCondition__c` records
	 */
	public virtual List<sflib_RecordActionCondition__c> selectById(Set<Id> idSet)
	{
		return Database.query(
				newQueryFactory()
						.setCondition('Id IN :idSet')
						.toSOQL()
		);
	}

	/**
	 * Queries `sflib_RecordActionCondition__c` records by their related record action Id
	 *
	 * @param recordActionIds A set of `sflib_RecordActionCondition__c.RecordAction__c` values
	 *
	 * @return A list of `sflib_RecordActionCondition__c` records
	 */
	public List<sflib_RecordActionCondition__c> selectByRecordActionId(Set<Id> recordActionIds) {
		return Database.query(
				newQueryFactory()
						.setCondition('RecordAction__c IN :recordActionIds')
						.toSOQL()
		);
	}
}
