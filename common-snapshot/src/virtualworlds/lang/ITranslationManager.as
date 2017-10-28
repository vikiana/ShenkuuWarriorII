package virtualworlds.lang
{
	
	import flash.events.IEventDispatcher;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	public interface ITranslationManager extends IEventDispatcher
	{
		
		
		function get translationXMLData():XML;
		
		function set externalURLforTranslation(pURL:String):void;
		
		function get languageCode():String;
		
		function get translationData(): TranslationData;
		function set translationData(value:TranslationData):void;
		
		
		function init( pLang:String,pGame_id:int, pType_id:int, translationData : TranslationData, pTranslationURL:String = null):void;
		  
		/**
		 * Set a textField using the translation system. The <code>TranslationManager</code>
		 * will decide whether to set the font and embed or not depending on the language.	
		 * @param pTextField The textField.
		 * @param pValue The already translated string to display.
		 * @param pFontName The font name (optional).
		 */
		 
		function setTextField(pTextField:TextField, pValue:String, pFontName:String = null, pFontFormat:TextFormat = null):void;
		
	}
}
