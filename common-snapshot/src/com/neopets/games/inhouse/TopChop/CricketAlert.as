package com.neopets.games.inhouse.TopChop
{
	//===============================================================================
	// IMPORTS
	//===============================================================================	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.*;
	import flash.text.*;

	public class CricketAlert extends MovieClip
	{
		//===============================================================================
		// VARS & CONSTANTS
		//===============================================================================
		internal static const CRICKET_ANIMATION_DONE : String = "AnimationDone";
		
		private var mGamingSystem     : MovieClip;
		private var mKougraKarateGame : KougraKarateGame;
		
		private var mGarbage : Array;
		
		//===============================================================================
		// CONSTRUCTOR CricketAlert
		//===============================================================================		
		public function CricketAlert( pGamingSystem : MovieClip, pKougraKarateGame : KougraKarateGame )
		{
			super( );
			trace( "CricketAlert created" );
			
			setupVars( );
			
			mGamingSystem = pGamingSystem;
			mKougraKarateGame = pKougraKarateGame;
			
			var tCricketAlertFrame : GenericFrame = new GenericFrame( );
			trace( "tCricketAlertFrame.width: " + tCricketAlertFrame.width );
			trace( "tCricketAlertFrame.height: " + tCricketAlertFrame.height );
			tCricketAlertFrame.width = 150;
			tCricketAlertFrame.height = 100;
			mGarbage.push( tCricketAlertFrame );
			this.addChild( tCricketAlertFrame );
			
			var tCricketAlertDisplay = new GenericTextField( "displayFont", "left", 0x000000, 20, 100, 60, 55, 10 );			
			var tCricketAlertText : String = mGamingSystem.getTranslation( "IDS_CRICKET_ALERT" );
			mKougraKarateGame.setText( "displayFont", tCricketAlertDisplay, tCricketAlertText );			
			tCricketAlertFrame.addChild( tCricketAlertDisplay );	
			
			this.x = 230;
			this.y = 750;		
			
		} // end constructor
		
		//===============================================================================
		//  FUNCTION doAnimation( ):
		//===============================================================================
		internal function doAnimation( ) : void
		{	
			trace( "doAnimation in CricketAlert called" );	
			this.addEventListener( Event.ENTER_FRAME, moveMeUp, false, 0, true );
			
		} // end doAnimation
		
		//===============================================================================
		//  function moveMeUp( ):
		//===============================================================================
		private function moveMeUp( evt : Event ) : void
		{
			trace( "moveMeUp in CricketAlert called" );	
			if( this.y > 500 )
			{
				this.y -= 30;
			}
			
			else
			{
				this.removeEventListener( Event.ENTER_FRAME, moveMeUp );
				
				var tTimer : Timer = new Timer( 800, 1 );
				tTimer.addEventListener( TimerEvent.TIMER_COMPLETE, endCricketAlert, false, 0, true );
				tTimer.start( );
			}
			
		} //end moveMeUp
		
		//===============================================================================
		//  function endSplitScreen( ):
		//===============================================================================
		private function endCricketAlert( evt : Event ) : void
		{			
			this.addEventListener( Event.ENTER_FRAME, moveMeDown, false, 0, true );
						
		} //end endSplitScreen
		
		//===============================================================================
		//  function moveMeDown( ):
		//===============================================================================
		private function moveMeDown( evt : Event ) : void
		{
			if( this.y < 750 )
			{
				this.y += 30;
			}
			
			else
			{
				clearMe( );
				this.removeEventListener( Event.ENTER_FRAME, moveMeDown );
				dispatchEvent ( new Event( CRICKET_ANIMATION_DONE ) );
			}
			
		} //end moveMeDown
		
		//===============================================================================
		// FUNCTION clearMe( ): 
		//          - removes all children of this class
		//===============================================================================
		internal function clearMe( ):void
		{
			for( var i : int = mGarbage.length - 1; i >= 0; i-- )
			{
				var tCurrentObject : DisplayObject = mGarbage[ i ];
				
				if( tCurrentObject.parent != null )
				{
					tCurrentObject.parent.removeChild( tCurrentObject );
					tCurrentObject = null;					
				}
			}
			
			mGarbage = new Array( );
			
		} // end clearMe
		
		//===============================================================================
		// FUNCTION setupVars( ): 
		//          - assigns vars
		//===============================================================================
		private function setupVars( ):void
		{
			mGarbage = new Array( );
			
		} // end setupVars
		
	} // end class
	
} // end package