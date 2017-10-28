
/* AS3
	Copyright 2008
*/

package com.neopets.games.inhouse.AdventureFactory.editor.options
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.util.general.GeneralFunctions;
	
	import com.neopets.games.inhouse.AdventureFactory.game.GameWorld;
	import com.neopets.games.inhouse.AdventureFactory.AdventureFactory_GameScreen;
	import com.neopets.games.inhouse.AdventureFactory.editor.ImageTab;
	import com.neopets.games.inhouse.AdventureFactory.editor.LevelPane;
	
	/**
	 *	This class links an image-based tab to the game world's goal.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  07.12.2010
	 */
	 
	public class GoalButton extends ImageTab
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
		
		public function GoalButton():void{
			super();
			selectionEvent = LevelPane.CHANGE_GOAL;
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
					if(world != null) selected = (world.goalClass == selectionData);
				}
			}
		}
		
		override public function get selectionData():Object {
			if(_loadedImage != null) {
				var loaded_clip:MovieClip = _loadedImage as MovieClip;
				if(loaded_clip != null) {
					var model:DisplayObject = loaded_clip.getChildByName("model_mc");
					return getQualifiedClassName(model);
				}
			}
			return null;
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
