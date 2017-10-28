/* AS3
	Copyright 2008
*/
package com.neopets.marketing.collectorsCase
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	
	/**
	 *	This class displays the info for a single collector's case item.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  10.07.2009
	 */
	public class TabBar extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const SCROLL_TIME:Number = 1;
		public static const TABS_LOADED:String = "tabs_loaded";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _target:MovieClip;
		protected var tabContainer:MovieClip;
		protected var _tabMask:MovieClip;
		protected var _numTabsVisible:int;
		protected var maxTabsVisible:int;
		protected var tabSpacing:Number;
		protected var currentTab:MovieClip;
		protected var _nextButton:InteractiveObject;
		protected var _previousButton:InteractiveObject;
		protected var minTabIndex:int;
		protected var tabTween:Tween;
		protected var loadingIndex:int;
		protected var _loadList:LoaderQueue;
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function TabBar():void{
			// add our tab container
			tabContainer = new MovieClip();
			addChild(tabContainer);
			// set default spacing values
			_numTabsVisible = 1;
			maxTabsVisible = 3;
			tabSpacing = 100;
			minTabIndex = 0;
			// check for a mask layer
			tabMask = this["mask_mc"];
			// set up buttons
			previousButton = this["prev_btn"];
			nextButton = this["next_btn"];
		}		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get loadList():LoaderQueue { return _loadList; }
		
		public function set loadList(list:LoaderQueue) {
			_loadList = list;
			// update our children's load lists
			var tab:MovieClip;
			for(var i:int = 0; i < tabContainer.numChildren; i++) {
				tab = tabContainer.getChildAt(i) as MovieClip;
				if("loadList" in tab) tab.loadList = _loadList;
			}
		}
		
		public function get numTabsVisible():int { return _numTabsVisible; }
		
		public function set numTabsVisible(val:int) {
			// make sure we didn't exceed our cap
			if(val >= maxTabsVisible) {
				_numTabsVisible = maxTabsVisible;
				// set button visibility
				if(_previousButton != null) _previousButton.visible = true;
				if(_nextButton != null) _nextButton.visible = true;
			} else {
				_numTabsVisible = val;
				// set button visibility
				if(_previousButton != null) _previousButton.visible = false;
				if(_nextButton != null) _nextButton.visible = false;
			}
			// calculate spacing
			if(_tabMask != null) tabSpacing = _tabMask.width / _numTabsVisible;
			else tabSpacing = width / _numTabsVisible;
		}
		
		public function get nextButton():InteractiveObject { return _nextButton; }
		
		public function set nextButton(btn:InteractiveObject) {
			// clear previous button
			if(_nextButton != null) _nextButton.removeEventListener(MouseEvent.CLICK,onNextTab);
			// set up the new button
			_nextButton = btn;
			if(_nextButton != null) {
				_nextButton.visible = (_numTabsVisible >= maxTabsVisible);
				_nextButton.addEventListener(MouseEvent.CLICK,onNextTab);
			}
		}
		
		public function get previousButton():InteractiveObject { return _previousButton; }
		
		public function set previousButton(btn:InteractiveObject) {
			// clear previous button
			if(previousButton != null) _previousButton.removeEventListener(MouseEvent.CLICK,onPreviousTab);
			// set up the new button
			_previousButton = btn;
			if(_previousButton != null) {
				_previousButton.visible = (_numTabsVisible >= maxTabsVisible);
				_previousButton.addEventListener(MouseEvent.CLICK,onPreviousTab);
			}
		}
		
		public function get tabMask():MovieClip { return _tabMask; }
		
		public function set tabMask(clip:MovieClip) {
			_tabMask = clip;
			tabContainer.mask = _tabMask;
			if(_tabMask != null) {
				tabSpacing = _tabMask.width / _numTabsVisible;
				var bbox:Rectangle = _tabMask.getBounds(this);
				tabContainer.y = (bbox.top + bbox.bottom) / 2;
				tabContainer.x = _tabMask.x;
			} else tabSpacing = width / _numTabsVisible;
		}
		
		public function get target():MovieClip { return _target; }
		
		public function set target(inst:MovieClip) {
			if(_target != inst) {
				// clear previous target
				if(_target != null) {
					_target.removeEventListener(ItemAlbum.ON_DATA_LOADED,onTargetLoad);
				}
				// set up new target
				_target = inst;
				if(_target != null) {
					loadTargetTabs();
					_target.addEventListener(ItemAlbum.ON_DATA_LOADED,onTargetLoad);
				}
			}
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @This function removes all selection buttons from the tab bar.
		 */
		 
		public function clearTabs():void {
			var tab:DisplayObject;
			while(tabContainer.numChildren > 0) {
				tab = tabContainer.getChildAt(0);
				tab.removeEventListener(MouseEvent.CLICK,onMouseClick);
				tabContainer.removeChild(tab);
			}
		}
		
		/**
		 * @This function adds a new selection button to the tab bar.
		 * @param		info		Object 		Data to be loaded
		 */
		 
		public function addTab(info:Object):void {
			var tab:MovieClip = new CollectionTabMC();
			tab.loadList = loadList;
			tab.loadCollection(info);
			tab.x = tabSpacing * (tabContainer.numChildren + .5);
			tab.addEventListener(MouseEvent.CLICK,onMouseClick);
			tabContainer.addChild(tab);
		}
		
		/**
		 * @This function starts tab loading based on our target's collection data.
		 */
		 
		public function loadTargetTabs():void {
			// clear previous tabs
			clearTabs();
			// load new tabs
			if(_target != null) {
				var info:Object = _target.albumData;
				if(info != null) {
					var list:Array = info.collections;
					if(list != null) {
						numTabsVisible = list.length;
						for(var i:int = 0; i < list.length; i++) {
							addTab(list[i]);
						}
					} // end of collection test
				} // end of info test
			} // end of target test
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @This function refreshes our tab list when our target loads new data.
		 */
		 
		public function onTargetLoad(ev:Event):void {
			loadTargetTabs();
		}
		
		/**
		 * @When a tab is clicked, go it's collection page.
		 */
		
		public function onMouseClick(ev:MouseEvent) {
			// turn off current tab
			if(currentTab != null) currentTab.highlight = false;
			// turn on new tab
			currentTab = ev.currentTarget as MovieClip;
			if(currentTab != null) {
				currentTab.highlight = true;
				if(_target != null) {
					_target.gotoCollection(currentTab.collectionData);
				}
			}
		}
		
		/**
		 * @Use this function to move to bring the next tab on screen.
		 */
		 
		public function onNextTab(ev:Event=null):void {
			// check if can move any further forward
			if(minTabIndex + _numTabsVisible < tabContainer.numChildren) {
				// stop previous tween
				if(tabTween != null) {
					tabTween.stop();
					tabTween = null;
				}
				// start the new tween
				var next_index:Number = minTabIndex + 1;
				var next_x:Number = -tabSpacing * next_index;
				if(tabContainer.mask != null) next_x += tabContainer.mask.x;
				tabTween = new Tween(tabContainer,"x",Regular.easeInOut,tabContainer.x,next_x,SCROLL_TIME,true);
				// update our tab index
				minTabIndex = next_index;
			}
		}
		
		/**
		 * @Use this function to move to bring the previous tab on screen.
		 */
		 
		public function onPreviousTab(ev:Event=null):void {
			// check if can move any further back
			if(minTabIndex > 0) {
				// stop previous tween
				if(tabTween != null) {
					tabTween.stop();
					tabTween = null;
				}
				// start the new tween
				var next_index:Number = minTabIndex - 1;
				var next_x:Number = -tabSpacing * next_index;
				if(tabContainer.mask != null) next_x += tabContainer.mask.x;
				tabTween = new Tween(tabContainer,"x",Regular.easeInOut,tabContainer.x,next_x,SCROLL_TIME,true);
				// update our tab index
				minTabIndex = next_index;
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}