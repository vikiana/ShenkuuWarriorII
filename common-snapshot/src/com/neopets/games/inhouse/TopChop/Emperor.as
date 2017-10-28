package com.neopets.games.inhouse.TopChop
{
	//===============================================================================
	// imports
	//===============================================================================
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.Timer;

	public class Emperor extends MovieClip
	{
		//===============================================================================
		// VARS & CONSTANTS
		//===============================================================================
		private var mBlinkCounter : int;
		
		//===============================================================================
		// CONSTRUCTOR Blossoms
		//===============================================================================
		public function Emperor( )
		{
			super( );
			this.stop( );
			
			trace( "Emperor created" );
			
			init( );
			//doAnimation( );
						
			
		} // end constructor
		
		//===============================================================================
		// FUNCTION init
		//===============================================================================
		internal function init( ) : void
		{			
			mBlinkCounter = 0;
			
			doAnimation( );
			
		} // end init
		
		//===============================================================================
		// FUNCTION doAnimation
		//===============================================================================
		private function doAnimation( ) : void
		{
			trace( "doAnimation called" );
			trace( "mBlinkCounter: " + mBlinkCounter );
			
			if( GameVars.mGameOn )
			{			
				if( mBlinkCounter == 2 )
				{
					var tNodOffChance   : Number = Math.floor( Math.random( ) * 3 );
					var tSequenceSwitch : Number = Math.floor( Math.random( ) * 2 );
					trace( "tNodOffChance: " + tNodOffChance );
					
					switch( tNodOffChance )
					{						
						case 0:
						case 1:
							mBlinkCounter = 0;
							GameVars.mEmperorAnimOn = true;
							switch( tSequenceSwitch )
							{
								case 0:
									trace( "startSequenceOne" );
									this.gotoAndPlay( "startSequenceOne" );
									break;
									
								case 1:
									trace( "startSequenceTwo" );
									this.gotoAndPlay( "startSequenceTwo" );
									break;
							}
							break;
							
						case 2:
							trace( "just blinking" );
							this.gotoAndPlay( "startBlinkFrame" );
							break;												
					}			 
				}
				
				else
				{
					trace( "just blinking" );
					trace( "mBlinkCounter: " + mBlinkCounter );
					mBlinkCounter++;
					GameVars.mEmperorAnimOn = false;
					trace( "mBlinkCounter: " + mBlinkCounter );
					this.gotoAndPlay( "startBlinkFrame" );
				}
				
				this.addEventListener( Event.ENTER_FRAME, checkFrame, false, 0, true );
			}
			
			else
			{
				clearMe( );
			}
			
		} // end doAnimation
		
		//===============================================================================
		// FUNCTION checkFrame
		//===============================================================================
		private function checkFrame( evt : Event ):void
		{
			//trace( "checkFrame called" );
			if( GameVars.mGameOn )
			{
				if( this.currentLabel == "endSequenceOne" || this.currentLabel == "endBlinkFrame" || this.currentLabel == "endSequenceTwo" )
				{
					if( this.hasEventListener( Event.ENTER_FRAME ) )
					{
						trace( "removing event listener" );
						this.removeEventListener( Event.ENTER_FRAME, checkFrame );
					}
					
					this.stop( );
					this.doAnimation( );
				}
			}
			
			else
			{
				clearMe( );
			}
			
		} // end checkFrame
		
		//===============================================================================
		// FUNCTION clearMe
		//===============================================================================
		internal function clearMe( ):void
		{
			GameVars.mEmperorAnimOn = false;
			this.stop( );
				
			if( this.hasEventListener( Event.ENTER_FRAME ) )
			{
				this.removeEventListener( Event.ENTER_FRAME, checkFrame );
			}
			
		} // end clearMe
		
	} // end class
	
} // end package