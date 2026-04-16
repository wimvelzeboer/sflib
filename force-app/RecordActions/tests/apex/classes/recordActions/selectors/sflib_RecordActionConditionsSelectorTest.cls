/**
 * sflib_RecordActionConditionsSelectorTest selector test class
 *
 * This class is testing the selector sflib_RecordActionConditionsSelector and all its methods.
 *
 * @see sflib_RecordActionConditionsSelector
 */
@IsTest(IsParallel=true)
private class sflib_RecordActionConditionsSelectorTest
{
	@IsTest
	static void testBehavior()
	{
		sflib_RecordActionConditionsSelector.replaceWith(sflib_IRecordActionConditionsSelector.class);
		sflib_RecordActionConditionsSelector.replaceWith(new sflib_RecordActionConditionsSelector());
		sflib_RecordActionConditionsSelector.newInstance();
		sflib_IRecordActionConditionsSelector selector = sflib_RecordActionConditionsSelector.newElevatedInstance();

		selector.selectById(new Set<Id>());
		selector.selectSObjectsById(new Set<Id>());
	}
}
