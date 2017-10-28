/**
 *	This class provides listener and close button behaviour for simple pop ups.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.09.2010
 */

package com.neopets.games.marketing.destination.capriSun.disrespectoids.widgets.shop
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.util.BroadcasterClip;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.util.BroadcastEvent;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.pages.PrizeShopPage;
	import com.neopets.projects.destination.destinationV3.AbsPage;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.general.GeneralFunctions;
	
	public class PointTextPane extends BroadcasterClip
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var _pointField:TextField;
		public var pointText:String;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function PointTextPane():void {
			super();
			pointText = "<b>My Points: %1</b>";
			// set up components
			_pointField = getChildByName("point_txt") as TextField;
			// set up broadcaster listeners
			useParentDispatcher(AbsPage);
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		override public function set sharedDispatcher(disp:EventDispatcher) {
			// clear listeners
			if(_sharedDispatcher != null) {
				_sharedDispatcher.removeEventListener(PrizeShopPage.STATUS_RESULT,onStatusResult);
			}
			_sharedDispatcher = disp;
			_dispatcherClass = GeneralFunctions.getClassOf(_sharedDispatcher);
			// set up listeners
			if(_sharedDispatcher != null) {
				_sharedDispatcher.addEventListener(PrizeShopPage.STATUS_RESULT,onStatusResult);
			}
		}
		
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
		
		// When there's a status event, extract the data.
		
		protected function onStatusResult(ev:CustomEvent) {
			if(_pointField != null) {
				var info:Object = ev.oData;
				if("xp" in info) {
					if(pointText != null) {
						_pointField.htmlText = pointText.replace("%1",info["xp"]);
					} else _pointField.htmlText = info["xp"];
				} else _pointField.htmlText = "";
			}
		}

	}
	
}