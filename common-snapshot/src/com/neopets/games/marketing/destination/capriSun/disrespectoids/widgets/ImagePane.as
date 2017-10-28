/**
 *	This class handles adding display object into a nested content area.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  01.06.2010
 */

package com.neopets.games.marketing.destination.capriSun.disrespectoids.widgets
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class ImagePane extends MovieClip
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var _contentArea:MovieClip;
		protected var _loadIndicator:MovieClip;
		protected var _content:DisplayObject;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function ImagePane():void {
			contentArea = getChildByName("content_area_mc") as MovieClip;
			loadIndicator = getChildByName("loading_mc") as MovieClip;
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get content():DisplayObject { return _content; }
		
		public function set content(dobj:DisplayObject) {
			if(dobj != null && dobj.parent != null) return; // abort if object is already on stage
			if(dobj == _content) return; // abort if we're already using that content
			// remove previous content
			if(_content != null) {
				removeChild(_content);
			}
			_content = dobj;
			// add content to stage
			if(_content != null) {
				// check for a content area
				var area_bounds:Rectangle;
				if(_contentArea != null) {
					var index:int = getChildIndex(_contentArea);
					addChildAt(_content,index + 1); // add on top of content area
					area_bounds = _contentArea.getBounds(this);
					// if image is too larger, scale to content area
					var x_ratio:Number = area_bounds.width / _content.width;
					var y_ratio:Number = area_bounds.height / _content.height;
					var min_ratio:Number = Math.min(x_ratio,y_ratio);
					if(min_ratio < 1) {
						_content.scaleX = min_ratio;
						_content.scaleY = min_ratio;
					}
				} else {
					addChild(_content);
					area_bounds = getBounds(this);
				}
				// center content over area
				var content_bounds:Rectangle = _content.getBounds(this);
				// horizontally center
				var mid_area:Number = (area_bounds.left + area_bounds.right) / 2;
				var mid_content:Number = (content_bounds.left + content_bounds.right) / 2;
				_content.x += mid_area - mid_content;
				// vertically center
				mid_area = (area_bounds.top + area_bounds.bottom) / 2;
				mid_content = (content_bounds.top + content_bounds.bottom) / 2;
				_content.y += mid_area - mid_content;
			}
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get contentArea():MovieClip { return _contentArea; }
		
		public function set contentArea(clip:MovieClip) {
			_contentArea = clip;
		}
		
		public function get loadIndicator():MovieClip { return _loadIndicator; }
		
		public function set loadIndicator(clip:MovieClip) {
			_loadIndicator = clip;
			if(_loadIndicator != null) _loadIndicator.visible = false;
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
	}
	
}