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

package  com.neopets.games.inhouse.FaerieBubblesAS3.game
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	

	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------

	
	
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
		private var keyBuffer:String = "";
		private var mGame:Game;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function Gems(pGame:Game):void
		{
			trace ("gems activated")
			//These are basically names... not sure why they are cheats...
			//stardust, faerieland, slumberberry, bubbles
			
			mGame = pGame
			
			aJams.push( [115,116,97,114,100,117,115,116] );
			aJams.push( [102,97,101,114,105,101,108,97,110,100] );
			aJams.push( [115,108,117,109,98,101,114,98,101,114,114,121] );
			aJams.push( [98,117,98,98,108,101,115] );
			
			for ( var i=0; i < aJams.length; i++ ) 
			{
				var str = "";
				for ( var j=0; j< aJams[i].length; j++ ) {
					str += String.fromCharCode( aJams[i][j] );	
				}
				trace (str)
				aGems.push( new Gem(str, false, false) );
			}
			trace (aGems)
		}

		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		
		public function resetGems():void
		{
			trace ("gems reset")
			for ( var i=0; i < aGems.length; i++ ) aGems[i].found = false;
		}
		
		//what's the point in taking char param when you never use it...????
		//visit this class later...
		public function checkGem (char:uint):void
		{
			// no gem if course is active!
			//if in instructions return nothing... this should be checked later on
			//if ( _global.gGame.bInstructions ) return;
	
			keyBuffer += String.fromCharCode(char)
	
			var len = keyBuffer.length;
			var whichFound = -1;
			
			var i:Number;
			
			for (i=0; i<aGems.length; i++ )
			{
				if (keyBuffer == aGems[i].cheat )  {
					if ( !aGems[i].found || aGems[i].multiple ) {
						aGems[i].found = true;
						whichFound = i;
						break;
					}
				}
			}
			
			// found nothing
			if ( whichFound == -1 )
			{
				var bMatch = false;
				for (i=0; i<aGems.length; i++ )
				{
					if ( keyBuffer.substr(0,len) == aGems[i].cheat.substr(0,len) )
						bMatch = true;
				}
				
				
				if ( !bMatch ) this.keyBuffer = String.fromCharCode(char);
				trace("keyBuffer: "+this.keyBuffer);
			}
			else
			{
				trace ("correct cheat code:", whichFound)
				//visit here again later
				if ( whichFound == 0 ) mGame.giveNova();
				else if ( whichFound == 1 ) mGame.giveRainbow();
				else if ( whichFound == 2 ) mGame.giveTop();
				else if ( whichFound == 3 ) mGame.giveExtra();
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