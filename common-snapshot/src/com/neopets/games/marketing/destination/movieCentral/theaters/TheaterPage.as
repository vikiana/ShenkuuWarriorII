/**
 *	This is the main theater page,  unelss there are main changes how a theater should be this will always kick in  
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  07.16.2009
 */
 
package com.neopets.games.marketing.destination.movieCentral.theaters
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.destinationV2.movieTheater.AbsTheaterPage;
	import com.neopets.projects.destination.destinationV2.videoPlayerComponent.VideoPlayerSingleton;
	import com.neopets.util.tracker.NeoTracker;
	import flash.events.Event
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------
		
	public class TheaterPage extends AbsTheaterPage
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		
		/**
		 *	constrcutor of the class
		 *	@PARAM		pName		String		Name of the class (this.name)
		 *	@PARAM		pView		String		view class where instance of this class will be added to
		 **/
		public function TheaterPage(pName:String = null, pView:Object = null):void
		{
			super (pName, pView)
		}
		
		
		override protected function onVideoViewed(evt:Event)
		{
			trace ("on video viewed from theater page")
			VideoPlayerSingleton.instance.removeEventListener(VideoPlayerSingleton.VIDEO_VIEWED, onVideoViewed)
			NeoTracker.instance.trackNeoContentID(14782)
			
		}
		
	}
}