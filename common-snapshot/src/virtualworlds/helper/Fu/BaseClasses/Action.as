package virtualworlds.helper.Fu.BaseClasses
{
	import virtualworlds.helper.Fu.Helpers.ActionsController;
	
	public class Action extends UpdateableClass
	{
		
		public var controller:ActionsController
		
		public function Action()
		{
			super();	
		}
		
		
		public function removeActionCopies(aAction:Action):Boolean
		{
			return false
		}
		
		
		

	}
}