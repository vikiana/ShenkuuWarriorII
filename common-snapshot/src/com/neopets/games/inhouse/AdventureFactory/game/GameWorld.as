
/* AS3
	Copyright 2008
*/

package com.neopets.games.inhouse.AdventureFactory.game
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	import flash.utils.Timer;
	import flash.ui.Keyboard;
	
	import com.neopets.util.general.GeneralFunctions;
	import com.neopets.util.display.BroadcasterClip;
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.collision.CollisionManager;
	import com.neopets.util.input.KeyManager;
	
	import com.neopets.games.inhouse.AdventureFactory.GameScreenClip;
	import com.neopets.games.inhouse.AdventureFactory.AdventureFactory_GameScreen;
	import com.neopets.games.inhouse.AdventureFactory.game.objects.HeroClip;
	import com.neopets.games.inhouse.AdventureFactory.game.objects.GoalClip;
	import com.neopets.games.inhouse.AdventureFactory.game.objects.PhysicsEntity;
	
	/**
	 *	This class acts as a container for gameplay elements.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author David Cary
	 *	@since  02.26.2010
	 */
	 
	public class GameWorld extends BroadcasterClip
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const RESET_GAME:String = "reset_game";
		public static const SET_INITIAL_STATE:String = "set_initial_state";
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		protected var _backgroundLayer:int;
		protected var _physicsTimer:Timer;
		protected var _keys:KeyManager;
		// dynamically added components
		protected var _background:DisplayObject;
		protected var _hero:HeroClip;
		protected var _goal:GoalClip;
		// component classes
		protected var _backgroundClass:String;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function GameWorld():void{
			super();
			// initialize properties
			_physicsTimer = new Timer(100);
			_backgroundLayer = 1;
			CollisionManager.addSpace(name,this);
			//CollisionManager.addCanvas(name,this); // comment this is to see collision boxes
			// set default dispatcher
			useParentDispatcher(AdventureFactory_GameScreen);
			// screen new additions
			addEventListener(Event.ADDED,onAddition);
			addEventListener(Event.ADDED_TO_STAGE,onKeyInit);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get backgroundClass():String { return _backgroundClass; }
		
		public function set backgroundClass(class_id:String) {
			if(class_id != _backgroundClass) {
				// create new image
				var image:DisplayObject = GeneralFunctions.getDisplayInstance(class_id);
				// replace current image
				if(image != null) {
					if(_background != null) DisplayUtils.replaceChild(this,_background,image);
					else addChildAt(image,_backgroundLayer);
				}
				_background = image;
				_backgroundClass = class_id;
			}
		}
		
		public function get goalClass():String {
			if(_goal != null) return getQualifiedClassName(_goal);
			else return null;
		}
		
		public function set goalClass(class_id:String) {
			if(class_id != goalClass) {
				// create new image.  onAddition handler will take care of replacing the previous hero
				var image:DisplayObject = GeneralFunctions.getDisplayInstance(class_id);
				if(image != null) addChild(image);
			}
		}
		
		public function get heroClass():String {
			if(_hero != null) return getQualifiedClassName(_hero);
			else return null;
		}
		
		public function set heroClass(class_id:String) {
			if(class_id != heroClass) {
				// create new image.  onAddition handler will take care of replacing the previous hero
				var image:DisplayObject = GeneralFunctions.getDisplayInstance(class_id);
				if(image != null) addChild(image);
			}
		}
		
		public function get keys():KeyManager { return _keys; }
		
		public function get physicsTimer():Timer { return _physicsTimer; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Use this function to store our starting state for later reference.
		
		public function recordState():void {
			dispatchEvent(new Event(SET_INITIAL_STATE));
		}
		
		// Use this function to revert the game world to it's initial condition.
		
		public function reset():void {
			_physicsTimer.stop();
			_physicsTimer.reset();
			dispatchEvent(new Event(RESET_GAME));
		}
		
		// Use this function to start the game from it's initial state.
		
		public function restart():void {
			reset();
			_physicsTimer.start();
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		protected function onAddition(ev:Event) {
			// check if the target is being add to this object
			var added_obj:DisplayObject = ev.target as DisplayObject;
			if(added_obj != null && added_obj.parent == this) {
				// if this is a hero, replace the previous one
				if(added_obj is HeroClip) {
					if(_hero != null) DisplayUtils.replaceChild(this,_hero,added_obj);
					_hero = added_obj as HeroClip;
				}
				// if this is a goal, replace the previous one
				if(added_obj is GoalClip) {
					if(_goal != null)  DisplayUtils.replaceChild(this,_goal,added_obj);
					_goal = added_obj as GoalClip;
				}
				// if the object has physics, tie it to our own collision space and time stream
				if(added_obj is PhysicsEntity) {
					var physics_obj:PhysicsEntity = added_obj as PhysicsEntity;
					physics_obj.initPhysicsFor(this);
					physics_obj.recordState();
				}
			}
		}
		
		// Use this function to set up standard keyboard inputs.
		
		protected function onKeyInit(ev:Event=null):void {
			if(stage == null) return;
			if(_keys == null) _keys = new KeyManager(stage);
			_keys.addKey(HeroClip.WALK_LEFT,Keyboard.LEFT);
			_keys.addKey(HeroClip.WALK_RIGHT,Keyboard.RIGHT);
			_keys.addKey(HeroClip.JUMP,Keyboard.UP);
			removeEventListener(Event.ADDED_TO_STAGE,onKeyInit);
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
