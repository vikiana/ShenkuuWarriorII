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
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.net.sendToURL;
	import flash.net.Responder;
	
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.util.servers.NeopetsAmfManager;
	import com.neopets.util.servers.ServerFinder;
	import virtualworlds.net.AmfDelegate;
	
	import com.neopets.games.marketing.destination.frootLoops.fruityFun.ChooseTeamPopUp;
	import com.neopets.games.marketing.destination.frootLoops.fruityFun.BasicPopUp;
	
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.util.ParticleManager;
	
	dynamic public class LandingPage extends MovieClip
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		public static const AWARD_POINTS:String = "award_team_points";
		public static const SEND_NEOCONTENT:String = "send_neocontent";
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		public var delegate:AmfDelegate;
		public var servers:ServerFinder;
		public var individualPoints:String;
		// components
		public var congrads_mc:MovieClip;
		public var chooseTeam_mc:MovieClip;
		public var login_mc:MovieClip;
		public var yourPoints_mc:MovieClip;
		public var yourTeam_mc:MovieClip;
		public var videoPopup_mc:MovieClip;
		public var triviaPopup_mc:MovieClip;
		public var instructionsPopup_mc:MovieClip;
		public var teamToucanMeter_mc:MovieClip;
		public var teamMasterMeter_mc:MovieClip;
		public var playGame_mc:MovieClip;
		public var visitSite_mc:MovieClip;
		public var viewLatest_mc:MovieClip;
		public var trivia_mc:MovieClip;
		public var instructions_mc:MovieClip;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function LandingPage():void {
			super();
			// add event listeners
			addEventListener(AWARD_POINTS,onPointRequest);
			addEventListener(SEND_NEOCONTENT,onSendNeocontent);
			// cache images
			DisplayUtils.cacheImages(this);
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		public function initPage():void {
			// set up amf delegate
			delegate = NeopetsAmfManager.instance.getDelegateFor(this);
			servers = NeopetsAmfManager.instance.getServersFor(this);
			// call tracking
			sendNeocontent(16137);
		}
		
		public function sendNeocontent(id:Number) {
			var full_path:String = servers.scriptServer + "/process_click.phtml?item_id=" + id + "&noredirect=1";
			var req:URLRequest = new URLRequest(full_path);
			sendToURL(req);
			trace("sending click to "+full_path);
		}
		
		public function setTeam(id:String) {
			// check for alternate IDs
			if(id != null) {
				if(id.indexOf("Toucan") >= 0) id = "1";
				else {
					if(id.indexOf("Master") >= 0) id = "2";
				}
			}
			// check point totals
			var pts:Number;
			if(individualPoints != null) pts = Number(individualPoints);
			else pts = 0;
			// check ID
			switch(id) {
				case "1":
					yourPoints_mc.points_txt.text = pts;
					yourTeam_mc.gotoAndStop("TOUCAN");
					chooseTeam_mc.close();
					yourPoints_mc.visible = true;
					yourTeam_mc.visible = true;
					break;
				case "2":
					yourPoints_mc.points_txt.text = pts;
					yourTeam_mc.gotoAndStop("MASTER");
					chooseTeam_mc.close();
					yourPoints_mc.visible = true;
					yourTeam_mc.visible = true;
					break;
				default:
					yourPoints_mc.visible = false;
					yourTeam_mc.visible = false;
					break;
			}
			trace("Team set to " + id + " with " + individualPoints + " points");
		}
		
		public function updateTeams():void {
			// udpate team scores
			var responder:Responder = new Responder(onTeamStatusResult,onTeamStatusFault);
			delegate.callRemoteMethod("FrootLoops2010Service.getTeamStatus",responder,1);
			delegate.callRemoteMethod("FrootLoops2010Service.getTeamStatus",responder,2);
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
		
		protected function onPointRequest(ev:CustomEvent) {
			// extract parameters
			var info:Object = ev.oData;
			var activity:String;
			var score:Number;
			var correct:Boolean;
			if(info != null) {
				if("activity" in info) activity = info.activity;
				if("score" in info) score = info.score;
				else score = 0;
				if("correct" in info) correct = info.correct;
				else correct = false;
			}
			// send out amf call
			var responder:Responder = new Responder(onRecordResult,onRecordFault);
			delegate.callRemoteMethod("FrootLoops2010Service.recordActivity",responder,activity,score,correct);
		}
		
		/**
		 * Amf success for recordActivity call
		*/
		protected function onRecordResult(msg:Object):void {
			trace("onRecordResult: " + msg);
			// check for a returned point value
			var award:Number = Number(msg);
			if(isNaN(award)) award = 0;
			// show point display
			var part_manager:ParticleManager = ParticleManager.getInstance(this);
			var marker:MovieClip = part_manager.getFreeParticle(AwardMarker) as MovieClip;
			marker.x = mouseX;
			marker.y = mouseY;
			marker.pointValue = award;
			// update user score
			var responder:Responder = new Responder(onUserStatusResult,onUserStatusFault);
			delegate.callRemoteMethod("FrootLoops2010Service.getUserStatus",responder);
		}
		
		/**
		 * Amf fault for recordActivity call
		*/
		protected function onRecordFault(msg:Object):void {
			trace("onRecordFault: " + msg);
		}
		
		/**
		 * Amf success for getTeamStatus call
		*/
		protected function onUserStatusResult(msg:Object):void {
			trace("onUserStatusResult: " + msg);
			// update score
			if("score" in msg) individualPoints = String(msg.score);
			if("team" in msg) {
				setTeam(msg.team);
			} else {
				yourPoints_mc.points_txt.text = individualPoints;
			}
		}
		
		/**
		 * Amf fault for getTeamStatus call
		*/
		protected function onUserStatusFault(msg:Object):void {
			trace("onUserStatusFault: " + msg);
		}
		
		/**
		 * Amf success for getTeamStatus call
		*/
		protected function onTeamStatusResult(msg:Object):void {
			trace("onTeamStatusResult: " + msg);
			// check id of team
			switch(String(msg.team)) {
				case "1":
					teamToucanMeter_mc.percentScore = Number(msg.cumScore);
					break;
				case "2":
					teamMasterMeter_mc.percentScore = Number(msg.cumScore);
					break;
			}
		}
		
		/**
		 * Amf fault for getTeamStatus call
		*/
		protected function onTeamStatusFault(msg:Object):void {
			trace("onTeamStatusFault: " + msg);
		}
		
		// This function send out of the target neocontent tracking request.
		
		protected function onSendNeocontent(ev:CustomEvent) {
			var id:Number = Number(ev.oData);
			sendNeocontent(id);
		}

	}
	
}