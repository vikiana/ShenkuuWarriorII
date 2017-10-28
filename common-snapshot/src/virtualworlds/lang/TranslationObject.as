package virtualworlds.lang
{
	import flash.text.TextField;
	
	/**
	 *  This is For holding Data
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern 
	 * 
	 *	@author Clive Henrick
	 *	@since  01.12.2009
	 */
	 
	public class TranslationObject
	{
		public var resourceName:String;
		public var fontName:String;
		public var textField:TextField;
		
		/**
		 * @Note: This is a Data Object for Holding Info
		 * @Param 	a_resName		String 		The Reference for the PHP Translation List
		 * @Param 	a_fontName		String 		The Reference to the Font name used in the Library
		 * @Param 	a_TF			TextField 	The TextField that will be translated
		 */
		 		
		public function TranslationObject(a_resName:String, a_fontName:String, a_TF:TextField)
		{
			resourceName = a_resName;
			fontName = a_fontName;
			textField = a_TF;
		}

	}
}

