/**
 * sflib_RecordActionsSelectorTest selector test class
 *
 * This class is testing the selector sflib_RecordActionsSelector and all its methods.
 *
 * @see sflib_RecordActionsSelector
 */
@IsTest(IsParallel=true)
private class sflib_RecordActionsSelectorTest
{
	@IsTest
	static void testBehavior()
	{
		sflib_RecordActionsSelector.replaceWith(sflib_IRecordActionsSelector.class);
		sflib_RecordActionsSelector.replaceWith(new sflib_RecordActionsSelector());
		sflib_RecordActionsSelector.newInstance();
		sflib_IRecordActionsSelector selector = sflib_RecordActionsSelector.newElevatedInstance();

		selector.selectById(new Set<Id>());
		selector.selectSObjectsById(new Set<Id>());
		selector.selectBySObjectType(new Set<String>());
	}
}
