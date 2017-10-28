/* AS3
	Copyright 2009
*/

package com.neopets.projects.comicEngine.gui
{

	import com.neopets.util.events.MultitonEventDispatcher;
	
	
	/**
	 *	This is for the MultiFrame Artwork with a Keyframe for each language Used
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern StoryEngine
	 * 
	 *	@author Clive Henrick
	 *	@since  9.27.2009
	 */
	 
	public class StoryBookLogoArtwork extends StoryBookAbsArtwork 
	{
		

		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function StoryBookLogoArtwork():void
		{
			mSingletonED = MultitonEventDispatcher.getInstance(StoryBookLogoSymbol.KEY);
			mSingletonED.addEventListener(StoryBookAbsArtwork.TRANSLATE_ARTWORK, changeArtworkEvent, false, 0 , true);
		}
		
		
		

	}
	
}
