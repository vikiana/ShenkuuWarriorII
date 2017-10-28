/**
 *	It simply extends feedAPetMain (abstract class to deal with amfphp side of feedapet)
 *	no new stuff needed to be created
 *
 *	IMPORTANT: BE SURE TO NOTIFY PHP PERSON AND HAVE HIM OR HER ADD YOUR FEEDCODE AS A LEGIT ID
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

package com.neopets.games.marketing.destination.kidCuisine2.feedAPet
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	
	
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.destinationV2.feedapet.AbsFeedAPetAMFPHP;
		
	public class DefaultAMFPHP extends AbsFeedAPetAMFPHP
	{
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		//private var variable
		
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		public function DefaultAMFPHP(pID:String = null):void
		{
			super(pID);
		}
		
		//----------------------------------------
		//GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------
	}
	
}