package com.neopets.games.inhouse.TopChop
{	
	//===============================================================================
	// IMPORTS
	//===============================================================================
	//import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class GenericTextField extends TextField
	{		
		//===============================================================================
		// VARS & CONSTANTS
		//===============================================================================		
		public var mTextBox : TextField;		
		
		//===============================================================================
		// CONSTRUCTOR GenericTextField
		//===============================================================================
		public function GenericTextField( pFont      : String  = "Times",
									      pAlign     : String  = "center",
									      pColor     : int     = 0x000000,
									      pPointSize : int     = 20,
									      pWidth     : int     = 100,
									      pHeight    : int     = 30,
									      pXpos      : int     = 0,
									      pYpos      : int     = 0,
									      pBorder    : Boolean = false,
									      pBorderCol : int     = 0xFFFFFF )
		{	
			setupVars( );
							
 			var tFormat : TextFormat = new TextFormat( );
			
            tFormat.font  = pFont;
			tFormat.align = pAlign;
            tFormat.color = pColor;
            tFormat.size  = pPointSize;			
			
			
			this.border = pBorder;
			
			if( pBorder )
			{			
				this.borderColor = pBorderCol;
			}
			
			this.width  = pWidth;
			this.height = pHeight;
			this.x = pXpos;
			this.y = pYpos;
			this.selectable = false;
			this.defaultTextFormat = tFormat;
			//mTextBox.text = "";
						
		} // end CONSTRUCTOR
		
		//===============================================================================
		// FUNCTION setupVars( ): 
		//          - assigns vars
		//===============================================================================
		private function setupVars( ):void
		{
			mTextBox = new TextField( );
			
		} // end setupVars
		
	} // end class
	
} // end package
