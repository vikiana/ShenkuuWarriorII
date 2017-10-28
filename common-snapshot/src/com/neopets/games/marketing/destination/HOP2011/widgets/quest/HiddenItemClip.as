/**
 *	This class provides listener and close button behaviour for simple pop ups.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.09.2010
 */

package com.neopets.games.marketing.destination.HOP2011.widgets.quest
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	import flash.net.Responder;
	
	import com.neopets.util.display.BroadcasterClip;
	import com.neopets.util.events.BroadcastEvent;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.amfphp.NeopetsConnectionManager;
	
	import com.neopets.games.marketing.destination.HOP2011.pages.AbsPage;
	import com.neopets.games.marketing.destination.HOP2011.pages.HubPage;
	
	public class HiddenItemClip extends BroadcasterClip
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		public var activityID:String = "item3";
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function HiddenItemClip():void {
			super();
			// set up broadcaster listeners
			useParentDispatcher(AbsPage);
			// set up mouse listeners
			addEventListener(MouseEvent.CLICK,onMouseClick);
			buttonMode = true;
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		protected function onMouseClick(ev:MouseEvent) {
			var func_path:String = HubPage.SERVICE_ID + ".recordActivity";
			var responder:Responder = new Responder(onRecordResult, onRecordFault);
			NeopetsConnectionManager.instance.callRemoteMethod(func_path,responder,activityID);
		}
		
		// "getStatus" responder functions
		
		protected function onRecordResult(msg:Object):void {
			trace("recordActivity success: " + msg);
			// broadcast status
			broadcast(HubPage.RECORD_ACTIVITY_RESULT,msg);
		}
		
		protected function onRecordFault(msg:Object):void {
			trace("recordActivity fault: " + msg);
		}
		
	}

	
}