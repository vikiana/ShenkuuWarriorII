
/* AS3
	Copyright 2008
*/

package com.neopets.games.inhouse.AdventureFactory.editor.options
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.InteractiveObject;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import fl.transitions.Tween;
	import fl.transitions.easing.Regular;
	
	import com.neopets.util.button.NeopetsButton;
	import com.neopets.util.general.GeneralFunctions;
	import com.neopets.util.display.BroadcasterClip;
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.util.events.CustomEvent;
	import virtualworlds.lang.TranslationManager;
	
	import com.neopets.games.inhouse.AdventureFactory.AdventureFactory_GameScreen;
	import com.neopets.games.inhouse.AdventureFactory.editor.ImageRow;
	import com.neopets.games.inhouse.AdventureFactory.editor.states.GameStatePanel;
	import com.neopets.games.inhouse.AdventureFactory.game.GameWorld;
	
	/**
	 *	This class handles the tools and options available at each stage of game creation.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author David Cary
	 *	@since  02.23.2010
	 */
	 
	public class SelectionPane extends BroadcasterClip
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const ON_FRESH_START:String = "onStartFromScratch";
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		protected var _optionsXML:XML;
		// components
		protected var _optionRow:ImageRow;
		protected var _rowMask:DisplayObject;
		protected var _nextButton:InteractiveObject;
		protected var _previousButton:InteractiveObject;
		// tweener
		protected var rowTween:Tween;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function SelectionPane():void{
			super();
			// set up controls
			nextButton = getChildByName("next_btn") as InteractiveObject;
			previousButton = getChildByName("prev_btn") as InteractiveObject;
			// set up option container
			optionRow = new ImageRow();
			rowMask = getChildByName("mask_mc");
			// listen to the game screen for the editor state
			addParentListener(AdventureFactory_GameScreen,GameStatePanel.STATE_SELECTED,onStateChange);
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get optionRow():ImageRow { return _optionRow; }
		
		public function set optionRow(row:ImageRow) {
			if(_optionRow != row) {
				_optionRow = row;
				if(_optionRow != null) {
					addChild(_optionRow);
					if(_rowMask != null) {
						_optionRow.alignWith(_rowMask);
						_optionRow.mask = _rowMask;
					}
					_optionRow.spacing = 8;
				}
			}
		}
		
		public function get nextButton():InteractiveObject { return _nextButton; }
		
		public function set nextButton(btn:InteractiveObject) {
			// remove previous listeners
			if(_nextButton != null) {
				_nextButton.removeEventListener(MouseEvent.CLICK,onNextRequest);
			}
			// set up new listeners
			_nextButton = btn;
			if(_nextButton != null) {
				_nextButton.addEventListener(MouseEvent.CLICK,onNextRequest);
			}
		}
		
		public function get previousButton():InteractiveObject { return _previousButton; }
		
		public function set previousButton(btn:InteractiveObject) {
			// remove previous listeners
			if(_previousButton != null) {
				_previousButton.removeEventListener(MouseEvent.CLICK,onPreviousRequest);
			}
			// set up new listeners
			_previousButton = btn;
			if(_previousButton != null) {
				_previousButton.addEventListener(MouseEvent.CLICK,onPreviousRequest);
			}
		}
		
		public function get rowMask():DisplayObject { return _rowMask; }
		
		public function set rowMask(dobj:DisplayObject) {
			_rowMask = dobj;
			if(_optionRow != null) {
				_optionRow.alignWith(_rowMask);
				_optionRow.mask = _rowMask;
			}
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Use this function to go to a new option set.
		
		public function setState(id:Object) {
			// clear previous contents
			_optionRow.clearChildren();
			// set new contents
			switch(id) {
				case GameStatePanel.GAME_STARTER_STATE:
					loadStarters();
					break;
				case GameStatePanel.BACKGROUND_STATE:
					loadBackgrounds();
					break;
				case GameStatePanel.HERO_STATE:
					loadHeroes();
					break;
				case GameStatePanel.GOAL_STATE:
					loadGoals();
					break;
				case GameStatePanel.LEVEL_DESIGN_STATE:
					loadTools();
					break;
			}
			// check if the new contents overrun the row's bounds
			var show_btns:Boolean;
			if(_optionRow != null && _rowMask != null) {
				_optionRow.alignWith(_rowMask); // realign option row
				show_btns = _optionRow.width > _rowMask.width;
			} else show_btns = false;
			// set button visibility
			if(_nextButton != null) _nextButton.visible = show_btns;
			if(_previousButton != null) _previousButton.visible = show_btns;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		public function onNextRequest(ev:MouseEvent=null) {
			if(_optionRow == null || _rowMask == null) return;
			// check bounds
			var row_bounds:Rectangle = _optionRow.getBounds(this);
			var mask_bounds:Rectangle = _rowMask.getBounds(this);
			// check how much space we have on the right
			var dist_remaining:Number = row_bounds.right - mask_bounds.right;
			if(dist_remaining <= 0) return; // we're as far to the right as we can go
			// find the left most row element that's in bounds
			var opt:DisplayObject;
			var opt_bounds:Rectangle;
			var end_bounds:Rectangle;
			for(var i:int = 0; i < _optionRow.numChildren; i++) {
				opt = _optionRow.getChildAt(i);
				opt_bounds = opt.getBounds(this);
				if(opt_bounds.left > mask_bounds.left) {
					end_bounds = opt_bounds;
					break;
				}
			}
			if(end_bounds == null) return;
			// shift row to left
			var dist:Number = Math.min(end_bounds.right - mask_bounds.left,dist_remaining);
			dist += _optionRow.spacing / 2; // apply padding
			rowTween = new Tween(_optionRow,"x",Regular.easeInOut,_optionRow.x,_optionRow.x-dist,0.5,true);
		}
		
		public function onPreviousRequest(ev:MouseEvent=null) {
			if(_optionRow == null || _rowMask == null) return;
			// check bounds
			var row_bounds:Rectangle = _optionRow.getBounds(this);
			var mask_bounds:Rectangle = _rowMask.getBounds(this);
			// check how much space we have on the left
			var dist_remaining:Number = mask_bounds.left - row_bounds.left;
			if(dist_remaining <= 0) return; // we're as far to the right as we can go
			// find the right most row element that's in bounds
			var opt:DisplayObject;
			var opt_bounds:Rectangle;
			var end_bounds:Rectangle;
			for(var i:int = _optionRow.numChildren - 1; i >= 0; i--) {
				opt = _optionRow.getChildAt(i);
				opt_bounds = opt.getBounds(this);
				if(opt_bounds.right < mask_bounds.right) {
					end_bounds = opt_bounds;
					break;
				}
			}
			if(end_bounds == null) return;
			// shift row to left
			var dist:Number = Math.min(mask_bounds.right - end_bounds.left,dist_remaining);
			dist += _optionRow.spacing / 2; // apply padding
			rowTween = new Tween(_optionRow,"x",Regular.easeInOut,_optionRow.x,_optionRow.x+dist,0.5,true);
		}
		
		protected function onStateChange(ev:CustomEvent) { setState(ev.oData); }
		
		// Starter Functions
		
		public function onFreshStart(ev:Event=null) {
			broadcast(ON_FRESH_START);
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		// Tool Bar Loading Functions
		// These function may be overridden by subclasses to handle different layouts and tool sets.
		
		// Use this function to load background options from our game screen.
		
		protected function loadBackgrounds():void { loadOptionSet("backgrounds","BackgroundButtonMC"); }
		
		// Use this function to load goal options from our game screen.
		
		protected function loadGoals():void { loadOptionSet("goals","GoalButtonMC"); }
		
		// Use this function to load hero options from our game screen.
		
		protected function loadHeroes():void { loadOptionSet("heroes","HeroButtonMC"); }
		
		// Use this function to load hero options from our game screen.
		
		protected function loadTools():void { loadOptionSet("tools","TileSetMC"); }
		
		// Use this function to load a list of entries into our options area.
		// param	shell_type		String			Class id for our shell movieclips.
		// param	data_list		Array			Initialization entries for each clip.
		
		protected function loadOptionSet(group_id:String,shell_type:String):void {
			if(_optionsXML == null) {
				// try to synch our options with the game screen
				var screen:AdventureFactory_GameScreen;
				screen = DisplayUtils.getAncestorInstance(this,AdventureFactory_GameScreen) as AdventureFactory_GameScreen;
				if(screen != null) _optionsXML = screen.levelOptionsXML;
				if(_optionsXML == null) return;
			}
			// get all entries for the target group
			var groups:XMLList = _optionsXML.child(group_id);
			// cycle through all nodes in the group
			var group:XML;
			var options:XMLList;
			var option:XML;
			var shell:Object;
			var i:Object;
			var j:Object;
			for(i in groups) {
				group = groups[i];
				options = group.children();
				for(j in options) {
					option = options[j];
					// create a new shell
					if("@class" in option) shell = GeneralFunctions.getInstanceOf(option["@class"]);
					else shell = GeneralFunctions.getInstanceOf(shell_type);
					if(shell == null) return; // abort if shell could not be created
					// try to add the shell to the selection pane
					if(shell is DisplayObject && _optionRow != null) {
						_optionRow.addChild(shell as DisplayObject);
						if("initFrom" in shell) shell.initFrom(option); // try to initialize the shell
					}
				} // end of option loop
			} // end of group loop
		}
		
		protected function loadStarters():void {
			addStarter("IDS_FRESH_STARTER",onFreshStart);
			addStarter("IDS_LOAD_STARTER",onFreshStart);
		}
		
		// Content Adding Functions
		
		/**
		 * @This function creates starter option buttons and add them to our contents.
		 * @param	id		String		Translation ID of button's label.
		 * @param	func	Function	Function triggered when starter is clicked.
		 */
		
		protected function addStarter(id:String,func:Function) {
			var starter:NeopetsButton = new StarterButtonMC();
			var translation:String = TranslationManager.instance.getTranslationOf(id);
			starter.setText(translation);
			starter.addEventListener(MouseEvent.CLICK,func);
			_optionRow.addChild(starter);
		}
		
	}
	
}
