
/* AS3
	Copyright 2008
*/

package com.neopets.projects.mvc.controller
{
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.loading.LoadingEngineXML;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	

	/**
	 *	This Class holds a LoadingEngine and Returns it
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author Clive Henrick
	 *	@since  12.03.2008
	 */
	 
	public class LoadCmd extends EventDispatcher{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public const CMD_LOAD_XML_SWFS:String = "LoadfromXML";
		public const CMD_FINISHED:String = "FinishedCmd";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var mLoaderEngine:LoadingEngineXML;
		private var mID:String;
		private var RequestingID:String;
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		 public function LoadCmd (pID:String = "LoadController", target:IEventDispatcher=null)
		{
			super(target);
			mID = pID;
			setupVars();
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function doCMD (pCMD:String,pData:Object = null,pID:String = ""):void
		{
			switch (pCMD)
			{
				case CMD_LOAD_XML_SWFS:
					RequestingID = pID;
					mLoaderEngine.init(pData.XML);
					mLoaderEngine.addEventListener(mLoaderEngine.LOADING_COMPLETE,onLoadingEngineReady,false,0,true);	
				break;
			}	
		}
		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		private function onLoadingEngineReady(evt:Event):void
		{
			var tDataObject:Object = {LOADING_ENGINE:mLoaderEngine,ID:RequestingID};
			
			dispatchEvent(new CustomEvent(tDataObject,CMD_FINISHED));
		}
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 *	@Setup Variables
		 */
		 
		 private function setupVars():void 
		 {
		 	mLoaderEngine = new LoadingEngineXML();	
		 }
	}
	
}
