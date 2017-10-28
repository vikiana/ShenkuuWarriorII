/* AS3
	Copyright 2008
*/
package com.neopets.projects.neopetsGameShell.controller
{
	import com.neopets.projects.mvc.iLogic;
	import com.neopets.projects.neopetsGameShell.events.GameShell_Events;
	import com.neopets.projects.neopetsGameShell.events.SharedListener;
	import com.neopets.projects.neopetsGameShell.support.NeopetsGameSupport;
	import com.neopets.util.events.CustomEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	
	/**
	 *	This Class is a Bridge for Handling Communications between the GameShell_Events and SharedListener Classes
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author 
	 *	@since  08.04.2008
	 */
	public class BridgeConnection extends EventDispatcher
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		private const ID:String = "BridgeConnection";
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var mSharedListener:SharedListener;
		private var mGameShell_Events:GameShell_Events;
		private var mProjectLogic:iLogic;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function BridgeConnection(pProjectLogic:iLogic,target:IEventDispatcher=null)
		{
			super(target);
			
			mProjectLogic = pProjectLogic;
			mSharedListener = mProjectLogic.sharedListener as SharedListener;
			mGameShell_Events = mProjectLogic.gameShell_Events as GameShell_Events;	
			
			mGameShell_Events.addEventListener(mGameShell_Events.ACTION_SEND_CMD_SHELL,translateRequestsGameShell,false,0,true);
			mSharedListener.addEventListener(mSharedListener.PROJECT_STOPSOUNDS,translateRequestsShell,false,0,true);
		
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function init ():void
		{
			
		}
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @Note: This translates an GameInterface CMD into the SharedListener
		 * @param	PassedObject.CMD		String		The Desired Command
		 * @param	PassedObject.PARAM		Object		The Desired Paramaters		
		 */
		 
		private function translateRequestsGameShell(evt:CustomEvent):void
		{
			switch (evt.oData.CMD)
			{
				case mGameShell_Events.CMD_GAME_END:
				
				break;	
				case mGameShell_Events.CMD_GAME_READY:
				
				break;
				case mGameShell_Events.CMD_GAME_START:
				
				break;
				case mGameShell_Events.ACTION_SEND_CMD_SHELL:
					mSharedListener.addEventListener(mSharedListener.PROXY_SENDOBJ,SendRequestObjectToGameShell,false,0,true);
					mSharedListener.dispatchEvent(new CustomEvent(evt.oData.PARAM,mSharedListener.PROXY_GETOBJ));
				break;	
			}
		}
		
		/**
		 *  When the Config File (or Data) is Returned
		 * 	@param		evt.oData.ID		String		Object IDs requesting the DataObject (This Class)
		 *  @param		evt.oData.XML		XML			The Requested Object (Useally XML)
		 *  @param		evt.oData.ITEM		String		The Object Being Requested (What was requested)
		 */
	
		private function SendRequestObjectToGameShell(evt:CustomEvent):void
		{
			if (evt.oData.ID == NeopetsGameSupport.ID)
			{
				mGameShell_Events.dispatchEvent(new CustomEvent({ID:evt.oData.ITEM,XML:evt.oData.XML},mGameShell_Events.ACTION_RETURN_DATA));	
				evt.stopImmediatePropagation();
			}
				
		}
		
		/**
		 * @Note: This translates an SharedListener CMDS into the GameShell_Events	
		 */
		 
		private function translateRequestsShell(evt:Event):void
		{
			
		}
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
