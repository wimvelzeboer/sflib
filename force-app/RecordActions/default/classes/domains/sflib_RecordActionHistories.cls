/**
 * sflib_RecordActionHistories domain class
 *
 * This domain is a wrapper around sflib_RecordActionHistory__c records, and it contains getter,
 * setter and filter (selector) methods.
 *
 * Getters retrieve field values from all the sflib_RecordActionHistory__c records in this domain
 * Setters change field values on all the sflib_RecordActionHistory__c records in this domain
 * Selectors filter the contents of this domain
 *
 * The getter, setter and selector methods always targets (iterate over)
 * all the records the domain contains.
 * First use a selector, when a certain setter or getter method should target
 * only a subset.
 *
 * The only concern/context known to this domain is the List of sflib_RecordActionHistory__c records
 * it encapsulates. It is not aware of anything outside this domain,
 * so there should be no references to other classes or object types besides
 * the classes it is extended from
 *
 * @see sflib_IRecordActionHistories
 *
 * @example
 * Map<Id, sflib_RecordActionHistory__c> recordActionHistoriesById =
 *              sflib_RecordActionHistories.newInstance(recordIds)
 *                      .selectBySomeField('Holland')
 *                      .getById();
 */
public virtual inherited sharing class sflib_RecordActionHistories extends fflib_SObjects2 implements sflib_IRecordActionHistories
{
	/**
	 * Class constructor
	 *
	 * @param records Constructs the domain with the given records
	 *
	 * @return Returns a new instance of the sflib_RecordActionHistories domain
	 *
	 * @see sflib_IRecordActionHistories
	 */
	public static sflib_IRecordActionHistories newInstance(List<sflib_RecordActionHistory__c> records)
	{
		return new sflib_RecordActionHistories(records);
	}

	/**
	 * Class constructor
	 *
	 * @param ids Constructs the domain by querying the given record Ids
	 *
	 * @return Returns a new instance of the sflib_RecordActionHistories domain
	 *
	 * @see sflib_IRecordActionHistories
	 * @see sflib_RecordActionHistorySelector
	 */
	public static sflib_IRecordActionHistories newInstance(Set<Id> ids)
	{
		return new sflib_RecordActionHistories(sflib_RecordActionHistorySelector.newInstance().selectById(ids));
	}

	/**
	 * Class constructor
	 *
	 * @param ids Constructs the domain by querying the given record Ids in a SYSTEM_MODE context
	 *
	 * @return Returns a new instance of the sflib_RecordActionHistories domain
	 *
	 * @see sflib_IRecordActionHistories
	 * @see sflib_RecordActionHistorySelector
	 */
	public static sflib_IRecordActionHistories newElevatedInstance(Set<Id> ids)
	{
		return new sflib_RecordActionHistories(sflib_RecordActionHistorySelector.newElevatedInstance().selectById(ids));
	}

	/**
	 * Class constructor
	 *
	 * Avoid instantiating this constructor directly, instead use the static newInstance methods
	 *
	 * @param records A list of `sflib_RecordActionHistory__c` records
	 *
	 * @see sflib_RecordActionHistory__c
	 */
	@TestVisible
	protected sflib_RecordActionHistories(List<sflib_RecordActionHistory__c> records)
	{
		super(records, Schema.sflib_RecordActionHistory__c.SObjectType);
	}

	/**
	 * Get the `sflib_RecordActionHistory__c` records the domain contains
	 *
	 * @return Returns the list of `sflib_RecordActionHistory__c` records
	 *
	 * @see sflib_RecordActionHistory__c
	 *
	 * @example
	 * List<sflib_RecordActionHistory__c> filteredRecordActionHistories =
	 *         sflib_RecordActionHistories.newInstance(recordIds)
	 *                 .selectBySomeField('Holland')
	 *                 .getRecordActionHistories();
	 */
	public List<sflib_RecordActionHistory__c> getRecordActionHistories()
	{
		return getRecords();
	}

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
	public Map<Id, sflib_RecordActionHistory__c> getById()
	{
		return new Map<Id, sflib_RecordActionHistory__c>(getRecordActionHistories());
	}

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
	public Map<Id, sflib_RecordActionHistory__c> getLatestByActionId() {
		Map<Id, sflib_RecordActionHistory__c> result = new Map<Id, sflib_RecordActionHistory__c>();
		for (sflib_RecordActionHistory__c record : getRecordActionHistories()) {
			if (result.containsKey(record.RecordAction__c)
					&& result.get(record.RecordAction__c).CreatedDate <= record.CreatedDate) continue;

			result.put(record.RecordAction__c, record);
		}
		return result;
	}

	/**
         * Gets a sub-selection of the `sflib_RecordActionHistory__c` records matching the given ids
         *
         * @param ids A set of `sflib_RecordActionHistory__c.Id` values
         *
         * @return Returns a new instance of the sflib_RecordActionHistories domain containing the matching records
         *
         * @see sflib_IRecordActionHistories
         *
         * @example sflib_IRecordActionHistories subset = recordActionHistories.selectById(recordIds);
         */
	public sflib_IRecordActionHistories selectById(Set<Id> ids)
	{
		return new sflib_RecordActionHistories(getRecords(ids));
	}

	/**
	 * Gets a sub-selection of the sflib_RecordActionHistories records where the given (String) field is blank
	 *
	 * @param sObjectField A String field on the `sflib_RecordActionHistory__c` object
	 *
	 * @return Returns a list of `sflib_RecordActionHistory__c` records containing only the matching records
	 *
	 * @see sflib_IRecordActionHistories
	 * @see Schema.SObjectField
	 *
	 * @example
	 * public sflib_IRecordActionHistories selectWithBlankName()
	 * {
	 *     return new sflib_RecordActionHistories(selectBlank(Schema.sflib_RecordActionHistory__c.Name));
	 * }
	 */
	@TestVisible
	protected List<sflib_RecordActionHistory__c> selectBlank(Schema.SObjectField sObjectField)
	{
		List<sflib_RecordActionHistory__c> result = new List<sflib_RecordActionHistory__c>();
		for (sflib_RecordActionHistory__c record : getRecordActionHistories())
		{
			if (String.isNotBlank(String.valueOf(record.get(sObjectField)))) continue;

			result.add(record);
		}
		return result;
	}

	/**
	 * Gets a sub-selection of the sflib_RecordActionHistories records where the given (String) field is not blank
	 *
	 * @param sObjectField A String field on the `sflib_RecordActionHistory__c` object
	 *
	 * @return Returns a list of `sflib_RecordActionHistory__c` records containing only the matching records
	 *
	 * @see sflib_IRecordActionHistories
	 * @see Schema.SObjectField
	 *
	 * @example
	 * public sflib_IRecordActionHistories selectWithName()
	 * {
	 *     return new sflib_RecordActionHistories(selectNonBlank(Schema.sflib_RecordActionHistory__c.Name));
	 * }
	 */
	@TestVisible
	protected List<sflib_RecordActionHistory__c> selectNonBlank(Schema.SObjectField sObjectField)
	{
		List<sflib_RecordActionHistory__c> result = new List<sflib_RecordActionHistory__c>();
		for (sflib_RecordActionHistory__c record : getRecordActionHistories())
		{
			if (String.isBlank(String.valueOf(record.get(sObjectField)))) continue;

			result.add(record);
		}
		return result;
	}

	/**
	 * Gets a sub-selection of the sflib_RecordActionHistories records where the given field is not null
	 * Tip: use selectNonBlank for String fields
	 *
	 * @param sObjectField A field on the `sflib_RecordActionHistory__c` object
	 *
	 * @return Returns a list of `sflib_RecordActionHistory__c` records containing only the matching records
	 *
	 * @see sflib_IRecordActionHistories
	 * @see Schema.SObjectField
	 *
	 * @example
	 * public sflib_IRecordActionHistories selectExistingRecords()
	 * {
	 *     return new sflib_RecordActionHistories(selectWith(Schema.sflib_RecordActionHistory__c.Name));
	 * }
	 */
	@TestVisible
	protected List<sflib_RecordActionHistory__c> selectWith(Schema.SObjectField sObjectField)
	{
		List<sflib_RecordActionHistory__c> result = new List<sflib_RecordActionHistory__c>();
		for (sflib_RecordActionHistory__c record : getRecordActionHistories())
		{
			if (record.get(sObjectField) == null) continue;

			result.add(record);
		}
		return result;
	}

	/**
	 * Gets a sub-selection of the sflib_RecordActionHistories records where the given field is null
	 * Tip: use selectBlank for String fields
	 *
	 * @param sObjectField A field on the `sflib_RecordActionHistory__c` object
	 *
	 * @return Returns a list of `sflib_RecordActionHistory__c` records containing only the matching records
	 *
	 * @see sflib_IRecordActionHistories
	 * @see Schema.SObjectField
	 *
	 * @example
	 * public sflib_IRecordActionHistories selectNewRecords()
	 * {
	 *     return new sflib_RecordActionHistories(selectWithout(Schema.sflib_RecordActionHistory__c.Name));
	 * }
	 */
	@TestVisible
	protected List<sflib_RecordActionHistory__c> selectWithout(Schema.SObjectField sObjectField)
	{
		List<sflib_RecordActionHistory__c> result = new List<sflib_RecordActionHistory__c>();
		for (sflib_RecordActionHistory__c record : getRecordActionHistories())
		{
			if (record.get(sObjectField) != null) continue;

			result.add(record);
		}
		return result;
	}
}
