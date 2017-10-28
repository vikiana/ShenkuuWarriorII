/**
 *	MAIN LANDING PAGE
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

package com.neopets.games.marketing.destination.movieCentral.pages
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.events.MouseEvent
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------
	
	import com.neopets.util.events.CustomEvent;
	import com.neopets.projects.destination.destinationV2.movieTheater.MovieDataHolder;
	import com.neopets.projects.destination.destinationV2.movieTheater.LobbyPoster;
	import com.neopets.projects.destination.destinationV2.ImageLoader;
	import com.neopets.util.tracker.NeoTracker;
	
	
	public class PageMainLanding extends AbsMovieCentralPage
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		
		private var mUserName:String
		private var mDatabaseID:String
		
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function PageMainLanding(pName:String = null):void
		{
			super(pName);
			setupPage ()
			updatePoster();
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
			addImage("MainReceptionMC", "mainPage", 390, 265);
		}
		
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		/**
		 *	loads poster infos
		 **/
		
		private function updatePoster():void
		{
			var lobbyObj:Object = MovieDataHolder.instance.getLobby()
			var imagesArray:Array = []
			for (var i in lobbyObj.images)
			{
				var imageURL:String = lobbyObj.images[i].image
				imagesArray.push(imageURL)
			}
			
			ImageLoader.instance.addEventListener(ImageLoader.IMAGES_LOADED, onImagesLoaded, false, 0, true)
			ImageLoader.instance.startLoading(imagesArray)
			for (var j:String in lobbyObj.images)
			{
				var posterHolder:MovieClip =  MovieClip(getChildByName("mainPage"))["poster"+ j.toString()].posterHolder;
				posterHolder.addChild( new LobbyPoster ("posterInfo"+j.toString(), null, lobbyObj.images[j].link,lobbyObj.images[j].target, lobbyObj.images[j].tracking, lobbyObj.images[j].active))
			}
		}
		
		
		/**
		 *	When a poster is clicked, it retrieves the data and navigate to a theater
		 **/
		
		private function processPosterClick(pObj:DisplayObject):void
		{
			
			var lobbyPoster:LobbyPoster = LobbyPoster(pObj);
			NeoTracker.instance.trackURLArray(lobbyPoster.tracking)
			navigateToURL(new URLRequest(lobbyPoster.linkURL), lobbyPoster.target)
			
		}

		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		/**
		 *	returns loaded images
		 *	@PARAM		evt		CustomEvent		evt.oData.DATA will return a array of loaded images
		 **/
		private function onImagesLoaded(evt:CustomEvent):void
		{
			ImageLoader.instance.removeEventListener(ImageLoader.IMAGES_LOADED, onImagesLoaded)
			trace ("called??")
			for (var i:int = 0; i < evt.oData.DATA.length; i++)
			{
				var posterHolder:MovieClip =  MovieClip(getChildByName("mainPage"))["poster"+ i.toString()].posterHolder;
				posterHolder.removeChild(posterHolder.getChildByName("loader"))
				LobbyPoster(posterHolder.getChildByName("posterInfo" + i.toString())).addImage(evt.oData.DATA[i])
			}

			
		}
		
		
		override protected function handleObjClick(e:CustomEvent):void
		{
			var objName:String = e.oData.DATA.parent.name;
			switch (objName)
			{
				case "poster0":
					processPosterClick(e.oData.DATA.parent.posterHolder.getChildByName("posterInfo0"))
					break;
					
				case "poster1":
					processPosterClick(e.oData.DATA.parent.posterHolder.getChildByName("posterInfo1"))
					break;
					
				case "poster2":
					processPosterClick(e.oData.DATA.parent.posterHolder.getChildByName("posterInfo2"))
					break;
			}
		}
	}
	
}