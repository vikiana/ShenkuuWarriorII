package com.neopets.games.marketing.destination.altadorbooth2011.pages
{
		//----------------------------------------
		//	IMPORTS 
		//----------------------------------------
		import com.neopets.projects.destination.AbstractPageWithBtnState;
		import com.neopets.projects.destination.destinationV3.Parameters;
		import com.neopets.users.abelee.utils.SupportFunctions;
		import com.neopets.util.loading.LibraryLoader;
		import com.neopets.util.tracker.NeoTracker;
		import com.neopets.util.video.VideoManager;
		
		import flash.display.MovieClip;
		import flash.display.Shape;
		import flash.events.MouseEvent;
		
		/**
		 *	Video popup
		 *
		 *	@langversion ActionScript 3.0
		 *	@playerversion Flash 9.0 
		 *	@author Viviana Baldarelli
		 *	@since  5.17.10
		 **/
		public class VideoPopup extends AbstractPageWithBtnState
		{
			//----------------------------------------
			//	VARIABLES
			//----------------------------------------
			private var xPos:Number
			private var yPos:Number
			
			//var mVideoPlayer:BasicVideoPlayer;
			private var vM:VideoManager;
			private var vPlayerID:int;
			
			//private var _closeBtn:MovieClip;
	
			
			//----------------------------------------
			//	CONSTRUCTOR 
			//----------------------------------------
			public function VideoPopup(pName:String=null, pView:Object=null, pMessage:String = null, px:Number = 0, py:Number = 0):void
			{
				super(pName, pView);
				xPos = px
				yPos = py
				setupPage ()
			}
			
			//----------------------------------------
			//	GETTERS AND SETTORS
			//----------------------------------------
			
			//----------------------------------------
			//	PUBLIC METHODS
			//----------------------------------------
			public function show(path:String, W:Number, H:Number):void
			{
				var baseurl:String;
				var videoPath:String;
				baseurl  = Parameters.imageURL;
				visible = true;
				vM.loadAndPlay(vPlayerID, baseurl+path, W, H);
				_closeBtn.x = vM.getPlayerInstance(vPlayerID).x + W/2;
				_closeBtn.y = vM.getPlayerInstance(vPlayerID).y- H/2;
				_closeBtn.visible = true;
				//Neocontent tracking
				//NeoTracker.instance.trackNeoContentID(15223);
			}
			
			public function hide():void
			{
				visible = false 
				vM.getPlayerInstance(vPlayerID).stopVideo();
			}
			
			//----------------------------------------
			//	PROTECTED METHODS
			//----------------------------------------
			
			protected override function setupPage():void
			{
				//faded background
				var screen:Shape = new Shape ();
				screen.graphics.beginFill(0x000000, 0.7);
				screen.graphics.drawRect(0, 0, 810, 744);
				screen.graphics.endFill();
				addChild (screen);
				
				//videoplayer
				vM = VideoManager.instance;
				vPlayerID = VideoManager.instance.createVideoPlayer();
				
				vM.playerParameters(vPlayerID, false, false);
				
				vM.getPlayerInstance(vPlayerID).x = screen.width/2;//-vM.getPlayerInstance(vPlayerID).width/2;
				vM.getPlayerInstance(vPlayerID).y = screen.height/2;//-vM.getPlayerInstance(vPlayerID).height/2; 
				
				addChild (vM.getPlayerInstance(vPlayerID));
				
				var bc:Class = LibraryLoader.getLibrarySymbol ("popup_closeBtn");
				_closeBtn = new bc();
				_closeBtn.name = "videoclose_btn";
				addChild (_closeBtn);
				_closeBtn.visible = false;
			}
			
			//----------------------------------------
			//	PRIVATE METHODS
			//----------------------------------------

			
			//----------------------------------------
			//	EVENT LISTENERS
			//----------------------------------------
		}
	}