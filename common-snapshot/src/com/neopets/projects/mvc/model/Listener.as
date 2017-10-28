
/* AS3
	Copyright 2008
*/
package com.neopets.projects.mvc.model
{
	import com.neopets.projects.mvc.model.ISharedListener;
	import com.neopets.util.events.CustomEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	
	/**
	 *	This a Class to Send Events through a Closed Non Display Object System
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author Clive Henrick
	 *	@since  12.16.2008
	 */
	 
	public class Listener extends EventDispatcher implements ISharedListener
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function Listener(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		/**
		 * @Note: This is for sending an Object (Data) with an Event
		 * @param		pEvent			String
		 * @param		pObject			Object
		 * @param		pBubbles		Boolean
		 * @param		pCancelable		Boolean
		 */
		
		public function sendCustomEvent(pEvent:String,pObject:Object, pBubbles:Boolean=false, pCancelable:Boolean=false):void {
			this.dispatchEvent(new CustomEvent(pObject,pEvent,pBubbles,pCancelable));
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
