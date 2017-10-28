/**
 *	Destination shell class (document class for the project)
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

package com.neopets.games.marketing.destination.kidCuisine
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import flash.events.Event;
		
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.destinationV2.*
	
	
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	
	
	
	public class KidView extends AbsView
	{
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		private var mControl:KidControl;
		
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		public function KidView():void
		{
			super()
			mControl = new KidControl (this)
			addEventListener(USER_NAME_SET, onUserNameSet);
			init()
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
				
		
		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
		
		//when user name is set, call ready for setup (readyForSetup defined by parent class)
		private function onUserNameSet (evt:Event):void
		{
			removeChild(getChildByName("loaderArrow"))
			readyForSetup()
		}
		
		
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------
	}
}