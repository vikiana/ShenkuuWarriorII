package com.neopets.games.inhouse.Diceroll {
	// required for flash file and output display
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.*;
	import com.neopets.util.events.CustomEvent;
	import flash.text.TextField;
		
	
	public class IntroScreenClass extends GenericScreenClass {
		
		public var btn_instructions: SimpleButton; //on stage
		public var btn_purchase: SimpleButton; //on stage
		public var btn_roll: SimpleButton; //on stage
		
		public var txt_btn_purchase: TextField; //on stage
		public var txt_btn_instructions: TextField; //on stage
		public var txt_dice_remaining: TextField; //on stage
		
		public var mcTransLogo:MovieClip; //on stage
		public var mcTransRoll:MovieClip; //on stage
		
		public var dData: Object;
		
		public function IntroScreenClass() {			
			super();						
			dData = DiceData.instance;
		}
		
		public function init() {
			///trace("btn_roll = " + btn_roll);
			mcTransLogo.gotoAndStop(dData.lang);
			mcTransRoll.gotoAndStop(dData.lang);
			btn_instructions.addEventListener(MouseEvent.CLICK, mouseClicked,false,0,true);
			btn_purchase.addEventListener(MouseEvent.CLICK, mouseClicked,false,0,true);			
			btn_roll.addEventListener(MouseEvent.CLICK, mouseClicked,false,0,true);
			mcTransRoll.mouseEnabled = false;
			mcTransRoll.dice1.mouseEnabled = false;			
			mcTransRoll.dice2.mouseEnabled = false;			
			mcTransRoll.rolltext.mouseEnabled = false;			
			mcTransRoll.rollbtn.mouseEnabled = false;
			//trace(" mouse disableds");
			
			
			//trace("tData.IDS_BTN_PURCHASE = " + tData.IDS_BTN_PURCHASE);
			
			tManager.setTextField(txt_btn_purchase, tData.IDS_BTN_PURCHASE);			
			tManager.setTextField(txt_btn_instructions, tData.IDS_BTN_INSTRUCTIONS);			
			txt_btn_instructions.mouseEnabled = false;
			txt_btn_purchase.mouseEnabled = false;
			var numDiceRemaining: Number = dData.diceRemaining;
			tManager.setTextField(txt_dice_remaining, tData.IDS_DICE_REMAINING + String(numDiceRemaining));			
		}
		
	
	
	
	
	}
}

