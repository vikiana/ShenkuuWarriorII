/* AS3
	Copyright 2009
*/

package  com.neopets.games.inhouse.advervideo.game {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	
	import com.neopets.games.inhouse.advervideo.pc.PCGameEngine;
	import com.mtvn.MtvnPlayer;
	import com.neopets.games.inhouse.advervideo.game.SimpleXML;
	
	
	/**
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author Koh Peng Chuan
	 *	@since  9 Dec 2010
	 */
	 
	public class Game extends MovieClip {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		private const PCGE:PCGameEngine = PCGameEngine.instance;
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		private var _mtvnPlayer:MtvnPlayer = null;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function Game():void {
			trace("Game started");
		
			SCORE = 0; // score defaulted at 0. No score will be sent
			startGame();
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function set SCORE(p_score:int):void {
			PCGE.score = p_score;
		}
		
		public function get SCORE():int {
			return PCGE.score;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		public function startVideo():void {
			//play video
			var configParams:String = PCGameEngine.CONFIG_URL+"?uri=" + PCGameEngine.VIDEO_ID + "&group=kids&type=network&site=nick&playerName=" + PCGameEngine.VIDEO_PLAYER_NAME;
			if (_mtvnPlayer != null) {
				_mtvnPlayer.visible = true;
				_mtvnPlayer.playURI(PCGameEngine.VIDEO_ID);
			} else {
				_mtvnPlayer = new MtvnPlayer(PCGameEngine.VIDEO_WIDTH, PCGameEngine.VIDEO_HEIGHT, PCGameEngine.PLAYER_LOADER_SWF, configParams);		
				_mtvnPlayer.x = 130;
				_mtvnPlayer.y = 139;
				addChild(_mtvnPlayer);
			}
			_mtvnPlayer.addEventListener(MtvnPlayer.PLAYLIST_COMPLETE, PCGameEngine.onPlaylistComplete, false, 0, true);
			
		}
		
		public function trackVideoPlay():void {
			/*var trackUrl:String = _trailerXML.xmlObj.content.urls.url.(@type == "START_URL").text();
			if (trackUrl) {
				PCGameEngine.loadImageTracker(trackUrl);
			}
			*/
		}
		
		/**
		* Note: callback for custom event that happens when the video playlist has completed
		*/
		public function videoFinished():void {
			_mtvnPlayer.removeEventListener(MtvnPlayer.PLAYLIST_COMPLETE, PCGameEngine.onPlaylistComplete);
			_mtvnPlayer.visible = false;
		}
		
		/**
		 * This game instance will be destroyed and player will be brought back to the intro screen.
		 */
		public function endGame():void {
			PCGE.goIntro();
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * Place your custom game initialization here
		 * eg. 
		 * mygame:CustomGame = new CustomGame(this); 	<-- pass in this Game instance to gain access to functions such as endGame
		 * container.addChild(mygame); 								<-- assuming your custom game is a displayobject instance. simply add it to the container. Otherwise, add the appropriate displayobject to container.
		 */
		private function startGame():void {
		//	PCGE.gameScreen.loadBannerAd('http://ad.doubleclick.net/ad/neopets.nol/games/advervideo;sz=728x90;ord=' + Math.floor(Math.random() * 10000000000));
		}
		
		/**
		 * This destructor method is called when endGame() is triggered.
		 */
		public function destructor():void {
		
			/*********************************
			 Place custom game destructor here
			 eg.
				mygame.destructor();
				mygame = null;
			 **********************************/
				
			trace("Game ended");
		}
		
		  
	}
	
}
