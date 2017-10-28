
/* AS3
	Copyright 2008
*/
package com.neopets.projects.support.trivia.cmds
{
	import com.neopets.projects.neopetsGameShell.model.ExternalCommands;
	
	import flash.events.IEventDispatcher;
	
	
	/**
	 *	This needs to contain information about the Class and what it is used for
	 *	Please use ASDocs if you can for your notes
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author Clive henrick
	 *	@since  02.04.2009
	 */
	 
	public class TriviaExternalCmds extends ExternalCommands
	{

		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function TriviaExternalCmds(pParentClass:Object,pConfigXML:XML = null, target:IEventDispatcher=null)
		{
			super(pParentClass, pConfigXML, target);
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
		
		public override function doExternalCommand(pCmd:String,pParam:String = null,pObject:Object = null):void
		{
			var tParamArray:Array = [];
			
			switch (pCmd)
			{
				case "checkAnswer":
					mParentClass[pCmd](pParam);	
				break;
			}
		}
		
		
		
	}
	
}
