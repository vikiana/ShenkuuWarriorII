/**
 *	This class acts as an interface for javascript and neocontent tracking calls.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.23.2010
 */

package com.neopets.games.marketing.destination.despicableMe
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.net.sendToURL;
	import flash.external.ExternalInterface;
	
	public class TrackingProxy extends Object
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		public var projectName:String;
		public var projectPath:String;
		public var serverURL:String;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function TrackingProxy():void {
			serverURL = "http://www.neopets.com"; // set default server
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		// Javascript Proxy Functions
		
		public function sendADLinkCall(id:String) {
			if (ExternalInterface.available) {
				try { 
					ExternalInterface.call("sendADLinkCall",id);
					trace("sendADLinkCall: "+id);
				} catch (e:Error) {
					trace("Handle Error in sendADLinkCall");
				}
			}
		}
		
		public function sendReportingCall(id:String) {
			if (ExternalInterface.available) {
				try { 
					ExternalInterface.call("sendReportingCall",id,projectName);
					trace("sendReportingCall: "+id);
				} catch (e:Error) {
					trace("Handle Error in sendReportingCall");
				}
			}
		}
		
		public function urchinTracker(id:String) {
			if (ExternalInterface.available) {
				try {
					// attach project path to id
					var full_path:String;
					if(projectPath != null) full_path = projectPath + "/" + id;
					else full_path = id;
					// make javascript call
					ExternalInterface.call("urchinTracker",full_path);
					trace("urchinTracker: "+id);
				} catch (e:Error) {
					trace("Handle Error in urchinTracker");
				}
			}
		}
		
		// NeoContent Functions
		
		public function navigateToNeoContent(id:int,window:String=null) {
			var full_path:String = serverURL + "/process_click.phtml?item_id=" + id;
			var req:URLRequest = new URLRequest(full_path);
			navigateToURL(req,window);
			trace("navigating to "+full_path);
		}
		
		// no redirect
		public function sendNeoContentClick(id:int) {
			var full_path:String = serverURL + "/process_click.phtml?item_id=" + id + "&noredirect=1";
			var req:URLRequest = new URLRequest(full_path);
			sendToURL(req);
			trace("sending click to "+full_path);
		}
		
		// 
		public function sendNeoContentImpression(id:int) {
			var full_path:String = serverURL + "/nc_track.phtml?noredirect=1&nc_multiple=1&nc_status=10&item_id=" + id;
			var req:URLRequest = new URLRequest(full_path);
			sendToURL(req);
			trace("sending impression to "+full_path);
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