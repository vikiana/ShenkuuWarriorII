/**
 *	This class provides listener and close button behaviour for simple pop ups.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.09.2010
 */

package com.neopets.games.marketing.destination.HOP2011.widgets.downloads
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	
	public class DownloadableData extends Object
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		public var imageClass:String;
		public var caption:String;
		public var clickPath:String;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function DownloadableData(img:String=null,cap:String=null,path:String=null):void {
			super();
			imageClass = img;
			caption = cap;
			clickPath = path;
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
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