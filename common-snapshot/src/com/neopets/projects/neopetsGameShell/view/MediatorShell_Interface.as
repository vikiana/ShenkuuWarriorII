/* AS3
	Copyright 2008
*/

package com.neopets.projects.neopetsGameShell.view
{

	import com.neopets.projects.mvc.view.LoadedItem;
	import com.neopets.projects.mvc.view.MediatorBase;
	import com.neopets.projects.neopetsGameShell.document.InterfaceShell;
	import com.neopets.projects.neopetsGameShell.events.GameShell_Events;
	
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
	
	/**
	 *	This is a the For the BackGround Plate 
	 * 	
	 *	@layer 0
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author Clive Henrick
	 *	@since  12.11.2008
	 */
	 
	public class MediatorShell_Interface extends MediatorBase
	{
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var mInterface:InterfaceShell;
		private var mTotalAssetsLoaded:uint;
		private var	mTotalAssetsToLoad:uint;
		private var mGameShell_Events:GameShell_Events;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function MediatorShell_Interface()
		{
			super();
			setLocalVars();
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		private function InterfaceReady(evt:Event):void
		{
			this.dispatchEvent(new Event(this.MEDIATOR_READY));
		}
		
		//--------------------------------------
		//  PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		
		/** 
		 * This is for Init of Items after the Parent is Class is Done
		 */
		 
		protected override function localInit():void
		{
			mGameShell_Events = mSiteLogic.gameShell_Events as GameShell_Events;
		}
		
		/** 
		 * This goes through each LoadedItem Object that the Loading Engine Returns
		 */
		 
		protected override function setupDisplayItem(pLoadingItem:LoadedItem):void
		{
			var tDisplayIndex:uint = pLoadingItem.objData.hasOwnProperty("DISPLAYORDER") ? pLoadingItem.objData.DISPLAYORDER:0;
			
			switch (pLoadingItem.objID)
			{
				case "INTERFACE":
					mInterface = pLoadingItem.objItem as InterfaceShell;
					mInterface.addEventListener(mInterface.READY,InterfaceReady,false,0,true);
					mViewContainer.addDisplayObjectUI(mInterface,tDisplayIndex,"mInterface");
					mTotalAssetsLoaded++;
					mInterface.externalInit(mGameShell_Events,mSiteLogic.configXML);
				break;
			}
					
		}
		
		
		//--------------------------------------
		//  PRIVATE INSTANCE METHODS
		//--------------------------------------
		
		
		private function setLocalVars():void
		{
			mTotalAssetsLoaded = 0;
			mTotalAssetsToLoad = 1;
		}
		
		 
		
		 
		
		
	}
	
}
