
/* AS3
	Copyright 2008 NeoPets
*/
package com.neopets.projects.mvc.model
{
	import com.neopets.util.events.CustomEvent;
	
	import flash.events.*;
	
	
	/**
	 *	This is a Class for Sending Events to Various Objects within the Scope of the Project
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author Clive Henrick
	 *	@since  12.04.2008
	 */
	 
	public class BaseSharedListener extends EventDispatcher implements ISharedListener
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		
		/* PROXY REQUEST */
		public static const PROXY_SENDOBJ:String = "ContainerSendObject";				//Send an Loaded Object to Another Class
		public static const PROXY_GETOBJ:String = "ContainerGetObject";				//Get an Loaded Object from another Class
		public static const PROXY_LOADERROR:String = "ErrorLoadingXML";				//PROXY Could not get the Asked for Item
		
		public const CONTROLLER_SENDOBJ:String = "ControllerReturnObject";		//A LoadedObject is being Returned to the Class
		
		/* PROJECT LEVEL EVENTS */
		
		
		/* SMARTFOX EVENTS */
		
		
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function BaseSharedListener():void {}
		
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
