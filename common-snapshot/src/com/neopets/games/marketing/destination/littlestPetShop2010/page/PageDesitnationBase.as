
/**
 *	@NOTE: DO NOT USE THIS CLASSS DIRECTLY. 
 *	@NOTE: TO CREATE A "PAGE", PLEASE CREATE A CLASS AND EXTEND EITHER THIS CLASS OR "AbstractPage"
 *
 *	Extension of Abstract Page with MouseOver and MouseOut stage (should you have buttons with such state)
 *	Any MovieClips (or Sprites) buttons you add on (child of) this class must have a MovieClip or a Sprite
 *	within itself at the most top layer and name it "btnArea".  
 *	That's the only way to activate the MouseOver and MouseOut state.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

	

package com.neopets.games.marketing.destination.littlestPetShop2010.page
{
	
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import flash.filters.GlowFilter;
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.destinationV3.AbsPageWithLoader;

	
	public class PageDesitnationBase extends AbsPageWithLoader {
		
		
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		
		//----------------------------------------
		//CONSTRUCTOR
		//----------------------------------------
		public function PageDesitnationBase(pName:String = null) 
		{
			super(pName)
		}		
		
		//----------------------------------------
		//GETTERS AND SETTERS
		//----------------------------------------
		
		
		
		
		//----------------------------------------
		//PUBLIC METHODS 
		//----------------------------------------
				
		//----------------------------------------
		//PROTECTED METHODS
		//----------------------------------------
		
		 /**
		  *	Default is set to white glow around the display object when MouseOver.
		  *	For different effects, child class should override this function
		  *
		  *	@NOTE: This display Object must have MC within itself named "btnArea" at the top layer
		  * @NOTE: If the display Object has a "over" state (as frame lable) it'll stop at that state
		  **/
		protected override function handleMouseOver(evt:MouseEvent):void
		{
			if (evt.target.name == "btnArea")
			{
				var mc:MovieClip = evt.target as MovieClip
				if (!mc.buttonMode) mc.buttonMode = true;
				MovieClip(mc.parent).gotoAndStop("over")
				//MovieClip(mc.parent).filters = [new GlowFilter(0xFFFFFF, 1, 16, 16, 2, 3)]
			}
		}
		
		
	
		/**
		 *	Default is set have no filter on the display object when MouseOut.
		 *	For different effects, child class should override this function
		 *
		 *	@NOTE: This display Object must have MC within itself named "btnArea" at the top layer
		 *	@NOTE: If the display Object has a "out" state (as frame lable) it'll stop at that state
		 **/
		protected override function handleMouseOut(evt:MouseEvent):void
		{
			if (evt.target.name == "btnArea")
			{
				var mc:MovieClip = evt.target as MovieClip
				MovieClip(mc.parent).gotoAndStop("out")
				//MovieClip(mc.parent).filters = null
			}
		}
		
		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
		
				
		
		//----------------------------------------
		//EVENT LISTENER
		//----------------------------------------
	}
}
		