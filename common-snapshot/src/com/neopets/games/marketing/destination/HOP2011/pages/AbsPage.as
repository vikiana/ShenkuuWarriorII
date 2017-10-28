/**
 *	This class handles general page functions.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  01.04.2010
 */

package com.neopets.games.marketing.destination.HOP2011.pages
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------/**/
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import com.neopets.util.servers.NeopetsServerManager;
	
	import com.neopets.games.marketing.destination.HOP2011.commands.GoToURLCommand;
	import com.neopets.games.marketing.destination.HOP2011.commands.DispatcherCommand;
	
	public class AbsPage extends MovieClip
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function AbsPage():void
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		}
		
		//----------------------------------------
		//	GETTERS AND SETTERS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		public function initEventButton(btn:MovieClip,tag:String,info:Object=null):void {
			if(btn != null && tag != null) {
				btn.clickCommand = new DispatcherCommand(this,tag,info);
			}
		}
		
		public function initSiteLink(btn:MovieClip,path:String):void {
			if(btn != null && path != null) {
				btn.clickCommand = new GoToURLCommand(path);
			}
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		// Use this to set up all child objects.
		
		protected function initChildren():void {}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		protected function onAddedToStage(ev:Event) {
			NeopetsServerManager.instance.findServersFor(this);
			initChildren();
			removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		}
		
	}
	
}