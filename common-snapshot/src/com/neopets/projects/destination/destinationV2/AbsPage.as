/**
 *	Most Basic Class.  All pages that'll be added onto stage should extend this (or its children) class
 *
 *	Basic rull of thumb, When you create a page, 
 *	
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

	

package com.neopets.projects.destination.destinationV2
{
	
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.users.abelee.utils.SupportFunctions;
	import com.neopets.util.events.CustomEvent;
	
	public class AbsPage extends Sprite {
		
		
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		protected var mView:Object
		
		//----------------------------------------
		//CONSTRUCTOR
		//----------------------------------------
		public function AbsPage(pName:String = null, pView:Object = null) 
		{
			if (pName != null) this.name = pName;
			if (pView != null)
			{
				trace ("ADD PAGE EVENT LISTENER")
				mView = pView
				mView.addEventListener(AbsView.OBJ_CLICKED, handleObjClick, false, 0, true);
			}
		}		
		
		//----------------------------------------
		//GETTERS AND SETTERS
		//----------------------------------------
		
		
		
		
		//----------------------------------------
		//PUBLIC METHODS 
		//----------------------------------------
		
		/**
		 *	OVERRIDE this function if necessary.
		 * otherwise, it simply removes all its children (this is called from DistinationControl Class)
		 **/
		public function cleanup():void 
		{  
			if (mView.hasEventListener(AbsView.OBJ_CLICKED))
			{
				mView.removeEventListener(AbsView.OBJ_CLICKED, handleObjClick);
			}
			SupportFunctions.removeAllChildren(this)
		}
		
		//----------------------------------------
		//PROTECTED METHODS
		//----------------------------------------
		
		
				
		/**
		 *	OVERRIDE this function. It practically serves as init.
		 *	but in case you want to have a separate init...
		 *	This functions should be in charge of setting up the page 
		 *	(adding background,btns, display objects, etc.)
		 **/
		protected function setupPage():void
		{
			
		}
		
		
		/**
		 *	Places a interactive display object with no dynamic text (icon, image btn, etc.)
		 *	For consistancy reasons, addImageButton should be called instead of placeImageButton
		 *	@NOTE This display object should have a MC or a sprite at the most top layer named (btnArea)
		 * 	which will serve as "hit area" in traditional button sense
		 **/
		protected function placeImageButton (buttonClass:String, pName:String, px:Number = 0, py:Number = 0, pAngle:Number = 0, pFrame:String = null):void
		{
			var btnClass:Class = getDefinitionByName(buttonClass) as Class
			var btn:MovieClip = new btnClass ();
			btn.x = px;
			btn.y = py;
			btn.rotation = pAngle
			btn.name = pName;
			btn.hasOwnProperty("btnArea")? btn.btnArea.buttonMode = true: trace ("Please create btnArea");
			if (pFrame != null) btn.gotoAndStop(pFrame);
			addChild(btn);
		}
		
		
		
		// for consistancy reasons, addImageButton should be called instead of placeImageButton
		protected function addImageButton (buttonClass:String, pName:String, px:Number = 0, py:Number = 0, pAngle:Number = 0, pFrame:String = null):void
		{
			placeImageButton (buttonClass, pName, px, py, pAngle, pFrame)
		}
		
		
		
		/**
		 *	Places a interactive display object with dynamic text 
		 *	(icon/button with a text ex "start" button)
		 *	for consistancy reasons, addTextButton should be called instead of placeTextButton
		 *
		 *	@NOTE:	A Dynamic TextField within this display object should be named "btnText" to show
		 *	dynamic text
		 *
		 *	@NOTE:	This display object should have a MC or a sprite at the most top layer named (btnArea)
		 * 	which will serve as "hit area" in traditional button sense
		 **/
		protected function placeTextButton (buttonClass:String, pName:String,pText:String, px:Number, py:Number, pAngle:Number = 0, pFrame:String = null):void
		{
			var btnClass:Class = getDefinitionByName(buttonClass) as Class
			var btn:MovieClip = new btnClass ();
			btn.x = px;
			btn.y = py;
			btn.rotation = pAngle
			btn.name = pName;
			btn.hasOwnProperty("btnArea")? btn.btnArea.buttonMode = true:trace ("Please create btnArea");
			btn.hasOwnProperty("btnText")? btn.btnText.text = pText:trace ("Create a TF named btnText");
			if (pFrame != null) btn.gotoAndStop(pFrame);
			addChild(btn);
		}
		
		
		
		// for consistancy reasons, addTextButton should be called instead of placeTextButton
		protected function addTextButton (buttonClass:String, pName:String,pText:String, px:Number, py:Number, pAngle:Number = 0, pFrame:String = null):void
		{
			placeTextButton (buttonClass, pName, pText, px, py, pAngle, pFrame)
		}
		
		
		
		//Override this should you need it
		protected function placeToggleButton ():void
		{
			//meant to be over written
		}
		
		
		/**
		 *	OBSOLETE 
		 *	Any class that calls this funciton should be replaced by "addImage" function
		 *	Places static display object as a background but use addImage function instead as that's more
		 *	accurate description of its function
		 **/
		protected function addBackground(imageClass:String, pName:String, px:Number, py:Number):void
		{
			var bgClass:Class = getDefinitionByName(imageClass) as Class
			var bg:MovieClip = new bgClass();
			bg.x = px;
			bg.y = py;
			bg.name = pName
			addChild(bg)
		}
		
		
		
		
		/**
		 *	Places static display object, be it background, foreground or a small objects
		 **/
		protected function addImage(pImageClass:String, pName:String, px:Number = 0, py:Number = 0):void
		{
			var imageClass:Class = getDefinitionByName(pImageClass) as Class;
			var image:MovieClip = new imageClass();
			image.x = px;
			image.y = py;
			image.name = pName
			addChild(image)
		}
		
		/**
		 *	Places static display object, with one text field called myText
		 *	Usually I use it for testing background changes		 
		 **/
		protected function addImageWithText(pImageClass:String, pName:String, pText:String, px:Number = 0, py:Number = 0):void
		{
			var imageClass:Class = getDefinitionByName(pImageClass) as Class
			var image:MovieClip = new imageClass();
			image.x = px;
			image.y = py;
			image.name = pName
			if (image.hasOwnProperty("myText"))image.myText.text = pText;
			addChild(image)
		}
		
		/**
		 *	Only here for samentic consistancy with calling button methods (though grammatically incorrect);
		 **/
		protected function addTextImage(pImageClass:String, pName:String, pText:String, px:Number = 0, py:Number = 0):void
		{
			addImageWithText(pImageClass, pName, pText, px, py)
		}
		
		
		/**
		 *	Adds a text box (assumes its a movie clip with a text field inside named myText
		 **/
		protected function addTextBox(pBoxClass:String, pName:String, pText:String = null, px:Number = 0, py:Number = 0, pBoxWidth:Number = 400, pBoxHeight:Number = 50 , pAutoSize:String = null):void
		{
			var boxClass:Class = getDefinitionByName(pBoxClass) as Class
			var box:MovieClip = new boxClass();
			box.x = px;
			box.y = py;
			box.name = pName
			if (box.hasOwnProperty("myText"))
			{
				box.myText.text = pText;
				box.myText.width = pBoxWidth;
				box.myText.height = pBoxHeight;
				box.myText.mouseWheelEnabled = false;
				if (pAutoSize != null)box.myText.autoSize = pAutoSize;
				
			}
			addChild(box)
		}
		
		/**
		 *	Adds a text field
		 **/
		
		protected function addTextField(pName:String, pText:String = null, px:Number = 0, py:Number = 0, pBoxWidth:Number = 400, pBoxHeight:Number = 50 , pAutoSize:String = null, pTextFormat:TextFormat = null):void
		{
			var textfield:TextField = new TextField ();
			textfield.wordWrap = true;
			textfield.x = px;
			textfield.y = py;
			textfield.name = pName;
			textfield.text = pText;
			textfield.width = pBoxWidth;
			textfield.height = pBoxHeight;
			textfield.multiline = true;
			textfield.embedFonts = true;
			textfield.mouseWheelEnabled = false
			if (pAutoSize != null)textfield.autoSize = pAutoSize;
			if (pTextFormat != null) textfield.setTextFormat(pTextFormat);
			
				
			addChild(textfield)
		}
		
		
		protected function handleObjClick(e:CustomEvent):void
		{
			trace ("    FROM ABS PAGE:", e.oData.DATA.parent.name, e.oData.DATA.parent)
			
			//e.oData.DATA.parent will return the button object
			//e.oData.DATA.parent.name will return the name of the object
			
			//example of handling the button click below:
			/*
			var objName:String = e.oData.DATA.parent.name;
			switch (objName)
			{
				case "Btn_VideoPage":
					cleanupPage()
					sendTrackerID(14364) 
					setupVideoPage()
					break;
				
				case "Btn_Game1":
					processClickURL(14258)
					mSixFlagsDatabase.game1++
					break;
				
				case "Btn_InfoPage":
					cleanupPage()
					sendTrackerID(14365) 
					setupInfoPage()
					break;
			}
			*/
		}
		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
		
				
		
		//----------------------------------------
		//EVENT LISTENER
		//----------------------------------------
	}
}
		