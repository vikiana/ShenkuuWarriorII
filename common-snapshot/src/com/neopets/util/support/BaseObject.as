
/* AS3
	Copyright 2008
*/
package com.neopets.util.support
{
	import flash.display.MovieClip;
	
	
	/**
	 *	Adds Basic Functions to Every DisplayObject
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author Clive Henrick (based on Smerc code)
	 *	@since  01.09.2009
	 */
	 
	public class BaseObject extends MovieClip 
	{
		

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var mTraceReporting:Boolean = true;
		protected var mFlexComplie:Boolean;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		public function BaseObject():void{}
		
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
		
		public function set flexComplie(aFlag:Boolean):void
		{
			mFlexComplie = 	aFlag;
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
