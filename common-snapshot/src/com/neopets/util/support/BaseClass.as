
/* AS3
	Copyright 2008
*/
package com.neopets.util.support
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	
	/**
	 *	This is a Root Class to Extend from to add some very basic functions
	 *	For all Non DisplayObject Classes
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author Clive Henrick (Based on Smerc Class of the Same Name)
	 *	@since  01.09.2009
	 */
	 
	public class BaseClass extends EventDispatcher
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE / PROTECTED VARIABLES
		//--------------------------------------
		
		protected var mTraceReporting:Boolean = true;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function BaseClass(target:IEventDispatcher=null){}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		/**
		 * @Note: Use this to turn on and off traces for this object 
		*/
		
		public function set traceReporting(aBool:Boolean):void
		{
			mTraceReporting = aBool;
		}
		
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * @Note: use this instead of trace
		*/
		
		protected function output(aString:String):void{
			if(mTraceReporting)
			{
				trace(aString + " : " + this)
			}
		}
		
		/**
		 * @Note: use this instead of throw new error
		*/
		
		// 
		protected function error(aString:String):void{
			throw new Error(aString + ":" + this)
		}
	}
	
}
