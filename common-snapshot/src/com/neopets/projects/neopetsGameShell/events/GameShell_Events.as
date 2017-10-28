
/* AS3
	Copyright 2008
*/
package com.neopets.projects.neopetsGameShell.events
{
	import com.neopets.projects.mvc.model.Listener;
	
	import flash.events.IEventDispatcher;
	
	
	/**
	 *	This is a Communications Object for Sending Events to a Game Engine or From the Game Engine to the Shell or the Interface
	 *  to the PPP Game Shell.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author Clive Henrick
	 *	@since  12.15.2008
	 */
	 
	public class GameShell_Events extends Listener
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		//Requests
		
		//public const ACTION_REQUEST_TRANSLATION:String = "RequestingTranslation"; //{OBJECT: the Object which has the neededText, STRING: the text to be Translated Text}
		public const ACTION_REQUEST_SFC:String = "RequestingSmartFoxClient";
		
		//Returns
		//public const ACTION_RETURN_TRANSLATION:String = "Translation is being returned"; // {OBJECT: the Object Sent, STRING: the Translated Text}
		public const ACTION_RETURN_SFC:String = "SmartFoxClient is being returned"; // {OBJECT: theSmartFoxClient}
		public const ACTION_RETURN_DATA:String = "DATAisBeingReturned";				// {OBJECT {ID:What was request (STRING), XML: the Data}
		
		//Communication to the external Background, Interface, Intro (If needed)
		public const ACTION_SEND_CMD_INTERFACE:String = "SendCmdtoINTERFACE"; //{CMD: "YourCmd",PARAM: {}}
		public const ACTION_SEND_CMD_GAME:String = "SendCmdtoGAME"; //{CMD: "YourCmd",PARAM: {}}
		public const ACTION_SEND_CMD_SHELL:String = "SendCmdtoSHELL"; //{CMD: "YourCmd",PARAM: {}}
		public const ACTION_SEND_CMD_PRELOADER:String = "SendCmdtoPreloader"; //{CMD: "YourCmd",PARAM: {}}
		 
		//CMDS
		public const CMD_GAME_READY:String = "GameIsReadyToStart"; //The Game is Ready to be Started (Send this through the ACTION_SEND_CMD_INTERFACE)
		public const CMD_GAME_END:String = "GameIsFinished";	//The Game has ended ready to be closed (Send this through the ACTION_SEND_CMD_INTERFACE)
		public const CMD_GAME_START:String = "GameStart";		//The Container tells the Game to Start (Send this through the ACTION_SEND_CMD_INTERFACE)
		public const CMD_REQUEST_DATA:String = "RequestDataFromShell";		//The Container tells the Game to Start (Send this through the ACTION_SEND_CMD_INTERFACE)
																			// Example GameShell_Event.sendCustomEvent(GameShell_Event.ACTION_SEND_CMD_INTERFACE,{CMD:GameShell_Event.CMD_GAME_END,PARAMS:{SCORE:621}});
		public const CMD_PRELOADER_DONE:String = "PreloaderIsSetup";		//The PRELOADER is Done, So XFade between the Sections (Send this through the ACTION_SEND_CMD_INTERFACE)
		public const CMD_ALLLOADED:String = "PreloaderIsDone";		//The Container tells the Game to Start (Send this through the ACTION_SEND_CMD_INTERFACE)
		
		//Calls to the PPP World Engine
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function GameShell_Events(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
