/**
 *	This class lets a movieclip mimic the mouse-over behaviour of a button.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  01.04.2010
 */

package com.neopets.games.marketing.destination.kidCuisine2.widgets
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	
	public class PetDisplay extends MovieClip
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		// constants
		public static var MAX_SLOTS:int = 10;
		// protected variables
		protected var _petSlots:Array;
		protected var _petData:Array;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function PetDisplay():void {
			setSlots("slot_#_mc",1);
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get petData():Array { return _petData; }
		
		public function set petData(info:Array) {
			_petData = info;
			// fill the slots with pet images
			loadSlots();
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		/**	
		 *	Initializes the slot list.
		 *	@PARAM		pattern			Naming convention for slots.
		 *	@PARAM		first_index		Number used by first slot.
		 **/
		
		public function setSlots(pattern:String,first_index:Number=1) {
			// clear previous slots
			if(_petSlots != null) {
				while(_petSlots.length > 0) _petSlots.pop();
			} else _petSlots = new Array();
			// find slot clips
			var index:int;
			var tag:String;
			var child:MovieClip;
			for(var i:int = 0; i < MAX_SLOTS; i++) {
				index = first_index + i;
				tag = pattern.replace("#",String(index));
				child = getChildByName(tag) as MovieClip;
				if(child != null) _petSlots.push(child);
			}
			// fill the slots with pet images
			loadSlots();
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		/**	
		 *	Loads all pet data into the corresponding slot.
		 **/
		
		public function loadSlots() {
			if(_petSlots == null || _petData == null) return;
			// cycle through all data
			var slot:MovieClip;
			for(var i:int = 0; i < _petData.length; i++) {
				if(i < _petSlots.length) {
					slot = _petSlots[i];
					slot.petData = _petData[i];
				} else break;
			}
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
	}
	
}