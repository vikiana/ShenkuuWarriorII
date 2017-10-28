/* AS3
	Copyright 2008
*/
package com.neopets.projects.neopetsGameShell
{

	import com.neopets.projects.mvc.controller.IController;
	import com.neopets.projects.mvc.iLogic;
	import com.neopets.projects.mvc.model.ISharedListener;
	import com.neopets.projects.mvc.view.IView;
	import com.neopets.projects.neopetsGameShell.controller.ProjectController;
	import com.neopets.projects.neopetsGameShell.events.GameShell_Events;
	import com.neopets.projects.neopetsGameShell.events.SharedListener;
	import com.neopets.projects.neopetsGameShell.model.ProjectModel;
	import com.neopets.projects.neopetsGameShell.view.ProjectView;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	
	/**
	 *	This is the Main Class for the Shell for PPP Games. 
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@pattern MVC
	 * 
	 * 	@NOTE:
	 *  This Class will Handle Most of the Interactions between the Various Elements that Make up the Site
	 *  As well as the Class's that will Handle the Various Sub Elements such as
	 * 
	 *	@author Clive Henrick
	 *	@since  12.03.08
	 */
	 
	 
	public class ProjectLogic extends EventDispatcher implements iLogic {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const ID:String = "ProjectLogic";
		public static const PROJECT_LOGIC_READY:String = "ProjectLogicIsReady";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var mProjectModel:ProjectModel;
		private var mProjectView:ProjectView;
		private var mProjectController:ProjectController;
		
		private var mSharedListener:SharedListener;
		private var mGameShell_Events:GameShell_Events;
		
		private var mTotalProjectVC:uint;
		private var mTotalProjectVCcount:uint;
		
		private var mStartupLoadingMsg:String;
		
		private var mRootApplication:Stage;
		
		private var mConfigXML:XML;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function ProjectLogic ():void{
			setVars();
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get projectView():IView
		{
			return mProjectView;
		}
		
		public function get projectController():IController
		{
			return mProjectController;
		}
		
		public function get rootApplication():Object
		{
			return mRootApplication;
		}
		
		public function get gameShell_Events():ISharedListener
		{
			return mGameShell_Events;	
		}
		
		public function get sharedListener():ISharedListener
		{
			return mSharedListener;
		}
		
		public function get configXML():XML
		{
			return mConfigXML;
		}
		
		public function set configXML(pXML:XML):void
		{
			if (configXML == null)
			{
				mConfigXML = pXML;
			}
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Note This is the Init
		 * @param	pRootApplication 	Stage		The Root Movie
		 */
		 
		public function init(pRootApplication:Stage):void
		{
			mRootApplication = pRootApplication;
			mProjectModel.init(this);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @note: This is when each section reports back that it is ready
		 */
		 
		private function onProjectCoreReady(evt:Event):void
		{
			
			switch (evt.currentTarget.ID)
			{
				case mProjectModel.ID:
					mProjectController.init(mSharedListener,this);
					trace("Project Model is Done");
				break;
				case mProjectView.ID:
					trace("Project View is Done");
					setupGame();
				break;
				case mProjectController.ID:
					mProjectView.init(this);
					trace("Project Controller is Done");
				break;
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		
		private function setVars():void
		{
			mSharedListener = new SharedListener();
			mGameShell_Events = new GameShell_Events();
			mProjectModel = new ProjectModel();
			mProjectView = new ProjectView();
			mProjectController = new ProjectController();
			
			mProjectModel.addEventListener(mProjectModel.PROJECT_MODEL_READY,onProjectCoreReady,false,0,true);
			mProjectController.addEventListener(mProjectController.PROJECT_CONTROLLER_READY,onProjectCoreReady,false,0,true);
			mProjectView.addEventListener(mProjectView.PROJECT_VIEW_READY,onProjectCoreReady,false,0,true);
			
			mTotalProjectVC = 2;
			mTotalProjectVCcount = 0;
		
			mStartupLoadingMsg = "";
			
		}
		
		/**
		 * @Note this is the Game Setup Area
		 */
		 
		 private function setupGame():void
		 {
		 	mProjectView.projectMediator.viewContainer.reOrderDisplayList();
		 	
		 	mRootApplication.addChild(mProjectView.projectViewContainer);
		 }

	}
	
}
