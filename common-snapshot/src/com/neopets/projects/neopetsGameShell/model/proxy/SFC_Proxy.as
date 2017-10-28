
/* AS3
	Copyright 2008
*/
package com.neopets.projects.neopetsGameShell.model.proxy
{
	import com.neopets.projects.mvc.model.ISharedListener;
	import com.neopets.projects.mvc.model.Proxy;
	import com.neopets.projects.neopetsGameShell.events.GameShell_Events;
	import com.neopets.util.events.CustomEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import it.gotoandplay.smartfoxserver.SFSEvent;
	import it.gotoandplay.smartfoxserver.SmartFoxClient;
	
	/**
	 *	This is the Proxy is to handle the holding of the SFC. The Class does not handle specific events as that can be done in 
	 *  a seperate class for a specific instance for a Game Engine.
	 * 
	 *  The SFC will be from the PPP Engine in the final Version of this Class, not generated in the Class
	 * 
	 * 	Some Basic Concepts of this Class
	 * 		*Allow the User to use these Built in Functions to interact with SFC
	 * 		*Allow the User to get the SFC and do all the process directly
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author Clive Henrick
	 *	@since  12.15.2008
	 */
	 
	public class SFC_Proxy extends EventDispatcher
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var mSmartFoxClient:SmartFoxClient;
		private var mGameShell_Events:GameShell_Events;
		private var mSFCFromWorldEngine:Boolean = false;
		private var mID:String;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function SFC_Proxy(pID:String="SFC_Proxy",target:IEventDispatcher=null)
		{
			super(target);
			mID = pID;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get ID():String
		{
			return mID;
		}
		
		public function set SFClient(pSFC:SmartFoxClient):void
		{
			if (mSmartFoxClient == null)
			{
			 	mSmartFoxClient = pSFC;	
			}	
		}
		
		public function get SFClient():SmartFoxClient
		{
			if (mSmartFoxClient == null)
			{
				mSmartFoxClient = new SmartFoxClient(true);	
			}
			else
			{
				return mSmartFoxClient;	
			}
			
			return null;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * This is the Init of the Class
		 * @param	pGameSharedListener		ISharedListener			These Events are For Games Interfaces
		 * @param	pSFCFromWorldEngine		Boolean					If the SFC is going to be imported from another Source
		 */
		 		
		public function init(pGameSharedListener:ISharedListener,pSFCFromWorldEngine:Boolean = false, pSFC:SmartFoxClient = null):void
		{
			mGameShell_Events = pGameSharedListener as GameShell_Events;
			mSFCFromWorldEngine = pSFCFromWorldEngine;
			
			if (!mSFCFromWorldEngine)
			{
				if (mSmartFoxClient == null)
				{
					mSmartFoxClient = new SmartFoxClient(true);
				}	
			}
			else
			{
				mSmartFoxClient = pSFC;
			}
			
			mGameShell_Events.addEventListener(mGameShell_Events.ACTION_REQUEST_SFC, onRequestSFC, false,0,true);
			
		}
		
		/**
		 * This Connects SFC to the Server
		 *	@param		pHost		String 		The Location of the SFServer
		 */
		 
		 public function connectSFC(pHost:String = "localhost"):void
		 {
		 	mSmartFoxClient.connect(pHost);		
		 }
		 
		 /**
		 * This Disconnects SFC from the Server
		 */
		 
		 public function disconnectSFC():void
		 {
		 	mSmartFoxClient.disconnect();	
		 }
		 
		 
		 //--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 *	@Note:	This will return a reference to the SFC
		 */
		 
		 private function onRequestSFC(evt:Event):void
		 {
		 	mGameShell_Events.dispatchEvent(new CustomEvent({OBJECT:mSmartFoxClient},mGameShell_Events.ACTION_RETURN_SFC));
		 
		 	evt.stopImmediatePropagation();	
		 }
		 
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
