/**
 *	creates Instructions page
 *	There is only one button but idea is that when button(s) on this page clicked, it'll carry out actions
 *	if the actiosn is pertained within instructions page.  Otherwise, it'll dispatch an event and mMainGame
 *	will listen for it.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

	

package com.neopets.games.inhouse.brucyBSlots
{
	
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------

	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getDefinitionByName;
	
	import flash.text.TextField;
	import flash.text.TextFormat;

	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.users.abelee.resource.easyCall.QuickFunctions;
	
	public class InstructionsPage extends MovieClip {
		
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		public static const BACK_BUTTON:String = "back_button";
		
		private var mMainGame:Object;
		private var mClickedButton:String;	//keeps track of latest clicked button
		
		//----------------------------------------
		//constructor
		//----------------------------------------
		public function InstructionsPage(pMainGame:Object) {
			mMainGame = pMainGame;
			
			
		}		
		
		//----------------------------------------
		//Getters and setters
		//----------------------------------------
		public function get clickedButton():String
		{
			return mClickedButton;
		}
		

		//----------------------------------------
		//public fucntions
		//----------------------------------------
		
		public function init(pMainGame:Object):void
		{
			mMainGame = pMainGame;
			var back:String = mMainGame.system.getTranslation ("IDS_INSTRUCTIONS_BUTTON_BACK");
			var instTitle:String = mMainGame.system.getTranslation ("IDS_INSTRUCTIONS_TITLE");
			var instContent:String = mMainGame.system.getTranslation ("IDS_INSTRUCTIONS_CONTENT");
			createBackground();
			placeButton ("GenericButtonA", BACK_BUTTON, back, 185, 540);
			placeTextField("messageFont", instTitle, 100, 80, 380);
			trace ("place time new roman baby")
			//placeTextField("bodyFont", instContent, 100, 140, 440);
			
			placeTextField("messageFont", instContent, 100, 140, 440);
			
		}
		
		////
		// 	Most Generic function to place a button
		//	
		//	@PARAM		pBtnClass		Export class name from the asset library
		//	@PARAM		pName			Name of the button
		//	@PARAM		pText			Text that'll be shown on the button
		//	@PARAM		px				x position
		//	@PARAM		py				y position
		////
		public function placeButton (buttonClass:String, pName:String, pText:String, px:Number, py:Number):void
		{
			var btnClass:Class = mMainGame.assetInfo.getDefinition(buttonClass)
			//var btnClass:Class = getDefinitionByName(buttonClass) as Class
			var btn:MovieClip = new btnClass ();
			btn.x = px;
			btn.y = py;
			btn.name = pName;
			btn.buttonMode = true;
			btn.stop();
			btn.addEventListener(MouseEvent.CLICK,onBackButtonClicked);
			
			mMainGame.setText("messageFont", btn.btnTextField, pText)
			addChild(btn);
		}
		
		
		////
		// 	places text filed on the stage
		//	
		//	@PARAM		pFont		name of the font (what is added to the gaming system)
		//	@PARAM		pName		name of this text box
		//	@PARAM		pText		this should be html tagged text
		//	@PARAM		pWidth		The width of the text field
		////
		public function placeTextField (pfont:String, pText:String, px:Number, py:Number, pWidth:Number):void
		{
			var textBoxClass:Class = mMainGame.assetInfo.getDefinition("TextBox") as Class
			var textBox:MovieClip = new textBoxClass ()
			textBox.x = px;
			textBox.y = py;
			textBox.textField.width = pWidth;
			textBox.textField.autoSize = TextFieldAutoSize.LEFT;
			mMainGame.setText(pfont, textBox.textField, pText)
			addChild (textBox)
			//trace (textBox.width, textBox.height)
		}
		
		////
		// 	clean up this class/page
		////
		public function cleanup():void 
		{  
			var func:QuickFunctions = new QuickFunctions ()
			func.removeChildren(this)
			mMainGame = null;	
			mClickedButton = null;
		}	
		
		//----------------------------------------
		//Private functions
		//----------------------------------------
		
		////
		// 	create background (for now the name is hard coded) it's not pulled out in config xml
		////
		private function createBackground():void
		{
			var xml:XMLList = mMainGame.configXML.GAME
			if (xml.hasOwnProperty("instBackground"))
			{
				var bgClass:Class = mMainGame.assetInfo.getDefinition(xml.instBackground.@className);
				var bg:Sprite = new bgClass();
				bg.x = Number(xml.instBackground.@x);
				bg.y = Number(xml.instBackground.@y);
				addChild(bg)
			}
			else 
			{
				trace ("MISSING: instructions page background")
			}
		}
		
		
		//----------------------------------------
		//EVENT LISTENER
		//----------------------------------------
		
		////	
		// click event handler when back button is clicked
		////	
		private function onBackButtonClicked(event:MouseEvent):void
		{
			//var buttonName:String = event.currentTarget.name;
			mMainGame.playThisSound(mMainGame.soundBank.button, mMainGame.soundOn);
			mClickedButton = BACK_BUTTON;
			dispatchEvent(new Event ("updateInstructionsStatus"));
		}
		
		private function btnOverState(evt:MouseEvent):void
		{
			var btn:MovieClip = evt.target as MovieClip;
			btn.button.gotoAndStop("over");
		}
		
		private function btnOutState(evt:MouseEvent):void
		{
			var btn:MovieClip = evt.target as MovieClip;
			btn.button.gotoAndStop("out");
		}
		
	}
}
		