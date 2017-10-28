/* AS3
Copyright 2010
*/

package com.neopets.games.marketing.destination.CapriSun2011.subElements
{
	import com.neopets.games.marketing.destination.CapriSun2011.button.HiButton;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	/**
	 *	This needs to contain information about the Class and what it is used for
	 *	Please use ASDocs if you can for your notes
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author Clive Henrick
	 *	@since  5.18.2010
	 */
	
	public class SixFlags2010InfoPopup extends MovieClip
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const CLOSE_BTN_EVENT:String = "closeBtnClicked";
		public static const WEB_BTN_EVENT:String = "GotoAWebSite";
		public static const GOBACK_EVENT:String = "GoBack";
	
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		public var close_btn:HiButton; //Onstage
		public var web_btn:HiButton; //Onstage
		public var textFieldTop:TextField; //OnStage
		public var textFieldBottom:TextField; //NotUsed
		public var back_btn:HiButton;
		
		protected var _Image:Bitmap;
		protected var _loader:Loader;
		protected var _URL:String;
		protected var _ActivityID:int;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function SixFlags2010InfoPopup()
		{
			super();
			close_btn.addEventListener(MouseEvent.CLICK, closePopUp, false, 0, true);
			web_btn.addEventListener(MouseEvent.CLICK, webButtonClicked, false, 0, true);
		}
		
		public function setUpPicture(pURL:String, bkbtn:Boolean=false):void
		{
			if (!bkbtn){
				back_btn.visible = false;
			} else {
				back_btn.visible = true;
				back_btn.addEventListener(MouseEvent.CLICK, goBack, false, 0, true);
			}
			
			if (_Image != null)
			{
				removeChild(_Image);
				_Image = null;	
			}
			
			_loader = new Loader();
			var tURLRequest:URLRequest = new URLRequest(pURL);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError,false,0,true);
			_loader.load(tURLRequest);
		}
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get URL():String
		{
			return _URL;
		}
		
		public function set URL(pURL:String):void
		{
			_URL = pURL;
		}
		
		public function get activityID():int
		{
			return _ActivityID;
		}
		
		public function set activityID(pID:int):void
		{
			_ActivityID = pID;
		}
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		protected function imageLoaded(evt:Event):void
		{
			_Image = Bitmap(_loader.content);
			_Image.x = 86.75;
			_Image.y = 81.85;
			addChild(_Image);
		}
		
		protected function closePopUp(evt:Event):void
		{
			this.dispatchEvent(new Event(SixFlags2010InfoPopup.CLOSE_BTN_EVENT));	
		}
		
		protected function webButtonClicked (evt:Event):void
		{
			dispatchEvent(new Event(SixFlags2010InfoPopup.WEB_BTN_EVENT));
		}
		
		
		protected function goBack(e:MouseEvent):void {
			this.dispatchEvent(new Event(SixFlags2010InfoPopup.GOBACK_EVENT));
		}
		/**
		 *	@onError handles when a Loader has an Error
		 *  @param			evt			Event		From Event.ERROR	
		 **/
		
		protected function onError(error:IOErrorEvent):void {
			trace("Error on Loadign >" + error);
		}
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
	}
}

