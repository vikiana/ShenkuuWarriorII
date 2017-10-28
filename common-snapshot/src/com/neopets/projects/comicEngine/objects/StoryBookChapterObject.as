/* AS3
	Copyright 2008
*/
package  com.neopets.projects.comicEngine.objects
{

	
	
	/**
	 * This is a Simple Storage Object 
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern StoryEngine
	 * 
	 *	@author Clive Henrick
	 *	@since  9.08.2009
	 */
	 
	public class StoryBookChapterObject 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		public var logo_asset_url:String;				//The Location for the Click Through Event
		public var nav_asset_url:String;					//The Front of the TranslationID
		public var panels:Array;							//If there is an 
		public var id:String 									//The ID of the Panel
		public var content_id:int 						// This is the Translation ID for the Chapter
		public var hash:String;							// The Optional Hash Table from PHP
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function StoryBookChapterObject():void
		{
			panels = [];
		}
		
		
	}
	
}
