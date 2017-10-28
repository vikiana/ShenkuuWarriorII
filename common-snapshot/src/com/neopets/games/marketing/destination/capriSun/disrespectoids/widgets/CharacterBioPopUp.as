/**
 *	This class shows characte bio information.  The character image and text is handled by 
 *  the CharacterBioPane class.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.09.2010
 */

package com.neopets.games.marketing.destination.capriSun.disrespectoids.widgets
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.util.BroadcasterClip;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.util.BroadcastEvent;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.widgets.CharacterClip;
	import com.neopets.projects.destination.destinationV3.AbsPage;
	import com.neopets.util.general.GeneralFunctions;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.widgets.BasicPopUp;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.DestinationView;
	
	public class CharacterBioPopUp extends BroadcasterClip
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		public static const RADIANS_PER_DEGREE:Number = Math.PI / 180;
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var _bioPane:CharacterBioPane;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function CharacterBioPopUp():void {
			super();
			visible = false; // start hidden by default
			bioPane = getChildByName("window_mc") as CharacterBioPane;
			useParentDispatcher(AbsPage);
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get bioPane():CharacterBioPane { return _bioPane; }
		
		public function set bioPane(pane:CharacterBioPane) {
			// clear listeners
			if(_bioPane != null) {
				_bioPane.removeEventListener(Event.CLOSE,onCloseRequest);
			}
			// set button
			_bioPane = pane;
			// set listeners
			if(_bioPane != null) {
				_bioPane.addEventListener(Event.CLOSE,onCloseRequest);
			}
		}
		
		override public function set sharedDispatcher(disp:EventDispatcher) {
			// clear listeners
			if(_sharedDispatcher != null) {
				_sharedDispatcher.removeEventListener(CharacterClip.CHARACTER_SELECTED,onCharacterSelected);
				_sharedDispatcher.removeEventListener(BasicPopUp.POPUP_SHOWN,onPopUpShown);
			}
			_sharedDispatcher = disp;
			_dispatcherClass = GeneralFunctions.getClassOf(_sharedDispatcher);
			// set up listeners
			if(_sharedDispatcher != null) {
				_sharedDispatcher.addEventListener(CharacterClip.CHARACTER_SELECTED,onCharacterSelected);
				_sharedDispatcher.addEventListener(BasicPopUp.POPUP_SHOWN,onPopUpShown);
			}
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		// Use this function try auto-positioning adjacent to the target.
		
		public function placeNear(target:MovieClip) {
			if(target == null || parent == null) return;
			// get bounds
			var t_bounds:Rectangle = target.getBounds(parent);
			var p_bounds:Rectangle = getBounds(parent);
			// get offsets
			var ox:Number = x - p_bounds.x;
			var oy:Number = y - p_bounds.y;
			// try first position: left edge of popup over upper center point of target
			p_bounds.x = (t_bounds.left + t_bounds.right) / 2;
			p_bounds.y = t_bounds.top - p_bounds.height;
			// if we're too far right, flip to left
			var h_align:String;
			if(p_bounds.right > stage.stageWidth) {
				p_bounds.x -= p_bounds.width;
				h_align = "left";
			} else h_align = "right";
			// if we're too far up, flip to bottom
			var v_align:String;
			if(p_bounds.top < 0) {
				p_bounds.y = t_bounds.bottom;
				v_align = "lower";
			} else v_align = "upper";
			// move to position
			x = p_bounds.x + ox;
			y = p_bounds.y + oy;
			// set frame
			gotoAndPlay(v_align+"_"+h_align);
		}
		
		// Use this function move directly over a guide point.
		
		public function placeOverMarker(marker:MovieClip) {
			if(marker == null || parent == null) return;
			// get bounds
			var p_bounds:Rectangle = getBounds(parent);
			// get coordinate in parent space
			var pt:Point = new Point();
			pt = marker.localToGlobal(pt);
			pt = parent.globalToLocal(pt);
			// check for horizontal flip
			var rad:Number = marker.rotation * RADIANS_PER_DEGREE;
			var h_align:String;
			if(Math.cos(rad) >= 0) {
				x += pt.x - p_bounds.left;
				h_align = "right";
			} else {
				x += pt.x - p_bounds.right;
				h_align = "left";
			}
			// check for vertical flip
			var v_align:String;
			if(Math.sin(rad) >= 0) {
				y += pt.y - p_bounds.top;
				v_align = "lower";
			} else {
				y += pt.y - p_bounds.bottom;
				v_align = "upper";
			}
			// set frame
			gotoAndPlay(v_align+"_"+h_align);
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		// This function is triggered when a character selection event is broadcast.
		
		protected function onCharacterSelected(ev:BroadcastEvent) {
			var ev_sender:Object = ev.sender;
			var char:CharacterClip = ev_sender as CharacterClip;
			if(char != null) {
				// reposition
				if(char.bioMarker != null) placeOverMarker(char.bioMarker);
				else placeNear(char);
				// load bio text and images
				if(_bioPane != null) _bioPane.loadCharacter(char);
				// show pop up
				visible = true;
				broadcast(BasicPopUp.POPUP_SHOWN);
				broadcast(DestinationView.SHOP_AWARD_REQUEST,"1");
			}
		}
		
		// This function hides the pop up when the close button is clicked.
		
		public function onCloseRequest(ev:Event=null) {
			visible = false;
		}
		
		// This function lets the pop up react to any other pop up openning.
		
		protected function onPopUpShown(ev:BroadcastEvent) {
			if(ev.sender != this) onCloseRequest();
		}

	}
	
}