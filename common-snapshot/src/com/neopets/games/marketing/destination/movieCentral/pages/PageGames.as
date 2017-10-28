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
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.destinationV2.AbsPageWithBtnState;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.projects.destination.destinationV2.movieTheater.MovieDataHolder;
	import com.neopets.projects.destination.destinationV2.movieTheater.GameObject;
	import com.neopets.projects.destination.destinationV2.ImageLoader;
	import com.neopets.util.tracker.NeoTracker;
	
	public class PageGames extends AbsMovieCentralPage
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function PageGames(pName:String = null):void
		{
			super(pName);
			setupPage ()
			updateGameMachines();
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
			addImage("ArcadeMC", "gamesPage", 390, 265);
		}
		
		
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		private function updateGameMachines():void
		{
			var gamesObj:Object = MovieDataHolder.instance.getGames()
			var imagesArray:Array = []
			for (var i in gamesObj.games)
			{
				var imageURL:String = gamesObj.games[i].image
				imagesArray.push(imageURL)
			}
			
			ImageLoader.instance.addEventListener(ImageLoader.IMAGES_LOADED, onImagesLoaded, false, 0, true)
			ImageLoader.instance.startLoading(imagesArray)
			
			for (var j:String in gamesObj.games)
			{
				var arcadeScreen:MovieClip =  MovieClip(getChildByName("gamesPage"))["arcadeScreen"+ j.toString()]
				arcadeScreen.addChild( new GameObject ("gameObj"+j.toString(), gamesObj.games[j].title, null, gamesObj.games[j].link,gamesObj.games[j].target, gamesObj.games[j].tracking))
				trace (arcadeScreen.numChildren)
				
				var arcadeMachine:MovieClip =  MovieClip(getChildByName("gamesPage"))["arcade"+ j.toString()]
				arcadeMachine.gameTitle.text = gamesObj.games[j].title.toUpperCase()
				
			}
		}
		
		
		
		private function processArcadeClick(pID:int):void
		{
			var id:String = pID.toString()
			var arcadeScreen:MovieClip =  MovieClip(getChildByName("gamesPage"))["arcadeScreen"+ id]
			var gameObj:GameObject = GameObject(arcadeScreen.getChildByName("gameObj" + id))
			
			navigateToURL(new URLRequest(gameObj.linkURL), gameObj.target)
			NeoTracker.instance.trackURLArray(gameObj.tracking)
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
			for (var i:int = 0; i < evt.oData.DATA.length; i++)
			{
				var arcadeScreen:MovieClip =  MovieClip(getChildByName("gamesPage"))["arcadeScreen"+ i.toString()]
				arcadeScreen.removeChild(arcadeScreen.getChildByName("loader"))
				GameObject(arcadeScreen.getChildByName("gameObj" + i.toString())).addImage(evt.oData.DATA[i])
			}
		}
		
		
		
		override protected function handleObjClick(e:CustomEvent):void
		{
			var objName:String = e.oData.DATA.parent.name;
			switch (objName)
			{
				case "arcade0":
					processArcadeClick(0)
					break;
				
				case "arcade1":
					processArcadeClick(1)
					break;
				
				case "arcade2":
					processArcadeClick(2)
					break;

			}
		}
		
		
	}
	
}