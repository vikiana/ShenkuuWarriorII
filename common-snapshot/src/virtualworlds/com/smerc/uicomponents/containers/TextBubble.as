package virtualworlds.com.smerc.uicomponents.containers
{	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.getQualifiedClassName;
	
	import org.spicefactory.lib.logging.LogContext;
	import org.spicefactory.lib.logging.Logger;
	
	import virtualworlds.com.smerc.utils.disp.DisplayObjectUtils;
	
	/**
	* Handles TextFormat.  Basically calls DisplayObjectUtils.setTextFieldWithinHeight
	* after saving the original TextFormat.
	* 
	* @author Bo
	*/
	public class TextBubble extends Sprite
	{
		protected static const log:Logger = LogContext.getLogger(TextBubble);
		/**
		 * The Sprite that contains all the pieces that a TextBubble needs (and extracts from).
		 */
		protected var _contentMC:Sprite;
		
		/**
		 * The TextField that is used for setting the main bubble text.
		 */
		protected var _bubbleTxt:TextField;
		
		/**
		 * The original textField's TextHeight, used for re-setting the text size upon reuse of the TextField.
		 */
		protected var _originalTextHeight:Number = NaN;
		
		/**
		 * The original TextFormat of the _bubbleTxt for re-setting the text size upon reuse of the TextField.
		 */
		protected var _originalTextFormat:TextFormat;
		
		/**
		 * 
		 * @param	a_txtBubbleImg:	Sprite object of which we extract a TextField with the name 'bubbleText_txt'.
		 * 
		 * @param	a_bAddContents:	Boolean 'true' if you wish to add the parameterized contents a_txtBubbleImg to this TextBubble.
		 * 							Note, its x,y and scale will *not* be altered, so this is best used for new Instances of a_txtBubbleImg,
		 * 							or clearing the x,y of a_txtBubbleImg before constructing this TextBubble.
		 */
		public function TextBubble(a_txtBubbleImg:Sprite, a_bAddContents:Boolean = true, a_txtFldName:String = "bubbleText_txt")
		{
			_contentMC = a_txtBubbleImg;
			
			if (!a_txtBubbleImg)
			{
				log.warn("TextBubble::TextBubble(): a_txtBubbleImg=" + a_txtBubbleImg + ", returning.");
				return;
			}
			
			if (a_bAddContents)
			{
				this.addChild(_contentMC);
			}
			
			this.extractParts(a_txtFldName);
			
		}//end TextBubble() constructor.
		
		/**
		 * This extracts the necessary parts.  In this case, a TextField with name 'bubbleText_txt".
		 * Note: the TextField has its multiline property set to 'true' and its type set to TextFieldType.DYNAMIC.
		 * 
		 * @return	An Array representation of the descendants of _contentMC
		 */
		protected function extractParts(a_txtFldName:String = null):Array
		{
			if (!a_txtFldName)
			{
				a_txtFldName = "bubbleText_txt";
			}
			
			var contentMcDescendants:Array = DisplayObjectUtils.getDescendantsOf(_contentMC);
			
			var firstTxtField:TextField;
			
			for (var i:int = 0; i < contentMcDescendants.length; i++)
			{
				if (!firstTxtField)
				{
					firstTxtField = contentMcDescendants[i] as TextField;
				}
				
				_bubbleTxt = contentMcDescendants[i] as TextField;
				if (_bubbleTxt && _bubbleTxt.name == a_txtFldName)
				{
					break;
				}
			}
			
			if (!_bubbleTxt)
			{
				_bubbleTxt = firstTxtField;
			}
			
			if (!_bubbleTxt)
			{
				log.warn("TextBubble::extractParts(): _contentMC contains no descendant TextField "
								+ "named '" + a_txtFldName + "'!");
				return contentMcDescendants;
			}
			
			_bubbleTxt.multiline = true;
			_bubbleTxt.type = TextFieldType.DYNAMIC;
			
			_originalTextHeight = (_bubbleTxt.getBounds(_bubbleTxt)).height;
			_originalTextFormat = _bubbleTxt.getTextFormat();
			
			return contentMcDescendants;
			
		}//end extractParts()
		
		/**
		 * 
		 * @param	a_str:			String text to set for the text property of the represented textfield.
		 * @param	a_bShrinkToFit:	Boolean 'true' if you wish to shrink the text to fit within the ORIGINAL height of the TextField.
		 */
		public function setText(a_str:String, a_bShrinkToFit:Boolean = true):void
		{
			_bubbleTxt.setTextFormat(_originalTextFormat);
			
			if(a_bShrinkToFit)
			{
				DisplayObjectUtils.setTextFieldWithinHeight(a_str, _bubbleTxt, _originalTextHeight);
			}
			else
			{
				_bubbleTxt.text = a_str;
			}
			
		}//end setText()
		
		/**
		 * Getter to allow manipulation of the textfield outside of this class.
		 * 
		 * @return The textField in TextBubble.
		 * 
		 * @author Brista
		 */
		public function getTextField():TextField
		{
			return _bubbleTxt;
		}
		
		public function getText():String
		{
			return _bubbleTxt ? _bubbleTxt.text : "";
		}//end getText()
		
		override public final function toString():String
		{
			return "[ " + getMyStringRep() + " ]";
			
		}//end toString()
		
		protected function getMyStringRep():String
		{
			var myQName:String = getQualifiedClassName(this);
			var stringRep:String = myQName + " _contentMC=" + _contentMC + " _bubbleTxt=" + _bubbleTxt 
									+ " _originalTextHeight=" + _originalTextHeight 
									+ " _originalTextFormat=" + _originalTextFormat;
			
			return stringRep;
			
		}//end getMyStringRep()
		
		public function destroy(...args):void
		{
			_contentMC = null;
			_bubbleTxt = null;
			_originalTextHeight = NaN;
			_originalTextFormat = null;
			
		}//end destroy()
		
	}//end class TextBubble
	
}//end package com.smerc.uicomponents.Containers..store.views.PopUps
