/**
 *	Document class for a theater (most of the theater will simply have this as it's base)
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  07.16.2009
 */
 
 //----------------------------------------
 //	OVERALL FLOW
 //----------------------------------------

 
package com.neopets.games.marketing.destination.movieCentral.theaters
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.destinationV2.movieTheater.AbsTheaterView;
	import com.neopets.projects.destination.destinationV3.movieTheater.MovieData;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	
	public class GenericTheater extends AbsTheaterView
	{
		//----------------------------------------
		//VARIABLES
		//----------------------------------------

		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		
		public function GenericTheater():void
		{
			super()
		}
		
		//----------------------------------------
		//GETTERS AND SETTORS
		//----------------------------------------
		
		
		//----------------------------------------
		//PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//PROTECTED METHODS
		//----------------------------------------
		
		
		
		protected override function setupTheater(pData:Object):void
		{
			trace ("theater should be set up")
			var theater:TheaterPage = new TheaterPage ("theater page", this)
			theater.setup(pData);
			addChild (theater);
		}
		
		protected override function init():void
		{
			var path:String = "http://dev.neopets.com"
			var movie_id:String = "guardians"
			try {
				var paramObj:Object = LoaderInfo(this.stage.root.loaderInfo).parameters;
				if (paramObj["baseurl"] != undefined || paramObj["baseurl"] != null)
				{
					path = paramObj["baseurl"]
				}
				
				if (paramObj["movie"] != undefined || paramObj["movie"] != null)
				{
					movie_id = paramObj["movie"]
				}
			} catch (error:Error) {
				trace(error.toString());
			}
			
			MovieData.instance.init(path)
			MovieData.instance.addEventListener(MovieData.CINEMA_RECEIVED, onCinemaLoaded, false, 0, true);
			MovieData.instance.getCinema(movie_id)
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseClick)
		}
		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
		/**
		 *	setup theater once cinema obj is loaded.  This event is coming from init() (setting movie data)
		 **/
		private function onCinemaLoaded(evt:CustomEvent):void
		{
			setupTheater(evt.oData.DATA)
		}
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------
	}
}