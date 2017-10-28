
package com.neopets.util.events
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 *	This is a Static EventDispatcher that can be shared across Projects
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern Singleton
	 * 
	 *	@author Clive Henrick
	 *	@since 9.13.2009
	 */
	 
	public class MultitonEventDispatcher extends EventDispatcher
	{
		//--------------------------------------
		//  PRIVATE / PROTECTED VARIABLES
		//--------------------------------------
		
		// The Multiton Key for this app
		protected var multitonKey : String;
	
		// The Multiton Facade instanceMap.
		protected static var instanceMap : Array = new Array(); 
	
		// Message Constants
		protected const MULTITON_MSG:String = "EventDispatcher instance for this Multiton key already constructed!";


		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function MultitonEventDispatcher(key:String)
		{
			if (instanceMap[ key ] != null) 
			{
				throw Error(MULTITON_MSG);	
			}
				
			instanceMap[ multitonKey ] = this;

		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public static function getInstance(key:String):MultitonEventDispatcher
		{ 
			if (instanceMap[ key ] == null ) 
			{
				instanceMap[ key ] = new MultitonEventDispatcher( key );	
			}
			
			return instanceMap[ key ];

		} 
	
	}
}
