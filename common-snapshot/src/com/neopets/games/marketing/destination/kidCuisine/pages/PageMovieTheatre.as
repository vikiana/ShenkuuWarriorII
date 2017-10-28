/**
 *	MAIN LANDING PAGE
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

package com.neopets.games.marketing.destination.movieTest.pages
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.utils.getDefinitionByName;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.text.TextFormat;
	import flash.text.TextField;
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.AbstractPageWithBtnState;
	import com.neopets.projects.destination.videoPlayerComponent.VideoPlayerSetup;
	import com.neopets.projects.destination.videoPlayerComponent.VideoPlayerSingleton;
	import com.neopets.games.marketing.destination.movieTest.theatre.*
	import com.neopets.util.events.CustomEvent;
	import com.neopets.users.abelee.utils.ViewManager;
	
	
	public class PageMovieTheatre extends AbstractPageWithBtnState
	{		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		private var mHint:String;
		private var mRootTimeLine:Object;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function PageMovieTheatre(pName:String = null, pRootTimeLine:Object = null):void
		{
			super(pName);
			mRootTimeLine = pRootTimeLine
			var xmlHandler:MovieXMLHandler = new MovieXMLHandler()
			xmlHandler.addEventListener(xmlHandler.MOVIE_INFO_IN, onMovieInfoIn, false, 0, true)
			setupPage ()
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		protected override function setupPage():void
		{
			addTextImage("GenericBackground", "background", "Movie Theatre Page");
			addTextButton("GenericButton", "backToLanding", "Back", 550, 450);
			//addTextBox("GenericTextBox", "videoDescription", "xx", 50, 410, 400, 50, null, myTextFormat());
			addTextField("videoDescription", "xx", 50, 410, 400, 50, null, myTextFormat());
			addChild(VideoPlayerSingleton.instance)
			VideoPlayerSingleton.instance.addEventListener(VideoPlayerSingleton.VIDEO_VIEWED, onVideoViewed)
		}
		
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		private function myTextFormat():TextFormat
		{
			var textFormat:TextFormat = new TextFormat ()
			textFormat.align = "left",
			textFormat.size = 10
			textFormat.font = "Arial"
			return textFormat;
		}
		
		
		private function createMovieUI(pMovieInfo:Array):void
		{
			var trailerButtonArray:Array = createTrailerButtonArray(pMovieInfo);
			var arrowButtonArray:Array = createArrowButtonArray()
			
			var buttonMenu: ViewManager = new ViewManager(trailerButtonArray, arrowButtonArray)
			buttonMenu.x = 50;
			buttonMenu.y = 490;
			buttonMenu.images.addEventListener(MouseEvent.MOUSE_DOWN, onTrailerButtonClick, false, 0, true)
			addChild(buttonMenu)
		}
		
		private function createTrailerButtonArray(pMovieInfo:Array):Array
		{
			var trailerButtonArray:Array = new Array ();
			for (var i:String in pMovieInfo)
			{
				var currentMovieInfo:Array = pMovieInfo[i]	//info on individual movie
				var imageClass:Class = getDefinitionByName("GenericTrailerButton") as Class
				var image:MovieClip = new imageClass ();
				image.gotoAndStop("out")
				var info:MovieTestInfo = new MovieTestInfo (
															image, 
															currentMovieInfo[1],
															currentMovieInfo[2], 
															currentMovieInfo[3],
															currentMovieInfo[4]
															)
				info.name = currentMovieInfo[0]
				trailerButtonArray.push(info)
			}
			return trailerButtonArray
		}
		
		
		private function createArrowButtonArray():Array
		{
			var leftClass:Class = getDefinitionByName("GenericArrowLeft") as Class
			var left:MovieClip = new leftClass ();
			left.gotoAndStop("out")
			left.name = "left arrow"
		
			var rightClass:Class = getDefinitionByName("GenericArrowRight") as Class
			var right:MovieClip = new rightClass ();
			right.gotoAndStop("out")
			right.name = "right arrow"
			
			return [left, right]
		}
		
		private function startTheMovie (pURL:String, pHint:String, pClickID:int, pDescription:String):void
		{
			mHint = pHint;
			if (TextField(getChildByName("videoDescription")) != null)
			{
				var myText:TextField = TextField(getChildByName("videoDescription"))
				myText.text = pDescription
			}
			
			VideoPlayerSingleton.instance.setVideoParam(
														mRootTimeLine, 
													 "VideoPlayer", 
													 pURL, 
													 null, 
													 230, 
													 250, 
													 pClickID
													 )
		}
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		private function onMovieInfoIn(evt:CustomEvent):void
		{	var xmlHandler:MovieXMLHandler = evt.target as MovieXMLHandler
			xmlHandler.removeEventListener(xmlHandler.MOVIE_INFO_IN, onMovieInfoIn)
			createMovieUI(evt.oData.DATA)
		}
		
		private function onTrailerButtonClick(evt:MouseEvent):void
		{
			trace (evt.target.parent.name)
			if (evt.target.name == "btnArea")
			{
				var info:MovieTestInfo = MovieTestInfo(evt.target.parent.parent)
				var url:String = info.videoSourceURL
				var hint:String = info.clue
				var clickID:int = int(info.clickLinkID)
				var description:String = info.description
				
				startTheMovie (url, hint, clickID, description)
			}
		}
		
		private function onVideoViewed(evt:Event):void
		{
			trace ("removeVideo from move theatre page")
		}
		
	}
	
}