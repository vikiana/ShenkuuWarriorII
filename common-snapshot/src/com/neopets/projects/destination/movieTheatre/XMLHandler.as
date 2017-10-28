
package com.neopets.projects.destination.movieTheatre
{
	
	//----------------------------------------
	//	IMPORTS
	//----------------------------------------
	
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.display.Sprite;
	
	//----------------------------------------
	//	CUSTOM IMPORTS
	//----------------------------------------
	import com.neopets.util.events.CustomEvent;
	
	public class XMLHandler extends Sprite{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public const MOVIE_INFO_IN:String = "movie_info_in"  //sucessfully loaded movie xml and is parsed
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
				
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function XMLHandler(pPath:String, pFileName:String = "theatreConfig.xml", pLocalTesting:Boolean = true):void
		{
			var server:String = pLocalTesting? "":"http//:images50.neopets.com/";
			var path:String = pPath;
			var fileName:String = pFileName
			
			var url:String = server + path + fileName
			
			var xmlLoader:URLLoader = new URLLoader()
			var myURLRequest:URLRequest = new URLRequest(url)
			xmlLoader.addEventListener(Event.COMPLETE, XMLLoaded);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, xmlLoadError);
			xmlLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			xmlLoader.load(myURLRequest)
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PROTECTED METHODS
		//--------------------------------------
		
		protected function processXML(pxml:XML):void
		{
			var xmlList:XMLList = pxml.children()
			var mMovieInfoArray:Array = new Array ()
			for each (var i:XML in xmlList)
			{
				 mMovieInfoArray.push([i.@name, i.@source, i.@clickID, i.@clue, i.@description])
			}
			dispatchEvent (new CustomEvent ({DATA:mMovieInfoArray}, MOVIE_INFO_IN))
		}
		//--------------------------------------
		//  PRIVATE METHODS
		//--------------------------------------
		
		
		//--------------------------------------
		//  EVENT LISTENERS
		//--------------------------------------
		
		private function progressHandler(evt:ProgressEvent) 
		{
			trace ("progress = ", evt.bytesLoaded, evt.bytesTotal)
		}
		
		private function XMLLoaded(evt:Event):void 
		{
			var xmlLoader:URLLoader = evt.target as URLLoader
			xmlLoader.removeEventListener(Event.COMPLETE, XMLLoaded)
			xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, xmlLoadError);
			xmlLoader.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			processXML(XML(evt.target.data))
		}
		
		private function xmlLoadError(evt:IOErrorEvent) 
		{
				trace (evt)
				trace('There was an error loading the xml file.');
		}
	}
}
