// Each "cabinet" is a self contained pinball level.
// Author: David Cary
// Last Updated: April 2008

package com.neopets.games.inhouse.pinball
{
	
	import com.neopets.games.inhouse.pinball.objects.BallPit;
	import com.neopets.games.inhouse.pinball.objects.CabinetWalls;
	import com.neopets.games.inhouse.pinball.objects.LevelDisplay;
	import com.neopets.games.inhouse.pinball.objects.ScoreDisplay;
	import com.neopets.games.inhouse.pinball.objects.abstract.CabinetPart;
	import com.neopets.util.button.NeopetsButton;
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.general.GeneralFunctions;
	import com.neopets.util.support.PauseHandler;
	
	import com.neopets.games.inhouse.pinball.SoundIDs;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import org.cove.ape.*;
	
	public class PinballCabinet extends MovieClip {
		// Misc. Variables
		protected var _game:GameShell;
		protected var _initXML:XML;
		protected var walls:CabinetWalls;
		protected var pit:BallPit;
		
		// Component Variables
		protected var regParts:Array; // tracks all registered CabinetParts
		// Physics Values
		protected var gravity:Number;
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		public var scoreBox:ScoreDisplay; 		//Score Display Box on the Stage
		public var levelBox:LevelDisplay;		// Level Box on the Stage
		public var endGameButton:NeopetsButton; 	//End Game Button on Stage
		
		
		public function PinballCabinet() {
			// set default values
			regParts = new Array();
			gravity = 16;
			// look for the game shell when we're added to the stage
			addEventListener(Event.ADDED_TO_STAGE,findShell);
		}
		
		// Accessor functions
		
		public function get game():GameShell { return _game; }
		
		public function get parts():Array { return regParts; }
		
		public function get initXML():XML { return _initXML; }
		
		public function set initXML(xml:XML) {
			_initXML = xml;
			if(_initXML != null) {
				if("@gravity" in _initXML) gravity = Number(_initXML.@gravity);
			}
		}
		
		public function get boardNumber():int { return getIndexOfNode("board") + 1; }
		
		public function get levelNumber():int { return getIndexOfNode("level") + 1; }
		
		public function getIndexOfNode(ref:String):int {
			var xml:XML = _initXML;
			while(xml != null) {
				if(xml.localName() == ref) return xml.childIndex();
				xml = xml.parent();
			}
			return -1;
		}
		
		// Initialization Functions
		
	
		
		// This function handles the cabinet's initial set up once it's been added to the stage.
		protected function onAddedToGame():void {
			_game.updater.addEventListener(PauseHandler.UPDATE_EVENT,update); // listen for update cycles
			// add walls to keep ball on stage
			walls = new CabinetWalls();
			addChild(walls);
			// add a storage area for balls that fall off screen
			pit = new BallPit();
			addChild(pit);
			// try apply caching to minimize graphical slowdowns
			DisplayUtils.cacheImages(this);
			updateTextFields();
			
		}
		
		// Removal Functions
		
		// This function turns off all updates and removes all registry entries and APEngine
		// interactions.  This function should only be called right before removing the 
		// cabinet from the game, as there is currently no function for reactivating a cabinet.
		public function disable():void {
			// remove listeners
			if(_game != null) _game.updater.removeEventListener(PauseHandler.UPDATE_EVENT,update);
			// disable our parts
			var entry:CabinetPart
			for(var i:int = regParts.length - 1; i >= 0; i--) {
				entry = regParts[i];
				entry.disable();
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @Note: When the Quit Game Button is pressed
		 */
		 
		protected function quitGame (ev:Event):void
		{
			_game.controller.playSound(SoundIDs.BEEP_SHORT2);
			_game.gameOver(false);	
		}
		
		// Game Cycle Functions
		
		// Use this function to handle per frame actions.
		protected function update(ev:Event):void  {
			if(APEngine.container == this) {
				APEngine.step();
				APEngine.paint();
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/** 
		 * @NOTE: Updates the TextFields on the Stage with Correct Translations
		 */
		 
		protected function updateTextFields():void
		{
			_game.controller.setText( "PinballCabinetFont", scoreBox.score_txt, _game.controller.gamingSystem.getTranslation ("IDS_GAME_SCORE"));
			_game.controller.setText( "PinballCabinetFont", levelBox.level_txt, _game.controller.gamingSystem.getTranslation ("IDS_GAME_LEVEL_ID"));
			_game.controller.setText( "PinballCabinetFont", endGameButton.label_txt, _game.controller.gamingSystem.getTranslation ("IDS_GAME_BUTTON_CLOSE"));
		}
		
			// This function searches to see if this object has a GameShell ancestor.
		
		protected function findShell(ev:Event):void {
			if(ev.target == this) {
				var p:Object = parent as Object;
				while(p != null && p != stage) {
					if(p is GameShell) {
						_game = p as GameShell;
						onAddedToGame();
						break;
					} else p = p.parent; // keep searching
				}
				removeEventListener(Event.ADDED_TO_STAGE,findShell);
				
				endGameButton.addEventListener(MouseEvent.MOUSE_UP, quitGame, false,0, true);
			}
		}
		
		// Use this function to add gravitional acceleration to an APEngine particle.
		public function applyGravityTo(p:AbstractParticle,tvel:Number=100):void {
			if(p.velocity.y < tvel) {
				var force:VectorForce = new VectorForce(false,0,Math.min(gravity,tvel - p.velocity.y));
				p.addForce(force);
			}
		}
		
		// APEngine Functions
		
		// This function tries to add a new part to the cabinet's registry.
		public function registerPart(p:CabinetPart):void {
			if(p == null) return;
			// don't add the part if we already have it
			for(var i:int = 0; i < regParts.length; i++) {
				if(regParts[i] == p) return;
			}
			// let the new part set up it's collision reactions
			checkInteractionsFor(p);
			// add the new part's group to the APEngine
			if(p.group != null) {
				APEngine.addGroup(p.group);
			}
			// add the part to the registry
			regParts.push(p);
		}
		
		// This function lets all registered parts set up their interactions with the target part.
		public function checkInteractionsFor(p:CabinetPart):void {
			var p2:CabinetPart;
			for(var i:int = 0; i < regParts.length; i++) {
				p2 = regParts[i];
				if(p2 != p) {
					p.checkInteractionsFor(p2);
					p2.checkInteractionsFor(p);
				}
			}
		}
		
		// This function remove a part from the cabinet's registry.
		public function unregisterPart(p:CabinetPart):void {
			var entry:CabinetPart
			for(var i:int = regParts.length - 1; i >= 0; i--) {
				entry = regParts[i]
				if(entry == p) {
					if(p.group != null) APEngine.removeGroup(p.group);
					regParts.splice(i,1);
					break;
				}
			}
		}
		
		// Utility Functions
		
		// Use this function to create a copy a part which sub-classes a given class.
		// This function is mostly commonly used to create new pinballs.
		// "cls" is the class object of the base class, while "px" and "py" are the
		// coordinates for the newly created objects.
		public function createInstanceOf(cls:Class,px:Number,py:Number):Object {
			// see if we have any parts of the target class
			var src:Object;
			var entry:CabinetPart
			for(var i:int = regParts.length - 1; i >= 0; i--) {
				entry = regParts[i]
				if(entry is cls) src = entry;
			}
			// if we found the part, use it to create the new object
			if(src != null) {
				var dup:Object = GeneralFunctions.cloneObject(src);
				if(dup is MovieClip) {
					dup.x = px;
					dup.y = py;
					if(src is MovieClip && src.parent != null) {
						i = src.parent.getChildIndex(src);
						src.parent.addChild(dup);
						src.parent.setChildIndex(dup,i);
					}
				}
				return dup;
			} else return null;
		}
		
	}
	
}