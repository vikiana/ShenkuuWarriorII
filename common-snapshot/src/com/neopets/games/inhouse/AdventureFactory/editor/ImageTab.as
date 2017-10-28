
/* AS3
	Copyright 2008
*/

package com.neopets.games.inhouse.AdventureFactory.editor
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	import com.neopets.util.general.GeneralFunctions;
	import com.neopets.util.display.DisplayUtils;
	
	import com.neopets.games.inhouse.AdventureFactory.game.GameWorld;
	import com.neopets.games.inhouse.AdventureFactory.editor.GameScreenTab;
	import com.neopets.games.inhouse.AdventureFactory.AdventureFactory_GameScreen;
	
	/**
	 *	This class handles tab selection that uses library images in place of labels.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author David Cary
	 *	@since  07.12.2010
	 */
	 
	public class ImageTab extends GameScreenTab
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		protected var _backingImage:DisplayObject;
		protected var _loadedImage:DisplayObject;
		protected var _imageID:String;
		public var autoScale:Boolean;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function ImageTab():void{
			super();
			autoScale = false;
			// check for backing layer
			_backingImage = getChildByName("bg_mc");
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get imageID():String { return _imageID; }
		
		public function set imageID(id:String) {
			if(_imageID == id) return;
			_imageID = id;
			// replace existing image
			var replacement:DisplayObject = GeneralFunctions.getDisplayInstance(_imageID);
			replaceImage(replacement);
		}
		
		public function get loadedImage():DisplayObject { return _loadedImage; }
		
		override public function get selectionData():Object { return _imageID; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Use this function to set up the button from a given data source.
		
		public function initFrom(info:Object) {
			if(info is XML) {
				imageID = info.@image;
			} else {
				imageID = String(info);
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		// Use this function to replace our loaded image.
		
		protected function replaceImage(replacement:DisplayObject):void {
			//if(_loadedImage == replacement) return;
			// clear previous image
			if(_loadedImage != null)  removeChild(_loadedImage);
			// set up new image
			_loadedImage = replacement;
			if(_loadedImage != null) {
				// place over backing if applicable
				if(_backingImage != null) {
					// add image to container if needed
					if(!contains(_loadedImage)) {
						var index:int = getChildIndex(_backingImage) + 1;
						addChildAt(_loadedImage,index);
					}
					_loadedImage.mask = _backingImage.mask;
					// scale down to fit backing area
					if(autoScale) {
						var x_ratio:Number = _backingImage.width / _loadedImage.width;
						var y_ratio:Number = _backingImage.height / _loadedImage.height;
						_loadedImage.scaleX = Math.min(x_ratio,y_ratio);
						_loadedImage.scaleY = _loadedImage.scaleX;
					}
					// get center image over backing
					var image_center:Point = DisplayUtils.getCenter(_loadedImage,this);
					var backing_center:Point = DisplayUtils.getCenter(_backingImage,this);
					_loadedImage.x += backing_center.x - image_center.x;
					_loadedImage.y += backing_center.y - image_center.y;
				} else {
					// add image to container if needed
					if(!contains(_loadedImage)) addChild(_loadedImage);
				}
			}
		}
		
	}
	
}
