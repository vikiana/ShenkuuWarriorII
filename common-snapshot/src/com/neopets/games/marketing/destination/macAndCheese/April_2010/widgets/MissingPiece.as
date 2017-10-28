/* AS3
	Copyright 2009
*/
package com.neopets.games.marketing.destination.macAndCheese.April_2010.widgets
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	
	import com.neopets.games.marketing.destination.macAndCheese.April_2010.LandingPage;
	import com.neopets.games.marketing.destination.macAndCheese.April_2010.LandingPageTranslation;
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.util.events.CustomEvent;
	
	/**
	 *	This class handles scavenger hunt items.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  3.24.2009
	 */
	public class MissingPiece extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const UNKNOWN_STATE:int = 0;
		public static const UNRELEASED_STATE:int = 1;
		public static const RELEASED_STATE:int = 2;
		public static const FOUND_STATE:int = 3;
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _partNumber:int;
		protected var _releaseState:int;
		protected var _hintText:String;
		protected var _landingPage:LandingPage;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function MissingPiece():void {
			super();
			releaseState = UNKNOWN_STATE;
			// set up listeners
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
			addEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
			addEventListener(MouseEvent.CLICK,onClick);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get landingPage():LandingPage { return _landingPage; }
		
		public function set landingPage(page:LandingPage) {
			// remove listeners
			if(_landingPage != null) {
				_landingPage.removeEventListener(LandingPage.HUNT_STATUS_RESULT,onHuntResult);
			}
			// set up listeners
			_landingPage = page;
			if(_landingPage != null) {
				_landingPage.addEventListener(LandingPage.HUNT_STATUS_RESULT,onHuntResult);
			}
		}
		
		public function get partNumber():int { return _partNumber; }
		
		public function set partNumber(val:int) {
			_partNumber = val;
		}
		
		public function get releaseState():int { return _releaseState; }
		
		public function set releaseState(val:int) {
			_releaseState = val;
			// set color transformation based on state
			var tint:ColorTransform;
			var c_multi:Number;
			var c_offset:Number;
			switch(_releaseState) {
				case UNKNOWN_STATE:
					tint = new ColorTransform(1,1,1,0.1,0,0,0,0);
					buttonMode = false;
					break;
				case UNRELEASED_STATE:
					c_multi = 0.5;
					c_offset = 100;
					tint = new ColorTransform(c_multi,c_multi,c_multi,0.8,c_offset,c_offset,c_offset,0);
					buttonMode = false;
					break;
				case RELEASED_STATE:
					c_multi = 4;
					c_offset = 0;
					tint = new ColorTransform(c_multi,c_multi,c_multi,1,c_offset,c_offset,c_offset,0);
					buttonMode = true;
					break;
				case FOUND_STATE:
					tint = new ColorTransform(1,1,1,1,0,0,0,0);
					buttonMode = true;
					break;
			}
			transform.colorTransform = tint;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		// Use this function to find the landing page when we're added to the stage.
		
		protected function onAdded(ev:Event) {
			if(ev.target == this) {
				landingPage = DisplayUtils.getAncestorInstance(this,LandingPage) as LandingPage;
				removeEventListener(Event.ADDED_TO_STAGE,onAdded);
			}
		}
		
		// This function triggers when the piece is clicked on.
		
		protected function onClick(ev:MouseEvent) {
			switch(_releaseState) {
				case RELEASED_STATE:
					if(_landingPage != null) {
						var trans:LandingPageTranslation = _landingPage.translationData;
						_landingPage.setPopUpText(trans.hintHeader,_hintText);
					}
					break;
			}
		}
		
		// This function process hunt status info for this piece.
		
		protected function onHuntResult(ev:CustomEvent) {
			var result:Object = ev.oData;
			var pieces:Object = result["pieces"];
			if(pieces != null) {
				// search for a reference to this piece
				var match:Object;
				var entry:Object;
				for(var i in pieces) {
					entry = pieces[i];
					if(entry != null && entry["id"] == _partNumber) {
						match = entry;
						break;
					}
				}
				// if we have a match, extract data from it.
				if(match != null) {
					// get release state
					var state_num:int = int(match["status"]);
					if(!isNaN(state_num)) releaseState = state_num;
					// get hint string
					_hintText = match["hint"];
				}
			}
		}
		
		// Clear listeners when we go off stage.
		
		protected function onRemoved(ev:Event) {
			if(ev.target == this) {
				landingPage = null;
				removeEventListener(Event.ADDED_TO_STAGE,onAdded);
				removeEventListener(Event.ADDED_TO_STAGE,onRemoved);
			}
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
