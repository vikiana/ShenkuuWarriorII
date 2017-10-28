/**
 *	Destination shell class (document class for the project)
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 *	@modified Nov.2009
 */

package com.neopets.games.marketing.destination.littlestPetShop2010
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import flash.events.Event;
	
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.destinationV3.AbsView;
	import com.neopets.projects.destination.destinationV3.Parameters;

	
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	
	
	
	public class DestinationView extends AbsView
	{
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		private var mNeoContentProjectID:String = "1691"	//please obtain legit NeoContentID from Producer
		private var mFlashVarBaseURL:String = "baseurl"		//please talk to php person to find the flashvar property name to get baseURL (dev. vs www.) usually it should be "baseurl" and you must have this for this to work properly
		private var mAssetPath:String = "sponsors/littlestpetshop/2010/petsonparade/artAssets" //temp directory
		//private var mAssetPath:String = "sponsors/testdestination/artAssets"	// final pathway
		private var mOnlineMode:Boolean = true;	//change this before putting live.
		private var mGroupMode:Boolean = true;		//it's only important when each page needs to load assets.
		
		
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		
		/**
		*	instantiate control class and set up project ID
		**/
		public function DestinationView():void
		{			
			super()
			setBaseURLs(mFlashVarBaseURL);
			init (new DestinationControl (), mNeoContentProjectID, mGroupMode, mOnlineMode);
			Parameters.assetPath = mAssetPath;
		}
		
		//----------------------------------------
		//GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//PROTECTED METHODS
		//----------------------------------------
		
		/**
		*	This is called after inital prameters are set (view, control, user name and project ID)
		*	remove spinning arrow or do other things as you please
		**/
		protected override function  setupReady ():void
		{
			trace ("   remove loading arrow sign")
			if (getChildByName("loaderArrow") != null) removeChild(getChildByName("loaderArrow"));
		}
		
		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
				
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------
	}
}