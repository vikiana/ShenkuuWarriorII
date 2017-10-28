/**
 *	This class uses reversible animation to handle roll over and roll out effects.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.14.2010
 */

package com.neopets.games.marketing.destination.HOP2011.widgets.downloads
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.neopets.games.marketing.destination.HOP2011.commands.GoToURLCommand;
	import com.neopets.games.marketing.destination.HOP2011.widgets.CommandButton;
	import com.neopets.games.marketing.destination.HOP2011.widgets.downloads.DownloadableData;
	
	public class DownloadableButton extends CommandButton
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		public var mainClip:MovieClip;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function DownloadableButton():void {
			super();
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		public function initFrom(info:DownloadableData) {
			if(mainClip != null) mainClip.initFrom(info);
			// set up our mouse click response
			if(info != null) clickCommand = new GoToURLCommand(info.clickPath);
			else clickCommand = null;
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------

	}
	
}