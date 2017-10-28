﻿/**
 *	This class handles links to other pages in the same destination.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.14.2010
 */

package com.neopets.games.marketing.destination.capriSun.disrespectoids.widgets.nav
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.DestinationControl;
	
	public class ShopPageLink extends PageLink
	{
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function ShopPageLink():void {
			var dest_con:DestinationControl = Parameters.control as DestinationControl;
			if(dest_con != null) targetPage = dest_con.shopPageURL;
			ADLinkID = "Main to Prize Shop";
			neoContentID = 16053;
			super();
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
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