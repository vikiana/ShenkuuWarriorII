/**
 *	class that checks for various combo and carry out functions based on it
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

	
	
	public class Combo
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		
		private var B_FIRE:Number    = 1;
		private var B_WATER:Number   = 2;
		private var B_LIGHT:Number   = 3;
		private var B_EARTH:Number   = 4;
		private var B_AIR:Number     = 5;
		private var B_DARK:Number    = 6;
		
		private var _FIRE:Number      =  111;
		private var _WATER:Number     =  222;
		private var _LIGHT:Number     =  333;
		private var _EARTH:Number     =  444;
		private var _AIR:Number       =  555;
		private var _DARK:Number      =  666;
		
		private var _DESTROY:Number      =  999;
		private var _EXPLODE:Number      = 1000;
		private var _CONNECTED:Number    = 1001;
		private var _NOTCONNECTED:Number = 1002;
		private var _TEMP:Number         = 9999;
	
		// the actual bubbles to kill
		private var aKill   = [];
		private var aCombos:Array  = [];
		private var aAddX:Array   = [];
		private var maxy:Number    = 0;
		private var maxx:Number    = 0;	
		private var topRow:Number  = 0;
		
		// used for random bubble combos
		private var maxBalls:Number = 0; // set in init
		private var randomBubble:Number = 0;

		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function Combo():void
		{
			
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		/**
		*	initial set up for the combo, needs to know the grid 
		*	@PARAM		rows		Number		number of rows
		*	@PARAM		cols		Number		number of columns
		*	@PARAM		max			Number		maxBalls... not sure what this is... max of combo balls??
		**/	
		public function init(rows:Number, cols:Number, max:Number):void
		{
			maxy     = rows;
			maxx     = cols;	
			maxBalls = max;
		}
		
		// reset arr to level values
		public function reset(aLevel:Array, aObjs:Array, aAx:Array , top:Number):void
		{
			aAddX  = aAx;
			topRow = top;
		
			aKill   = [];
			aCombos = [];
			
			var obj:*; //I don't know what this should be
			for ( var r = 0; r < maxy; r++ ) {
				aCombos.push( [] );
				for ( var c=0; c < maxx; c++ ) {
					if ( aLevel[r][c] == -1 ) aCombos[r].push( -1 );
					else {
						// get reference to actual bubble obj
						obj = aObjs[ aLevel[r][c] ];
						this.aCombos[r].push( obj.ballType );
					}
				}
			}
		}
		
		/**
		*	start the combo earch
		**/	
		public function initSearch(lastSetY:Number, lastSetX:Number):void
		{
			aCombos[lastSetY][lastSetX] = _DESTROY;
		}
		
		/**
		*	set the grid cell in ball color I believe...
		**/	
		public function setComboItem (row:Number, col:Number, bcolor:*):void 
		{
			aCombos[row][col] = bcolor;
		}
		
		
		// -------------------------------------------------- //
		// recursive function which looks for connected balls
		// of the same color as the last shot ball
		// -------------------------------------------------- //	
		public function searchForCombos ( row:Number, col:Number, bcolor:* ):Number
		{
			if (aCombos[row][col] == -1 ) return ( 0 );
			
			var count = 0;
			// look left
			if ( col > 0 ) 
			{
				if ( aCombos[row][col-1] == bcolor ) 
				{
					aCombos[row][col-1] = _DESTROY;
					count++;
					count += searchForCombos( row, (col-1), bcolor );
				}
			}
	
			// look right
			if ( col < (maxx-1) ) 
			{
				if ( aCombos[row][col+1] == bcolor ) 
				{
					aCombos[row][col+1] = _DESTROY;
					count++;
					count += searchForCombos( row, (col+1), bcolor );
				}
			}
			
			// look top
			if ( row > 0 ) 
			{
				if ( aCombos[row-1][col] == bcolor ) 
				{
					aCombos[row-1][col] = _DESTROY;
					count++;
					count += searchForCombos( (row-1), col, bcolor );
				}
				if ( aAddX[row] > 0 ) 
				{
					if ( col < (maxx-1) ) 
					{
						if ( aCombos[row-1][col+1] == bcolor ) 
						{
							aCombos[row-1][col+1] = _DESTROY;
							count++;
							count += searchForCombos( (row-1), (col+1), bcolor );
						}
					}
				}
				else 
				{
					if ( col > 0 ) 
					{
						if ( aCombos[row-1][col-1] == bcolor ) 
						{
							aCombos[row-1][col-1] = _DESTROY;
							count++;
							count += searchForCombos( (row-1), (col-1), bcolor );
						}
					}
				}
			}
			
			// look bottom
			if ( row < (maxy-1) ) 
			{
				if ( aCombos[row+1][col] == bcolor ) 
				{
					aCombos[row+1][col] = _DESTROY;
					count++;
					count += searchForCombos( (row+1), col, bcolor );
				}
				if ( aAddX[row] > 0 ) 
				{
					if ( col < (maxx-1) ) 
					{
						if (aCombos[row+1][col+1] == bcolor ) 
						{
							aCombos[row+1][col+1] = _DESTROY;
							count++;
							count += searchForCombos( (row+1), (col+1), bcolor );
						}
					}
				}
				else 
				{
					if ( col > 0 ) 
					{
						if ( aCombos[row+1][col-1] == bcolor ) 
						{
							aCombos[row+1][col-1] = _DESTROY;
							count++;
							count += searchForCombos( (row+1), (col-1), bcolor );
						}
					}
				}
			}
			
			return ( count );
		}
		
		
		// -------------------------------------------------- //
		// returns all occupied neighbour cells of ball[row][col]
		// that are not -1 && iException
		// -------------------------------------------------- //	
		public function getNeighbours ( row:Number, col:Number, iException:* ):Array
		{
			if ( iException == undefined ) iException = -1;
			var aN:Array = [];
			
			// top
			if ( row > 0 ) 
			{
				if ( (aCombos[row-1][col] != -1) && (aCombos[row-1][col] != iException) )
				{
					aN.push( [row-1,col] );
				}
				if ( (aAddX[row] > 0) && (col < (maxx-1)) ) 
				{
					if ( (aCombos[row-1][col+1] != -1) && (aCombos[row-1][col+1] != iException) )
					{
						aN.push( [row-1,col+1] );
					}
				}
				else if ( (aAddX[row] == 0) && (col > 0) ) 
				{
					if ( (aCombos[row-1][col-1] != -1) && (aCombos[row-1][col-1] != iException) )
					{
						aN.push( [row-1,col-1] );
					}
				}
			}
			
			// right
			if ( col < (maxx-1) ) 
			{
				if ( (aCombos[row][col+1] != -1) && (aCombos[row][col+1] != iException) )
				{
					aN.push( [row,col+1] );
				}
			}
			
			// bottom
			if ( row < (maxy-1) ) 
			{
				if ( (aCombos[row+1][col] != -1) && (aCombos[row+1][col] != iException) )
				{
					aN.push( [row+1,col] );
				}
				if ( (aAddX[row] > 0) && (col < (maxx-1)) ) 
				{
					if ( (aCombos[row+1][col+1] != -1) && (aCombos[row+1][col+1] != iException) )
					{
						aN.push( [row+1,col+1] );
					}
				}
				else if ( (aAddX[row] == 0) && (col > 0) ) 
				{
					if ( (aCombos[row+1][col-1] != -1) && (aCombos[row+1][col-1] != iException) )
					{
						aN.push( [row+1,col-1] );
					}
				}
			}
			
			// left
			if ( col > 0 ) {
				if ( (aCombos[row][col-1] != -1) && (aCombos[row][col-1] != iException) )
				{
					aN.push( [row,col-1] );
				}
			}
	
			return ( aN );
		}
		
		public function setRegularCombo ( aLevel:Array, aObjs:Array ):void
		{
			for ( var r=0; r<maxy; r++ ) {
				for ( var c=0; c<maxx; c++ ) {
					if (aCombos[r][c] == _DESTROY) {
						aKill.push( [r,c] );
					}
				}
			}
		}


		public function getNextBubble():Array
		{
			return ( aKill );
		}

		public function setFireCombo( aLevel:Array, aObjs:Array):void
		{
			var aN:Array    = [];
			var aTemp:Array = [];
			var obj:Ball  ;
			var newDepth:Number = 9000;
			var dropMultiplier:Number = 1;
			
			for ( var r=0; r<maxy; r++ ) {
				for ( var c=0; c<maxx; c++ ) {
					if ( aCombos[r][c] == _DESTROY ) {
						aTemp.push( aLevel[r][c] );
						obj = aObjs[ aLevel[r][c] ];
						obj.startAnimation(); // start the fire :)
						aN = getNeighbours( r, c, _DESTROY );
						for ( var n=0; n<aN.length; n++ ) {
							if ( (aCombos[ aN[n][0] ][ aN[n][1] ] != _DESTROY)
							&&   (aCombos[ aN[n][0] ][ aN[n][1] ] != _FIRE   )
							&&   (aCombos[ aN[n][0] ][ aN[n][1] ] != B_WATER )) 
							{
								aKill.push( [ aN[n][0], aN[n][1] ] );
								aCombos[ aN[n][0] ][ aN[n][1] ] = _FIRE;
							}
						}
					}
				}
			}
	
			// add the original bubbles to destroy
			for ( var k=0; k<aTemp.length; k++ ) {
				obj = aObjs[ aTemp[k] ];
				obj.prepareDrop( 0, dropMultiplier, newDepth++ );
			}
			
			//return ( count );	//why are you returning something?
		}
		
		
		
		public function getNextBall_FIRE():Array
		{
			
			return ( aKill );
		}
	
		

		public function setWaterCombo ( aLevel:Array, aObjs:Array ):void
		{
			var obj:Ball;
			var newDepth = 9000;
			var dropMultiplier = 1;
			
			for ( var r = 0; r < maxy; r++ ) 
			{
				for ( var c = 0; c < maxx; c++ ) 
				{
					if ( aCombos[r][c] == _DESTROY ) 
					{
						//this.aKill.push( [r,c] );
						obj = aObjs[ aLevel[r][c] ];
						obj.startAnimation(); // start the water :)
						obj.prepareDrop( 0, dropMultiplier, newDepth++ );
					}
					else if (aCombos[r][c] == B_WATER) 
					{
						aKill.push( [r,c] );
						obj = aObjs[ aLevel[r][c] ];
						obj.startAnimation(); // start the water :)
					}
				}
			}
		}
		
		public function getNextBall_WATER ():Array
		{
			
			return ( this.aKill );
		}

		
		public function setLightCombo( aLevel:Array, aObjs:Array):void
		{
			var aN:Array    = [];
			var aTemp:Array = [];
			var obj:Ball;
			var newDepth:Number = 9000;
			var dropMultiplier:Number = 1;
			var firstColor:Number = -1;
			
			for ( var r=0; r< maxy; r++ ) {
				for ( var c=0; c< maxx; c++ ) {
					if ( aCombos[r][c] == _DESTROY ) {
						aTemp.push( aLevel[r][c] );
						obj = aObjs[ aLevel[r][c] ];
						obj.startAnimation(); // start the light :)
						aN = getNeighbours( r, c, _DESTROY );
						for ( var n=0; n<aN.length; n++ ) {
							if ( (aCombos[ aN[n][0] ][ aN[n][1] ] != _DESTROY)
							&&   (aCombos[ aN[n][0] ][ aN[n][1] ] != B_LIGHT )) 
							{
								aCombos[ aN[n][0] ][ aN[n][1] ] = _LIGHT;
								if ( firstColor == -1 ) 
								{
									obj = aObjs[ aLevel[ aN[n][0] ][ aN[n][1] ] ];
									firstColor = obj.ballType;
								}
							}
						}
					}
				}
			}
	
			// set the random color
			randomBubble = firstColor;
			while ( randomBubble == firstColor ) {
				randomBubble = 1+Math.floor(Math.random() * maxBalls);
			}
			
			// add the original bubbles to destroy
			for ( var k=0; k<aTemp.length; k++ ) {
				obj = aObjs[ aTemp[k] ];
				obj.prepareDrop( 0, dropMultiplier, newDepth++ );
			}
			
			//return ( count );  why is it returning something...?
		}

		
		public function setNextBall_LIGHT( aLevel:Array, aObjs:Array ):void
		{
			for ( var r=0; r < maxy; r++ ) {
				for ( var c=0; c < maxx; c++ ) {
					if (aCombos[r][c] == _LIGHT ) {
						// get reference to actual bubble obj
						var obj = aObjs[ aLevel[r][c] ];
						aCombos[r][c] = randomBubble;
						obj.ballType = randomBubble;
						obj.goto( randomBubble );
					}
				}
			}
		}
		
		
		public function setEarthCombo ( aLevel:Array, aObjs:Array ):void
		{
			var obj:Ball;
			var newDepth = 9000;
			var dropMultiplier = 1;
			for ( var r=0; r<maxy; r++ ) {
				for ( var c=0; c<maxx; c++ ) {
					if (aCombos[r][c] == _DESTROY) {
						obj = aObjs[ aLevel[r][c] ];
						obj.startAnimation(); // start the earth!
						obj.prepareDrop( 0, dropMultiplier, newDepth++ );
					}
				}
			}
		}
		
		
		public function setAirCombo( aLevel:Array, aObjs:Array ):void
		{
			trace ("///////////// air combo")
			var aN:Array    = [];
			var aTemp:Array = [];
			var obj:Ball;
			var newDepth:Number = 9000;
			var dropMultiplier:Number = 1;
			randomBubble = B_AIR;
			
			trace (maxy, maxx)
		
			for ( var r=0; r<maxy; r++ ) {
				for ( var c=0; c<maxx; c++ ) {
					if ( aCombos[r][c] == _DESTROY ) {
						aTemp.push( aLevel[r][c] );
						obj = aObjs[ aLevel[r][c] ];
						obj.startAnimation(); // start the light :)
						for ( var c2 = c-1; c2 >= 0; c2-- )
						{
							if ( aCombos[r][c2] == -1 ) this.aCombos[r][c2] = this._AIR;
						}
						for ( var c3 = c+1; c3<this.maxx; c3++ )
						{
							if ( aCombos[r][c3] == -1 ) this.aCombos[r][c3] = this._AIR;
						}
					}
				}
			}
	
			// add the original bubbles to destroy
			for ( var k=0; k<aTemp.length; k++ ) 
			{
				obj = aObjs[ aTemp[k] ];
				obj.prepareDrop( 0, dropMultiplier, newDepth++ );
			}
			
			//return ( count );
		}
		
		
		public function setNextBall_AIR( curRow:Number, aLevel:Array, aObjs:Array ):Array
		{
			//var obj:Array    = {};
			var aObjs:Array  = [];
			var rand:Number   = randomBubble;
	
			var r:Number = curRow;
			for ( var c=0; c<maxx; c++ ) {
				if ( aCombos[r][c] == _AIR ) {
					rand = 1+ Math.floor(Math.random() * maxBalls);
					while ( rand == randomBubble ) rand = 1+ Math.floor(Math.random() * maxBalls);;
					aCombos[r][c] = rand;
					aObjs.push ( new Cell( r, c, rand ) );
				}
			}
			
			return ( aObjs );
		}
		
		
		public function setDarkCombo( aLevel:Array, aObjs:Array ):void
		{
			var obj:Ball;
			var newDepth:Number = 9000;
			for ( var r=0; r<maxy; r++ ) {
				for ( var c=0; c<maxx; c++ ) {
					if (aCombos[r][c] == _DESTROY) {
						obj = aObjs[ aLevel[r][c] ];
						obj.startAnimation(); // start the earth!
					}
				}
			}
		}
		

		public function setNextBall_DARK ( aLevel:Array, aObjs:Array ):Number
		{
			var count = 0;
			var obj:Ball;
			
			for ( var r=0; r<maxy; r++ ) {
				for ( var c=0; c<maxx; c++ ) {
					if ( aCombos[r][c] == _DESTROY ) {
						//_root.playSound(3);
						// get reference to actual bubble obj
						obj = aObjs[ aLevel[r][c] ];
						var rBall = 1 + Math.floor(Math.random() * maxBalls);
						while ( rBall == obj.ballType ) rBall = 1+ Math.floor(Math.random() * maxBalls);
						aCombos[r][c] = rBall;
						obj.ballType = rBall;
						obj.goto( rBall );
						// stop loop
						count++; r = maxy;	c = maxx;
					}
				}
			}
			
			return ( count );
		}
	
		public function searchForFreeBubbles( aLevel:Array, aObjs:Array ):Number
		{
			var obj:Ball;
			var save:Number = 0;
			var count:Number = 0;
			var newDepth:Number = 9000;
			var bConnected:Boolean = false;
			var dropMultiplier:Number = 2;
			
			// except row 0 which is connected to the top!
			for ( var row=1; row<maxy; row++ ) {
				for ( var col=0; col<maxx; col++ ) {
					if ( aCombos[row][col] != -1 ) {
						
						bConnected = followBubblePath( row, col );
			
						if ( !bConnected ) {
							aCombos[row][col] = _NOTCONNECTED;
							obj = aObjs[ aLevel[row][col] ];
							obj.prepareDrop( 0, dropMultiplier, newDepth++ );
							count++;
						}
						else aCombos[row][col] = _CONNECTED;
					}
				}
			}
			return ( count );
		}
		
		// -------------------------------------------------- //
		// follow the bubble path and see if it leads
		// to the top row
		// -------------------------------------------------- //
		public function followBubblePath( row:Number, col:Number ):Boolean
		{
			var bTopRow = false;
			
			if ( row == topRow ) 
			{
				bTopRow = true;
			}
			else if ( aCombos[row][col] != _TEMP ) 
			{
				// prevent endless loops
				var save = aCombos[row][col];
				aCombos[row][col] = _TEMP;
						
				var aN:Array = getNeighbours( row, col, _TEMP );
				for ( var n=0; n<aN.length; n++ ) {
					var row2 = aN[n][0];
					var col2 = aN[n][1];
					if ( aCombos[row2][col2] == _CONNECTED ) {
						bTopRow = true;
						break;
					}
					else if ( aCombos[row2][col2] != _NOTCONNECTED ) {
						bTopRow = followBubblePath( row2, col2 );
						if ( bTopRow ) break;
					}
				}
				
				if ( bTopRow ) aCombos[row][col] = save;
				else aCombos[row][col] = _NOTCONNECTED;
				
			}
	
			return ( bTopRow );
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


/*
// -------------------------------------------------- //	
// this class takes care of all the win combos
// -------------------------------------------------- //	
comboClass = function()
{
	

	

	
// -------------------------------------------------- //	
// look for bubbles to drop 
// -------------------------------------------------- //	
	
	
	
	
}; // EOF
*/