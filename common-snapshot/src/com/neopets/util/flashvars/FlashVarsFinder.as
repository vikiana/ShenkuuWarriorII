/**
 *	FindFlashVars -- finds the given flashvars and returns its value
 *
 *	EXAMPLE
 *	FlashVarsFinder.findvar(stage.root, "baseurl")
 *	Should give you either http://dev.neopets.com or http://www.neopets.com 
 *	That is assuming such property is given by php person
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  08.20.2009
 */

package com.neopets.util.flashvars
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	
	import flash.display.LoaderInfo;
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------

	
	
	public class FlashVarsFinder 
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
	
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function FlashVarsFinder():void
		{
			
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		/**
		 *	Retrieve flashVars value given the root object and flashvars property name.
		 *	@PARAM			pRoot			Object(display object)			The Root object of flash
		 *	@PARAM			pFlashVars		String							Name of the flash var property
		 *	@NOTE:			If pFlashVars does not exist, it will return null
		 **/
		public static function findVar(pRoot:Object, pFlashVars:String):String
		{
			
			var flashVarsValue:String = null;
			try 
			{
				var paramObj:Object = LoaderInfo(pRoot.loaderInfo).parameters;
				 flashVarsValue = paramObj[pFlashVars];
				 trace("The flash var '" + pFlashVars +"' is: "+flashVarsValue);
			} 
			catch (error:Error) 
			{
				trace(error.toString());
			}
			
			return flashVarsValue;
			
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