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
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.util.BroadcasterClip;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.util.BroadcastEvent;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.pages.PrizeShopPage;
	import com.neopets.projects.destination.destinationV3.AbsPage;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.general.GeneralFunctions;
	
	public class PointGauge extends BroadcasterClip
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var _gaugeTrack:DisplayObject;
		protected var _gaugeBounds:Rectangle;
		protected var _gaugeArrow:DisplayObject;
		protected var _gaugeMask:DisplayObject;
		public var maxPoints:Number;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function PointGauge():void {
			super();
			// set default values
			maxPoints = 10000;
			// set up components
			gaugeTrack = getChildByName("track_mc");
			_gaugeArrow = getChildByName("arrow_mc");
			_gaugeMask = getChildByName("bar_mask_mc");
			// set up broadcaster listeners
			useParentDispatcher(AbsPage);
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get gaugeTrack():DisplayObject { return _gaugeTrack; }
		
		public function set gaugeTrack(dobj:DisplayObject) {
			_gaugeTrack = dobj;
			if(_gaugeTrack != null) {
				_gaugeBounds = _gaugeTrack.getBounds(this);
			} else _gaugeBounds = getBounds(this);
		}
		
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
			// extract point total
			var info:Object = ev.oData;
			var pts:Number;
			if("xp" in info) pts = Number(info["xp"]);
			else pts = 0;
			// convert to position on track
			var percent_full:Number = Math.min(Math.max(0,pts/maxPoints),1);
			var track_pos:Number = _gaugeBounds.bottom - percent_full * _gaugeBounds.height;
			// move elements to target point on track
			if(_gaugeArrow != null) _gaugeArrow.y = track_pos;
			if(_gaugeMask != null) _gaugeMask.y = track_pos;
		}

	}
	
}