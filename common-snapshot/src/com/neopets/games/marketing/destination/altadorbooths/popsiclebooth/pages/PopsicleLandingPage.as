﻿/**
 *	This class handles the first page users should see on entering the destination.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary/Viviana Baldarelli
 *	@since  01.04.2010
 */

package com.neopets.games.marketing.destination.altadorbooths.popsiclebooth.pages
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import com.neopets.games.marketing.destination.altadorbooths.popsiclebooth.PopsicleboothInfo;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.DestinationView;
	import com.neopets.projects.destination.destinationV3.AbsPageWithBtnState;
	import com.neopets.util.amfphp.Amfphp;
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.flashvars.FlashVarManager;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.net.Responder;
	
	public class PopsicleLandingPage extends AbsPageWithBtnState
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		//icons
		public var game_btn:MovieClip;
		public var trivia_btn:MovieClip;
		public var logo_btn:MovieClip;
		public var video_btn:MovieClip;
		public var dailybonus_btn:MovieClip;
		public var quest_btn:MovieClip;
		public var sweepstake_btn:MovieClip;
		
	

		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function PopsicleLandingPage(pName:String = null, pView:Object = null):void
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
		//----------------------------------------
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
	}
	
}