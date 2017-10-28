/**
 *	This class handles sponsor characters.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.09.2010
 */

package com.neopets.games.marketing.destination.capriSun.disrespectoids.widgets
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.util.BroadcasterClip;
	import com.neopets.projects.destination.destinationV3.AbsPage;
	
	public class CharacterClip extends BroadcasterClip
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		public static const CHARACTER_SELECTED:String = "character_selected";
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var _characterName:String;
		protected var _characterBio:String;
		protected var _characterNumber:int;
		protected var _portraitClass:String;
		protected var _bioMarker:MovieClip;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function CharacterClip():void {
			super();
			// set default bio info
			_characterName = name;
			_characterBio = String(this) + " is a Disrespectoid!";
			_portraitClass = getQualifiedClassName(this);
			// set up broadcasts
			useParentDispatcher(AbsPage);
			// check for speech point
			_bioMarker = getChildByName("bio_mc") as MovieClip;
			// set up mouse behaviour
			addEventListener(MouseEvent.CLICK,onClick);
			buttonMode = true;
			tabEnabled = false;
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get bioMarker():MovieClip { return _bioMarker; }
		
		public function get characterBio():String { return _characterBio; }
		
		public function get characterName():String { return _characterName; }
		
		public function get characterNumber():int { return _characterNumber; }
		
		public function get portraitClass():String { return _portraitClass; }
		
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
		
		// Relay click through shared dispatcher.
		
		protected function onClick(ev:MouseEvent) {
			broadcast(CHARACTER_SELECTED);
		}

	}
	
}