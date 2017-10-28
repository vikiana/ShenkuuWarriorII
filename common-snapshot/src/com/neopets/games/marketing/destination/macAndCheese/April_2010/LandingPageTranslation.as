package com.neopets.games.marketing.destination.macAndCheese.April_2010
{
	import virtualworlds.lang.TranslationData;
	
	/**
	 *	This is list of the Resouce IDs and their valuesthat will be used in a Game.
	 *  These are used to find the "resname" atttribute in the returned XML from Neopets
	 *  Create your own TranslationData (example: NeeterballTranslationData) and extend this class.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern 
	 * 
	 *	@author David Cary
	 *	@since  3.23.2010
	 */
	 
	public class LandingPageTranslation extends TranslationData
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		public var aboutHeader:String = "About Mac and Cheese";
		public var aboutText:String = "cheesy..";
		public var instructionHeader:String = "Instructions";
		public var instructionText:String = "<font size='18'>A stadium has exploded and all of the pieces have landed in Neopia!  Can you find them all? \n\n When a piece of the stadium is available to find, its matching piece in the rubble on the page will turn white.  Click that piece to get a clue as to where it can be found.  When you find each piece, you'll earn a virtual prize!  Find all 14 pieces and earn an EXCLUSIVE Neohome item, brought to you by KRAFT Macaroni & Cheese Dinner! \n\n Be sure to check back each week to see which new pieces have been released!</font>";
		public var loggedOutHeader:String = "Please Log In";
		public var loggedOutText:String = "You must be <a href='%login'><u>logged in</u></a> to participate.";
		public var hintHeader:String = "Hint";
		public var pieceFoundHeader:String = "Piece Found!";
		public var pieceFoundText1:String = "Congratulations! You found a piece of the stadium!";
		public var pieceFoundText2:String = "As a reward, you will receive the following prize:";
		public var claimPrize:String = "Click <a href='%event'><u>here</u></a> to claim your prize!";
		public var finalPieceFoundText:String = "Congratulations, you found all pieces of the stadium and have earned an EXCLUSIVE Neohome item, brought to you by KRAFT Macaroni & Cheese!";
		public var claimSuccessHeader:String = "Prize Claimed";
		public var claimSuccessText:String = "%prize has been added to your <a href='%url'><u>inventory</u></a>.";
		public var anotherPrize:String = "Hey! There's another <a href='%event'><u>prize</u></a> waiting for you...";
		public var claimErrorHeader:String = "Prize Error";
		public var claimErrorText:String = "Hmm, there seems to have been some kind of error claiming your prize. Reload the page and try again!";
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function LandingPageTranslation(){}
		
		//--------------------------------------
		//  PUBLIC FUNCTIONS
		//--------------------------------------
		
		

	}
	
}
