/**
 *	Destination example shell class (document class for the project)
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 *	@modified Nov.2009
 */

package com.neopets.games.marketing.destination.kidCuisine2
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import flash.events.Event;
	import flash.text.TextField;
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.destinationV3.AbsView;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.flashvars.FlashVarsFinder;
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	
	
	
	public class DestinationView extends AbsView
	{
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		// constants
		public static const IMAGE_HOST_VAR:String = "imageHost";
		// private variables
		private var mNeoContentProjectID:String = "0000"	//please obtain legit NeoContentID from Producer
		private var mOnlineMode:Boolean = false;
		private var mGroupMode:Boolean = true;
		
		
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		
		/**
		*	instantiate control class and set up project ID
		**/
		public function DestinationView():void
		{
			super()
			setImageHost(IMAGE_HOST_VAR);
			init (new DestinationControl (), mNeoContentProjectID, mGroupMode, mOnlineMode)
			
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
			//trace ("   remove loading arrow sign")
			//if (getChildByName("loaderArrow") != null) removeChild(getChildByName("loaderArrow"));
		}
		
		/**
		*	This function lets you set up the image host and base url given the name of the image host
		*   flash var.  It also check for online mode.
		**/
		function setImageHost(pVarID:String):void
		{
			var imageURL:String = FlashVarsFinder.findVar(this.stage.root,pVarID);
			// make sure we start with http:
			if(imageURL != null) {
				if(imageURL.indexOf("http://") < 0) imageURL = "http://" + imageURL;
			}
			Parameters.imageURL = imageURL;
			// set online mode
			mOnlineMode = (imageURL != null);
			// set the base url
			switch(imageURL) {
				case "http://images50.neopets.com":
					Parameters.baseURL = "http://dev.neopets.com";
					break;
				case "http://images.neopets.com":
					Parameters.baseURL = "http://www.neopets.com";
					break;
				case null:
					Parameters.baseURL = "http://dev.neopets.com";
					Parameters.imageURL = "http://images50.neopets.com";
					break;
			}
		}
		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
				
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------
		
	}
}