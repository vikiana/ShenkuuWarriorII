//Marks the right margin of code *******************************************************************
package com.neopets.util.lang.collectorscase
{
	//--------------------------------------
	//  Imports
	//--------------------------------------
	import com.neopets.lang.TranslationData;	
		
	//--------------------------------------
	//  Class
	//--------------------------------------
	/**
	 * Extends <code>TranslationData</code> to populate with name/values expected from TranslationManager
	 * call. This hardcode assists the intellisense (autocompletion) during Flex 3 authoring.
	 * 
     * <listing version="3.0" >
	 * 	//Code example goes here.
	 * </listing>
	 *
     * <span class="hide">Any hidden comments go here.</span>
     *
	*/
	[Bindable]
	dynamic public class CollectorsCaseTranslationData extends TranslationData
	{		
		
		//--------------------------------------
		//  Properties
		//--------------------------------------

		//**************************************************************************************************
		//GENERAL
		//**************************************************************************************************
		public var GENERAL_TEST_VALUE_1 : String 			= "This is a general test value.";
		public var GENERAL_TEST_VALUE_2 : String 			= "This is really %ADJECTIVE general test value for use with formatted string.";
		
		//**************************************************************************************************
		//PROMPTS
		//**************************************************************************************************
		
		//**************************************************************************************************
		//COMPONENTS
		//**************************************************************************************************
		
		//**************************************************************************************************
		//TOOL TIPS
		//**************************************************************************************************		
		
		//**************************************************************************************************
		//ERRORS
		//**************************************************************************************************

	}
}