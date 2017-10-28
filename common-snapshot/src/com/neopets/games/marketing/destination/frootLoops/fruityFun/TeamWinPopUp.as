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
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.neopets.games.marketing.destination.frootLoops.fruityFun.BasicPopUp;
	
	public class TeamWinPopUp extends BasicPopUp
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		public var textTemplate:String = "Congratulations to %1 for winning the challenge!";
		protected var _mainField:TextField;
		protected var _teamID:Number;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function TeamWinPopUp():void {
			super();
			// set up components
			mainField = getChildByName("main_txt") as TextField;
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get mainField():TextField { return _mainField; }
		
		public function set mainField(txt:TextField) {
			_mainField = txt;
			updateText();
		}
		
		public function get teamID():Number { return _teamID; }
		
		public function set teamID(val:Number) {
			_teamID = val;
			updateText();
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		public function updateText():void {
			if(_mainField == null) return; // abort if we have no textfield
			var team_name:String;
			// convert IDs to team names
			switch(_teamID) {
				case 1:
					team_name = "Team Toucan Sam";
					break;
				case 2:
					team_name = "Team Fruity Taste";
					break;
				default:
					team_name = "Team " + _teamID;
					break;
			}
			// load new text
			_mainField.htmlText = textTemplate.replace("%1",team_name);
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
		
	}
	
}