/**
 *	This class simply adds "runJavascript" to AbsPageWithBtnState for omniture tracking support.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  01.04.2010
 */

package com.neopets.games.marketing.destination.kidCuisine2.pages
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.destinationV3.AbsPageWithBtnState;
	import com.neopets.util.tracker.NeoTracker;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.sound.SoundManager;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.external.ExternalInterface;
	
	public class AbsPageWithTracking extends AbsPageWithBtnState
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var _neoContentID:int;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function AbsPageWithTracking(pName:String = null, pView:Object = null):void
		{
			super(pName, pView);
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get neoContentID():int { return _neoContentID; }
		
		public function set neoContentID(val:int) {
			_neoContentID = val;
			if(_neoContentID >= 0) NeoTracker.instance.trackNeoContentID(_neoContentID);
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		/**	
		 *	This function add a new sounds from the library to our sound manager.
		 *	param		tag				String		Identifer for created sound object
		 **/
		
		public function addSound(tag:String) {
			var sounds:SoundManager = SoundManager.instance;
			if(!sounds.checkSoundObj(tag)) {
				sounds.loadSound(tag,sounds.TYPE_SND_INTERNAL);
			}
		}
		
		/**	
		 *	Runs java script for omniture
		 *	@PARAM		scriptID		One fo the parameters used to call the java script
		 **/
		public function runJavaScript(scriptID:String):void
		{

			trace (this+" run javascript "+scriptID);
			if (ExternalInterface.available)
			{
				try
				{ 
					ExternalInterface.call("sendADLinkCall", scriptID) ;
					
				}
				catch (e:Error)
				{
					trace ("Handle Error in JavaScript")
				}
			}
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