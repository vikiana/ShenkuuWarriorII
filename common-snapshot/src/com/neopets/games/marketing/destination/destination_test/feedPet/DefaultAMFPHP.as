/**
 *	It simply extends feedAPetMain (abstract class to deal with amfphp side of feedapet)
 *
 *	IMPORTANT: BE SURE TO NOTIFY PHP PERSON (JOE) AND HAVE HIM OR HER ADD YOUR FEEDCODE AS A LEGIT ID
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  07.6.2009
 */

package com.neopets.games.marketing.destination.destination_test.feedPet
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.destinationV3.feedapet.AbsFeedAPetAMFPHP;
		
	public class DefaultAMFPHP extends AbsFeedAPetAMFPHP
	{
		
		//----------------------------------------
		//	CONSTANT
		//----------------------------------------
		
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function DefaultAMFPHP(pID:String = null):void
		{
			super(pID);
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
	}
	
}