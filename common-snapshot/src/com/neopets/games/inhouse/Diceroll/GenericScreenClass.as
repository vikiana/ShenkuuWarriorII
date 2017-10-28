package com.neopets.games.inhouse.Diceroll {
	// required for flash file and output display
	import com.neopets.games.inhouse.Diceroll.TranslationManagerInfo;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.text.TextField;
	
	import virtualworlds.lang.ITranslationManager;
	import virtualworlds.lang.TranslationData;
	import virtualworlds.lang.TranslationManager;	
		
	
	
	public class GenericScreenClass extends MovieClip {

		public const BUTTON_PRESSED:String = "MenuButtonPressed";
		
		public var tManager:ITranslationManager;
		public var tData:TranslationData;
		
		
		public function GenericScreenClass() {			
			super();						
		}
		
		
		protected function mouseClicked(evt:Event):void
		{			
			//trace("MOUSE CLICKED :: " + evt.currentTarget.name);
			stage.dispatchEvent(new  CustomEvent({TARGETID:evt.currentTarget.name},BUTTON_PRESSED));				
		}
		
		public function setTrans(p_man:ITranslationManager, p_dat: TranslationData):void {
			tManager = p_man;
			tData = p_dat;
		}
	
	
	
	
	
	
	
	}
}

