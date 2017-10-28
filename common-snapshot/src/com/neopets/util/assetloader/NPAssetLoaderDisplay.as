/* AS3
	Copyright 2010
*/

package com.neopets.util.assetloader {

	/**
	 *	Display out for the Asset Loader
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@Koh Peng Chuan
	 *	@since 7 October 2010
	*/	

	import com.neopets.projects.gameEngine.gui.MenuManager;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.text.TextField;

	
		/**
		 * @Note: Method description
		 * @param		var name			var type 		var description
		 * @return		var type				var description
		*/ 		
	 
		internal class NPAssetLoaderDisplay {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private const NPAL:NPAssetLoader = NPAssetLoader.instance;
		
		private var _root:MovieClip;
		
		private var _gwidth:int;
		private var _gheight:int;
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------

		public var bg:Sprite;
		
		public var partbar:Sprite;
		public var totalbar:Sprite;
		public var tf:TextField;
		
		//public var IDS_LOADING_OPEN:String = "<p align='center'><font face='_sans' size='10' color='#FFFFFF'>";
		//public var IDS_LOADING_CLOSE:String = "</font></p>";
		public var IDS_LOADING_RESOURCE:String = "<p align='center'><font face='_sans' size='10' color='#FFFFFF'>Loading Resource...</font></p>";
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function NPAssetLoaderDisplay(p_width:int, p_height:int, p_root:MovieClip):void {
			_root = p_root;
			_gwidth = p_width;
			_gheight = p_height;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function updateProgress(p_id:int = 0, p_total:int = 0, p_loaded:Number = 0):void {
			makeBg();
			if (p_total > 0) {
				if (p_loaded >= 1) {
					partbar.scaleX = 1;
					totalbar.scaleX = (p_id + 1) / p_total;
				} else {
					partbar.scaleX = p_loaded;
					totalbar.scaleX = p_id / p_total;
				}
			}
		}
		
		public function clearProgress():void {
			if (bg) {
				bg.addEventListener(Event.ENTER_FRAME, fadeOut);
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------

		private function fadeOut(e:Event):void {
			if (bg.alpha > 0) {
				bg.alpha -= 0.2;
			} else {
				bg.removeEventListener(Event.ENTER_FRAME, fadeOut);
				NPAL.reportDisplayAnimDone();
			}
		}

		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------		
		
		private function makeBg():void {
			if (!bg && _root) {
				bg = new Sprite();
				bg.addChild(drawRect(_gwidth, _gheight, 0x60000000));
				
				tf = new TextField();
				//tf.htmlText = IDS_LOADING_OPEN + IDS_LOADING_RESOURCE + "                                 " + IDS_LOADING_CLOSE;
				tf.htmlText = IDS_LOADING_RESOURCE;
				bg.addChild(tf);
				tf.x = (_gwidth / 2) - 100;
				tf.y = (_gheight / 2) - 30;
				
				partbar = new Sprite();
				partbar.addChild(drawRect(200, 5, 0x70FFFFFF));
				partbar.scaleX = 0;
				totalbar = new Sprite();
				totalbar.addChild(drawRect(200, 5, 0x70FFFFFF));
				totalbar.scaleX = 0;
				bg.addChild(partbar);
				bg.addChild(totalbar);
				
				partbar.x = (_gwidth / 2) - 100;
				partbar.y = (_gheight / 2) - 10;
				
				totalbar.x = (_gwidth / 2) - 100;
				totalbar.y = (_gheight / 2);
				
				var stop1:Bitmap = drawRect(1, 5, 0x80FFFFFF);
				var stop2:Bitmap = drawRect(1, 5, 0x80FFFFFF);
				bg.addChild(stop1);
				bg.addChild(stop2);
				stop1.x = partbar.x + 200;
				stop1.y = partbar.y;
				stop2.x = totalbar.x + 200;
				stop2.y = totalbar.y;
				var stop3:Bitmap = drawRect(1, 5, 0x80FFFFFF);
				var stop4:Bitmap = drawRect(1, 5, 0x80FFFFFF);
				bg.addChild(stop3);
				bg.addChild(stop4);
				stop3.x = partbar.x;
				stop3.y = partbar.y;
				stop4.x = totalbar.x;
				stop4.y = totalbar.y;
				
				_root.addChild(bg);
			}
		}
		
		private function drawRect(p_width:Number, p_height:Number, p_color:Number):Bitmap {
			return new Bitmap(new BitmapData(p_width, p_height, true, p_color));
		}
		
		/**
		 *	@Destructor
		 */
		public function destructor():void {
			if (bg) {
				if (bg.parent) bg.parent.removeChild(bg);
				for (var b:int = 0; b < bg.numChildren; b ++) {
					if (bg.getChildAt(b) is Bitmap) {
						Bitmap(bg.getChildAt(b)).bitmapData.dispose();
					}
				}
				bg = null;
			}
		}
	}
}

