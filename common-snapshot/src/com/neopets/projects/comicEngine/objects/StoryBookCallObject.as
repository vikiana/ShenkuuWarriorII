
/* AS3
	Copyright 2008
*/
package  com.neopets.projects.comicEngine.objects
{
	import flash.net.registerClassAlias;
	
	/**
	 * This is a Simple Storage Object 
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern StoryEngine
	 * 
	 *	@author Clive Henrick
	 *	@since  10.08.2009
	 */
	 
	public class StoryBookCallObject 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		public var call_function:String;
		public var call_params:Array;							//Parameters
		public var attach_symbol:String;					//Name of the Object for the Click Through event
		public var rollover_effect:String;					//Name of the HighLight Effect

		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function StoryBookCallObject():void
		{
				//registerClassAlias("Comic.ClickObjectCallVO", com.neopets.projects.comicEngine.objects.StoryBookCallObject);
		}
		
		
	}
	
}
