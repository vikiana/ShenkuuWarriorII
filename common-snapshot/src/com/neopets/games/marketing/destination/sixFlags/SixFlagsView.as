/**
 *	Destination shell class (document class for the project)
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

package com.neopets.games.marketing.destination.sixFlags
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import flash.events.Event;
	
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.*
	
	
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	
	
	
	public class SixFlagsView extends AbstractDestinationView
	{
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		//private var variable
		private var mControl:SixFlagsControl;
		
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		public function SixFlagsView():void
		{
			super()
			mainControlInit()
			addEventListener(USER_NAME_SET, onUserNameSet);
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
		
		//Be sure to instantiate the child class of DestinationMain class you've created
		protected override function mainControlInit():void
		{
			mControl = new SixFlagsControl (this)
		}
		
		
		
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