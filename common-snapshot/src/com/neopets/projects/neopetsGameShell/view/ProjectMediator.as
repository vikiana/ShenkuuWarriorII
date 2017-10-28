/* AS3
	Copyright 2008
*/

package com.neopets.projects.neopetsGameShell.view
{
	import com.neopets.projects.mvc.iLogic;
	import com.neopets.projects.mvc.model.ISharedListener;
	import com.neopets.projects.mvc.view.IMediator;
	import com.neopets.projects.mvc.view.IMediatorController;
	import com.neopets.projects.mvc.view.ViewContainerold;
	import com.neopets.projects.neopetsGameShell.events.SharedListener;
	import com.neopets.util.events.CustomEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	
	/**
	 *	This is a Mediator Basic Class
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author Clive Henrick
	 *	@since  08.04.2008
	 */
	 
	public class ProjectMediator extends EventDispatcher implements IMediatorController
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public const PROJECT_MEDIATOR_READY:String = "ProjectMediatorReady";
		public const ID:String = "ProjectMediator";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		private var mSharedListener:SharedListener
		private var mViewContainer:ViewContainerold;
		private var mProjectLogic:iLogic;
		
		private var mProjectMediatorsTotal:uint;
		private var mProjectMediatorsCount:uint;
		
		private var mMediatorShell_Interface:MediatorShell_Interface;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function ProjectMediator(target:IEventDispatcher=null)
		{
			super(target);
			setupVars();
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		
		public function get viewContainer():ViewContainerold
		{
			return mViewContainer;
		} 
		
		public function set projectMediatorsTotal(pNum:uint):void
		{
			mProjectMediatorsTotal = pNum;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function init(pSharedListener:ISharedListener,pSiteLogic:iLogic):void
		{
			mSharedListener = pSharedListener as SharedListener; 
			mProjectLogic = pSiteLogic;
	
			setUpViewContainers();
			mSharedListener.addEventListener(mSharedListener.PROJECT_CHANGE_FOCUS,onDisplayViewChange,false,0,true);
		}
		
		/**
		 * This is For adding the other View Mediators to the Master (Site) Mediator and its View Container
		 * You Do this to get all your Interfaces (UI View Containers) into one centeral File.
		 */
		 
		public function  addDisplayMediator(pViewMediator:IMediator):void
		{
			switch (pViewMediator.ID)
			{
				case "INTERFACE_Mediator":
					mMediatorShell_Interface = pViewMediator as MediatorShell_Interface;
					mViewContainer.addUIViewContainer(mMediatorShell_Interface.viewContainer,mMediatorShell_Interface.viewContainersLayer,mMediatorShell_Interface.viewContainer.ID);
					mMediatorShell_Interface.ActiveViewFlag = true;
					mProjectMediatorsCount++;
				break;
			}
			
			if (mProjectMediatorsCount == mProjectMediatorsTotal)
			{
				mViewContainer.reOrderDisplayList();
				this.dispatchEvent(new Event(PROJECT_MEDIATOR_READY));
			}
		
		}
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		private function setUpViewContainers():void
		{
			mViewContainer = new ViewContainerold("SiteViewContainer");
		}
		
		private function setupVars():void
		{
			mProjectMediatorsCount = 0;
		}
		
		/** Routes the Display to the Correct Screen
		 * 	@param		evt.oData.ID		String					Which Meditor Should Handles this request
		 * 	@param		evt.oData.GOTO		String					Where it should Go
		 * 	@param		evt.oData.PAGE		Number		Optional	The SubPage (area) for the Page to Open To
		 */
		 
		private function onDisplayViewChange(evt:CustomEvent):void
		{
			if (evt.oData.ID == ID) {
				switch (evt.oData.GOTO)
				{
					case "TEST":
					break;
				}	
			}
			
		}
		
		
	}
	
}
