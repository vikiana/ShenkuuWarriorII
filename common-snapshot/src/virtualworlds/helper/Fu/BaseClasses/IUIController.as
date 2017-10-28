package virtualworlds.helper.Fu.BaseClasses
{
	import virtualworlds.helper.Fu.Helpers.UIControllerTransitions.BasicTransition;
	
	public interface IUIController extends IUpdateable
	{ 
		function hide (target:IUIDisplayObject, transition:Object = null):void;
		function show(aUIDisplayObject:IUIDisplayObject, aTransition:BasicTransition = null):void;
	}
}