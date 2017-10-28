/**
 *	This class handles the text and images for a character bio popup.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.09.2010
 */

package com.neopets.games.marketing.destination.despicableMe.widgets
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.geom.Rectangle;
	
	import com.neopets.games.marketing.destination.despicableMe.widgets.CharacterClip;
	import com.neopets.util.general.GeneralFunctions;
	
	public class CharacterBioPane extends MovieClip
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var _nameField:TextField;
		protected var _bioField:TextField;
		protected var _portrait:DisplayObject;
		protected var _portraitArea:MovieClip;
		protected var _closeButton:SimpleButton;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function CharacterBioPane():void {
			super();
			_nameField = getChildByName("name_txt") as TextField;
			_bioField = getChildByName("bio_text") as TextField;
			_portraitArea = getChildByName("portrait_area_mc") as MovieClip;
			closeButton = getChildByName("close_btn") as SimpleButton;
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get closeButton():SimpleButton { return _closeButton; }
		
		public function set closeButton(btn:SimpleButton) {
			// clear listeners
			if(_closeButton != null) {
				_closeButton.removeEventListener(MouseEvent.CLICK,onCloseRequest);
			}
			// set button
			_closeButton = btn;
			// set listeners
			if(_closeButton != null) {
				_closeButton.addEventListener(MouseEvent.CLICK,onCloseRequest);
			}
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		// Use this function to load a new character bio.
		
		public function loadCharacter(char:CharacterClip):void {
			if(char == null) return;
			if(_nameField != null) _nameField.htmlText = char.characterName;
			if(_bioField != null) _bioField.htmlText = char.characterBio;
			loadPortrait(char.portraitClass);
		}
		
		// Use this function to load a new character image.
		
		public function loadPortrait(class_name:String) {
			// clear previous portrait
			if(_portrait != null) {
				removeChild(_portrait);
			}
			// add new portrait
			_portrait = GeneralFunctions.getDisplayInstance(class_name);
			if(_portrait != null) {
				// add new portrait to stage
				addChild(_portrait);
				// prevent click reaction on portrait
				if(_portrait is InteractiveObject) InteractiveObject(_portrait).mouseEnabled = false;
				// check if target area is set up
				if(_portraitArea != null) {
					// scale to portrait area
					var scaling:Number = Math.min(_portraitArea.width/_portrait.width,_portraitArea.height/_portrait.height);
					_portrait.scaleX = scaling;
					_portrait.scaleY = scaling;
					// center in portrait area
					var p_bounds:Rectangle = _portrait.getBounds(this);
					var a_bounds:Rectangle = _portraitArea.getBounds(this);
					// horizontally center
					var p_mid:Number = (p_bounds.left + p_bounds.right) / 2;
					var a_mid:Number = (a_bounds.left + a_bounds.right) / 2;
					_portrait.x += a_mid - p_mid;
					// vertically center
					p_mid = (p_bounds.top + p_bounds.bottom) / 2;
					a_mid= (a_bounds.top + a_bounds.bottom) / 2;
					_portrait.y += a_mid - p_mid;
				} // end of applying area constraints
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
		
		// This function dispatches a close event when the close button is clicked.
		
		public function onCloseRequest(ev:MouseEvent) {
			dispatchEvent(new Event(Event.CLOSE));
		}

	}
	
}