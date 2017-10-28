/* AS3
	Copyright 2009
*/
package com.neopets.games.marketing.destination.macAndCheese.April_2010
{
	import flash.display.MovieClip;
	
	//import com.neopets.util.managers.FlashVarsManager; // mx.core.Application not found
	import com.neopets.marketing.collectorsCase.FlashVarManager;
	
	import com.neopets.games.marketing.destination.macAndCheese.April_2010.widgets.countdown.CountDownDisplay;
	
	/**
	 *	This class handle the teaser swf.  It mostly just sets up flash var defaults.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author 
	 *	@since  3.04.2009
	 */
	public class TeaserClip extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function TeaserClip():void{
			super();
			FlashVarManager.setDefault(CountDownDisplay.DAYS_LEFT,3);
			FlashVarManager.initVars(root);
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
