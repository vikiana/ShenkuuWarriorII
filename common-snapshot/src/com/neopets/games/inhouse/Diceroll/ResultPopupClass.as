package com.neopets.games.inhouse.Diceroll {
	// required for flash file and output display
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.*;
	import com.neopets.util.events.CustomEvent;
	import flash.text.TextField;
	
	
	
	public class ResultPopupClass extends GenericScreenClass {
		
		public var btn_toPrizePage: SimpleButton; //on stage
		
		public var txt_btn_toPrizePage: TextField; //on stage
		public var txt_rollResult: TextField; //on stage		
		
		public var dice1: MovieClip; //on stage
		public var dice2: MovieClip; //on stage
		
		var result_value: String = "";
		
		var str_result_var: String = "";
		var str_result_full: String = "";
		
		
		
		
		public function ResultPopupClass() {			
			super();						
		}
		
		public function init() {
			//trace("init ConfirmPopup");
			btn_toPrizePage.addEventListener(MouseEvent.CLICK, mouseClicked2,false,0,true);						
			tManager.setTextField(txt_btn_toPrizePage, tData.IDS_BTN_TO_PRIZE_PAGE);			
			txt_btn_toPrizePage.mouseEnabled = false;						
			tManager.setTextField(txt_rollResult, str_result_full);			
		}
		
		public function setResult(p_result: String = null) {
			var resultArray: Array = new Array("","wood","bronze","silver","gold","bonus","double");
			//trace("SET RESULT: " + p_result);
			result_value = p_result
			switch (resultArray[p_result]) {
				case "gold" : 
					str_result_var = tData.IDS_ROLL_RESULT_GOLD; 
					break;
				case "silver" : 
					str_result_var = tData.IDS_ROLL_RESULT_SILVER; 
					break;
				case "bronze" : 
					str_result_var = tData.IDS_ROLL_RESULT_BRONZE; 
					break;
				case "wood" : 
					str_result_var = tData.IDS_ROLL_RESULT_WOOD; 
					break;
				case "double" : 
					str_result_var = tData.IDS_ROLL_RESULT_DOUBLE; 
					break;
				case "bonus" : 
					str_result_var = tData.IDS_ROLL_RESULT_BONUS; 
					break;									
				default : 
					str_result_var = "ERROR"; 
					break;									
			}
			//trace("RESULT VAR = " + str_result_var);
			str_result_full = tData.IDS_ROLL_RESULT.replace("%1",str_result_var);
			tManager.setTextField(txt_roll_result, str_result_full);			
			dice1.gotoAndStop(resultArray[p_result]);			
			dice2.gotoAndStop(resultArray[p_result]);
		}
		
		protected function mouseClicked2(evt:Event):void
		{			
			//trace("MOUSE CLICKED :: " + evt.currentTarget.name);
			stage.dispatchEvent(new  CustomEvent({TARGETID:evt.currentTarget.name, VALUEID: result_value},BUTTON_PRESSED));				
		}
		
	
	
	
	
	}
}

