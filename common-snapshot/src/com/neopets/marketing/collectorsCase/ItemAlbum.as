/* AS3
	Copyright 2008
*/
package com.neopets.marketing.collectorsCase
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.InteractiveObject;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	/**
	 *	This class roughly mimics the layout of a book.  In this model, only one page is shown at
	 *  a time.  As such, this class does not enforce z-axis handling on page flips.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  10.07.2009
	 */
	public class ItemAlbum extends ReversibleAnimation 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const ON_DATA_LOADED:String = "on_data_loaded";
		public static const NEXT_PAGE_REQUESTED:String = "next_page_requested";
		public static const PREV_PAGE_REQUESTED:String = "previous_page_requested";
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _albumData:Object;
		protected var pages:Array;
		protected var _pageIndex:int;
		protected var targetIndex:int;
		// component variables
		protected var _frontCover:MovieClip;
		protected var _backCover:MovieClip;
		protected var _pageArea:MovieClip;
		protected var _loadingBar:MovieClip;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function ItemAlbum():void{
			stop();
			// initialize values
			pages = new Array();
			_pageIndex = -1;
			// initialize component links
			frontCover = this["front_mc"];
			_backCover = this["back_mc"];
			_pageArea = this["page_area_mc"];
			_loadingBar = this["loading_mc"];
			mouseEnabled = false;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get albumData():Object { return _albumData; }
		
		public function get frontCover():MovieClip { return _frontCover; }
		
		public function set frontCover(clip:MovieClip) {
			_frontCover = clip;
			if(_frontCover != null) {
				_frontCover.mouseEnabled = false; // prevents click blocking on tab bar
			}
		}
		
		public function set nextButton(btn:SimpleButton) {
			if(btn != null) btn.addEventListener(MouseEvent.CLICK,onLastPageRequest);
		}
		
		public function set prevButton(btn:SimpleButton) {
			if(btn != null) btn.addEventListener(MouseEvent.CLICK,onPreviousPageRequest);
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Removes all pages from the book.
		 */
		 
		public function clearPages():void {
			closeBook();
			// cycle through all pages
			var page:OneSidedPage;
			while(pages.length > 0) {
				page = pages.pop();
				removeChild(page);
			}
		}
		
		/**
		 * @Jump back to the start of the book.
		 */
		 
		public function closeBook():void {
			if(_pageIndex >= 0) {
				gotoAndPlay("close");
				_pageIndex = -1;
			}
		}
		
		/**
		 * @Use this function to find the first page we have that uses the target collection.
		 * @param		collection		Object 		Collection data being searched for.
		 */
		 
		public function getCollectionIndex(collection:Object):int {
			// cycle through all pages
			var page:MovieClip;
			var face:DisplayObjectContainer;
			var j:int;
			var image:DisplayObject;
			var col_page:CollectionPage;
			for(var i:int = 0; i < pages.length; i++) {
				page = pages[i];
				// cycle through all element on this page's surface
				face = page.frontFace;
				for(j = 0; j < face.numChildren; j++) {
					image = face.getChildAt(j);
					if(image is CollectionPage) {
						col_page = image as CollectionPage;
						if(col_page.collectionData == collection) {
							return i;
						}
					} // end of typ check
				} // end of content loop
			} // end of page loop
			return -1;
		}
		
		/**
		 * @Start flipping to the first page of the target collection.
		 * @param		collection		Object 		Collection data being searched for.
		 */
		 
		public function gotoCollection(collection:Object):void {
			var index:Number = getCollectionIndex(collection);
			gotoPage(index);
		}
		
		/**
		 * @Use this function to start turning to a specific page.
		 * @param		collection		Object 		Collection data being searched for.
		 */
		 
		public function gotoPage(index:int):void {
			// check if the target index is in range
			if(index < 0) {
				// turn back to the cover
				targetIndex = -1;
				addEventListener(Event.ENTER_FRAME,onTurnToTarget);
			} else {
				// force high indices to our last page
				if(index >= pages.length) index = pages.length - 1;
				// check if we're already on that page
				if(index != _pageIndex) {
					targetIndex = index;
					// check if the page's image have been loaded yet
					var page:MovieClip = pages[index];
					if(page.imagesLoaded) addEventListener(Event.ENTER_FRAME,onTurnToTarget);
					else {
						// start loading the page's art
						if(_loadingBar != null) _loadingBar.visible = true;
						page.addEventListener(OneSidedPage.IMAGES_LOADED,onPageReady);
						page.loadImages();
					}
				} else {
					removeEventListener(Event.ENTER_FRAME,onTurnToTarget);
				}
			}
		}
		
		/**
		 * @Use this function to make the book flip to it's next page.
		 * @param		info		Object 		Data to be loaded
		 */
		 
		public function loadAlbum(info:Object):void {
			if(info ==  null) return; // make sure we have valid data
			_albumData = info;
			clearPages();
			// load our new pages
			if("collections" in info) {
				// cycle through all collections
				var collections:Array = info.collections;
				var collection:Object;
				var limit:int;
				var prev_length:int;
				var layout:CollectionPage;
				var page_capacity:int;
				var entry_index:int;
				for(var i:int = 0; i < collections.length; i++) {
					collection = collections[i];
					// Make sure we add enough pages to handle all the entries
					// in this collection.
					limit = collection.entries.length;
					//pushPage(new LoadingSign()); // blank test page
					for(entry_index = 0; entry_index < limit; entry_index += page_capacity) {
						// try creating a new page layout
						layout = new CollectionPageMC();
						page_capacity = layout.maxItems;
						if(page_capacity > 0) {
							// set up the page
							layout.setCollection(collection,entry_index);
							pushPage(layout);
						} else break;
					}
					//pushPage(null); // blank test page
				} // end of collections loop
			}
			if(_loadingBar != null) _loadingBar.visible = false;
			dispatchEvent(new Event(ON_DATA_LOADED));
		}
		
		/**
		 * @Use this function to make the book flip to it's next page.
		 * @param		front			DisplayObject 		Image placed on the front of the page
		 */
		 
		public function pushPage(front:DisplayObject=null):void {
			var page:OneSidedPage = new AlbumLeaf();
			// add content to page
			page.addToFront(front);
			// move the page to it's attachment point
			if(_pageArea != null) {
				page.x = _pageArea.x;
				page.y = _pageArea.y;
			}
			// finish adding page
			page.addEventListener(NEXT_PAGE_REQUESTED,onNextPageRequest);
			page.addEventListener(PREV_PAGE_REQUESTED,onPreviousPageRequest);
			pages.push(page);
			addChild(page);
			// adjust the page's z index
			var index:int;
			if(_backCover != null) index = getChildIndex(_backCover) + 1;
			else index = 0;
			setChildIndex(page,index);
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @This function is called when the user presses a "next page" button.
		 */
		
		public function onLastPageRequest(ev:Event) {
			gotoPage(pages.length - 1);
		}
		
		/**
		 * @This function is called when the user presses a "next page" button.
		 */
		
		public function onNextPageRequest(ev:Event) {
			gotoPage(_pageIndex + 1);
		}
		
		/**
		 * @This function is called when the user presses a "next page" button.
		 */
		
		public function onPreviousPageRequest(ev:Event) {
			gotoPage(_pageIndex - 1);
		}
		
		/**
		 * @Use this function to spread turning to the target page over multiple frames.
		 */
		 
		public function onPageReady(ev:Event=null):void {
			var targ:Object = ev.target;
			// if the readied page is our target index page, turn there now
			if(targetIndex >= 0 && targetIndex < pages.length) {
				var page:MovieClip = pages[targetIndex];
				if(page == targ) gotoPage(targetIndex);
			}
			// hide loading bar
			if(_loadingBar != null) _loadingBar.visible = false;
		}
		
		/**
		 * @Use this function to spread turning to the target page over multiple frames.
		 */
		 
		public function onTurnToTarget(ev:Event=null):void {
			if(_pageIndex != targetIndex) {
				if(_pageIndex < targetIndex) turnNextPage();
				else turnPreviousPage();
			} else removeEventListener(Event.ENTER_FRAME,onTurnToTarget);
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * @Use this function to make the book flip to it's next page.
		 */
		 
		protected function turnNextPage():void {
			if(_pageIndex < 0) gotoFrame("open");
			else {
				if(_pageIndex < pages.length) {
					var page:OneSidedPage = pages[_pageIndex];
					page.flipToward("back");
				}
			}
			// increment the page number
			_pageIndex++;
		}
		
		/**
		 * @Use this function to make the book flip to the previous page.
		 */
		 
		protected function turnPreviousPage():void {
			if(_pageIndex >= 0) {
				if(_pageIndex > 0) {
					var index:int = _pageIndex - 1;
					var page:OneSidedPage = pages[index];
					page.flipToward("front");
				} else gotoFrame("closed");
			}
			// increment the page number
			_pageIndex--;
		}
		
	}
	
}