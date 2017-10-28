
/* AS3
	Copyright 2008
*/
package com.neopets.projects.neopetsGameShell.NotUsed
{


	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	
	/**
	 *	This is used to extend the Base Document of any game
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author Clive Henrick
	 *	@since  12.16.2008
	 */
	//public class NeopetsInterfaceSupport extends BaseClass //implements IGameContainer
	public class NeopetsInterfaceSupport  //implements IGameContainer
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		
		public const INTERFACE_READY:String = "TheInterfaceIsReady";
		public const SEND_THROUGH_CMD:String = "Send_A_Cmd_UpClass";
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		

		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function NeopetsInterfaceSupport(target:IEventDispatcher=null)
		{
			//setupVars();
			super();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
	
	}
	
}
