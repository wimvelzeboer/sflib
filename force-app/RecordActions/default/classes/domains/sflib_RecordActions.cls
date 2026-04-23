/**
 * sflib_RecordActions domain class
 *
 * This domain is a wrapper around sflib_RecordAction__c records, and it contains getter,
 * setter and filter (selector) methods.
 *
 * Getters retrieve field values from all the sflib_RecordAction__c records in this domain
 * Setters change field values on all the sflib_RecordAction__c records in this domain
 * Selectors filter the contents of this domain
 *
 * The getter, setter and selector methods always targets (iterate over)
 * all the records the domain contains.
 * First use a selector, when a certain setter or getter method should target
 * only a subset.
 *
 * The only concern/context known to this domain is the List of sflib_RecordAction__c records
 * it encapsulates. It is not aware of anything outside this domain,
 * so there should be no references to other classes or object types besides
 * the classes it is extended from
 *
 * @see sflib_IRecordActions
 *
 * @example
 * Map<Id, sflib_RecordAction__c> recordActionsById =
 *              sflib_RecordActions.newInstance(recordIds)
 *                      .selectBySomeField('Holland')
 *                      .getById();
 */
public virtual inherited sharing class sflib_RecordActions extends fflib_SObjects2 implements sflib_IRecordActions
{
	/**
	 * Class constructor
	 *
	 * @param records Constructs the domain with the given records
	 *
	 * @return Returns a new instance of the sflib_RecordActions domain
	 *
	 * @see sflib_IRecordActions
	 */
	public static sflib_IRecordActions newInstance(List<sflib_RecordAction__c> records)
	{
		records.sort(new RecordActionComparator());
		return new sflib_RecordActions(records);
	}

	/**
	 * Class constructor
	 *
	 * @param ids Constructs the domain by querying the given record Ids
	 *
	 * @return Returns a new instance of the sflib_RecordActions domain
	 *
	 * @see sflib_IRecordActions
	 * @see sflib_RecordActionsSelector
	 */
	public static sflib_IRecordActions newInstance(Set<Id> ids)
	{
		return new sflib_RecordActions(sflib_RecordActionsSelector.newInstance().selectById(ids));
	}

	/**
	 * Class constructor
	 *
	 * @param ids Constructs the domain by querying the given record Ids in a SYSTEM_MODE context
	 *
	 * @return Returns a new instance of the sflib_RecordActions domain
	 *
	 * @see sflib_IRecordActions
	 * @see sflib_RecordActionsSelector
	 */
	public static sflib_IRecordActions newElevatedInstance(Set<Id> ids)
	{
		return new sflib_RecordActions(sflib_RecordActionsSelector.newElevatedInstance().selectById(ids));
	}

	/**
	 * Class constructor
	 *
	 * Avoid instantiating this constructor directly, instead use the static newInstance methods
	 *
	 * @param records A list of `sflib_RecordAction__c` records
	 *
	 * @see sflib_RecordAction__c
	 */
	@TestVisible
	protected sflib_RecordActions(List<sflib_RecordAction__c> records)
	{
		super(records, Schema.sflib_RecordAction__c.SObjectType);
	}

	/**
	 * Adds a DML error message to each record in the domain
	 *
	 * @param sObjectField The SObjectField to which the error message should be linked
	 * @param message The error message
	 *
	 * @return Returns an instance of itself to allow for method chaining
	 */
	public sflib_IRecordActions addErrorMessage(SObjectField sObjectField, String message) {
		for (SObject record : this.getRecords()) {
			record.addError(sObjectField, message);
		}
		return this;
	}

	/**
	 * Get the `sflib_RecordAction__c` records the domain contains
	 *
	 * @return Returns the list of `sflib_RecordAction__c` records
	 *
	 * @see sflib_RecordAction__c
	 *
	 * @example
	 * List<sflib_RecordAction__c> filteredRecordActions =
	 *         sflib_RecordActions.newInstance(recordIds)
	 *                 .selectBySomeField('Holland')
	 *                 .getRecordActions();
	 */
	public List<sflib_RecordAction__c> getRecordActions()
	{
		return getRecords();
	}

	/**
	 * Gets the record Id List in the order which they are stored inside the domain
	 *
	 * @return Returns an ordered list of `sflib_RecordAction__c.Id` values
	 */
	public List<Id> getRecordIdList() {
		List<Id> results = new List<Id>();
		for (SObject record : getRecords()) {
			results.add(record.Id);
		}
		return results;
	}

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
	public Map<Id, sflib_RecordAction__c> getById()
	{
		return new Map<Id, sflib_RecordAction__c>(getRecordActions());
	}

	/**
	 * Get a set of referenced formula numbers by their record Id
	 *
	 * @return Returns the numbers referenced in the `Formula__c` field by their record Id
	 */
	public Map<Id, Set<Integer>> getFormulaNumbersById() {
		Map<Id, Set<Integer>> result = new Map<Id, Set<Integer>>();
		for (sflib_RecordAction__c record : getRecordActions()) {
			Pattern MyPattern = Pattern.compile('\\d++');
			Matcher MyMatcher = MyPattern.matcher(record.Formula__c);

			Set<Integer> matches = new Set<Integer>();
			while (MyMatcher.find()) {
				// m.group() is an alias for m.group(0), which returns the full match
				matches.add(Integer.valueOf(MyMatcher.group()));
			}
			result.put(record.Id, matches);
		}
		return result;
	}

	/**
	 * Gets a sub-selection of the `sflib_RecordAction__c` records matching the given ids
	 *
	 * @param ids A set of `sflib_RecordAction__c.Id` values
	 *
	 * @return Returns a new instance of the sflib_RecordActions domain containing the matching records
	 *
	 * @see sflib_IRecordActions
	 *
	 * @example sflib_IRecordActions subset = recordActions.selectById(recordIds);
	 */
	public sflib_IRecordActions selectById(Set<Id> ids)
	{
		return new sflib_RecordActions(getRecords(ids));
	}

	/**
	 * Gets a sub-selection of the `sflib_RecordAction__c` records matching the given SObject name
	 *
	 * @param sObjectName A `sflib_RecordAction__c.SObjectType__c` value
	 *
	 * @return Returns a new instance of the sflib_RecordActions domain containing the matching records
	 *
	 * @example sflib_IRecordActions subset = recordActions.selectBySObjectType('Account');
	 */
	public sflib_IRecordActions selectBySObjectType(String sObjectName) {
		return new sflib_RecordActions(getRecords(Schema.sflib_RecordAction__c.SObjectType__c, sObjectName));
	}

	/**
	 * Gets a sub-selection of the `sflib_RecordAction__c` records matching the given Status value
	 *
	 * @param statusValue A `sflib_RecordAction__c.Status__c` value
	 *
	 * @return Returns a new instance of the sflib_RecordActions domain containing the matching records
	 *
	 * @example sflib_IRecordActions subset = recordActions.selectByStatus('Draft');
	 */
	public sflib_IRecordActions selectByStatus(String statusValue) {
		return new sflib_RecordActions(getRecords(Schema.sflib_RecordAction__c.Status__c, statusValue));
	}

	/**
	 * Sets a new value for the Status field
	 *
	 * @param statusValue The new value for the `Status__c` field
	 *
	 * @return Returns an instance of itself to allow for method chaining
	 */
	public sflib_IRecordActions setStatus(String statusValue) {
		setFieldValue(Schema.sflib_RecordAction__c.Status__c, statusValue);
		return this;
	}

	/**
	 * Gets a sub-selection of the sflib_RecordActions records where the given (String) field is blank
	 *
	 * @param sObjectField A String field on the `sflib_RecordAction__c` object
	 *
	 * @return Returns a list of `sflib_RecordAction__c` records containing only the matching records
	 *
	 * @see sflib_IRecordActions
	 * @see Schema.SObjectField
	 *
	 * @example
	 * public sflib_IRecordActions selectWithBlankName()
	 * {
	 *     return new sflib_RecordActions(selectBlank(Schema.sflib_RecordAction__c.Name));
	 * }
	 */
	@TestVisible
	protected List<sflib_RecordAction__c> selectBlank(Schema.SObjectField sObjectField)
	{
		List<sflib_RecordAction__c> result = new List<sflib_RecordAction__c>();
		for (sflib_RecordAction__c record : getRecordActions())
		{
			if (String.isNotBlank(String.valueOf(record.get(sObjectField)))) continue;

			result.add(record);
		}
		return result;
	}

	/**
	 * Gets a sub-selection of the sflib_RecordActions records where the given (String) field is not blank
	 *
	 * @param sObjectField A String field on the `sflib_RecordAction__c` object
	 *
	 * @return Returns a list of `sflib_RecordAction__c` records containing only the matching records
	 *
	 * @see sflib_IRecordActions
	 * @see Schema.SObjectField
	 *
	 * @example
	 * public sflib_IRecordActions selectWithName()
	 * {
	 *     return new sflib_RecordActions(selectNonBlank(Schema.sflib_RecordAction__c.Name));
	 * }
	 */
	@TestVisible
	protected List<sflib_RecordAction__c> selectNonBlank(Schema.SObjectField sObjectField)
	{
		List<sflib_RecordAction__c> result = new List<sflib_RecordAction__c>();
		for (sflib_RecordAction__c record : getRecordActions())
		{
			if (String.isBlank(String.valueOf(record.get(sObjectField)))) continue;

			result.add(record);
		}
		return result;
	}

	/**
	 * Gets a sub-selection of the sflib_RecordActions records where the given field is not null
	 * Tip: use selectNonBlank for String fields
	 *
	 * @param sObjectField A field on the `sflib_RecordAction__c` object
	 *
	 * @return Returns a list of `sflib_RecordAction__c` records containing only the matching records
	 *
	 * @see sflib_IRecordActions
	 * @see Schema.SObjectField
	 *
	 * @example
	 * public sflib_IRecordActions selectExistingRecords()
	 * {
	 *     return new sflib_RecordActions(selectWith(Schema.sflib_RecordAction__c.Name));
	 * }
	 */
	@TestVisible
	protected List<sflib_RecordAction__c> selectWith(Schema.SObjectField sObjectField)
	{
		List<sflib_RecordAction__c> result = new List<sflib_RecordAction__c>();
		for (sflib_RecordAction__c record : getRecordActions())
		{
			if (record.get(sObjectField) == null) continue;

			result.add(record);
		}
		return result;
	}

	/**
	 * Gets a sub-selection of the sflib_RecordActions records where the given field is null
	 * Tip: use selectBlank for String fields
	 *
	 * @param sObjectField A field on the `sflib_RecordAction__c` object
	 *
	 * @return Returns a list of `sflib_RecordAction__c` records containing only the matching records
	 *
	 * @see sflib_IRecordActions
	 * @see Schema.SObjectField
	 *
	 * @example
	 * public sflib_IRecordActions selectNewRecords()
	 * {
	 *     return new sflib_RecordActions(selectWithout(Schema.sflib_RecordAction__c.Name));
	 * }
	 */
	@TestVisible
	protected List<sflib_RecordAction__c> selectWithout(Schema.SObjectField sObjectField)
	{
		List<sflib_RecordAction__c> result = new List<sflib_RecordAction__c>();
		for (sflib_RecordAction__c record : getRecordActions())
		{
			if (record.get(sObjectField) != null) continue;

			result.add(record);
		}
		return result;
	}

	/**
	 * Compares two sflib_RecordAction__c records and sorts them by their order field
	 */
	private class RecordActionComparator implements Comparator<sflib_RecordAction__c> {
		public Integer compare(sflib_RecordAction__c left, sflib_RecordAction__c right) {
			// Handle null values: nulls sort to the end
			if(left.Order__c == null) return 1;
			if(right.Order__c == null) return -1;
			return left.Order__c < right.Order__c ? -1 : 1;
		}
	}
}
