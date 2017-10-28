/**
 *	This class handles the first page users should see on entering the destination.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary/Viviana Baldarelli
 *	@since  01.04.2010
 */

package com.neopets.games.marketing.destination.altadorbooths.kraftaltadorbooth.pages
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import com.neopets.games.marketing.destination.altadorbooths.kraftaltadorbooth.KraftaltadorboothInfo;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.DestinationView;
	import com.neopets.projects.destination.destinationV3.AbsPageWithBtnState;
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.flashvars.FlashVarManager;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	public class KraftLandingPage extends AbsPageWithBtnState
	{ 
		//-------------------------------
		//	VARIABLES
		//----------------------------------------
		//public
		public var play_btn:MovieClip;
		public var instructions_btn:MovieClip;
		public var explosion_btn:MovieClip;
		public var wallpapers_btn:MovieClip;
		public var nick_btn:MovieClip;
		//public var shunt_btn:MovieClip;
		public var dailybonus_btn:MovieClip;
		public var avatars_btn:MovieClip;
		public var tournament_btn:MovieClip;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function KraftLandingPage(pName:String = null, pView:Object = null):void
		{
			super(pName, pView);

		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PROTECTED METHODS
		//-----------------------------------------
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
	
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		
		

	}
	
}