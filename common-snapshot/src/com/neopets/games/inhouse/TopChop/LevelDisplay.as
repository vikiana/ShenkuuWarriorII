package com.neopets.games.inhouse.TopChop
{	
	//===============================================================================
	// IMPORTS
	//===============================================================================
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class LevelDisplay extends MovieClip
	{		
		//===============================================================================
		// VARS & CONSTANTS
		//===============================================================================		
		public var mLabel : TextField;		
		
		//===============================================================================
		// CONSTRUCTOR TimeDisplay
		//===============================================================================
		public function LevelDisplay( pFont  : String = "Times",
									  pAlign : String = "center",
									  pColor : uint   = 0x000000,
									  pSize  : uint   = 20,
									  pXpos  : int    = 0,
									  pYpos  : int    = 0 )
		{	
			setupVars( );
							
 			var tFormat : TextFormat = new TextFormat( );
			
            tFormat.font  = pFont;
			tFormat.align = pAlign;
            tFormat.color = pColor;
            tFormat.size  = pSize;
			
			level_txt.x = pXpos;
			level_txt.y = pYpos;
			level_txt.selectable = false;
			level_txt.defaultTextFormat = tFormat;
			this.addChild( level_txt );
			level_txt.text = "";
						
		} // end constructor
		
		//===============================================================================
		// FUNCTION updateLevelDisplay( ): 
		//===============================================================================
		internal function updateLevelDisplay( ) : void
		{
			trace( "updateLevelDisplay in LevelDisplay called" );
			
			trace( "GameVars.mCurrentStage: " + GameVars.mCurrentStage );
			
			if( GameVars.mCurrentStage <= 3 )
			{
				level_txt.text = "1 - " + GameVars.mCurrentStage.toString( );	
			}
			
			else if( GameVars.mCurrentStage > 3 && GameVars.mCurrentStage <= 7 )
			{
				level_txt.text = "2 - " + ( GameVars.mCurrentStage - 3 ).toString( );
			}
			
			else if( GameVars.mCurrentStage > 7 && GameVars.mCurrentStage <= 12 )
			{
				level_txt.text = "3 - " + ( GameVars.mCurrentStage - 7 ).toString( );
			}
			
			else if( GameVars.mCurrentStage == 13 )
			{
				level_txt.text = "4 - 1";
			}	
			
		} // end updateLevelDisplay
		
		//===============================================================================
		// FUNCTION setupVars( ): 
		//          - assigns vars
		//===============================================================================
		private function setupVars( ):void
		{
			//mLabel = new TextField( );
			
		} // end setupVars
		
	} // end class
	
} // end package
