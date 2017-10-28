package com.neopets.games.marketing.destination.altadorbooths.common
{
	import com.neopets.util.button.NeopetsButton;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class CustomButton extends MovieClip
	{
		
		public var label_txt:TextField;
		public var label2_txt:TextField;
		public var label2_shad_txt:TextField;
		public var label_shad_txt:TextField;
		public var label_mouseEnabled:Boolean;
		public var mDefaultFormat:TextFormat;
		public var btnArea:Sprite;
		
		public function CustomButton()
		{
			super();
			mDefaultFormat = new TextFormat();
			label_mouseEnabled = false;
			buttonMode = true;
			label2_txt.visible = false;
			label2_shad_txt.visible = false;
		}
		
		public function setText(pString:String):void{
			if (label_txt != null)
			{
				label_txt.mouseEnabled = label_mouseEnabled;
				label_txt.x = int(label_txt.x);
				label_txt.y = int(label_txt.y);
				label_txt.htmlText = pString;
				label_txt.setTextFormat(mDefaultFormat);
			}
			if ( label_shad_txt != null)
			{
				label_shad_txt.mouseEnabled = label_mouseEnabled;
				label_shad_txt.x = int(label_shad_txt.x);
				label_shad_txt.y = int(label_shad_txt.y);
				label_shad_txt.htmlText = pString;
				label_shad_txt.setTextFormat(mDefaultFormat);
			}
		}
		
		public function setAddtlText (pString:String):void {
			label2_txt.visible = true;
			label2_shad_txt.visible = true;
			
			if ( label2_shad_txt != null)
			{
				label2_shad_txt.mouseEnabled = label_mouseEnabled;
				label2_shad_txt.x = int(label2_shad_txt.x);
				label2_shad_txt.y = int(label2_shad_txt.y);
				label2_shad_txt.htmlText = pString;
				label2_shad_txt.setTextFormat(mDefaultFormat);
			}
			if (label2_txt != null)
			{
				label2_txt.mouseEnabled = label_mouseEnabled;
				label2_txt.x = int(label2_txt.x);
				label2_txt.y = int(label2_txt.y);
				label2_txt.htmlText = pString;
				label2_txt.setTextFormat(mDefaultFormat);
			}
		
		}
	}
}