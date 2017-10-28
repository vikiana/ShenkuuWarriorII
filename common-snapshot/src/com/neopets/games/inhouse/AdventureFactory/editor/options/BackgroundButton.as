
/* AS3
	Copyright 2008
*/

package com.neopets.games.inhouse.AdventureFactory.editor.options
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.util.general.GeneralFunctions;
	
	import com.neopets.games.inhouse.AdventureFactory.game.GameWorld;
	import com.neopets.games.inhouse.AdventureFactory.AdventureFactory_GameScreen;
	import com.neopets.games.inhouse.AdventureFactory.editor.ImageTab;
	import com.neopets.games.inhouse.AdventureFactory.editor.LevelPane;
	
	/**
	 *	This class links an image-based tab to the game world's background.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  07.12.2010
	 */
	 
	public class BackgroundButton extends ImageTab
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function BackgroundButton():void{
			super();
			autoScale = true;
			selectionEvent = LevelPane.SET_BACKGROUND;
			// when we turn on, change the game screen's background
			addEventListener(Event.SELECT,onSelect);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		override public function set imageID(id:String) {
			if(_imageID == id) return;
			_imageID = id;
			// replace existing image
			var replacement:DisplayObject = GeneralFunctions.getDisplayInstance(_imageID);
			replaceImage(replacement);
			// check if we match the world's background
			if(_defaultDispatcher != null) {
				var screen:AdventureFactory_GameScreen = _defaultDispatcher as AdventureFactory_GameScreen;
				if(screen != null) {
					var world:GameWorld = DisplayUtils.getDescendantInstance(screen,GameWorld) as GameWorld;
					if(world != null) selected = (world.backgroundClass == _imageID);
				}
			}
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
