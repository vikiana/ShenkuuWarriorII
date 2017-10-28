
/* AS3
	Copyright 2008
*/

package com.neopets.util.loading
{
	import com.neopets.util.events.CustomEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	/**
	 *	This is for loading external XML Files
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author Clive Henrick
	 *	@since  08.04.2008
	 */
	public class XMLLoader extends EventDispatcher
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public const XML_DONE:String = "XMLLoaded";
		public const XML_LOAD_ERROR:String = "XMLLoadError";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		private var mURL:String;
		private var mID:String;
		private var mLoader:EnhancedURLLoader;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 *  @param		pURL		String		The URL of the XML File
		 */
		public function XMLLoader(pURL:String,pID:String = "XML", target:IEventDispatcher=null)
		{
			super(target);
			mID = pID;
			mURL = pURL;
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		public function get URL():String
		{
			return mURL;
		}
		
		public function get ID():String
		{
			return mID;
		}
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 *	@Loads the XML
		 * 	@param		pURL		String		The URL of the XML File
		 */
		 
		public function loadXML(pID:String = "XML"):void
		{
		
			trace("XML URL", mURL);
			mLoader = new EnhancedURLLoader(mURL);
		 	mLoader.dataFormat = "text";
		 	mLoader.addEventListener(Event.COMPLETE, onXml_ExternalReady,false,0,true);
			mLoader.addEventListener(IOErrorEvent.IO_ERROR, onXMLError,false,0,true);
			mLoader.load(new URLRequest(mURL));

		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 *	@onError handles when a Loader has an Error
		 *  @param			evt			Event		From Event.ERROR	
		**/
		
		private function onXMLError(error:IOErrorEvent):void {
			dispatchEvent(new Event(XML_LOAD_ERROR));
			trace("XML LOAD ERROR"  + error);
		}
		
			
		/**
		 *	@Sends an XML Error
		 * 	@CustomEvent	evt.target.data			String			XML item from the Server
		*/
		
		private function onXml_ExternalReady(evt:Event):void {
			var tXML:XML = new XML(evt.target.data);
			this.dispatchEvent(new CustomEvent({XML:tXML,ID:mID},XML_DONE));
		}
			
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		
	}
	
}
