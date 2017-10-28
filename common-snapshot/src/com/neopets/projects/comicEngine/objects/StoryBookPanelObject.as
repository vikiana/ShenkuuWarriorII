
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
	 
	public class StoryBookPanelObject 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		public var asset_url:String;							//The Location for the Click Through Event
		public var content_prefix:String;					//The Front of the TranslationID
		public var clickable_objects:Array;				//If there is an 
		public var name:String 									//The ID of the Panel
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function StoryBookPanelObject():void
		{
			clickable_objects = [];
		}
		
		
	}
	
}
