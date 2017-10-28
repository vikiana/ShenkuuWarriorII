/**
 *	This class provides listener and close button behaviour for simple pop ups.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.09.2010
 */

package com.neopets.games.marketing.destination.HOP2011.widgets.downloads
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	
	import virtualworlds.lang.TranslationManager;
	
	import com.neopets.util.general.GeneralFunctions;
	
	public class DownloadableLayout extends MovieClip
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		public var imageBacking:MovieClip;
		public var captionField:TextField;
		public var downloadField:TextField;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function DownloadableLayout():void {
			super();
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get caption():String {
			if(captionField == null) return null;
			return captionField.htmlText;
		}
		
		public function set caption(tag:String) {
			if(captionField != null) {
				var prev_height:Number = captionField.height; // store for possible adjustments
				captionField.htmlText = tag;
				captionField.height = captionField.textHeight + 4;
				// check if there's a download field to compensate for
				if(downloadField != null) {
					downloadField.y += captionField.height - prev_height;
				}
			}
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		public function initFrom(info:DownloadableData) {
			if(info == null) return;
			// load our image
			var image:DisplayObject = GeneralFunctions.getDisplayInstance(info.imageClass);
			if(image != null) {
				if(imageBacking != null) {
					image.x = imageBacking.x;
					image.y = imageBacking.y;
				}
				addChild(image);
			}
			// set up our download text
			if(downloadField != null) {
				var translator:TranslationManager = TranslationManager.instance;
				downloadField.htmlText = translator.getTranslationOf("IDS_DOWNLOAD");
			}
			// load caption
			caption = info.caption;
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