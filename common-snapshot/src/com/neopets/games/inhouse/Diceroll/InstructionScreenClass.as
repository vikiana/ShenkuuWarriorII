package com.neopets.games.inhouse.Diceroll {
	// required for flash file and output display
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.*;
	import com.neopets.util.events.CustomEvent;
	import flash.text.TextField;
	
	
	
	public class InstructionScreenClass extends GenericScreenClass {
		
		public var btn_back: SimpleButton; //on stage
		
		public var txt_instruction_hdr: TextField;//on stage
		public var txt_instruction_txt: TextField;//on stage
		public var txt_btn_back: TextField;//on stage		
		
		
		public function InstructionScreenClass() {			
			super();						
		}
		
		public function init() {
			btn_back.addEventListener(MouseEvent.CLICK, mouseClicked,false,0,true);
			tManager.setTextField(txt_instruction_hdr, tData.IDS_INSTRUCTION_HEADER);			
			tManager.setTextField(txt_instruction_txt, tData.IDS_INSTRUCTION_TEXT);			
			tManager.setTextField(txt_btn_back, tData.IDS_BTN_BACK);			
			txt_btn_back.mouseEnabled = false;
		}
		
	
	
	
	
	}
}

