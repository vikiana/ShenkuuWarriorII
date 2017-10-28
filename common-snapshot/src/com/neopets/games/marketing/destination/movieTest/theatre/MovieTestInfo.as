/**
 *	MOVIE INFO
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

package com.neopets.games.marketing.destination.movieTest.theatre
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	//import flash.utils.getDefinitionByName;
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.movieTheatre.MovieInfo
	
	public class MovieTestInfo extends MovieInfo
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function MovieTestInfo (pImage:MovieClip, pVideoSource:String, pClickLinkID:String = null,  pHint:String = null, pDescription:String = null):void
		{			
			super(pImage, pVideoSource, pClickLinkID,  pHint, pDescription)
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