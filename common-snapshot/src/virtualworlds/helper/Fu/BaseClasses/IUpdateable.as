package virtualworlds.helper.Fu.BaseClasses
{
	// a bridge for Objects and Classes
	public interface IUpdateable
	{
		function enter():void
		function execute(aStep:uint = 0):void
		function exit():void
	}
}