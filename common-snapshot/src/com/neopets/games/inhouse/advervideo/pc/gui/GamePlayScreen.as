/* AS3
	Copyright 2009
*/

package com.neopets.games.inhouse.advervideo.pc.gui {
	
	import com.neopets.projects.gameEngine.gui.Interface.GameScreen;
	import com.neopets.projects.gameEngine.gui.MenuManager;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.net.*;
	
	import com.neopets.games.inhouse.advervideo.pc.PCGameEngine;
	import com.neopets.games.inhouse.advervideo.pc.GameUtilities;
	import com.neopets.games.inhouse.advervideo.translation.NPTextData;
	
	import com.neopets.games.inhouse.advervideo.pc.gui.Wheel;
	
	/**
	 *	
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@Koh Peng Chuan
	 *	@since  7.20.2009
	 */	
		
		/**
		 * @Note: Method description
		 * @param		var name			var type 		var description
		 * @return		var type				var description
		 */ 		
	 
	 public class GamePlayScreen extends GameScreen {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		public var backToMenuButton:CustomButton;
		public var spinWheelButton:CustomButton;
		public var viewTrailerButton:CustomButton;
		public var ad728:MovieClip;
		public var wheel;
		
		public var background_layer:Sprite;
		public var game_layer:MovieClip;
		public var overlay_layer:Sprite;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function GamePlayScreen():void {
			super();
			setupExtendedVars();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		public function setMessage(pStr:String = ""):void {
			NPTextData.pushCustomText(this, "msg_txt", pStr);
		}
		
		public function setMessageByTranslationId(pTransID:String):void {
			setMessage(NPTextData.getTranslationOf(pTransID));
		}
		
		public function inFocus():void {
			trace("@ Gameplay menu");
			hideButtons();
			viewTrailerButton.visible = true;
			//spinWheelButton.visible = true;
			loadBannerAd();
			wheel = getChildByName('Wheel');
			quitGameButton.tabEnabled = false;
			setMessageByTranslationId("IDS_VIDEO_LOADED");
		}
		
		public function outFocus():void {
		}
		
		public function hideButtons():void {
			viewTrailerButton.visible = false;
			spinWheelButton.visible = false;
			backToMenuButton.visible = false;
		}
		
		public function showButtons():void {
			viewTrailerButton.visible = true;
			spinWheelButton.visible = true;
			backToMenuButton.visible = true;
		}
		
		public function hideWheel():void {
			var myTween:Tween = new Tween(wheel, "x", Strong.easeOut, 585, 1200, 2, true);
		}
		
		public function showWheel():void {
			hideButtons();
			//TODO slide wheel into view
			var myTween:Tween = new Tween(wheel, "x", Strong.easeIn, 1100, 585, 2, true);
			spinWheelButton.visible = true;
		}
		
		public function finishSpin():void {
			var str:String = NPTextData.getTranslationOf("YOU_WON_NEOPOINTS_FROM");
			str = NPTextData.replaceToken(str, "%neopoints", wheel.wheelValues[wheel.getWheelValuesRewardIndex()]);
			setMessage(str);
			// show the button
			backToMenuButton.visible = true;
		}
		
	   /**
		* Note: load the ad located at the top of the screen
		*/
		public function loadBannerAd():void {
			var imageLoader:Loader = new Loader();;
			var image:URLRequest = new URLRequest('http://ad.doubleclick.net/ad/neopets.nol/games/advervideo;sz=728x90;ord=' + Math.floor(Math.random() * 10000000000));
			
			imageLoader.load(image);
			ad728.addChild(imageLoader);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		private function playVideo(e:MouseEvent):void {
			//hide screen button
			hideButtons();
			game_layer.startVideo();
			//hide wheel
			hideWheel();
			PCGameEngine.instance.playSound("MouseClick");
		}
		
		private function spinWheel(e:MouseEvent):void {
			//PCGameEngine.instance.startCustomGame();
			wheel.startSpin();
			hideButtons();
			trace("spin me!");
			PCGameEngine.instance.playSound("MouseClick");
		}
		
		private function backToMenu(e:MouseEvent):void {
			//PCGameEngine.instance.startCustomGame();
			trace('back to menu');
			game_layer.endGame();
			PCGameEngine.instance.playSound("MouseClick");
		}
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------		
		
		/**
		 * @Note: Setups Extended Variables
		 */ 
		private function setupExtendedVars():void {
			if (viewTrailerButton) {
				viewTrailerButton.setText(NPTextData.menuText("IDS_START_PLAYING"));
				viewTrailerButton.addEventListener(MouseEvent.MOUSE_UP, playVideo, false, 0, true);
				viewTrailerButton.tabEnabled = false;
			}
			
			if (spinWheelButton) {
				spinWheelButton.setText(NPTextData.menuText("IDS_SPIN_WHEEL"));
				spinWheelButton.addEventListener(MouseEvent.MOUSE_UP, spinWheel, false, 0, true);
				spinWheelButton.tabEnabled = false;
			}
			
			if (backToMenuButton) {
				backToMenuButton.setText(NPTextData.menuText("IDS_RETURN_TO_MAIN_MENU"));
				backToMenuButton.addEventListener(MouseEvent.MOUSE_UP, backToMenu, false, 0, true);
				backToMenuButton.tabEnabled = false;
			}
			
			//background_layer = new Sprite();
		//	overlay_layer = new Sprite();
			game_layer = new MovieClip();
			
		//	addChild(background_layer);
			addChild(game_layer);
		//	addChild(overlay_layer);
			
			//wheel.reset();
		}
		
		
		/**
		 *	@Destructor
		 */
		public function destructor():void {
		}
	}
}