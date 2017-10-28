package com.neopets.projects.neopetsGameShell.support
{
	/**
	 *	this is a root class to extend from to add basic functions to trace and throw errors
	 *	for all non DisplayObject classes
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern 
	 * 
	 *	@author Clive Henrick (based on Smerc class of the same name)
	 *	@since  01.09.2009
	 */
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	 
	public class BaseClass extends EventDispatcher
	{
		//=============================================
		//	CLASS CONSTANTS
		//=============================================
		
		//=============================================
		//  VARIABLES
		//=============================================
		protected var mTraceReporting : Boolean = true;
		
		//=============================================
		//  GETTER/SETTERS
		//=============================================
		
		/**
		 * @Note: use this to turn on and off traces for this object 
		 */		
		public function set traceReporting( pBool : Boolean ):void
		{
			mTraceReporting = pBool;
		}
		
		//=============================================
		//  CONSTRUCTOR
		//=============================================
		public function BaseClass( target : IEventDispatcher = null )
		{
			super( );
			
			//trace( "BaseClass constructed" );
			
		}
		
		//=============================================
		//  PUBLIC METHODS
		//=============================================	
		
		//=============================================
		//  EVENT HANDLERS
		//=============================================
		
		//=============================================
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//=============================================
		
		/**
		 * @Note: use this instead of "trace"
		 */		
		protected function output( pString : String ):void
		{
			if( mTraceReporting )
			{
				trace( pString + " : " + this )
			}
		}
		
		/**
		 * @Note: use this instead of "throw new Error"
		 */		
		protected function error( pString : String ):void
		{
			throw new Error( pString + " : " + this)
		}
	}	
}
