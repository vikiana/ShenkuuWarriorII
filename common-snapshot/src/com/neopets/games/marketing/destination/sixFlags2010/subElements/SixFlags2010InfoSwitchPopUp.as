
/* AS3
Copyright 2009
*/

package com.neopets.games.marketing.destination.sixFlags2010.subElements
{
	import com.neopets.games.marketing.destination.sixFlags2010.button.HiButton;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
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
	 *	@author 
	 *	@since  3.04.2009
	 */
	
	public class SixFlags2010InfoSwitchPopUp extends MovieClip
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const CLOSE_BTN_EVENT:String = "closeBtnClicked";
		public static const IMAGE_BTN_EVENT:String = "UserClickedonAnImage";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		public var close_btn:HiButton; //Onstage
		
		protected var _LeftImage:Sprite; 
		protected var _RightImage:Sprite; 
		protected var _loader:Loader;
		protected var _loader2:Loader;
		
		protected var _LeftButtonID:String;
		protected var _RightButtonID:String;
		
		protected var _caFlag:Boolean = false;
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function SixFlags2010InfoSwitchPopUp()
		{
			super();
			close_btn.addEventListener(MouseEvent.CLICK, closePopUp, false, 0, true);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		public function init(pURL1:String, pURL2:String, pButtonNameL:String, pButtonNameR:String, pCaliforniaFlag:Boolean = false):void
		{
			
			if (_LeftImage != null)
			{
				this.removeChild(_LeftImage);
				_LeftImage = null;
				this.removeChild(_RightImage);
				_RightImage = null;
			}
			
			_caFlag = pCaliforniaFlag;
			_loader = new Loader();
			_loader2 = new Loader();
			
			
			_LeftButtonID = pButtonNameL;
			_RightButtonID = pButtonNameR;
			
			var tURLRequest:URLRequest = new URLRequest(pURL1);
			var tURLRequest2:URLRequest = new URLRequest(pURL2);
			
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError,false,0,true);
			_loader.load(tURLRequest);
			
			_loader2.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded2);
			_loader2.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError,false,0,true);
			_loader2.load(tURLRequest2);
		}
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		protected function closePopUp(evt:Event):void
		{
			this.dispatchEvent(new Event(SixFlags2010Popup.CLOSE_BTN_EVENT));	
		}
		
		protected function loginButtonClicked (evt:Event):void
		{
			dispatchEvent(new Event(SixFlags2010Popup.LOGIN_BTN_EVENT));
		}
		
		protected function imageLoaded(evt:Event):void
		{	
			_LeftImage = new Sprite();
			_LeftImage.addChild(Bitmap(_loader.content));
			_LeftImage.scaleX = .75;
			_LeftImage.scaleY = .75;
			_LeftImage.x = 41;
			_LeftImage.y = 70;
			addChild(_LeftImage);
			_LeftImage.buttonMode = true;
			_LeftImage.mouseEnabled = true;
			
			_LeftImage.addEventListener(MouseEvent.CLICK,leftImageClicked,false,0,true);
		}
		
		protected function imageLoaded2(evt:Event):void
		{
			_RightImage = new Sprite();
			_RightImage.addChild(Bitmap(_loader2.content));
			_RightImage.buttonMode = true;
			
			if (_caFlag) // Discovery Kingdom is strange size
			{
				_RightImage.scaleX = .85;
				_RightImage.scaleY = .85;
				_RightImage.x = 320;
				_RightImage.y = 90;
			}
			else
			{
				_RightImage.scaleX = .75;
				_RightImage.scaleY = .75;
				_RightImage.x = 332;
				_RightImage.y = 70;
			}
			
			_RightImage.mouseEnabled = true;
		
			addChild(_RightImage);
			
			_RightImage.addEventListener(MouseEvent.CLICK,rightImageClicked,false,0,true);
		}
		/**
		 *	@onError handles when a Loader has an Error
		 *  @param			evt			Event		From Event.ERROR	
		 **/
		
		protected function onError(error:IOErrorEvent):void {
			trace("Error on Loadign >" + error);
		}
		
		protected function leftImageClicked(evt:Event):void
		{
			this.dispatchEvent(new CustomEvent({image:_LeftButtonID},SixFlags2010InfoSwitchPopUp.IMAGE_BTN_EVENT));	
		}
		
		protected function rightImageClicked(evt:Event):void
		{
			this.dispatchEvent(new CustomEvent({image:_RightButtonID},SixFlags2010InfoSwitchPopUp.IMAGE_BTN_EVENT));	
		}
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
	}
}

