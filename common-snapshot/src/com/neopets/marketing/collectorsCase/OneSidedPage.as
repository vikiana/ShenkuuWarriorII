/* AS3
	Copyright 2008
*/
package com.neopets.marketing.collectorsCase
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	/**
	 *	This class handles animated pages with content on only one side.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  10.07.2009
	 */
	public class OneSidedPage extends ReversibleAnimation 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const IMAGES_LOADED:String = "images_loaded";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		// components
		protected var _frontFace:DisplayObjectContainer;
		protected var frontMask:MovieClip;
		// loading variables
		protected var _imagesLoaded:Boolean;
		protected var _loadList:LoaderQueue;
		protected var _nextButton:SimpleButton;
		protected var _prevButton:SimpleButton;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function OneSidedPage():void{
			loadList = new LoaderQueue();
			gotoAndStop("front");
			_frontFace = this["front_mc"];
			frontMask = this["front_mask_mc"];
			if(frontMask != null) frontMask.gotoAndStop("front");
			_imagesLoaded = false;
		}		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get frontFace():DisplayObjectContainer { return _frontFace; }
		
		public function get imagesLoaded():Boolean { return _imagesLoaded; }
		
		public function get loadList():LoaderQueue { return _loadList; }
		
		public function set loadList(list:LoaderQueue) {
			// clear previous loading list
			if(_loadList != null) {
				_loadList.removeEventListener(Event.COMPLETE,onLoadComplete);
			}
			// set new loading list
			_loadList = list;
			if(_loadList != null) {
				_loadList.addEventListener(Event.COMPLETE,onLoadComplete);
			}
		}
		
		public function set nextButton(btn:SimpleButton) {
			if(btn != _nextButton) {
				// clear previous button
				if(_nextButton != null) {
					_nextButton.removeEventListener(MouseEvent.CLICK,onNextPageRequest);
					_nextButton.removeEventListener(MouseEvent.ROLL_OVER,onNextPageRollOver);
					_nextButton.removeEventListener(MouseEvent.ROLL_OUT,onNextPageRollOut);
				}
				// set new button
				_nextButton = btn;
				if(_nextButton != null) {
					_nextButton.addEventListener(MouseEvent.CLICK,onNextPageRequest);
					_nextButton.addEventListener(MouseEvent.ROLL_OVER,onNextPageRollOver);
					_nextButton.addEventListener(MouseEvent.ROLL_OUT,onNextPageRollOut);
				}
			}
		}
		
		public function set prevButton(btn:SimpleButton) {
			if(btn != _prevButton) {
				// clear previous button
				if(_prevButton != null) {
					_prevButton.removeEventListener(MouseEvent.CLICK,onPreviousPageRequest);
					_prevButton.removeEventListener(MouseEvent.ROLL_OVER,onPreviousPageRollOver);
					_prevButton.removeEventListener(MouseEvent.ROLL_OUT,onPreviousPageRollOut);
				}
				// set new button
				_prevButton = btn;
				if(_prevButton != null) {
					_prevButton.addEventListener(MouseEvent.CLICK,onPreviousPageRequest);
					_prevButton.addEventListener(MouseEvent.ROLL_OVER,onPreviousPageRollOver);
					_prevButton.addEventListener(MouseEvent.ROLL_OUT,onPreviousPageRollOut);
				}
			}
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @This function tries adding art to the front face of this page.
		 * @param		front		DisplayObject 		Image placed on the front of the page
		 */
		 
		public function addToFront(front:DisplayObject) {
			if(front == null) return;
			if(_frontFace != null) {
				if("loadList" in front) {
					var clip:MovieClip = front as MovieClip;
					clip.loadList = _loadList;
				}
				_frontFace.addChild(front);
			}
		}
		
		/**
		 * @Use this function to start a synched animation to a given frame.
		 * @param		id		Object 		Name or number of the target frame.
		 */
		 
		public function flipToward(id:Object) {
			gotoFrame(id);
			if(frontMask != null) frontMask.gotoFrame(id);
		}
		
		/**
		 * @Use this function to start loading our content's art assets.
		 */
		 
		public function loadImages():void {
			// check if that was the last item
			if(_frontFace != null) {
				// Have all our children load their assets
				var disp:DisplayObject;
				var clip:MovieClip;
				for(var i:int = 0; i < _frontFace.numChildren; i++) {
					disp = _frontFace.getChildAt(i);
					if("loadImages" in disp) {
						clip = disp as MovieClip;
						clip.loadImages();
					}
				}
				// start loading images
				_loadList.startLoading();
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @This function broadcasts when the loader has finished it's load operation.
		 */
		
		public function onLoadComplete(ev:Event) {
			_imagesLoaded = true;
			dispatchEvent(new Event(IMAGES_LOADED));
		}
		
		/**
		 * @This function is called when the user presses a "next page" button.
		 */
		
		public function onNextPageRequest(ev:Event) {
			// let out album know we want to look at the next page
			dispatchEvent(new Event(ItemAlbum.NEXT_PAGE_REQUESTED));
		}
		
		/**
		 * @This function is called when the user presses a "previous page" button.
		 */
		
		public function onPreviousPageRequest(ev:Event) {
			dispatchEvent(new Event(ItemAlbum.PREV_PAGE_REQUESTED));
		}
		
		/**
		 * @This function is called when the user rolls over a "next page" button.
		 */
		
		public function onNextPageRollOver(ev:Event) {
			if(_targetFrame < 0) flipToward("near_front");
		}
		
		/**
		 * @This function is called when the user rolls off a "next page" button.
		 */
		
		public function onNextPageRollOut(ev:Event) {
			if(_targetFrame < 0) flipToward("front");
		}
		
		/**
		 * @This function is called when the user rolls over a "previous page" button.
		 */
		
		public function onPreviousPageRollOver(ev:Event) {
			if(_targetFrame < 0) flipToward("near_back");
		}
		
		/**
		 * @This function is called when the user rolls off a "previous page" button.
		 */
		
		public function onPreviousPageRollOut(ev:Event) {
			if(_targetFrame < 0) flipToward("back");
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}