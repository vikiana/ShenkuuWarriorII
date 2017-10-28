/**
 * 
 *
 *@langversion ActionScript 3.0
 *@playerversion Flash 9.0 
 *@author Abraham Lee
 *@since  01.08.2010
 */

package com.neopets.games.inhouse.suteksTomb.game{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;

	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.util.sound.GameSoundManager;
	import virtualworlds.lang.TranslationData;
	import virtualworlds.lang.TranslationManager;



	public class Cubes 
	{
		//----------------------------------------
		//CONSTANTS
		//----------------------------------------

		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		
		protected var mGame:MovieClip	//this is the MoiveClip where the game is played so actually this is playfield
		protected var mGameClass:Game	// This is the game class where game logic and important variables are at


		protected var aLevel:Array =new Array () ;

		protected var tChange = getTimer()+5000;	// come back to this later

		protected var SECRET_:Number = 8;
		protected var WILDCARD_:Number = 9;
		protected var BOMB_:Number = 10;
		protected var SECRET2_:Number = 11;
		protected var EMPTY_:Number = 0;
		protected var UEBERSECRET_:Number = 12;

		// id's for level-vars //
		protected var NUMX_:int = 0;
		protected var NUMY_:int = 1;
		protected var SIZE_:int = 2;
		protected var DRAWX_:int = 3;
		protected var DRAWY_:int = 4;
		protected var COLORS_:int = 5;
		protected var TIME_:int = 6;

		protected var xCubes:Number = 0;
		protected var yCubes:Number = 0;
		protected var cubeSize:Number = 0;
		protected var xDraw:Number = 0;
		protected var yDraw:Number = 0;
		protected var colors:Number = 0;

		// array-id's for each cube //
		protected var COLOR_:int = 0;// color id
		protected var MFLAG_:int = 1;// is cube marked
		protected var CHFLAG_:int = 2;// is cube a changer

		// clean up row for game end
		protected var cleanupRow:Number = 0;

		// last marked cube
		protected var markedX:Number = -1;
		protected var markedY:Number = -1;

		// keep track of last randomly picked color
		protected var lastCol:Number = 0;
		// keep track of last column slid sound
		protected var lastSlide:Number = -1;

		// last swap
		protected var aSwap:Array = [-1,-1,-1,-1];
		// adjacent ones
		protected var aAdjacent:Array = [];
		// the exploding bombs
		protected var aBombs:Array = [];// vertical explosion
		protected var aBombsH:Array = [];// horizontal explosion
		// how many rows have been created
		protected var rowsCreated:Number = 0;

		// secret stuff
		protected var bShowNext:Boolean = false;
		protected var aNextMove:Array = [];
		protected var speedSum:Number = 0;
		protected var speedCount:Number = 0;
		
		protected var aPatterns:Array = [];
		
		private var mTranslationData:TranslationData = TranslationManager.instance.translationData;
		

		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		public function Cubes(pGame:MovieClip, pGameClass):void 
		{
			mGame = pGame
			mGameClass = pGameClass
			setupVars();
			

		}

		//----------------------------------------
		//GETTERS AND SETTORS
		//----------------------------------------

		//----------------------------------------
		//PUBLIC METHODS
		//----------------------------------------
		
		/**
		 *	start the round, set up the cute parameters
		 **/
		public function beginRound (aInit:Array):void
		{ 
			xCubes   = aInit[NUMX_];
			yCubes   = aInit[NUMY_];
			cubeSize = aInit[SIZE_];
			xDraw    = aInit[DRAWX_];
			yDraw    = aInit[DRAWY_];
			colors   = aInit[COLORS_];
			
			cleanupRow = 0;
			
			// empty game level array first //
			aLevel = new Array();
			for ( var rows:int = 0; rows < yCubes; rows++ ) 
			{
				aLevel.push( new Array() );
				for ( var cols:int = 0; cols < xCubes; cols++ ) 
				{
					aLevel[rows].push( new Array(EMPTY_,0,0) )
					//aLevel[rows].push( [EMPTY_,0,0] )
				}
			}
		
			// how many rows have been created
			rowsCreated = yCubes-1;
		}
		
		/**
		 *	create a level
		 **/
		public function createLevel():Boolean
		{

			var bDone:Boolean = false;
			var depth:int = 0;
			var j:int
			// attach movies //
			var addHalf:Number = cubeSize/2;
			for (j = 0; j < xCubes; j++ )
			{
				var cName:String = "cube" + rowsCreated.toString() + "_" + j.toString();
				//depth = 1000 + (rowsCreated*100) + j;
				if ( mGame[cName] == undefined ) {
					var newCube:MovieClip = AssetTool.getMC("cubeMC")//new cubeMC ();
					newCube.name = cName
					mGame.addChild(newCube);
				}
				var cube:MovieClip = MovieClip(mGame.getChildByName(cName))
				cube.width  = cubeSize;
				cube.height = cubeSize;
				cube.x = xDraw + (j * cubeSize) + addHalf;
				cube.y = yDraw + (rowsCreated * cubeSize) + addHalf;
				cube.buttonMode = true
				//mGame[cName].onRollOver  = _parent.showRollOver();

			}
			
			// fill current row with random colors //
			for (j = 0; j < xCubes; j++ ) 
			{
				createNewCube(rowsCreated,j,true);
				showCubeRight(rowsCreated,j);
			}
		
			if ( -- rowsCreated < 0 ) 
			{
				bDone = true;
			}
			
			return ( bDone );
		}
		
		
		// ---------------------------------------- //	
		/**
		 * remove all the cubes from the stage
		 **/
		public function cleanUp ():Boolean
		{
			var done:Boolean = false;
			var cMCInst:String = "";
			
			for ( var j=0; j < xCubes; j++ )
			{
				cMCInst = "cube" + String(cleanupRow) + "_" + String(j);
				mGame.removeChild(mGame.getChildByName(cMCInst))
			}
			
			if ( ++cleanupRow >= yCubes ) done = true;
			
			return ( done );
		}
		
		// --------------------------------------- //
		/**
		 *	I think this is used when swiping the cubes
		 **/
		public function changeCubes ( t:Number ):Boolean
		{
			if ( t < tChange ) return ( false );
			
			tChange = t + 5000;
			
			var col:int = 0;
			for ( var i:int = 0; i < yCubes; i++ ) 
			{
				for ( var j:int = 0; j < xCubes; j++ ) 
				{
					if ( aLevel[i][j][CHFLAG_] == 1 ) 
					{
						col = aLevel[i][j][COLOR_];
						col++;
						if ( col > colors ) col = 1;
						aLevel[i][j][COLOR_] = col;
						showCubeRight(i,j);
					}
				}
			}
			
			return ( true );
		}
		
		// --------------------------------------- //
		public function hitCube ():Boolean
		{
			var bHit = true;
			
			
		
			var iX = int( int(mGame.mouseX - xDraw) / cubeSize );
			var iY = int( int(mGame.mouseY - yDraw) / cubeSize );
			
			if ( iX >= xCubes ) bHit = false;
			else if ( iX < 0 ) bHit = false;
			if ( iY >= yCubes ) bHit = false;
			else if ( iY < 0 ) bHit = false;
			
			return ( bHit );
		}
		
		// --------------------------------------- //
		public function clickCube ( alreadyMarked:Boolean ):Boolean
		{
			var bMarked:Boolean = false;
			
			var iX = int( int(mGame.mouseX-xDraw) / cubeSize );
			var iY = int( int(mGame.mouseY-yDraw) / cubeSize );
			
			bMarked = checkCubes( iX, iY, alreadyMarked );
			
			return ( bMarked );
		}
		
		// --------------------------------------- //
		protected function checkCubes ( iX:int, iY:int, alreadyMarked:Boolean ):Boolean
		{
			var bCubeIsMarked:Boolean = false;
			
			
			var col:Number   = aLevel[iY][iX][COLOR_]; //I think is number 
			var mflag:Number = aLevel[iY][iX][MFLAG_]; 
			
		
			if ( col != EMPTY_ )
			{
				if ( mflag == 1 )
				{
					unmarkCube(iX,iY);
					mGameClass.marked = false;

				}
				else
				{
					var adjacent = true;
					if ( alreadyMarked )
						adjacent = checkAdjacent( iY, iX );
						
					if ( adjacent ) 
					{
						TranslationManager.instance.setTextField(mGame.helptext_txt, "");
						markCube( iX, iY );
						bCubeIsMarked = true;
					}
					else 
					{
						GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_SCHWING);
						TranslationManager.instance.setTextField(mGame.helptext_txt, "<font color ='#FFFFFF'>"+mTranslationData.IDS_adjacentTile+"</font>");
					}
				}
			}
			return ( bCubeIsMarked );
		}
		
		// --------------------------------------- //
		/**
		 *	Check if there are adjacent cube(s)???
		 **/
		protected function checkAdjacent ( row:int, col:int )
		{
			var px:int  = markedX;
			var py:int  = markedY;
			var px2:int = col;
			var py2:int = row;
			
			var adjacent:Boolean = false;
			
			if ( (px2==px) && ( (py2==(py+1)) || (py2==(py-1)) ) ) adjacent = true;
			else if ( (py2==py) && ( (px2==(px+1)) || (px2==(px-1)) ) ) adjacent = true;
			
			return ( adjacent );
		}
		
		// --------------------------------------- //
		
		/**
		 *	swap the two selected cubes
		 **/
		public function swapCubes ():Boolean
		{
			var bSwapped:Boolean = false;
			
			var px  = markedX;
			var py  = markedY;
			var x2 = -1;
			var y2 = -1;
			
			if ( (px>=0) && (py>=0) )
			{
				// find other marked cube
				for ( var i:int =0; i < yCubes; i++ ) {
					for ( var j:int =0; j < xCubes; j++ ) {
						if ( ((i!=py) || (j!=px)) && (aLevel[i][j][MFLAG_]==1) ) {
							x2 = j;
							y2 = i;
						}
					}
				}
				if ( (x2>=0) && (y2>=0) )
				{
					var adjacent = false;
					if ( (x2==px) && ( (y2==(py+1)) || (y2==(py-1)) ) ) adjacent = true;
					else if ( (y2==py) && ( (x2==(px+1)) || (x2==(px-1)) ) ) adjacent = true;
						
					if ( adjacent ) {
						// save swapped cubes
						bSwapped = true;
						aSwap = [px,py,x2,y2];
						// set new cube //
						var col = aLevel[py][px][COLOR_];
						aLevel[py][px][COLOR_] = aLevel[y2][x2][COLOR_];
						showCubeRight(py,px);
						// reset old cube //
						aLevel[y2][x2][COLOR_] = col;
						showCubeRight(y2,x2);
					}
				}
			}
		
			resetMarkedCubes();
			
			return ( bSwapped );
		}
		
		// --------------------------------------- //
		/**
		 *	unswap the two swaped cubes
		 **/
		public function unswapCubes ():void
		{
			// just in case
			if ( aSwap.length >= 4 ) 
			{
				// set new cube //
				var col = aLevel[aSwap[1]][aSwap[0]][COLOR_];
				aLevel[aSwap[1]][aSwap[0]][COLOR_] = aLevel[aSwap[3]][aSwap[2]][COLOR_];
				showCubeRight(aSwap[1],aSwap[0]);
				// reset old cube //
				aLevel[aSwap[3]][aSwap[2]][COLOR_] = col;
				showCubeRight(aSwap[3],aSwap[2]);
			}
		}
		
		
		// --------------------------------------- //
		/**
		 *	
		 **/
		public function checkForWin ():Array
		{
			aAdjacent = [];
			
			var mycol:int   = 0;
			var gridcol:int = 0;
			var found:int  = 0;
			var aFound:Array  = [];
		
			var already:Boolean = false;
			var aTemp:Array   = [];
			var temp:int;
			var foundWC:Number;
			//showLevel();
			
			// find winning lines - 3 or more adjacent of the same color
			for ( var row:int =0; row<yCubes; row++ ) 
			{
				for ( var col:int =0; col<xCubes; col++ ) 
				{
		
					//aAdjacent = [[row,col]];
					aTemp = [[row,col]];
					mycol = aLevel[row][col][COLOR_];
					
					for ( var col2:int =(col+1); col2<xCubes; col2++ ) 
					{
						gridcol = aLevel[row][col2][COLOR_];
						if ( mycol == WILDCARD_ ) 
						{
							mycol = gridcol;
							aTemp.push( [row,col2] );
						}
						else if ( (gridcol == mycol) || (gridcol == WILDCARD_) ) 
						{
							aTemp.push( [row,col2] );
						}
						else 
						{ 
							// exit for loop
							col2 = (xCubes+1); 
						}
					}
		
					// copy winning combos
					if ( aTemp.length >= 3 ) {
						// set counters
						aFound.push( aTemp.length );
						for ( temp =0; temp<aTemp.length; temp++ ) 
						{
							//found++;
							if ( aLevel[aTemp[temp][0]][aTemp[temp][1]][COLOR_] == WILDCARD_ ) foundWC++;
							// add to aAdjacent
							already = false;
							for ( var lookup=0; lookup<aAdjacent.length; lookup++ ) 
							{
								if ( (aAdjacent[lookup][0] == aTemp[temp][0]) && (aAdjacent[lookup][1] == aTemp[temp][1]) )
									already = true;
							}
							if ( !already ) 
							{
								
								aAdjacent.push( [aTemp[temp][0],aTemp[temp][1]] );
							}
						}
					}
		
					// search vertical			
					mycol = aLevel[row][col][COLOR_];
					aTemp = [[row,col]];
					for ( var row2:int =(row+1); row2<yCubes; row2++ ) 
					{
						gridcol = aLevel[row2][col][COLOR_];
						if ( mycol == WILDCARD_ ) 
						{
							mycol = gridcol;
							aTemp.push( [row2,col] );
						}
						else if ( (gridcol == mycol) || (gridcol == WILDCARD_) ) 
						{
							aTemp.push( [row2,col] );
						}
						else 
						{ 
							// exit for loop
							row2 = (yCubes+1); // exit for loop
						}
					}
					
					// copy winning combos
					if ( aTemp.length >= 3 ) 
					{
						// set counters
						aFound.push( aTemp.length );
						for ( temp=0; temp<aTemp.length; temp++ ) 
						{
							//found++;
							if ( aLevel[aTemp[temp][0]][aTemp[temp][1]][COLOR_] == WILDCARD_ ) foundWC++;
							// add to aAdjacent
							already = false;
							for ( var lookup2=0; lookup2<aAdjacent.length; lookup2++ ) {
								if ( (aAdjacent[lookup2][0] == aTemp[temp][0]) && (aAdjacent[lookup2][1] == aTemp[temp][1]) )
									already = true;
							}
							if ( !already )
							{
								
								aAdjacent.push( [aTemp[temp][0],aTemp[temp][1]] );
							}
						}
					}
				}
			}
		
			
			return ( aFound );
		}
		
		
		// --------------------------------------- //
		protected function killWinningCubes ():Number 
		{
			//return ( -1 );	//how can you return something and continue...???
			
			for ( var i:int =0; i< aAdjacent.length; i++ )
			{
				var py = aAdjacent[i][0];
				var px = aAdjacent[i][1];
				aLevel[py][px][MFLAG_] = 1;
			}
			aAdjacent = [];
			
			return ( -1 );	//moving the return statement to here...
		}
		
		
		// --------------------------------------- //
		protected function markCube ( iX, iY ):void
		{
			markedX = iX;
			markedY = iY;
			
			var mycol:Number = aLevel[iY][iX][COLOR_];
			
			var cName = "cube" + String(iY) + "_" + String(iX);
			aLevel[iY][iX][MFLAG_] = 1;
			MovieClip(mGame.getChildByName(cName)).gotoAndStop(mycol+12); //11
			
			
			if ( mycol == WILDCARD_ ) TranslationManager.instance.setTextField(mGame.helptext_txt,"<font color='#FFFFFF'>"+mTranslationData.IDS_wildcard+"</font>");
			else if ( mycol == BOMB_ ) TranslationManager.instance.setTextField(mGame.helptext_txt, "<font color='#FFFFFF'>"+mTranslationData.IDS_bomb+"</font>");
			else if ( mycol == SECRET_ ) TranslationManager.instance.setTextField(mGame.helptext_txt, "<font color='#FFFFFF'>"+mTranslationData.IDS_secret+"</font>");
			else if ( mycol == SECRET2_ ) TranslationManager.instance.setTextField(mGame.helptext_txt, "<font color='#FFFFFF'>"+mTranslationData.IDS_secret2+"</font>");
			else if ( mycol == UEBERSECRET_ ) TranslationManager.instance.setTextField(mGame.helptext_txt, "<font color='#FFFFFF'>"+mTranslationData.IDS_uebersecret+"</font>");
			
		}
		
		// --------------------------------------- //
		protected function unmarkCube ( iX, iY ):void
		{
			markedX = -1;
			markedY = -1;
			
			var cName = "cube" + String(iY) + "_" + String(iX);
			aLevel[iY][iX][MFLAG_] = 0;
			MovieClip(mGame.getChildByName(cName)).gotoAndStop(aLevel[iY][iX][COLOR_]);
		}
		
		
		// --------------------------------------- //
		public function bombsExploded ():Array
		{
			if ( (aBombs.length <= 0) && (aBombsH.length <= 0) )
			{
				return ( [0,0,false] );
			}
			else
			{
				var found:Number = 0;
				var foundWC:Number = 0;
				
				aAdjacent = [];
				
				// vertical
				var already = false;
				for ( var i:int =0; i < aBombs.length; i++ ) 
				{
					var row:int    = aBombs[i][0];
					var column:int  = aBombs[i][1];
					for ( var j:int = row; j >= 0; j-- ) {
						already = false;
						for ( var lookup:int = 0; lookup<aAdjacent.length; lookup++ ) {
							if ( (aAdjacent[lookup][0] == j) && (aAdjacent[lookup][1] == column) )
								already = true;
						}
						if ( !already ) 
						{
							aAdjacent.push( [j,column] );
						}
					}
				}
				
				found += aAdjacent.length;
			
				aBombs  = [];
				aBombsH = [];
				
				return ( [found, foundWC, true] );
			}
		}
		
		
		// --------------------------------------- //
		
		public function secretBeetles():Number
		{
			var found:Number = 0;
			var  col:int
			aAdjacent = [];
			
			for ( col=0; col < xCubes; col++ )
			{
				if ( aLevel[yCubes-1][col][COLOR_] == SECRET_ )
				{
					var kill:int
					for ( kill=col-1; kill >= 0; kill-- ) 
					{
						aAdjacent.push( [yCubes-1,kill] );
					}
					for ( kill=col+1; kill < xCubes; kill++ ) 
					{
						aAdjacent.push( [yCubes-1,kill] );
					}
					aAdjacent.push( [yCubes-1,col] );
					break;
				}
			}
			
			if ( aAdjacent.length == 0 )
			{
				for ( col=0; col < xCubes; col++ )
				{
					if ( aLevel[yCubes-1][col][COLOR_] == BOMB_ )
					{
						aAdjacent.push( [yCubes-1,col] );
					}
				}
			}
			
			found += aAdjacent.length;
		
			return ( found );
		}
		
		
		// --------------------------------------- //
		public function secretAnkh ():Number
		{
			var found:Number = 0;
			var col:int;
			aAdjacent = [];
			
			for ( col=0; col < xCubes; col++ )
			{
				if ( aLevel[yCubes-1][col][COLOR_] == SECRET2_ )
				{
					var kill:Number
					for (kill=col-1; kill >= 0; kill-- ) 
					{
						aAdjacent.push( [yCubes-1,kill] );
					}
					for (kill=col+1; kill < xCubes; kill++ ) 
					{
						aAdjacent.push( [yCubes-1,kill] );
					}
					for (kill=(yCubes-1); kill>=0; kill-- ) 
					{
						aAdjacent.push( [kill,col] );
					}
					aAdjacent.push( [yCubes-1,col] );
					break;
				}
			}
			
			if ( aAdjacent.length == 0 )
			{
				for ( col=0; col < xCubes; col++ )
				{
					if ( aLevel[yCubes-1][col][COLOR_] == BOMB_ )
					{
						aAdjacent.push( [yCubes-1,col] );
					}
				}
			}
			
			found += aAdjacent.length;
		
			return ( found );
		}

		
		// --------------------------------------- //
		public function magicFace ():Number
		{
			var found:Number = 0;
			var bFound:Boolean = false;
			var col:int
			aAdjacent = [];
			
			for ( col =0; col < xCubes; col++ )
			{
				if ( aLevel[yCubes-1][col][COLOR_] == UEBERSECRET_ )
				{
					bFound = true;
					break;
				}
			}
			
			if ( bFound ) {
				for ( var row:int =yCubes-1; row>=0; row-- )	{
					for ( col = xCubes-1; col>=0; col-- ) {
						aAdjacent.push( [row,col] );
					}
				}
			}
			
			found += aAdjacent.length;
		
			return ( found );
		}
		
		// --------------------------------------- //
		public function getPointsPosition ()
		{
			return ( [150,180] );
		}
		
		// --------------------------------------- //
		public function destroyCubes ( bBombExploded:Boolean ):Number
		{
			var count:Number = 0;
			
			lastSlide = -1;
			
			if ( aAdjacent.length > 0 )
			{
				count++;
				var row = aAdjacent[0][0];
				var col = aAdjacent[0][1];
				if ( bBombExploded ) 
				{
					GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_POP);
				}
				else if ( aLevel[row][col][COLOR_] == WILDCARD_ ) 
				{
					GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_WILD);
				}
				else if ( aLevel[row][col][COLOR_] == BOMB_ ) 
				{
					GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_POP);
				}
				else 
				{
					GameSoundManager.soundPlay(GameSoundManager.soundOn, Sounds.SND_PEEP);
				}
				for (var q:String in aLevel)
				{
				}
				if (row <= yCubes)
				{
					aLevel[row][col][COLOR_]  = EMPTY_;
					aLevel[row][col][MFLAG_]  = 0;
					aLevel[row][col][CHFLAG_] = 0;
					showCubeRight( row, col );
					aAdjacent.shift();
				}
				else 
				{
					trace ("busted!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!", row)
					trace ("row:", aLevel[row])
					trace ("col:", aLevel[row][col])
					trace ("color:", aLevel[row][col][COLOR_])
				}
			}
			return ( count );
		}
		
		
		
		// --------------------------------------- //

		public function dropCubes():Number
		{
			var iDropped:Number = 0;
			
			var cMCInst:String = "";
			var col:Number     = 0;
			var change:Number  = 0;
			var iTemp:Number   = 0;
			
			// keep track of last cell
			// in case something drops on a bomb 
			var lastCellSymbol:Number = -1;
			
			for ( var j:int =0; j < xCubes; j++ )
			{
				for ( var i:int  = (yCubes-1); i >= 0; i-- )
				{
					if ( aLevel[i][j][COLOR_] != EMPTY_ )
					{
						lastCellSymbol = aLevel[i][j][COLOR_];
					}
					else
					{
						// top row
						if ( i == 0 )
						{
							iDropped++;
							createNewCube(i,j,false);
							showCubeRight(i,j);
							
							//j = mGamexCubes+1;
							i = -1;
							break;
						}
						else
						{
							var bNew = false;
							for ( var k:int = (i-1); k >= 0; k-- )
							{
								if ( (k==0) && (aLevel[k][j][COLOR_] == EMPTY_) )
								{
									// no new bomb if it drops more than 2
									if ( (i-k) > 2 ) createNewCube(k,j,true);
									else createNewCube(k,j,false);
									
									showCubeRight(i,j);
									bNew = true;
								}
								
								col = aLevel[k][j][COLOR_];
								change = aLevel[k][j][CHFLAG_];
								
								if ( col != EMPTY_ )
								{
									iDropped++;
									// set new cube //
									aLevel[i][j][COLOR_]  = col; //k+1
									aLevel[i][j][CHFLAG_] = change; //k+1
									showCubeRight(i,j); //k+1
									// reset old cube //
									aLevel[k][j][COLOR_]  = EMPTY_;
									aLevel[k][j][CHFLAG_] = 0;
									showCubeRight(k,j);
								
									// bombs dropped more than 2 rows?
									
									if ( (col == BOMB_) ) 
									{
										if ( (i>(k+2)) || ((i>(k+1)) && bNew)) 
										{
											aBombs.push( [i,j] );
										}
									}
									
									i = -1;
									break;
								}
							}
						}
					}
				}
			}
		
			return ( iDropped );
		}
		
		// --------------------------------------- //
		protected function createNewCube ( row:int, col:int, bCreateLevel:Boolean ):void
		{
			var newcol:Number = lastCol;
			var changer:Number = 0;
		
			if ( !bCreateLevel ) {
				var r0 = Math.round(Math.random() * 10000);
				var r1 = Math.round(Math.random() * 3000);
				var r2 = Math.round(Math.random() * 25);
				if ( r0 == 3456 ) newcol = UEBERSECRET_;
				else if ( r1 == 1111 ) newcol = SECRET_;
				else if ( r1 == 2222 ) newcol = SECRET2_;
				else if ( (r2 == 15) && (lastCol != WILDCARD_) ) newcol = WILDCARD_;
				else if ( (r2 == 10) && (lastCol != BOMB_) ) newcol = BOMB_;
			}
		
			if ( row<(yCubes-1) ) 
			{
				while ( (newcol == lastCol) || (newcol == aLevel[row+1][col][COLOR_]) ) 
				newcol = 1 + Math.floor(Math.random()* colors);
			}
			if ( col<(xCubes-1) ) {
				while ( (newcol == lastCol) || (newcol == aLevel[row][col+1][COLOR_]) ) newcol = 1 + Math.floor(Math.random() * colors);
			}
			else 
			{
				while ( newcol == lastCol ) newcol = 1 + Math.floor(Math.random() * colors);
			}
			
			lastCol = newcol;
		
			aLevel[row][col][COLOR_]  = newcol;
			aLevel[row][col][MFLAG_]  = 0;
			aLevel[row][col][CHFLAG_] = changer;
		}
		
		// --------------------------------------- //
		protected function resetMarkedCubes ():void
		{
			var cName:String = "";
			var i:int;
			for ( i =0; i < yCubes; i++ ) {
				for ( var j:int =0; j < xCubes; j++ ) {
					if ( aLevel[i][j][MFLAG_] == 1 ) {
						aLevel[i][j][MFLAG_] = 0;
						showCubeRight(i,j);
					}
				}
			}
			
			if ( bShowNext ) {
				for ( i=0; i<aNextMove.length; i++ ) {
					showCubeRight( aNextMove[i][0], aNextMove[i][1] );
				}
				bShowNext = false;
				aNextMove = [];
			}
		}
		
		// ---------------------------------------- //	
		protected function showCubeRight ( row:int, col:int ):void
		{
			var cName:String  = "cube" + String(row) + "_" + String(col);
			var cube:MovieClip = MovieClip(mGame.getChildByName(cName))
			
			var mycol:Number  = aLevel[row][col][COLOR_];
			var mark:Number   = aLevel[row][col][MFLAG_];
			var change:Number = aLevel[row][col][CHFLAG_];
		
			
			
			
			if ( mycol == EMPTY_ )
				cube.gotoAndStop( 26 );
			else
				cube.gotoAndStop( mycol );
		}
		
		// --------------------------------------- //
		protected function showLevel ():void
		{
			for ( var row:int = 0; row < yCubes; row++ ) {
				var str:String = "";
				for ( var col:int =0; col<xCubes; col++ ) {
					str += aLevel[row][col][COLOR_] + ", "
				}
			}
		}
		
		// --------------------------------------- //
		public function getMoves ():Array
		{
			var t = getTimer();
			
			var bFound:Boolean  = false;
			var aMark:Array  = [];
			var mycol:int   = 0;
			var gridcol:int  = 0;
			var px:Number = 0;
			var py:Number = 0;

			
			for ( var row:int = 0; row<yCubes; row++ ) 
			{
				for ( var col:int = 0; col<xCubes; col++ ) 
				{
					
					for ( var pat:int =0; pat<aPatterns.length; pat++ ) 
					{
						
						bFound = true;
						mycol  = aLevel[row][col][COLOR_];
						for ( var p=0; p<aPatterns[pat].length; p++ ) 
						{
							
							px = aPatterns[pat][p][0];
							py = aPatterns[pat][p][1];
							
							if ( ((row+py)<0) || ((col+px)<0) || ((row+py)>=yCubes) || ((col+px)>=xCubes) ) 
							{
								bFound = false;
							}
							else
							{
								gridcol = aLevel[row+py][col+px][COLOR_];
								// 
								if ( (mycol == WILDCARD_) && (gridcol != WILDCARD_) ) 
								{
									mycol = gridcol;
								}
								else if ( (gridcol != mycol) && (gridcol != WILDCARD_) ) 
								{
									bFound = false;
								}
							}
						}
						
						if ( bFound ) {
							aMark.push( [row,col] );
							for ( var p2:int = 0; p2<aPatterns[pat].length; p2++ ) {
								px = aPatterns[pat][p2][0];
								py = aPatterns[pat][p2][1];
								aMark.push( [ row+py, col+px ] );
							}
							
							// exit loop
							pat = aPatterns.length;
							col = xCubes;
							row = yCubes;
						}
					}
					
				}
			}
		
			speedSum += (getTimer()-t);
			speedCount++;
			
			return ( aMark );
		}
		
		// --------------------------------------- //
		public function markNextMove( aMark:Array ):void
		{
			for ( var i=0; i<aMark.length; i++ ) 
			{
				var mycol = aLevel[ aMark[i][0] ][ aMark[i][1] ][COLOR_];
				var cName = "cube" + String(aMark[i][0]) + "_" + String(aMark[i][1]);
				//aLevel[iY][iX][MFLAG_] = 1;
				MovieClip(mGame.getChildByName(cName)).gotoAndStop(mycol+29);
			}
			bShowNext = true;
			aNextMove = aMark;
		}
		
		// --------------------------------------- //
		protected function setTestLevel ():void
		{
			aLevel[0][0][COLOR_] = WILDCARD_;
			showCubeRight(0,0);
			aLevel[0][3][COLOR_] = WILDCARD_;
			showCubeRight(0,3);
		}
		
		// --------------------------------------- //
		protected function testLevel():void
		{
			for ( var row:int = (yCubes-1); row>=0; row-- ) {
				for ( var col:int =0; col<xCubes; col++ ) {
					if ( row == (yCubes-1) && col == (xCubes-1) ) aLevel[row][col][COLOR_] = BOMB_;
					//else if ( col == (xCubes-1) ) aLevel[row][col][COLOR_] = 2;
					showCubeRight(row,col);
				}
			}
		}
		
		// --------------------------------------- //





		//----------------------------------------
		//PROTECTED METHODS
		//----------------------------------------
		
		/**
		 *	Set up various variables
		 **/
		protected function setupVars():void
		{
			// if there's a pattern like this - game's not over
			aPatterns.push( [[ 1, 1],[ 2, 0]] ); // x   x
			aPatterns.push( [[ 1,-1],[ 2, 0]] ); //   x
			aPatterns.push( [[ 1, 1],[ 0, 2]] );
			aPatterns.push( [[-1, 1],[ 0, 2]] );
			
			aPatterns.push( [[ 1, 0],[ 2, 1]] );
			aPatterns.push( [[ 1, 1],[ 2, 1]] );
			aPatterns.push( [[ 0, 1],[-1, 2]] );
			aPatterns.push( [[-1, 1],[-1, 2]] );
			
			aPatterns.push( [[ 1,-1],[ 2,-1]] );
			aPatterns.push( [[ 1, 0],[ 2,-1]] );
			aPatterns.push( [[ 0, 1],[ 1, 2]] );
			aPatterns.push( [[ 1, 1],[ 1, 2]] );
			
			aPatterns.push( [[ 1, 0],[ 3, 0]] ); // xx x
			aPatterns.push( [[ 2, 0],[ 3, 0]] );
			aPatterns.push( [[ 0, 1],[ 0, 3]] );
			aPatterns.push( [[ 0, 2],[ 0, 3]] );
		}

		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------

		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------

	}

}