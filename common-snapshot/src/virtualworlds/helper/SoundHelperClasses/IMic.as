package  virtualworlds.helper.SoundHelperClasses
{
	import flash.geom.Point;
	
	public interface IMic
	{
		/**
		 * the position of the mic 
		 * @return 
		 * 
		 */		
		function get position():Point
		
		/**
		 * the sensistivity in pixels of the mic as a radius 
		 * @return 
		 * 
		 */		
		function get sensitivity():uint
	}
}