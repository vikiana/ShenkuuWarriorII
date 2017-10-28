
/* AS3
	Copyright 2008
*/
package com.neopets.projects.neopetsGameShell.model
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	
	/**
	 *	This is a location to have all you specific commands for a project
	 * 	This is designed to be used so that you do not need to change the Game_Shell_Interface itself.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author Clive Henrick
	 *	@since  01.07.2009
	 */
	 
	public class ExternalCommands extends EventDispatcher implements IExternalCommands
	{
		
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var mParentClass:Object;
		protected var mConfigXML:XML;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function ExternalCommands(pParentClass:Object,pConfigXML:XML = null, target:IEventDispatcher=null)
		{
			mParentClass = pParentClass;
			mConfigXML = pConfigXML;
			super(target);
		}
		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Note:Commands that are to complex, so for now we must manuelly write a case state to Handle
		 * @Note: This Function can change from application to application. You should override this Class.
		 * @param		pCmd		String		The Function as a String
		 * @param		pParam		String		The List of Params for the Function
		 * @param		pObject		Object		An Object to do the Command on
		 */
		
		public function doExternalCommand(pCmd:String,pParam:String = null,pObject:Object = null):void
		{
			var tParamArray:Array = [];
			
			switch (pCmd)
			{
			case "sceneTransition":
			
				tParamArray = mParentClass.convertToArray(pParam);
				mParentClass.sceneTransition(mParentClass.getNeopetsScene(tParamArray[0]),mParentClass.getNeopetsScene(tParamArray[1]),tParamArray[2]);
			
			break;
			case "playSound":
				mParentClass.soundManager.soundPlay(pParam);
			break;
			case "gotoGame":
			
			break;
			}
		}
		
	}
	
}
