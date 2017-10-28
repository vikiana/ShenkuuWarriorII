/**
 *	a View class for theaters (class that extends this class will be a document class for each theater).
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  07.16.2009
 */
 

 
package com.neopets.projects.destination.destinationV3.movieTheater
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.LoaderInfo;
	
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.util.events.CustomEvent;
	import com.neopets.projects.destination.destinationV3.movieTheater.*
		
	public class AbsTheaterView extends MovieClip
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		public const OBJ_CLICKED:String = "obj_clicked"	//is dispatched when any objects are clicked
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		
		
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		
		public function AbsTheaterView():void
		{
			init();
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
		
		/**
		 *	retrieve cinema obj via amfphp, once it's received, build the cinema page
 		 **/
		protected function init():void
		{
			var path:String = "http://dev.neopets.com"
			var movie_id:String = "-1"
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
		
		
		/**
		 *	This class  shoud be overriden by child
 		 **/
		protected function setupTheater (pData:Object):void
		{
			var theater:AbsTheaterPage = new AbsTheaterPage ("theater page", this);
			theater.setup(pData);
			addChild (theater);
		}
		
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		/**
		 *	setup theater once cinema obj is loaded.  This event is coming from init() (setting movie data)
 		 **/
		private function onCinemaLoaded(evt:CustomEvent):void
		{
			setupTheater(evt.oData.DATA)
		}
			
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		/**
		 *	once object is clicked dispatch an event
 		 **/
		protected function onMouseClick(evt:MouseEvent):void
		{
			dispatchEvent (new CustomEvent ({DATA:evt.target}, OBJ_CLICKED))
		}
		
	}
}