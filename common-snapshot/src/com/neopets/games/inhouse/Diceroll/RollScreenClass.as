package com.neopets.games.inhouse.Diceroll {
	// required for flash file and output display
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.*;
	import com.neopets.util.events.CustomEvent;
	
	
	
	public class RollScreenClass extends GenericScreenClass {
		
		public var btn_rollanim: SimpleButton; //on stage
		
		
		public function RollScreenClass() {			
			super();						
		}
		
		public function init() {
			btn_rollanim.addEventListener(MouseEvent.CLICK, mouseClicked,false,0,true);
		}
		
		
		
	
	
	
	
	}
}

