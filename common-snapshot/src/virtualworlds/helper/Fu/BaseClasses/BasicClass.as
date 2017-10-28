package virtualworlds.helper.Fu.BaseClasses
{
	
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	import org.spicefactory.lib.logging.*;
	
	// basic unit of a class, aka all things that arent display objects
	public class BasicClass extends EventDispatcher
	{
		protected var _traceReporting:Boolean = true;
		protected var log : Logger = null;
		
		public function BasicClass()
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
			log.error(aString, new Error(aString + ":" + this));
		}

	}
}