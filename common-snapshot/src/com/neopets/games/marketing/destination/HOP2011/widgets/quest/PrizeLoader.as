/**
 *	This class provides listener and close button behaviour for simple pop ups.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.09.2010
 */

package com.neopets.games.marketing.destination.HOP2011.widgets.quest
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.geom.Rectangle;
	
	import com.neopets.util.display.IconLoader;
	
	public class PrizeLoader extends IconLoader
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		// components
		public var imageBacking:MovieClip;
		public var captionField:TextField;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function PrizeLoader():void {
			super();
			// check image backing
			if(imageBacking != null) {
				_imgHeight = imageBacking.height;
				_imgWidth = imageBacking.width;
			}
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get caption():String {
			if(captionField != null) return captionField.htmlText;
			return null;
		}
		
		public function set caption(tag:String) {
			if(tag == null) tag = "";
			if(captionField != null) {
				captionField.htmlText = tag;
				captionField.height = captionField.textHeight + 4;
			}
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		// Use this function to set up a prize image from the provided php data.
		
		public function initFrom(info:Object) {
			if(info == null) return;
			// check for caption
			if("name" in info) caption = info.name;
			// check for image url
			if("url" in info) loadFrom(info.url);
		}
		
		// This function ensures the loader is properly scaled and positioned.
		
		override public function updateIcon():void {
			if(_loader != null) {
				// rescale image
				_loader.scaleX = Math.min(_imgHeight/_loader.height,_imgWidth/_loader.width);
				_loader.scaleY = _loader.scaleX;
				// center image
				if(imageBacking != null) {
					_loader.x = imageBacking.x;
					_loader.y = imageBacking.y;
				} else {
					var bbox:Rectangle = _loader.getBounds(this);
					_loader.x = -(bbox.left + (bbox.width/2));
					_loader.y = -(bbox.top + (bbox.height/2));
				}
			}
		}
		
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