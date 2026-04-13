/**
 * sflib_RecordActionsSelector class
 *
 * Selector Class providing common database query support for abstracting and encapsulating query logic
 */
public virtual without sharing class sflib_RecordActionsSelector
		extends fflib_SObjectSelector
		implements sflib_IRecordActionsSelector
{
	/**
	 * The current implementation type of the service
	 */
	private static System.Type implementationType = sflib_RecordActionsSelector.class;

	/**
	 * The implementation replacement for the service,
	 */
	private static sflib_IRecordActionsSelector implementationReplacement;

	/**
	 * Runs the query in User Mode, respecting FLS, CRUD & sharing rules
	 *
	 * @return New instance of the selector
	 */
	public static sflib_IRecordActionsSelector newInstance()
	{
		sflib_IRecordActionsSelector selector =
				(implementationReplacement == null) ? (sflib_IRecordActionsSelector) implementationType.newInstance() : implementationReplacement;
		selector.setDataAccess(fflib_SObjectSelector.DataAccess.USER_MODE);
		return selector;
	}

	/**
	 * Runs the query in System Mode, disabling FLS, CRUD & sharing rules
	 *
	 * @return New instance of the selector
	 */
	public static sflib_IRecordActionsSelector newElevatedInstance()
	{
		sflib_IRecordActionsSelector selector =
				(implementationReplacement == null) ? (sflib_IRecordActionsSelector) implementationType.newInstance() : implementationReplacement;
		selector.setDataAccess(fflib_SObjectSelector.DataAccess.SYSTEM_MODE);
		return selector;
	}

	/**
	 * Class constructor
	 * This should not be used directly by an application but only by fflib
	 */
	public sflib_RecordActionsSelector()
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
				sflib_RecordAction__c.Id,
				sflib_RecordAction__c.Description__c,
				sflib_RecordAction__c.FlowName__c,
				sflib_RecordAction__c.Formula__c,
				sflib_RecordAction__c.Icon__c,
				sflib_RecordAction__c.Order__c,
				sflib_RecordAction__c.SObjectType__c,
				sflib_RecordAction__c.Status__c
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
		return Schema.sflib_RecordAction__c.SObjectType;
	}

	/**
	 * Replace the default implementation of the service
	 *
	 * @param systemType The System.Type of the replacement class
	 */
	public static void replaceWith(System.Type systemType)
	{
		sflib_RecordActionsSelector.implementationType = systemType;
	}

	/**
	 * Replace the default implementation of the service
	 *
	 * @param replacement A replacement instance
	 *
	 * @see sflib_IRecordActionsSelector
	 */
	public static void replaceWith(sflib_IRecordActionsSelector replacement)
	{
		sflib_RecordActionsSelector.implementationReplacement = replacement;
	}

	/**
	 * Queries sflib_RecordAction__c records by their record Id
	 *
	 * @param idSet A set of `sflib_RecordAction__c.Id` values
	 *
	 * @return A list of `sflib_RecordAction__c` records
	 */
	public virtual List<sflib_RecordAction__c> selectById(Set<Id> idSet)
	{
		return Database.query(
				newQueryFactory()
						.setCondition('Id IN :idSet')
						.toSOQL()
		);
	}

	/**
	 * Queries sflib_RecordAction__c records by their SObjectType value
	 *
	 * @param sObjectTypeNames A set of `sflib_RecordAction__c.SObjectType__c` values
	 *
	 * @return A list of `sflib_RecordAction__c` records
	 */
	public List<sflib_RecordAction__c> selectBySObjectType(Set<String> sObjectTypeNames) {
		fflib_QueryFactory queryFactory = newQueryFactory();

		((fflib_SObjectSelector) sflib_RecordActionConditionsSelector.newInstance())
				.addQueryFactorySubselect(
						queryFactory,
						'RecordActionConditions__r'
				);

		return Database.query(
				queryFactory
						.setCondition('SObjectType__c IN :sObjectTypeNames')
						.toSOQL()
		);
	}

	public override String getOrderBy() {
		return 'Order__c ASC';
	}
}
