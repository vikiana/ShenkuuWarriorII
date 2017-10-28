
/* AS3
	Copyright 2008
*/
package com.neopets.projects.neopetsGameShell.view.ui
{
	import com.caurina.transitions.*;
	import com.neopets.util.button.NeopetsButton;
	
	import fl.motion.easing.*;
	
	import flash.display.MovieClip;
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
	 
	public class SpecialButton extends NeopetsButton
	{
		
		
		//--------------------------------------
		//  PRIVATE / PUBLIC VARIABLES
		//--------------------------------------
		
		public var paw:MovieClip;
		public var bubble:MovieClip;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function SpecialButton()
		{
			super();
			paw.visible = false;
		}
		

		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		protected override function onRollOver(evt:MouseEvent):void 
		{
			if (!mLockout)
			{
				Tweener.addTween(
					bubble,
					{
						time: .5,
						scaleX:.8,
						scaleY:.8,
						ease:Elastic.easeOut
					}
				);
				paw.visible=true;
				checkSoundPlayBack(evt);
				gotoAndStop("on");
			}
		}
		
		protected override function onRollOut(evt:MouseEvent):void 
		{
			if (!mLockout)
			{
				Tweener.addTween(
					bubble,
					{
						time: .5,
						scaleX:1,
						scaleY:1,
						ease:Elastic.easeOut
					}
				);
				paw.visible=false;
				checkSoundPlayBack(evt);
				gotoAndStop("off");	
			}
		}
	}
	
}
