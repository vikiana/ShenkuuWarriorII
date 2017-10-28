/* Bubblemaster version - 3/2010
 property names have been added to access stage MCs
 

*/

package com.neopets.games.inhouse.BubbleMaster
{
	
	//IMPORTS
	
	import flash.display.MovieClip;
	import flash.net.*
	import flash.media.*;
	import flash.events.*
	import com.neopets.projects.gameEngine.gui.Interface.OpeningScreen;
	import com.neopets.projects.gameEngine.gui.buttons.SelectedButton;
	import com.neopets.util.button.NeopetsButton;
	
	
	/**
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author Neil
	 *	@since  02.23.2009 
	 */
	
	

	//CLASS DECLARATION
	public class Bubblemaster_OpeningScreen extends OpeningScreen
	{	
	 
		
	    //--------------------------------------------------------------------------
	    //  Properties
	    //--------------------------------------------------------------------------	
	     public var pauseBtn:MovieClip;
		 public var viewportMC:MovieClip;
		 public var paused:Boolean = false;
		 public var twisty:MovieClip;
		 public var bouncy:MovieClip;
		
		// public static var soundOn:Boolean; // plays automatically from Bubblemaster_SetUp
	  
	    //--------------------------------------------------------------------------
	    //  Constructor
	    //--------------------------------------------------------------------------


		public function Bubblemaster_OpeningScreen ()
		{
			trace("Bubblemaster_OpeningScreen () ---------------");
			init();
		}	
		
		// -------------------------------------------------------------------------
		// EVENTS
		// -------------------------------------------------------------------------
		
		
		//--------------------------------------------------------------------------
		//METHODS
		//--------------------------------------------------------------------------
		
		private function init()
		{
			// set up the pause button that controls the animal animations
		   pauseBtn.chrome.gotoAndPlay("on");	
		   pauseBtn.gotoAndPlay("on");
		   pauseBtn.addEventListener(MouseEvent.CLICK, pauseAnimation,false,0,true);
		   pauseBtn.buttonMode = true;
		   pauseBtn.addEventListener(MouseEvent.ROLL_OVER, function(){ pauseBtn.gotoAndStop('over') } );
		   pauseBtn.addEventListener(MouseEvent.ROLL_OUT, function(){ pauseBtn.gotoAndStop('up') } );
			
		}
		
		 private function pauseAnimation(evt:Event):void
		 {	
			pauseBtn.chrome.gotoAndPlay("off");	
			if(paused) {
				paused = false;
				viewportMC.twisty.play();
				viewportMC.bouncy.play();
			}else
			{
				paused = true;
				viewportMC.twisty.stop();
				viewportMC.bouncy.stop();
			}
			
		 }
		
		 
		
	}
}