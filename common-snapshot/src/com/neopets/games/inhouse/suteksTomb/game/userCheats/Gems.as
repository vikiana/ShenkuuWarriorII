/**
 *	Gems class
 *	Not exactly sure what the purpose this gem and gems classes are. but they are used
 *	Maybe this is part of cheat or something special...?
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  Nov.2009
 */

package  com.neopets.games.inhouse.suteksTomb.game.userCheats
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------

	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.games.inhouse.suteksTomb.game.Game;

	
	
	public class Gems
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		private var aGems:Array = [];
		private var aJams:Array = [];
		private var aKC:Array;
		private var keyBuffer:String = "";
		private var mGame:Game;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function Gems(pGame:Game):void
		{
			
			mGame = pGame
			/**
			 *	Cheats spell out below:
			 *	a) plzsutekcanihavemoretime
			 *	b) pyramibread
			 *	"plzsutekcanihavemoretime" can be typed only once per game play and it will reset the timer
			 *	"pyramibread" can be typed multiple times and will show the next move
			 **/
			
			
			this.aJams.push( [112,108,122,115,117,116,101,107,99,97,110,105,104,97,118,101,109,111,114,101,116,105,109,101] );
			this.aJams.push( [112,121,114,97,109,105,98,114,101,97,100] );
			this.aKC = [16,17,19,20,45,91,144,145];
			
			for ( var i=0; i < aJams.length; i++ ) 
			{
				var str:String = "";
				for ( var j=0; j< aJams[i].length; j++ ) {
					str += String.fromCharCode( this.aJams[i][j] );	
				}
				//trace (str)
				this.aGems.push( new Gem(str, false, false) );
			}
			//trace (aGems)
			this.aGems[1].multiple = true;
		}

		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		
		public function resetGems():void
		{
			//trace ("gems reset")
			for ( var i=0; i < aGems.length; i++ ) aGems[i].found = false;
		}
		
		//what's the point in taking char param when you never use it...????
		//visit this class later...
		public function checkGem (char:uint):void
		{
			var kc = char;
			var i:int;
			// F1-F12
			/*
			if ( (kc>=112) && (kc<=123) ) {
				return;
			}
			else if ( (kc>=33) && (kc<=40) ) {
				return;
			}
			*/
			
			for (i=0; i<this.aKC.length; i++ ) 
			{
				if ( kc == this.aKC[i] ) return;
			}
			
			this.keyBuffer += String.fromCharCode(char);
	
			var len = this.keyBuffer.length;
			
			var whichFound = -1;
			for (i=0; i<this.aGems.length; i++ )
			{
				if ( this.keyBuffer == this.aGems[i].cheat )  {
					if ( !this.aGems[i].found || this.aGems[i].multiple ) {
						this.aGems[i].found = true;
						whichFound = i;
						break;
					}
				}
			}
			
			// found nothing
			if ( whichFound == -1 )
			{
				var bMatch = false;
				for (i=0; i<this.aGems.length; i++ )
				{
					if ( this.keyBuffer.substr(0,len) == this.aGems[i].cheat.substr(0,len) )
						bMatch = true;
				}
				if ( !bMatch ) this.keyBuffer = String.fromCharCode(char);
				//trace("keyBuffer: "+this.keyBuffer);
			}
			else
			{
				if ( whichFound == 0 ) mGame.resetTime();
				else if ( whichFound == 1 ) mGame.showNextMove();
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