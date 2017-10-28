/**
 *	This command handles URL links to external sites.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.14.2010
 */

package com.neopets.games.marketing.destination.HOP2011.commands
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.events.Event;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.events.EventDispatcher;
	
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.events.SingletonEventDispatcher;
	
	public class GoToURLCommand extends AbsCommand
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		public static const ON_NAV_TO_URL:String = "onNavigateToURL";
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		public var url:String;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function GoToURLCommand(path:String=null):void {
			url = path;
			super();
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		override public function execute(ev:Event=null):void {
			if(url != null) {
				var req:URLRequest = new URLRequest(url);
				navigateToURL(req,"_blank");
				// broadcast event for tracking
				var sed:EventDispatcher = SingletonEventDispatcher.instance;
				var transmission:CustomEvent = new CustomEvent(url,ON_NAV_TO_URL);
				sed.dispatchEvent(transmission);
			}
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