/**
 *	This is the main theater page.  
 *	Since each theater is sort of self contained app, the page itself acts like a control.
 *
 *	Flow:
 *	1. set up the theater page and arrange all the display elements
 *	2. load poster images and set them (left/right posters)
 *	3. load movie trailer background and logo.
 *		Set the background and store a copy of the logo for pops and such
 *	4. load thumnail images and add them accordingly
 *	5. theater page is ready to go
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  07.16.2009
 */
 
 //----------------------------------------
 //	OVERALL FLOW
 //----------------------------------------

 
package com.neopets.projects.destination.destinationV2.movieTheater
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.events.Event;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import com.neopets.util.events.CustomEvent;
	import com.neopets.projects.destination.destinationV2.AbsPageWithBtnState;
	import com.neopets.projects.destination.destinationV2.movieTheater.icons.*;
	import com.neopets.projects.destination.destinationV2.movieTheater.popups.*;
	import com.neopets.users.abelee.utils.ViewManager_v3;
	import caurina.transitions.Tweener;
	import com.neopets.projects.destination.destinationV2.videoPlayerComponent.VideoPlayerSingleton;
	import com.neopets.projects.destination.destinationV2.ImageLoader;
	import com.neopets.projects.destination.destinationV2.movieTheater.LobbyPoster;
	import com.neopets.util.tracker.NeoTracker;
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------
		
	public class AbsTheaterPage extends AbsPageWithBtnState
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var mActiveIconsInfo:Array;	//contains active icon objects returned via amfphp
		protected var mActiveIconsArry:Array;	//active icons are stored here 	
		protected var mThumbnails:ViewManager_v3;	//movie thumb naile management system
		protected var mInfoTextBox:MovieClip;	//decription box at the bottom
		protected var mMovieHolder:MovieClip;	//where video player will be added
		protected var mRootTimeLine:Object;		//need for video player
		protected var mTopCurtain:MovieClip;	//where trailer thumbnails are displayed
		protected var mCinemaObj:Object;	//contails all the info needed to build cinema via amfphp call
		protected var mRPoster:LobbyPoster;	//right poster
		protected var mLPoster:LobbyPoster;	//left poster
		protected var mLogoImage:Bitmap;	//logo iamge mostly used only in popups
		
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		
		/**
		 *	constrcutor of the class
		 *	@PARAM		pName		String		Name of the class (this.name)
		 *	@PARAM		pView		String		view class where instance of this class will be added to
		 **/
		public function AbsTheaterPage(pName:String = null, pView:Object = null):void
		{
			super (pName)
			mView = pView
			pView.addEventListener(pView.OBJ_CLICKED, handleObjClick)
			mRootTimeLine = pView.stage.root	
		}
		
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		/**
		 *	Set up the cinema page according to info returned from amfphp call
		 *	@PARAM		pData		Object		The object is coming from amfphp in MovieData Class
		 *
		 *	@NOTE:	To be specific, Abs TheaterView class will instantiate this class.
		 *			It will call MovieData Class to get cinema obj via amfphp.
		 *			and pass the obj with properties to setup set up the theater
		 **/
		 
		public function setup(pData:Object = null):void
		{
			mCinemaObj = pData
			mActiveIconsInfo = pData.nav
			mActiveIconsArry = [];
			setupPage ();
			trace ("look for message", mCinemaObj.message)
		}
		
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		/**
		 *	Set up the cinema page accordingly in display order
		 **/
		protected override function setupPage():void
		{
			addImage("TheaterBackground", "bg");
			MovieClip(getChildByName("bg")).messageText.text = mCinemaObj.message
			//set up menu icons
			setupIcons();
			//add video player holder
			addImage("MovieHolder", "movie", 390, 210);
			//posters
			addImageButton("SidePoster", "rightPoster", 632, 60);
			addImageButton("SidePoster", "leftPoster", 0, 60);
			//visual elements blow the posters, next to the crowd
			addImage("ForegroundObjLeft", "objL", 81, 345);
			addImage("ForegroundObjRight", "objR", 700, 345);
			//crowd
			addImage("TheaterCrowd", "crowd");
			//back button
			addImageButton("btnBack", "back", 10, 420);
			//text box to show the icon titles
			addImage("TextBox", "textBox", 311, 474);
			mInfoTextBox = getChildByName("textBox") as MovieClip;
			mInfoTextBox.myText.text = "";
			mInfoTextBox.visible = false;
			//top curtain
			addImage("TopCurtain", "topCurtain");
			mTopCurtain = getChildByName("topCurtain") as MovieClip;
			//once all images and holders are in place, start setting up amfphp elements
			setPosters()
		}
		
		
		/**
		 *	Takes icons from mActiveIconsArry and display them. It's adjusted from center
		 **/
		protected function setupIcons():void
		{
			parseIcons();
			var midX:Number = 390;
			var midY:Number = 390;
			var startingX:Number = midX - (mActiveIconsArry.length * 60 / 2);
			for (var i in mActiveIconsArry)
			{
				addChild (mActiveIconsArry[i])
				mActiveIconsArry[i].x = startingX + 60 * i + 2
				mActiveIconsArry[i].y = midY
			}
		}
		
		
		/**
		 *	Creates an instance of icons based puts them in an array
		 *	(The actual icon info, when you go up the chain, is derived from amfphp call)
		 **/
		protected function parseIcons():void
		{
			for (var i:String in mActiveIconsInfo)
			{
				if (mActiveIconsInfo[i].active)
				{
					switch (mActiveIconsInfo[i].name)
					{
						case "trivia":
							mActiveIconsArry.push(new TriviaIcon(mActiveIconsInfo[i].name,"icon_trivia", "Icon_Trivia", mActiveIconsInfo[i].text, mActiveIconsInfo[i].tracking))
							break;
						
						case "hunt":
							mActiveIconsArry.push(new ScavengerHuntIcon(mActiveIconsInfo[i].name,"icon_hunt", "Icon_Scavenger", mActiveIconsInfo[i].text, mActiveIconsInfo[i].tracking))
							break;
						
						case "questions":
							mActiveIconsArry.push(new QuestionsIcon(mActiveIconsInfo[i].name,"icon_hunt", "Icon_Questions", mActiveIconsInfo[i].text, mActiveIconsInfo[i].tracking))
							break;
						
						case "schedule":
							mActiveIconsArry.push( new ScheduleIcon(mActiveIconsInfo[i].name,"icon_schedule", "Icon_Schedule",mActiveIconsInfo[i].text, mActiveIconsInfo[i].tracking))
							break;
						
						case "synopsis":
							mActiveIconsArry.push(new SynopsisIcon(mActiveIconsInfo[i].name,"icon_synopsis", "Icon_Synopsis", mActiveIconsInfo[i].text, mActiveIconsInfo[i].content, mActiveIconsInfo[i].tracking))
							break;
						
						case "website":
							mActiveIconsArry.push(new WebsiteIcon(mActiveIconsInfo[i].name,"icon_web", "Icon_Web", mActiveIconsInfo[i].text,mActiveIconsInfo[i].link, mActiveIconsInfo[i].target, mActiveIconsInfo[i].tracking ))
							break;
						
						case "clues":
							mActiveIconsArry.push(new CluesIcon(mActiveIconsInfo[i].name,"icon_clues", "Icon_Clues", mActiveIconsInfo[i].text, mActiveIconsInfo[i].tracking))
							break;
						
						case "games":
							mActiveIconsArry.push(new GamesIcon(mActiveIconsInfo[i].name,"icon_games", "Icon_Game", mActiveIconsInfo[i].text,mActiveIconsInfo[i].link,mActiveIconsInfo[i].target, mActiveIconsInfo[i].tracking ))
							break;
							
						case "quest":
							mActiveIconsArry.push(new BannerQuestIcon(mActiveIconsInfo[i].name,"icon_bannerQuest", "Icon_BannerQuest", mActiveIconsInfo[i].text,mActiveIconsInfo[i].link,mActiveIconsInfo[i].target, mActiveIconsInfo[i].tracking ))
							break;
					}
				}
			}
			
		}
		
		
		/**
		 * based on number of thumbnails, it displays them acordingly 
		 * if more than 4, scrolling buttons as activated)
		 **/
		protected function setupThumbnails(pThumbInfoArray:Array = null):void
		{
			
			
			mThumbnails = new ViewManager_v3 (pThumbInfoArray, 
											  [
											   new ThumbArrowLeft(), 
											   new ThumbArrowRight()
											   ])
			mThumbnails.y = 5
			
			var deco1:TrailerDeco = new TrailerDeco ()
			var deco2:TrailerDeco = new TrailerDeco ()
			var deco3:TrailerDeco = new TrailerDeco ()
			var deco4:TrailerDeco = new TrailerDeco ()
			
			deco1.y =20
			deco2.y =20
			deco3.y =20
			deco4.y =20
			
			
			addChild (deco1)
			addChild (deco2)
			addChild (deco3)
			addChild (deco4)
			addChild (mThumbnails)
			if (pThumbInfoArray.length > 3)
			{
				mThumbnails.x = 187
				mTopCurtain.gotoAndStop(4)
				deco1.x =269;
				deco2.x =377;
				deco3.x = 485;
				deco4.visible = false
			}
			else 
			{
				switch (pThumbInfoArray.length)
				{
					case 1:
					mThumbnails.x = 353
					mTopCurtain.gotoAndStop(1)
					deco1.x =325
					deco2.x =437
					deco3.visible = false
					deco4.visible = false
					break;
					
					case 2:
					mThumbnails.x = 300
					mTopCurtain.gotoAndStop(2)
					deco1.x =271;
					deco2.x =380;
					deco3.x = 492;
					deco4.visible = false					
					break;
					
					case 3:
					mThumbnails.x = 240
					mTopCurtain.gotoAndStop(3)
					deco1.x = 212;
					deco2.x = 322;
					deco3.x = 430;
					deco4.x = 539;
					break;
				}
						
			}
		}
		
		
		/**
		 *	Returns an array of TrailerThumbs.
		 *	@PARAM		pThumbsArray 	Array		Array of each trailer info (gets it via amfphp)
		 **/
		protected function returnTrailerInfo(pThumbsArray:Array):Array
		{
			var array:Array = []
			for (var i:String in  mCinemaObj.screenings)
			{
				var myName:String = "thumb" + i
				trace ("myThumbs", i, mCinemaObj.screenings[i].tracking)
				array.push(new TrailerThumb (myName , pThumbsArray[i], mCinemaObj.screenings[i].video,mCinemaObj.screenings[i].tracking ))
			}
			return array;
		}
		
		
		/**
		 *	Adds a video player
		 **/
		protected function addVideoPlayer():void
		{
			mMovieHolder = getChildByName("movie") as MovieClip
			mMovieHolder.addChild(VideoPlayerSingleton.instance)
			
		}
		
		
		/**
		 *	Plays a video
		 *	@PARAM		pTrailerThumb		TrailerThumb		class contains video source (url)
		 **/
		protected function startTheMovie (pTrailerThumb:TrailerThumb):void
		{
			var thumb:TrailerThumb = pTrailerThumb
			trace ("what's my tracking", thumb.tracking)
			trace (thumb.name)
			processTracking(thumb.tracking)
			VideoPlayerSingleton.instance.setVideoParam(
														mRootTimeLine, 
													 	"VideoPlayer", 
													 	unescape(thumb.videoLink), 
													 	null, 
													 	0, 
													 	0, 
													 	0,
														480,
														270
													 	)
			if (!VideoPlayerSingleton.instance.hasEventListener(VideoPlayerSingleton.VIDEO_VIEWED))
			{
				VideoPlayerSingleton.instance.addEventListener(VideoPlayerSingleton.VIDEO_VIEWED, onVideoViewed)
			}
		}
		
		
		/**
		 *	Handle mouse over when the mouse hovers over a display object with "btnArea" layer
		 **/
		protected override function handleMouseOver(evt:MouseEvent):void
		{
			if (evt.target.name == "btnArea")
			{
				var mc:MovieClip = evt.target as MovieClip
				mc.buttonMode = true;
				MovieClip(mc.parent).gotoAndStop("over")
				
				if (mc.parent.name.substr(0, 5) == "icon_")
				{
					mInfoTextBox.myText.text = AbsIcon(mc.parent.parent).iconText
					mInfoTextBox.visible = true
					mInfoTextBox.alpha = 0
					Tweener.addTween(mInfoTextBox, {alpha:1, time:.3})
				}
				
			}
		}
		
		
	
		/**
		 *	Default is set have no filter on the display object when MouseOut.
		 *	For different effects, child class should override this function
		 *
		 *	@NOTE: This display Object must have MC within itself named "btnArea" at the top layer
		 *	@NOTE: If the display Object has a "out" state (as frame lable) it'll stop at that state
		 **/
		protected override function handleMouseOut(evt:MouseEvent):void
		{
			if (evt.target.name == "btnArea")
			{
				var mc:MovieClip = evt.target as MovieClip
				MovieClip(mc.parent).gotoAndStop("out")
				
				if (mc.parent.name.substr(0, 5) == "icon_")
				{
					mInfoTextBox.visible = false
					mInfoTextBox.myText.text = ""
				}
				
			}
		}
		
		
		/**
		 *	When varioius icons are clicked,it shoudl carry functions accordingly
		 *
		 *	@NOTE: Not all the icons are defined.  We are making them as we go along.
		 **/
		protected function handleIconClick(pIcon:AbsIcon):void
		{
			switch (pIcon.name)
			{
				case "synopsis":
					var popup:PopUpGeneric = new PopUpGeneric ("popupGeneric", mView)
					popup.setText(SynopsisIcon(pIcon).content)
					popup.setLogo(makeBitmapCopy (mLogoImage))
					processTracking(SynopsisIcon(pIcon).tracking)
					addChild(popup)
					//Viv - scroller
					popup.addScroller();
					break;
				
				case "trivia":
					trace ("Its function hasn't be defined yet")
					processTracking(TriviaIcon(pIcon).tracking)
					break;
				
				case "hunt":
					trace ("Its function hasn't be defined yet")
					processTracking(ScavengerHuntIcon(pIcon).tracking)
					break;
				
				
				case "questions":
					trace ("Its function hasn't be defined yet")
					processTracking(QuestionsIcon(pIcon).tracking)
					break;
				
				case "schedule":
					trace ("Its function hasn't be defined yet")
					processTracking(ScheduleIcon(pIcon).tracking)
					break;
								
				case "website":
					WebsiteIcon(pIcon).doYourThing()
					processTracking(WebsiteIcon(pIcon).tracking)
					break;
				
				case "clues":
					trace ("Its function hasn't be defined yet")
					processTracking(CluesIcon(pIcon).tracking)
					break;
				
				case "games":
					GamesIcon(pIcon).doYourThing()
					processTracking(GamesIcon(pIcon).tracking)
					break;
					
				case "quest":
					BannerQuestIcon(pIcon).doYourThing()
					processTracking(BannerQuestIcon(pIcon).tracking)
					break;
			}
		}
		
		
		/**
		 *	Takes teh source display obect and returns a bitmap copy of the original
		 **/
		protected function makeBitmapCopy(pSource:DisplayObject):Bitmap
		{
			var myData:BitmapData = new BitmapData (pSource.width, pSource.height);
			myData.draw(pSource);
			var myCopy:Bitmap = new Bitmap(myData);
			return myCopy;
		}
		
		/**
		 *	track urls for marketing
		 **/
		protected function processTracking(pTrackArray:Array):void
		{
			NeoTracker.instance.trackURLArray(pTrackArray)
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		/**
		 *	create lobbyPoster class for right and left posets and add them in respected holders (left poster and right poster)
		 **/
		protected function setPosters():void
		{
			mRPoster = new LobbyPoster (
										 "right", 
										 null, 
										 mCinemaObj.rightBanner.link,
										 mCinemaObj.rightBanner.target, 
										 mCinemaObj.rightBanner.tracking, 
										 mCinemaObj.rightBanner.active
										 )
			
			mLPoster = new LobbyPoster (
										 "left", 
										 null, 
										 mCinemaObj.leftBanner.link,
										 mCinemaObj.leftBanner.target, 
										 mCinemaObj.leftBanner.tracking, 
										 mCinemaObj.leftBanner.active
										 )
			
			var rPoster:MovieClip = MovieClip(getChildByName("rightPoster"))
			rPoster.posterHolder.addChild(mRPoster)
			
			var lPoster:MovieClip = MovieClip(getChildByName("leftPoster"))
			lPoster.posterHolder.addChild(mLPoster)
			
			var imagesArray:Array = [mCinemaObj.leftBanner.image, mCinemaObj.rightBanner.image]
			ImageLoader.instance.addEventListener(ImageLoader.IMAGES_LOADED, onPostersLoaded,false, 0, true)
			ImageLoader.instance.startLoading(imagesArray)
		}
		
		protected function processPosterClick(pPoster:LobbyPoster):void
		{
			var lobbyPoster:LobbyPoster = pPoster;
			trace (lobbyPoster.linkURL, lobbyPoster.target)
			navigateToURL(new URLRequest(lobbyPoster.linkURL), lobbyPoster.target)
			processTracking(lobbyPoster.tracking)
		}
		
		/**
		 *	retrieve thumbnail images url and load them
		 **/
		protected function setThumbnailImages():void
		{
			var imagesArray:Array = [];
			for (var i:String in mCinemaObj.screenings)
			{
				imagesArray.push(mCinemaObj.screenings[i].thumb)
			}
			
			
			ImageLoader.instance.addEventListener(ImageLoader.IMAGES_LOADED, onThumbImagesLoaded,false, 0, true);
			ImageLoader.instance.startLoading(imagesArray);
			
		}
		
		/**
		 *	retrieve backgrouond and logo urls and load them
		 **/
		protected function setMiscImages():void
		{
			var imagesArray:Array = [];
			//"http://images50.neopets.com/sponsors/testdestination/artAssets/movieBackground.jpg"
			//"http://images50.neopets.com/sponsors/testdestination/artAssets/logo.jpg"
			var backgroundImageLink:String = mCinemaObj.trailerBackground
			var logoImageLink:String = mCinemaObj.logoImage
			imagesArray.push(backgroundImageLink)
			imagesArray.push(logoImageLink)
			ImageLoader.instance.addEventListener(ImageLoader.IMAGES_LOADED, onMiscImagesLoaded,false, 0, true);
			ImageLoader.instance.startLoading(imagesArray);
		}
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		/**
		 *	handle various obj clicks, assuming it's a button (has btnArea)
		 **/
		protected override function handleObjClick(evt:CustomEvent):void
		{
			if (evt.oData.DATA.name == "btnArea")
			{
				
				var mc:MovieClip = evt.oData.DATA as MovieClip
				//MovieClip(mc.parent).gotoAndStop("out")
				trace (mc.parent.parent.name)
				if (mc.parent.name.substr(0, 5) == "icon_")
				{
					handleIconClick(AbsIcon(mc.parent.parent))
				}
				else if (mc.parent.name.substr(0, 5) == "thumb")
				{
					startTheMovie(evt.oData.DATA.parent)
				}
				else
				{
					var objName:String = evt.oData.DATA.parent.name;
					switch (objName)
					{
						case "leftPoster":
							processPosterClick(mLPoster)
							break;
							
						case "rightPoster":
							processPosterClick(mRPoster)
							break;
						
						case "back":
							navigateToURL(new URLRequest(mCinemaObj.back), "_self")
							break;
					}
				}
				
				
			}
			
		}
		
		/**
		 *	incase if marketing wants to show/do something after each trailer is viewed...
		 **/
		protected function onVideoViewed(evt:Event)
		{
			VideoPlayerSingleton.instance.removeEventListener(VideoPlayerSingleton.VIDEO_VIEWED, onVideoViewed)
		}
		
		
		/**
		 *	once poster images are loaded, it should be added to posterObj (and thus show in the frame)	 
		 **/
		private function onPostersLoaded(evt:CustomEvent):void
		{
			ImageLoader.instance.removeEventListener(ImageLoader.IMAGES_LOADED, onPostersLoaded)
			mLPoster.addImage(evt.oData.DATA[0])
			mRPoster.addImage(evt.oData.DATA[1])
			
			setMiscImages()
						
		}
		
		/**
		 *	Once background and logo images are loaded, set them accordingly	 
		 **/
		private function onMiscImagesLoaded(evt:CustomEvent):void
		{
			ImageLoader.instance.removeEventListener(ImageLoader.IMAGES_LOADED, onMiscImagesLoaded)
			if (evt.oData.DATA[0] != undefined || evt.oData.DATA[0] != null)
			{
				var movieBackground:Bitmap = evt.oData.DATA[0]
				movieBackground.x = -movieBackground.width/2
				movieBackground.y = -movieBackground.height/2
				
				var movieHolder:MovieClip =  MovieClip(getChildByName("movie"))
				movieHolder.addChild(movieBackground)
			}
	
			addVideoPlayer();
			
			mLogoImage = evt.oData.DATA[1]
			
			setThumbnailImages()
		}
		
		/**
		 *	once thumbnail images are loaded, set them up accordingly	 
		 **/
		protected function onThumbImagesLoaded(evt:CustomEvent):void
		{
			trace ("set up thumnails")
			var trailersArray:Array =  returnTrailerInfo (evt.oData.DATA)
			setupThumbnails(trailersArray);
		}
	}
}