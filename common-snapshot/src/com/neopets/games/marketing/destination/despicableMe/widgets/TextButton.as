
/* AS3
	Copyright 2008
*/
package com.neopets.games.marketing.destination.despicableMe.widgets
{
	import com.neopets.util.button.NeopetsButton;
	
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	
	/**
	 *	This is an Example of a Special Button Extending the NeoPets Button Class
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern 
	 * 
	 *	@author Clive Henrick
	 *	@since  01.02.2009
	 */
	 
	public class TextButton extends NeopetsButton
	{
		//--------------------------------------
		//  PRIVATE / PUBLIC VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function TextButton()
		{
			super();
			// search for label
			if(label_txt == null) {
				var dobj:DisplayObject;
				for(var i:int = 0; i < numChildren; i++) {
					dobj = getChildAt(i);
					if(dobj != null && dobj is TextField) {
						label_txt = dobj as TextField;
						break;
					}
				} // end of search loop
			}
		}
		

		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
	}
}
