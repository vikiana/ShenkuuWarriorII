package com.neopets.projects.support.shell.loadingBar
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import com.neopets.projects.support.translation.TranslationListPreDone;
	
	
	/**
	 *	This is for a very simple ERROR Bar
	 *	Please use ASDocs if you can for your notes
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author Clive Henrick (Based on Code from Smerc)
	 *	@since  02.04.2009
	 */
	
	public class NeopetsLoadingBar extends MovieClip
	{
		
		public var bar:MovieClip;
		public var txt_Fld:TextField;
		public var paw:MovieClip;		
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function NeopetsLoadingBar()
		{
			txt_Fld.autoSize = TextFieldAutoSize.CENTER;
		}
		
		//--------------------------------------
		//  PUBLIC FUNCTIONS
		//--------------------------------------
		
		
		/**
		 * Offsets the ERROR bar for a ERROR animation.  
		 * Based on a ratio 0 - 1  :: 1 being 100%
		 * 
		 * @param	ratio a decimal number percentage
		 */
		public function adjustPosition(ratio:Number):void
		{
			this.bar.gotoAndStop(Math.round(ratio * 100));
			
			
		}//end adjustPosition()
		
		/**
		 * Sets the txt_Fld .
		 * 
		 * @param	str String HTML to set the text to.
		 */
		public function setText(str:String):void
		{
			txt_Fld.htmlText = str;	
		}
		
		/**
		 * Sets the Deafault Loading Message in the Text Field
		 * @param		pLang		String 		The Language Code
		 */
		 
		public function setDefaultLoading(pLang:String):void
		{
			pLang.toLocaleLowerCase();
			var tFinalString:String;
			
			switch (pLang)
			{
				case "ko":
					tFinalString = 	TranslationListPreDone.LOADING_KO;
				return;
				case "ch":
					tFinalString = 	TranslationListPreDone.LOADING_CH;
				return;
				case "zh":
					tFinalString = 	TranslationListPreDone.LOADING_ZH;
				return;
				case "nl":
					tFinalString = 	TranslationListPreDone.LOADING_NL;
				return;
				case "ja":
					tFinalString = 	TranslationListPreDone.LOADING_JA;
				return;
				case "it":
					tFinalString = 	TranslationListPreDone.LOADING_IT;
				return;
				case "es":
					tFinalString = 	TranslationListPreDone.LOADING_ES;
				return;
				case "de":
					tFinalString = 	TranslationListPreDone.LOADING_DE;
				return;
				case "fr":
					tFinalString = 	TranslationListPreDone.LOADING_FR;
				return;
				case "pt":
					tFinalString = 	TranslationListPreDone.LOADING_PT;
				return;
				default:
					tFinalString = 	TranslationListPreDone.LOADING_EN;
				return;	
			}
			
			setText(tFinalString);
		}
		
		/**
		 * Sets the Deafault Error in the Text Field
		 * @param		pLang		String 		The Language Code
		 */
		 
		public function setDefaultError(pLang:String):void
		{
			pLang.toLocaleLowerCase();
			var tFinalString:String;
			
			switch (pLang)
			{
				case "ko":
					tFinalString = 	TranslationListPreDone.ERROR_KO;
				return;
				case "ch":
					tFinalString = 	TranslationListPreDone.ERROR_CH;
				return;
				case "zh":
					tFinalString = 	TranslationListPreDone.ERROR_ZH;
				return;
				case "nl":
					tFinalString = 	TranslationListPreDone.ERROR_NL;
				return;
				case "ja":
					tFinalString = 	TranslationListPreDone.ERROR_JA;
				return;
				case "it":
					tFinalString = 	TranslationListPreDone.ERROR_IT;
				return;
				case "es":
					tFinalString = 	TranslationListPreDone.ERROR_ES;
				return;
				case "de":
					tFinalString = 	TranslationListPreDone.ERROR_DE;
				return;
				case "fr":
					tFinalString = 	TranslationListPreDone.ERROR_FR;
				return;
				case "pt":
					tFinalString = 	TranslationListPreDone.ERROR_PT;
				return;
				default:
					tFinalString = 	TranslationListPreDone.ERROR_EN;
				return;	
			}
			
			setText(tFinalString);
		}
		
		

	}
}