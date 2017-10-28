/**
 *	This is a shell class that uses PC's video player (flash 9, v2)
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

package com.neopets.projects.destination.destinationV2.videoPlayerComponent
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import flash.utils.getDefinitionByName;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	import videoplayer_flash9.v2.*
	
	public class VideoPlayerShell extends Sprite
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		public const VIDEO_STOPPED:String = "videoStopped"
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		private var vPlayer:NPVideoPlayer;		//video player
		
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------

		/**
		 * @PARAM		pABSROOT		Object			Most top timeline level
		 * @PARAM		pDefName		String			The videoplayer export name in the library
		 * @PARAM		pURLHigh		String			absolute path for video URL (high quality)
		 * @PARAM		pURLLow			String			absolute path for video URL (low quality)
		 * @PARAM		pSkip			Boolean			false: skips "high band", "low band" option	
		 * @PARAM		pHighClickID	int				NeoContentID for click url (high quality)
		 * @PARAM		pLowClickID		int				NeoContentID for click url (low quality)
		 * @PARAM		px				Number			x position
		 * @PARAM		py				Number			y Position
		 * @PARAM		pAutoEnd		Boolean			true: "go back" function called when video ends
		 **/
	
		public function VideoPlayerShell(pABSROOT:Object = null, pDefName:String = undefined, pURLHigh:String = null, pURLLow:String = null,px:Number = 0, py:Number = 0, pHighClickID:int = 0, pLowClickID:int = 0, pSKIP:Boolean = true, pAutoEnd:Boolean = true, pWidth:Number = 360, pHeight:Number = 240):void
		{
			//set up video player
			var vPlayerClass:Class = getDefinitionByName(pDefName) as Class 
			var skipSelection:Boolean = pURLLow == null? true: pSKIP;
			vPlayer = new vPlayerClass ();
			vPlayer.name = "vPlayer"
			vPlayer.x = px;
			vPlayer.y = py;
			
			//initialize the player
			if (pABSROOT != null)
			{
				vPlayer.init(pABSROOT, skipSelection);
				if (pAutoEnd) vPlayer.DISPATCHER.addEventListener(vPlayer.VIDEO_AUTOSTOPPED, handleVideoStopped, false, 0, true);
			}
			else 
			{
				trace ("Error: pABSROOT must not be null")
			}
			trace (pURLHigh, pURLLow, pHighClickID, pLowClickID)
			videoContentSetup(pURLHigh, pURLLow, pHighClickID, pLowClickID, pWidth, pHeight)
			addChild(vPlayer)
		}
		
		//----------------------------------------
		//GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//PUBLIC METHODS
		//----------------------------------------
		
		/**
		 * Adds background for the video
		 * @PARAM		pBgClassName		Sprite class name (from library) you want to have as background
		 * @PARAM		px					x Position
		 * @PARAM		py					y position
		 **/
		public function addBackground (pBgClassName:String = null, px:Number = 0, py:Number = 0):void
		{
			var bgClass:Class = getDefinitionByName(pBgClassName) as Class
			var bg:Sprite = new bgClass ();
			bg.x = px;
			bg.y = py;
			addChild (bg)
			setChildIndex(bg, 0);
		}
		
		/**
		 * Adds back button (must have btnArea) if it has a text field named btnText, pText will be shown 
		 * @PARAM	pBtnName		Name of the button class you want to instantiate (from the library)
		 * @PARAM	pName			Name of the button
		 * @PARAM	pText			Text that'll be shown on the button
		 * @PARAM	px, py			x position, y position
		 **/
		public function addBackBtn (pBtnName:String = null, pName:String = null, pText:String = null, px:Number = 0, py:Number = 0):void
		{
			var btnClass:Class = getDefinitionByName(pBtnName) as Class
			var btn:MovieClip = new btnClass ();
			btn.name = pName;
			btn.x = px;
			btn.y = py;
			btn.btnArea.buttonMode = true;
			if(pText != null)
			{
				btn.btnText.text = pText
			}
			addChild (btn)
			setChildIndex(btn, 1);
		}
		
		public function cleanup():void
		{
			if (getChildByName("vPlayer") != null)
			{
				var vPlayer:NPVideoPlayer = getChildByName("vPlayer") as NPVideoPlayer;
				if (vPlayer.DISPATCHER.hasEventListener(vPlayer.VIDEO_AUTOSTOPPED))
				{
					vPlayer.DISPATCHER.removeEventListener(vPlayer.VIDEO_AUTOSTOPPED, handleVideoStopped);
				}
				removeChild(vPlayer);
				vPlayer = null;
			}
		}
		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
		
		/**
		 * Create video parameter based on info sent out at constructor call
		 * @PARAM		pURLHigh		String			absolute path for video URL (high quality)
		 * @PARAM		pURLLow			String			absolute path for video URL (low quality)
		 * @PARAM		pHighClickID	int				NeoContentID for click url (high quality)
		 * @PARAM		pLowClickID		int				NeoContentID for click url (low quality)	
		 * @PARAM		pHeight			int				height of high trailer	
		 * @PARAM		pWidth 			int				width of high trailer	
		 **/
		private function videoContentSetup(pURLHigh:String = undefined, pURLLow:String = undefined, pHighNeoContentID:int = 0, pLowNeoContentID:int = 0, pWidth:Number = 320, pHeight:Number = 240):void
		{
			///////////////////////////////////////////////////////////////
			// so below is hard coded... 
			// for more on how to use this pleach check PC's NPVieoPlayer example at:
			// \\tazzalor\groups\Multimedia\projects\internal\com\neopets\components\flash9VideoPlayer\v2
			///////////////////////////////////////////////////////////////
		
			vPlayer.PARAMETERS.highTrailer1NeocontentID_str = pHighNeoContentID;
			vPlayer.PARAMETERS.highTrailer1URL_str =pURLHigh
			vPlayer.PARAMETERS.highTrailer1Width_str = pWidth;
			vPlayer.PARAMETERS.highTrailer1Height_str = pHeight;
			vPlayer.PARAMETERS.highTrailer1FPS = 24;

			vPlayer.PARAMETERS.lowTrailer1NeocontentID_str = pLowNeoContentID;
			vPlayer.PARAMETERS.lowTrailer1URL_str =pURLLow;
			vPlayer.PARAMETERS.lowTrailer1Width_str = 160;
			vPlayer.PARAMETERS.lowTrailer1Height_str = 120;
			vPlayer.PARAMETERS.lowTrailer1FPS = 24;
			
			vPlayer.PARAMETERS.autoHideControls = true;
			vPlayer.PARAMETERS.resizeControls = false;
			vPlayer.PARAMETERS.showLoader = true;
		}
		
		// removes the video player and dispatches an event notifying video has come to an end
		private function endVideoPlayer ():void
		{
			trace ("dispatch something")
			dispatchEvent(new Event (VIDEO_STOPPED))
			cleanup()
		}
		
		
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------
		
		// when video plays to the end, it calls endVideoPlayer()
		private function handleVideoStopped(evt:Event):void
		{
			trace ("video stopped");
			endVideoPlayer()
		}
	}
	
}