/**
 *	This class handles sending getting and displaying trivia questions.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.09.2010
 */

package com.neopets.games.marketing.destination.frootLoops.fruityFun
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.neopets.util.display.BroadcasterClip;
	import com.neopets.util.events.BroadcastEvent;
	
	public class AnswerClip extends BroadcasterClip
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		public static const ANSWER_SELECTED:String = "AnswerClip_selected";
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var _selected:Boolean;
		// components
		protected var _answerField:TextField;
		// stored variables
		protected var _lineID:String;
		protected var _answerText:String;
		protected var _answerID:int;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function AnswerClip():void {
			super();
			// set up components
			_answerField = getChildByName("label_txt") as TextField;
			// set up mouse listeners
			buttonMode = true;
			addEventListener(MouseEvent.ROLL_OVER,onMouseOver);
			addEventListener(MouseEvent.ROLL_OUT,onMouseOut);
			addEventListener(MouseEvent.CLICK,onClick);
			// set up container listeners
			useParentDispatcher(MovieClip);
			addParentListener(MovieClip,ANSWER_SELECTED,onAnswerSelected);
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get answerID():int { return _answerID; }
		
		public function get answerText():String { return _answerText; }
		
		public function set answerText(str:String) {
			_answerText = str;
			updateLine();
		}
		
		public function get lineID():String { return _lineID; }
		
		public function set lineID(id:String) {
			_lineID = id;
			updateLine();
		}
		
		public function get selected():Boolean { return _selected; }
		
		public function set selected(bool:Boolean) {
			if(_selected != bool) {
				_selected = bool;
				if(_selected) {
					gotoAndPlay("selected");
					broadcast(ANSWER_SELECTED);
				} else gotoAndPlay("off");
			}
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		// Use this function to process trivia answer retrieved from php.
		
		public function showAnswer(answer:Object):void {
			if(answer == null) return; //  abort if there's no answer
			// store answer ID
			if("aid" in answer) _answerID = int(Number(answer.aid));
			// show answer text
			if("answer" in answer) answerText = String(answer.answer);
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		// Use this function to set up our textfield.
		
		protected function updateLine():void {
			if(_answerField != null) {
				var str:String;
				// start with line identifier
				if(_lineID != null && _lineID.length > 0) str = _lineID + ". " + _answerText;
				else str = _answerText;
				// add main text
				if(str != null) _answerField.htmlText = str;
				else _answerField.htmlText = "";
			}
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		protected function onAnswerSelected(ev:BroadcastEvent) {
			if(ev.sender != this) selected = false;
		}
		
		protected function onClick(ev:MouseEvent) {
			selected = true;
		}
		
		protected function onMouseOut(ev:MouseEvent) {
			if(_selected) gotoAndPlay("selected");
			else gotoAndPlay("off");
		}
		
		protected function onMouseOver(ev:MouseEvent) {
			gotoAndPlay("on");
		}

	}
	
}