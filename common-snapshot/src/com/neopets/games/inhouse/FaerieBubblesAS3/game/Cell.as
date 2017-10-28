/**
 *	a cell of the x,y grid system of the game
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  nov.2009
 */

package com.neopets.games.inhouse.FaerieBubblesAS3.game
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------

	
	
	public class Cell
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		public var gridY:Number;	// position of the column
		public var gridX:Number;	// position fo the row 
		public var ball:Number;		// the ball that's in this grid, -1 means empthy
		
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function Cell(py:Number, px:Number, b:Number):void
		{
			gridY = -1; // grid col
			gridX = -1; // grid row
			ball  = -1; // the ball
			
			if (!isNaN(py)) this.gridY = py;
			if (!isNaN(px)) this.gridX = px;
			if (!isNaN(b)) this.ball  = b;
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