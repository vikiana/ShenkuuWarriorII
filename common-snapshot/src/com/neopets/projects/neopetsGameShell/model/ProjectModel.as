/* AS3
	Copyright 2008
*/
package com.neopets.projects.neopetsGameShell.model
{
	import com.neopets.mvc.iLogic;
	import com.neopets.mvc.model.Proxy;
	import com.neopets.neopetsGameShell.ProjectLogic;
	import com.neopets.neopetsGameShell.events.SharedListener;
	import com.neopets.neopetsGameShell.model.proxy.SFC_Proxy;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import it.gotoandplay.smartfoxserver.SmartFoxClient;
	
	
	/**
	 *	This will Hold the Proxys Used with the Data Objects for the Site
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 	@Pattern MVC
	 * 
	 *	@author Clive Henrick
	 *	@since  12.08.08
	 */
	public class ProjectModel extends EventDispatcher
	{
		
		//--------------------------------------
		// CLASS CONSTANTS 
		//--------------------------------------
		public const ID:String = "ProjectModel";
		public const PROJECT_MODEL_READY:String = "ProjectModelisReady";
		
		public static const PROXY_LOADINGDATA:Object = {PROXYID:"Proxy_SetupXML",ITEM:"CONFIG_XML",URL:ProjectURLData.LOCAL_DATA};
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var mSharedListener:SharedListener;
		
		private var mSetupData:Proxy;
		
		private var mProxysReady:Boolean;
		private var mProxysAmount:uint;
		private var mProxysCurrentReady:uint;
		private var mProjectLogic:iLogic;
		private var mProxySFC:SFC_Proxy;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function ProjectModel(target:IEventDispatcher=null)
		{
			super(target);
			
			setVars();
			
			
		}
		
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function init(pProjectLogic:iLogic):void
		{
		
			mProjectLogic = pProjectLogic;
			mSharedListener = mProjectLogic.sharedListener as SharedListener;
			setupProxys();
			loadData();
		}
		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 *	@The Proxy is ready to be in use
		*/
		
		private function onProxyReady(evt:Event):void
		{
			trace(evt.currentTarget.ID + " -- Proxy Data Is Recieved");
			
			mProxysCurrentReady++;
			
			//If to use SFC is in the config file set up the SFC_Proxy
			if (evt.currentTarget == mSetupData)
			{
				var tXML:XML = mSetupData.getXML(PROXY_LOADINGDATA.ITEM);
				
				if (Boolean(Number(tXML.SETUP.SMARTFOXCLIENT.USE)))
				{
					mProxySFC = new SFC_Proxy();
					
					if (Boolean(Number(tXML.SETUP.SMARTFOXCLIENT.USE_VWORLD)))
					{
						//############## TO DO: Will need the Code to get this from the PPP World Engine
						mProxySFC.init(mProjectLogic.gameShell_Events,true,new SmartFoxClient());	
					}
					else
					{
						mProxySFC.init(mProjectLogic.gameShell_Events);		
					}
				}	
			}
			
			if (mProxysAmount == mProxysCurrentReady)
			{
				mProjectLogic.configXML = mSetupData.getXML("CONFIG_XML");
				dispatchEvent(new Event(PROJECT_MODEL_READY));
			}
			
		}
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		private function setVars():void
		{
			mProxysReady= false;
			mProxysAmount = 1;
			mProxysCurrentReady = 0;
		}
		
		
		
		/**
		 *	@sets up all the Proxys
		 */
		private function setupProxys():void
		{		
			mSetupData = new Proxy(mSharedListener,PROXY_LOADINGDATA.PROXYID);	
			mSetupData.addEventListener(mSetupData.PROXY_READY,onProxyReady,false,0,true);
		}
		
		/**
		 *	@Tells the Proxys to Load there Data
		 */
		 
		private function loadData():void
		{
			
			mSetupData.loadData([[PROXY_LOADINGDATA.URL,PROXY_LOADINGDATA.ITEM]]);
		}
		
	}
	
}
