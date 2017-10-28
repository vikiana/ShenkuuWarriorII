/* AS3
	Copyright 2009
*/

package com.neopets.games.inhouse.advervideo.pc.gui {
	
	import com.neopets.projects.gameEngine.gui.AbsMenu;
	import com.neopets.util.button.NeopetsButton;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.video.NPTrailerPlayer;
	
	import com.neopets.games.inhouse.advervideo.pc.PCGameEngine;
	import com.neopets.games.inhouse.advervideo.translation.NPTextData;

	/**
	 *	
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@Koh Peng Chuan
	 *	@since  10 Sept 2009
	 */	
		
		/**
		 * @Note: Method description
		 * @param		var name			var type 		var description
		 * @return		var type				var description
		*/ 		
	 
	 public class ViewTrailerScreen extends AbsMenu {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		// on stage
		public var trailerplayer:NPTrailerPlayer;
		
		public var returnBtn:NeopetsButton;
		public var hibandBtn:NeopetsButton;
		public var lobandBtn:NeopetsButton;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function ViewTrailerScreen():void {
			super();
			setupVars();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function inFocus():void {
			trace("@ View trailer menu");
		}
		
		public function outFocus():void {
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		protected override function MouseClicked(evt:Event):void {
			if ((!hibandBtn.visible) && (!lobandBtn.visible)) {
				//PCGameEngine.instance.playSound("MouseClick");
				trailerplayer.terminateVideo();
				hibandBtn.visible = lobandBtn.visible = true;
			} else {
				this.dispatchEvent(new  CustomEvent({TARGETID:evt.currentTarget.name},BUTTON_PRESSED));
			}
		}
		
		protected function viewVideoHandler(e:MouseEvent):void {
			hibandBtn.visible = lobandBtn.visible = false;
			//PCGameEngine.instance.playSound("MouseClick");
			if (e.target.parent == lobandBtn) {
				lobandVideo();
			} else if (e.target.parent == hibandBtn) {
				hibandVideo();
			}
		}
		
		protected function videoDoneHandler(e:Event):void {
			trailerplayer.terminateVideo();
			hibandBtn.visible = lobandBtn.visible = true;
		}

		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------		
		
		/**
		 * @Note: Setups Variables
		*/
		 
		private function setupVars():void {
			returnBtn.addEventListener(MouseEvent.MOUSE_UP,MouseClicked,false,0,true);
			
			mID = "ViewTrailerScreen";
			
			hibandBtn.addEventListener(MouseEvent.MOUSE_UP, viewVideoHandler, false, 0, true);
			lobandBtn.addEventListener(MouseEvent.MOUSE_UP, viewVideoHandler, false, 0, true);
			
			NPTextData.updateViewTrailerText(this);
			
			trailerplayer = new NPTrailerPlayer();
			trailerplayer.playerButtons(playbutton, pausebutton, stopbutton, rewindbutton, mutebutton, unmutebutton);
			//trailerplayer.playerButtons();
			addChild(trailerplayer);
			trailerplayer.x = 325;
			trailerplayer.y = 225;
			trailerplayer.dispatcher.addEventListener(NPTrailerPlayer.VIDEO_DONE_PLAYING, videoDoneHandler);
		}
		 
		private function lobandVideo():void {
			trailerplayer.playLoBandVideo();
		}
		
		private function hibandVideo():void {
			trailerplayer.playHiBandVideo();
		}
				
		/**
		 *	@Destructor
		 */
		public function destructor():void {
			trailerplayer.dispatcher.removeEventListener(NPTrailerPlayer.VIDEO_DONE_PLAYING, videoDoneHandler);
			removeChild(trailerplayer);
			trailerplayer.destructor();
			trailerplayer = null;
		}
	}
}