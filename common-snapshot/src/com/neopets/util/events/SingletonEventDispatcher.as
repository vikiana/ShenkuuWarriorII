package com.neopets.util.events
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 *	This is a Static (SingleTon EventDispatcher
	 * 		>> Intro Menu
	 * 		>> Instruction Menu
	 * 		>> Game Menu
	 * 		>> Game Over Menu
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern Singleton
	 * 
	 *	@author Clive Henrick
	 *	@since 8.27.2009
	 */
	 
	public class SingletonEventDispatcher extends EventDispatcher
	{
		//--------------------------------------
		//  PRIVATE / PROTECTED VARIABLES
		//--------------------------------------
		
		private static const mInstance:SingletonEventDispatcher = new SingletonEventDispatcher( SingletonEnforcer ); 
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function SingletonEventDispatcher(singletonEnforcer : Class = null)
		{
			if(singletonEnforcer != SingletonEnforcer){
				throw new Error( "Invalid Singleton access.  Use MenuManager.instance." ); 
			}
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public static function get instance():SingletonEventDispatcher
		{ 
			return mInstance;	
		} 
	
	}
}

/**
 * @Note: This is to make sure there is only one version of this class at a time
 */
 
internal class SingletonEnforcer{}