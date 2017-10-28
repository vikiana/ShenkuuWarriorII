/**
 *	This class handles sending getting and displaying trivia questions.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.09.2010
 */

package com.neopets.games.marketing.destination.frootLoops.fruityFun
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	import com.neopets.util.servers.NeopetsAmfManager;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.events.EventFunctions;
	import virtualworlds.net.AmfDelegate;
	import flash.net.Responder;
	
	import com.neopets.games.marketing.destination.frootLoops.fruityFun.BasicPopUp;
	import com.neopets.games.marketing.destination.frootLoops.fruityFun.LandingPage;
	
	public class ChooseTeamPopUp extends BasicPopUp
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		public static const TEAM_CHOSEN:String = "team_chosen";
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var _toucanButton:DisplayObject;
		protected var _masterButton:DisplayObject;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function ChooseTeamPopUp():void {
			super();
			// set up components
			toucanButton = getChildByName("chooseToucan_mc");
			masterButton = getChildByName("chooseMaster_mc");
			// set up linkage to parent
			useParentDispatcher(MovieClip);
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get toucanButton():DisplayObject { return _toucanButton; }
		
		public function set toucanButton(dobj:DisplayObject) {
			// set up listeners
			EventFunctions.transferListener(_toucanButton,dobj,MouseEvent.CLICK,onToucanChosen);
			// store new component
			_toucanButton = dobj;
		}
		
		public function get masterButton():DisplayObject { return _masterButton; }
		
		public function set masterButton(dobj:DisplayObject) {
			// set up listeners
			EventFunctions.transferListener(_masterButton,dobj,MouseEvent.CLICK,onMasterChosen);
			// store new component
			_masterButton = dobj;
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		// This function lets php know we've chosen a team.
		
		protected function chooseTeam(id:String):void {
			var delegate:AmfDelegate = NeopetsAmfManager.instance.getDelegateFor(this);
			var responder:Responder = new Responder(onJoinTeamResult,onJoinTeamFault);
			delegate.callRemoteMethod("FrootLoops2010Service.joinTeam",responder,id);
			// hide the pop up
			close();
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		// Team Select Button Listeners
		
		protected function onToucanChosen(ev:Event) {
			//omniture, google tracking
			if (ExternalInterface.available) {
				//ExternalInterface.call("window.top.sendADLinkCall('KellogsFruitLoops2010 - Team Toucan Sam Selected')");
				ExternalInterface.call("window.top.sendReportingCall","KellogsFruitLoops2010 - Team Toucan Sam Selected");
				trace("calling Team Toucan Sam Selected");
			} else trace("ExternalInterfaceCall Not Available");
			// call tracking
			broadcast(LandingPage.SEND_NEOCONTENT,16138);
			// select the target team
			chooseTeam("1");
		}
		
		protected function onMasterChosen(ev:Event) {
			//omniture, google tracking
			if (ExternalInterface.available) {
				//ExternalInterface.call("window.top.sendADLinkCall('KellogsFruitLoops2010 - Team Fruit Master Selected')");
				ExternalInterface.call("window.top.sendReportingCall","KellogsFruitLoops2010 - Team Fruit Master Selected");
				trace("calling Team Fruit Master Selected");
			} else trace("ExternalInterfaceCall Not Available");
			// call tracking
			broadcast(LandingPage.SEND_NEOCONTENT,16139);
			// select the target team
			chooseTeam("2");
		}
		
		// "Join Team" Response Listeners
		
		protected function onJoinTeamResult(msg:Object):void {
			trace("onJoinTeamResult: " + msg);
			// check player's new team
			var delegate:AmfDelegate = NeopetsAmfManager.instance.getDelegateFor(this);
			var responder:Responder = new Responder(onUserStatusResult,onUserStatusFault);
			delegate.callRemoteMethod("FrootLoops2010Service.getUserStatus",responder);
		}
		
		protected function onJoinTeamFault(msg:Object):void {
			trace("onJoinTeamFault: " + msg);
		}
		
		// "User Status" Response Listeners
		
		protected function onUserStatusResult(msg:Object):void {
			trace("onUserStatusResult: " + msg);
			// let listeners know the team has been set
			var id:String = msg.team;
			var transmission:CustomEvent = new CustomEvent(id,TEAM_CHOSEN);
			dispatchEvent(transmission);
		}
		
		protected function onUserStatusFault(msg:Object):void {
			trace("onUserStatusFault: " + msg);
		}
		
		// This pop up should not automatically close when another pop up is called.
		
		override protected function onPopUpRequest(ev:CustomEvent) {
			if(ev.oData == this) open();
		}
		
	}
	
}