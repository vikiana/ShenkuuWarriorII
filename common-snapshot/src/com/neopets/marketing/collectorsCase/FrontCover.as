/* AS3
	Copyright 2008
*/
package com.neopets.marketing.collectorsCase
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.net.URLRequest;
	import flash.geom.Rectangle;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	/**
	 *	This class displays a single page of collector's case items.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  10.07.2009
	 */
	public class FrontCover extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _titleClip:MovieClip;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function FrontCover():void{
			titleClip = this["title_mc"];
			FlashVarManager.dispatcher.addEventListener(FlashVarManager.ON_INIT,onLangSet);
		}		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get titleClip():MovieClip { return _titleClip; }
		
		public function set titleClip(clip:MovieClip) {
			_titleClip = clip;
			if(_titleClip != null) {
				var lang:String = String(FlashVarManager.getVar("language"));
				_titleClip.gotoAndStop(lang);
			}
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @This function is called when the user presses a "next page" button.
		 */
		
		public function onLangSet(ev:Event) {
			if(_titleClip != null) {
				var lang:String = String(FlashVarManager.getVar("language"));
				_titleClip.gotoAndStop(lang);
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}