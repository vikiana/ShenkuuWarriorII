/* AS3
	Copyright 2008
*/
package com.neopets.projects.neopetsGameShell.view
{
	import com.neopets.projects.mvc.iLogic;
	import com.neopets.projects.mvc.model.ISharedListener;
	import com.neopets.projects.mvc.view.IMediator;
	import com.neopets.projects.mvc.view.IMediatorController;
	import com.neopets.projects.mvc.view.IView;
	import com.neopets.projects.mvc.view.ViewContainerold;
	import com.neopets.projects.neopetsGameShell.events.SharedListener;
	import com.neopets.projects.neopetsGameShell.model.ProjectModel;
	import com.neopets.projects.neopetsGameShell.model.ProjectURLData;
	import com.neopets.util.events.CustomEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	
	/**
	 *	This is the Main View Class for the Project. 
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@pattern MVC
	 * 
	 * 	@NOTE:
	 *  This Class will Handle Most of the Interactions between the Various View (UI) Elements that Make up the Site Area
	 *  @BIG NOTE:
	 * 	mSiteMediatorsTotal = THE TOTAL NUMBER OF MEDIATORS
	 * 
	 * 
	 *	@author Clive Henrick
	 *	@since  12.8.2008
	 */
	 
	public class ProjectView extends EventDispatcher implements IView
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public const ID:String = "ProjectView";
		public const PROJECT_VIEW_READY:String = "ProjectViewIsReady";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var mSharedListener:SharedListener;
		private var mProjectLogic:iLogic;
		
		private var mDataNeededArray:Array;
		private var mProjectMediator:ProjectMediator;
		private var mProjectMediatorsTotal:uint;
		
		private var mMediatorShell_Interface:MediatorShell_Interface;

		
		private var mConfigXML:XML;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function ProjectView (target:IEventDispatcher=null)
		{
			super(target);
			setVars();
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		public function get projectMediator():IMediatorController
		{
			return mProjectMediator;
		}
		
		public function get projectLogic():iLogic
		{
			return mProjectLogic;
		}
		
		public function get projectViewContainer():ViewContainerold
		{
			return mProjectMediator.viewContainer;	
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		/**
		 *	@Int of the View
		 * 	@param		evt.oData.ID		String		Object IDs requesting the DataObject
		 *  @param		evt.oData.PROXYID	String		The Proxys ID for the RequestedInfo
		 *  @param		evt.oData.ITEM		String		The Object Being Requested
		 * 	@param		evt.oData.LEFLAG	Boolean		false = Send Back as false as it means it is Not a LoadingList
		 */
		 
		public function init(pSiteLogic:iLogic):void
		{
			mProjectLogic = pSiteLogic;
			mSharedListener = pSiteLogic.sharedListener as SharedListener;
			
			mProjectMediator.init(mSharedListener,mProjectLogic);
			mProjectMediator.addEventListener(mProjectMediator.PROJECT_MEDIATOR_READY,onViewReady,false,0,true);
			
			mConfigXML = mProjectLogic.configXML;
			
			setupView();
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 *  The SiteMediator and its View Container are Ready, So the SiteView is Ready. 
		*/
		
		private function onViewReady (evt:Event):void
		{
			this.dispatchEvent(new Event(PROJECT_VIEW_READY));
		}
		
		/**
		 *  The Mediator is Ready to be Loaded to the SiteMediator 
		*/
		
		private function onViewContainerReady(evt:Event):void
		{
			trace("View Mediator:>" + evt.currentTarget.ID + " Is Ready");
			mProjectMediator.addDisplayMediator(evt.currentTarget as IMediator);
		}
		
		
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	
		 
		private function setVars():void
		{
			mProjectMediator = new ProjectMediator();	
			mProjectMediatorsTotal = 0;		
			mConfigXML = new XML();	
		}
		
		/**
		 * @Note: Setting up the View Mediators
		 */
		
		private function setupView():void
		{
			var tCount:uint = mConfigXML.SETUP.LAYER.length();
			
			for (var t:uint = 0; t < tCount; t++)
			{
				if (Boolean(Number(mConfigXML.SETUP.LAYER[t].USE)))
				{
					mProjectMediatorsTotal++;
				}
			}
			mProjectMediator.projectMediatorsTotal = mProjectMediatorsTotal;
			setUpViewContainers(tCount);
		}
		
		/**
		 * This Setups the View Containers as needed from the Config File
		 * @param		pCount		uint		The Number of Items being Loaded
		 */
		 
		private function setUpViewContainers(pCount:uint):void
		{
			
			for (var t:uint = 0; t < pCount; t++)
			{
				
				if (Boolean(Number(mConfigXML.SETUP.LAYER[t].USE)))
				{
					switch (mConfigXML.SETUP.LAYER[t].ID.toString())
					{
						case "GAME_INTERFACE_LAYER":
							mMediatorShell_Interface = new MediatorShell_Interface();
							mMediatorShell_Interface.addEventListener(mMediatorShell_Interface.MEDIATOR_READY,onViewContainerReady,false,0,true);
							mMediatorShell_Interface.init(mSharedListener,{PROXYID:"Proxy_SetupXML",ITEM:"CONFIG_XML",URL:ProjectURLData.LOCAL_DATA},mProjectLogic,2,"INTERFACE","INTERFACE_Mediator");
						break;
					}	
				}
			}
		}
	}
}
