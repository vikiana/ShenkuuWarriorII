﻿/**
 *	Pet class for feedApet.  It simply extends AbstractPet
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

package com.neopets.games.marketing.destination.destination_test.feedPet
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.destinationV3.feedapet.AbsPet
	
	
	
	public class DefaultPet extends AbsPet
	{
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		private var variable
		
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		public function DefaultPet(p_name: String, p_pngurl: String, p_swfurl:String, p_fed_recently: Boolean, pLocalTesting:Boolean = false):void
		{
			super(p_name, p_pngurl, p_swfurl, p_fed_recently, pLocalTesting)
		}
		
		
		//----------------------------------------
		//GETTERS AND SETTERS
		//----------------------------------------
		
		//----------------------------------------
		//PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------
	}
	
}