/**
 *	This class acts as an interface for javascript and neocontent tracking calls.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.23.2010
 */

package com.neopets.games.marketing.destination.capriSun.disrespectoids
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	
	import com.neopets.util.servers.NeopetsAmfManager;
	import virtualworlds.net.AmfDelegate;
	import flash.net.Responder;
	
	public class ShopAwardProxy extends Object
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var _activityData:Object;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function ShopAwardProxy():void {
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		// Use this function to get data for a single activity.
		
		public function getActivity(id:Object) {
			if(_activityData != null) {
				if("activities" in _activityData) {
					var act_list:Object = _activityData.activities;
					if(id in act_list) return act_list[id];
				}
			}
			return null;
		}
		
		// Use this function to retrieve the associated xp value for a given task.
		
		public function getXpFor(id:Object):Number {
			var info:Object = getActivity(id);
			if(info != null && "xp" in info) return info.xp;
			return 0;
		}
		
		// Use this function to start loading award values from php.
		
		public function initFor(dobj:DisplayObject):void {
			if(dobj == null) return;
			// ask php for activity info
			var delegate:AmfDelegate = NeopetsAmfManager.instance.getDelegateFor(dobj);
			var responder:Responder = new Responder(onInfoResult,onInfoFault);
			delegate.callRemoteMethod("CapriSun2010Service.prizeShopActivityInfo",responder);
		}
		
		// Use this function send a prize shop award request to php.
		
		public function requestAward(id:Object):void {
			var delegate:AmfDelegate = NeopetsAmfManager.instance.delegate;
			if(delegate != null) {
				var responder:Responder = new Responder(onRecordResult,onRecordFault);
				delegate.callRemoteMethod("CapriSun2010Service.prizeShopRecordActivity",responder,id);
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
		
		// "Activity Info" Response Listeners
		
		protected function onInfoResult(msg:Object):void {
			trace("onInfoResult: " + msg);
			_activityData = msg;
		}
		
		protected function onInfoFault(msg:Object):void {
			trace("onInfoFault: " + msg);
			_activityData = null;
		}
		
		// "Record Activity" Response Listeners
		
		protected function onRecordResult(msg:Object):void {
			trace("onRecordResult: " + msg);
		}
		
		protected function onRecordFault(msg:Object):void {
			trace("onRecordFault: " + msg);
		}

	}
	
}