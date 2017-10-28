/**
 *	This class handles sending getting and displaying trivia questions.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.09.2010
 */

package com.neopets.games.marketing.destination.frootLoops.fruityFun
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	
	public class VideoData extends Object
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		public var URL:String;
		public var height:Number;
		public var width:Number;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function VideoData(path:String=null,w:Number=0,h:Number=0):void {
			URL = path;
			width = w;
			height = h;
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