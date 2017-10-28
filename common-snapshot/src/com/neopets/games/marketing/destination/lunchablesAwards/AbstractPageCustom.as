package com.neopets.games.marketing.destination.lunchablesAwards
{
	import com.neopets.games.inhouse.shootergame.utils.LibraryLoader_v2;
	import com.neopets.projects.destination.destinationV2.AbsPageWithBtnState;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class AbstractPageCustom extends AbsPageWithBtnState
	{
		
		

		
		
		public function AbstractPageCustom(pName:String=null, pView:Object=null)
		{
			super(pName, pView);
			addBackButton ();
			trace ("Creating "+this);
		}
		
		
		public function updateText(pMessage:String = null, pWidth:Number = 300):void
		{	
			var textBox:MovieClip = getChildByName("textBox") as MovieClip;
			textBox.myText.text = pMessage;
			textBox.visible = true;
			textBox.myText.width = pWidth;
			textBox.myText.autoSize = "left";
			textBox.myText.multiline = true;
			textBox.myText.mouseWheelEnabled = false;

		}
		
			public function updateOtherText(textMcName:String, pMessage:String = null, pWidth:Number = 300):void
		{	
			var textBox:MovieClip = getChildByName(textMcName) as MovieClip;
			textBox.myText.text = pMessage;
			textBox.visible = true;
			textBox.myText.width = pWidth;
			textBox.myText.autoSize = "left";
			textBox.myText.multiline = true;
			textBox.myText.mouseWheelEnabled = false;

		}
		
		
		
		protected override  function addImage(pImageClass:String, pName:String, px:Number = 0, py:Number = 0):void
		{
			var imageClass:Class = getClass(pImageClass);
			var image:MovieClip = new imageClass();
			image.x = px;
			image.y = py;
			image.name = pName;
			addChild(image);
		}
		
		//overriding this only becouse of the different system that loads the library
		protected override function placeImageButton (buttonClass:String, pName:String, px:Number = 0, py:Number = 0, pAngle:Number = 0, pFrame:String = null):void
		{
			var btnClass:Class = getClass(buttonClass);
			var btn:MovieClip = new btnClass ();
			btn.x = px;
			btn.y = py;
			btn.rotation = pAngle
			btn.name = pName;
			btn.hasOwnProperty("btnArea")? btn.btnArea.buttonMode = true: trace ("Please create btnArea");
			if (pFrame != null) btn.gotoAndStop(pFrame);
			addChild(btn);
		}
		
		
		
		protected override function placeTextButton (buttonClass:String, pName:String,pText:String, px:Number, py:Number, pAngle:Number = 0, pFrame:String = null):void
		{
			var btnClass:Class = getClass(buttonClass);
			var btn:MovieClip = new btnClass ();
			btn.x = px;
			btn.y = py;
			btn.rotation = pAngle;
			btn.name = pName;
			btn.hasOwnProperty("btnArea")? btn.btnArea.buttonMode = true:trace ("Please create btnArea");
			btn.hasOwnProperty("btnText")? btn.btnText.text = pText:trace ("Create a TF named btnText");
			if (pFrame != null) btn.gotoAndStop(pFrame);
			addChild(btn);
		}
		
		override protected function addTextBox(pBoxClass:String, pName:String, pText:String = null, px:Number = 0, py:Number = 0, pBoxWidth:Number = 400, pBoxHeight:Number = 50 , pAutoSize:String = null):void
		{
			var boxClass:Class = getClass(pBoxClass);
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
		
		
		protected function getClass (className:String):Class {
			var cl:Class = LibraryLoader_v2.getLibrarySymbol(className);
			return cl;
		}
		
		/**
		  *	In this project, the glow is set on the timeline
		  *
		  *	@NOTE: This display Object must have MC within itself named "btnArea" at the top layer
		  * @NOTE: If the display Object has a "over" state (as frame lable) it'll stop at that state
		  **/
		protected override function handleMouseOver(evt:MouseEvent):void
		{
			if (evt.target.name == "btnArea")
			{
				trace ("here");
				var mc:MovieClip = evt.target as MovieClip
				if (!mc.buttonMode) mc.buttonMode = true;
				MovieClip(mc.parent).gotoAndStop("over")
				//trace (mc.parent+" mouse over");
				//MovieClip(mc.parent).filters = [new GlowFilter(0xFFFFFF, 1, 16, 16, 2, 3)]
			}
		}
		
		protected function addBackButton():void {
			addImageButton("Back_button", "backToMain", 27, 481);
		}
		
	}
}