/* AS3
	Copyright 2008 The Groop
*/
package com.neopets.projects.neopetsGameShell.controller
{
	import com.neopets.projects.mvc.controller.IController;
	import com.neopets.projects.mvc.controller.LoadCmd;
	import com.neopets.projects.mvc.iLogic;
	import com.neopets.projects.mvc.model.ISharedListener;
	import com.neopets.projects.neopetsGameShell.events.SharedListener;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.loading.LoadingEngineXML;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	
	/**
	 *	This will Hold Most of the Commands used to Handle the Interactions of the Project. 
	 * This isa Static Class.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 	@Pattern MVC
	 * 
	 *	@author Clive Henrick
	 *	@since  08.04.08
	 */
	public class ProjectController extends EventDispatcher implements IController
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public const ID:String = "ProjectController";
		public const PROJECT_CONTROLLER_READY:String = "ProjectControllerisReady";
		
		public static const CMD_LOADITEMS:String = "LoadThisViewItems";
		public static const CMD_XML_LOAD:String = "LoadThisXML";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var mLoadingEngines:Array;
		private var mSharedListener:SharedListener;
		private var mProjectLogic:iLogic;
		private var mBridgeConnection:BridgeConnection;
		//private var mTranslationController:TranslationManager;

		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function ProjectController(target:IEventDispatcher=null)
		{
			super(target);
			setupVars();
		}
		
		
		
		/**
		 *	@NOTE: This sends the Command to the Correct Command 
		 */
		 
		public function activateCMD(pCMD:String,pObject:Object = null):void
		{
			switch (pCMD) 
			{
				case CMD_XML_LOAD:
					var tLoadCmd:LoadCmd = new LoadCmd("ViewItemsLC");
					tLoadCmd.doCMD(tLoadCmd.CMD_LOAD_XML_SWFS,pObject);
					tLoadCmd.addEventListener(tLoadCmd.CMD_FINISHED,onCmdFinished);
				break;
				case CMD_LOADITEMS:
					var tLoadingEngine:LoadingEngineXML = new LoadingEngineXML();
					tLoadingEngine.init(pObject.XML,pObject.NAME);
					tLoadingEngine.addEventListener(tLoadingEngine.LOADING_COMPLETE, onCmdLoadingEngineDone);
				break;
			}	
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------

		public function init(pSharedListener:ISharedListener,pProjectLogic:iLogic):void
		{
			mSharedListener = pSharedListener as SharedListener;
			mProjectLogic = pProjectLogic;
			mBridgeConnection = new BridgeConnection(mProjectLogic);
			
			dispatchEvent(new Event(PROJECT_CONTROLLER_READY));
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		private function onSoundsReady(evt:Event):void
		{
			
		}
		
		/**
		 *	@Handles the Return Events from the Commands
		 */
		 /**
		 * All the Objects that are Requested Come Back Here
		 *  @param		evt.oData.LENGINE	LoadingEngineXML	The LoadingEngine with all the LoadingItems
		 *  @param		evt.oData.ITEM		String				The Object Being Requested (What was requested)
		 *  @param		evt.oData.ID		String				The Class that asked for the LEngine
		 */
		 private function onCmdFinished(evt:CustomEvent):void 
		 {
		 	
		 }

		 private function onCmdLoadingEngineDone(evt:CustomEvent):void
		 {
		 	mSharedListener.dispatchEvent(new CustomEvent({LENGINE:evt.currentTarget,ITEM:evt.currentTarget.ID,ID:evt.oData.ID},mSharedListener.CONTROLLER_SENDOBJ));		
		 }
		 
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		
		/**
		 *	@Setup Variables
		 */
		 
		 private function setupVars():void 
		 {
		 
		 	
		 }
	}
	
}
