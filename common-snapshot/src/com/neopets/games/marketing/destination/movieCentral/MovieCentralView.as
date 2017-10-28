/**
 *	Destination shell class (document class for the project)
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

package com.neopets.games.marketing.destination.movieCentral
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import flash.events.Event;
	import flash.display.LoaderInfo;	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.destinationV2.*
	
	
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	
	
	
	public class MovieCentralView extends AbsView
	{
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		private var mControl:MovieCentralControl;
		private var TypeID:int = 14		// use 14 for all destination projects
		private var NeoContentID:int = 1652	// get this Id from marketing
		
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		public function MovieCentralView():void
		{
			super()
			mControl = new MovieCentralControl (this)
			addEventListener(USER_NAME_SET, onUserNameSet);
			init(mControl, TypeID, NeoContentID)
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