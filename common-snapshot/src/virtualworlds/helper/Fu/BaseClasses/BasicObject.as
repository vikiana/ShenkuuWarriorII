package virtualworlds.helper.Fu.BaseClasses
{
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import org.spicefactory.lib.logging.*;
	
	// this is the start of the movieclip types
	public class BasicObject extends MovieClip
	{
		protected var log : Logger = null;
		
		public function BasicObject()
		{
			if (log == null) {
				
				try
				{
					var className:String = getQualifiedClassName(this);
					var classType:Class = getDefinitionByName(className) as Class;
					log = LogContext.getLogger(classType);
				}
				catch(e:Error)
				{
					log = LogContext.getLogger(Object);
				}
			}
		}
		
		// use this instead of trace
		protected function output(aString:String):void{
			
		}
		
		// use this instead of throw new error
		protected function error(aString:String):void{
			throw new Error(aString + ":" + this)
		}
		
	}
}