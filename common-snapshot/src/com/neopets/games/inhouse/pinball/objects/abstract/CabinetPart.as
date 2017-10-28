// This class sets up common tools and functions used by most of the objects in the pinball cabinet.
// Author: David Cary
// Last Updated: April 2008

package com.neopets.games.inhouse.pinball.objects.abstract
{
	
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import com.neopets.games.inhouse.pinball.GameShell;
	import com.neopets.games.inhouse.pinball.PinballCabinet;
	import com.neopets.util.support.PauseHandler;
	import com.neopets.util.display.DisplayUtils;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	// Make sure to add this library to your publish settings.
	import org.cove.ape.*;
	
	public class CabinetPart extends MovieClip {
		protected var _cabinet:PinballCabinet;
		protected var _group:Group;
		// zLayer tracks how far this part is above ground level in general terms
		protected var _zLayer:int; 
		// zLayer Constants
		public static const PIT_LAYER:int = -2;
		public static const LOWER_LAYER:int = -1;
		public static const GROUND_LAYER:int = 0;
		public static const UPPER_LAYER:int = 1;
		public static const LAUNCH_LAYER:int = 2;
		public static const BIN_LAYER:int = 3;
		
		public function CabinetPart() {
			_zLayer = GROUND_LAYER;
			addEventListener(Event.ADDED_TO_STAGE,findShell); // look for the game shell when we're added to the stage
		}
		
		// Accessor Functions
		
		public function get cabinet():PinballCabinet { return _cabinet; }
		
		public function get group():Group { return _group; }
		
		public function get zLayer():Number { return _zLayer; }
		
		public function set zLayer(pz:Number) {
			_zLayer = pz;
			if(_cabinet != null) _cabinet.checkInteractionsFor(this);
		}
		
		// Initialization Functions
		
		// This function searches to see if this object has a GameShell ancestor.
		protected function findShell(ev:Event):void  {
			if(ev.target == this) {
				var p:Object = parent as Object;
				while(p != null && p != stage) {
					if(p is PinballCabinet) {
						_cabinet = p as PinballCabinet;
						if(_cabinet.game != null) {
							onAddedToGame();
							_cabinet.registerPart(this);
						}
						break;
					} else p = p.parent; // keep searching
				}
				removeEventListener(Event.ADDED_TO_STAGE,findShell);
			}
		}
		
		// Put any initialization code that depends on the game shell here. 
		// This function will be overridden by most sub-classes.
		protected function onAddedToGame():void  {}
		
		// Use this function to tie this parts update function to the game's update cycles.
		protected function enableUpdates():void {
			if(_cabinet != null) {
				if(_cabinet.game != null) _cabinet.game.updater.addEventListener(PauseHandler.UPDATE_EVENT,update);
			}
		}
		
		// Game Cycle Functions
		
		// Put any per-frame operations here.
		// This function will be overridden by most sub-classes.
		protected function update(ev:Event):void {}
		
		// Removal Functions
		
		// Use this function to shut down the part's functionality and close it's references.
		// This function should only be called right before removing the part from the game,
		// as there is currently no function for reactivating a part.
		public function disable():void  {
			onRemoval(); // trigger sub-class specific clean up code
			if(_cabinet != null) {
				if(_cabinet.game != null) _cabinet.game.updater.removeEventListener(PauseHandler.UPDATE_EVENT,update);
				_cabinet.unregisterPart(this);
			}
		}
		
		// Put the object's clean up code here.
		// This function will be overridden by most sub-classes.
		protected function onRemoval():void  {}
		
		// Particle Creation Functions
		
		// This function builds a RectangleParticle from one of the target cabinet part's child clips.
		// "ref" is the name of the child clip.
		// The remaining parameters are copied from the RectangleParticle's constructor.
		public function getRectPart(ref:String,fixed:Boolean=false,mass:Number=1,
										   elasticity:Number=0.3,friction:Number=0):RectangleParticle {
			if(ref in this) {
				var clip:MovieClip = this[ref] as MovieClip;
				DisplayUtils.centerChildren(clip); // center the clip's art
				// get clip bounds
				var angle:Number = clip.rotation; // store current rotation
				clip.rotation = 0; // get boudns at 0 rotation
				var bbox:Rectangle = clip.getRect(_cabinet);
				// create the rectangle
				var cx:Number = (bbox.left + bbox.right) / 2;
				var cy:Number = (bbox.top + bbox.bottom) / 2;
				var part:RectangleParticle = new RectangleParticle(cx,cy,bbox.width,bbox.height,angle,fixed,mass,elasticity,friction);
				clip.rotation = angle; // restore clip rotation
				part.setDisplay(clip); // set the clip as the particle's sprite
				return part;
			} else return null;
		}
		
		// This function searches the target cabinet part for a series of numbered child clips with similar
		// names, such as "p1", "p2", ect..  It then uses those clips to build an array of CircleParticles.
		// The function is mostly used to provide a list of points which can be connected to each other
		// with spring constraints.
		// "ref" is the shared name of the target child clips.
		// The remaining parameters are copied from the CircleParticle's constructor.
		public function getPointParts(ref:String,fixed:Boolean=false,mass:Number=1,
									  elasticity:Number=0.3,friction:Number=0):Array {
			var pts:Array = new Array();
			// cycle through a series of name+number combos
			var tag:String;
			var pt:CircleParticle;
			var i:int = 1;
			do {
				tag = ref + i;
				pt = getPointPart(tag,fixed,mass,elasticity,friction);
				if(pt != null) pts.push(pt);
				else break; // The series was broken, so stop checking
				i++;
			} while(pt != null);
			return pts;
		}
		
		// This function builds a CircleParticle from one of the target cabinet part's child clips.
		// "ref" is the name of the target child clip.
		// The remaining parameters are copied from the CircleParticle's constructor.
		public function getPointPart(ref:String,fixed:Boolean=false,mass:Number=1,
									 elasticity:Number=0.3,friction:Number=0):CircleParticle {
			if(ref in this) {
				var clip:MovieClip = this[ref] as MovieClip;
				DisplayUtils.centerChildren(clip); // center the clip's art
				if(clip != null) {
					var bb:Rectangle = clip.getRect(_cabinet);
					var cx:Number = (bb.left + bb.right) / 2;
					var cy:Number = (bb.top + bb.bottom) / 2;
					var cr:Number = (bb.width + bb.height) / 4;
					var pt:CircleParticle = new CircleParticle(cx,cy,cr,fixed,mass,elasticity,friction);
					pt.setDisplay(clip);
					clip.width = bb.width;
					clip.height = bb.height;
					return pt;
				}
			}
			return null;
		}
		
		// This function searches the target cabinet part for a series of numbered child clips with similar
		// names, such as "p1", "p2", ect..  It then uses those clips to build an array of points.
		// "ref" is the shared name of the target child clips.
		// The remaining parameters are copied from the CircleParticle's constructor.
		public function getPoints(ref:String,vis:Boolean=true):Array {
			var pts:Array = new Array();
			// cycle through a series of name+number combos
			var tag:String;
			var pt:Vector;
			var i:int = 1;
			do {
				tag = ref + i;
				pt = getPoint(tag,vis);
				if(pt != null) pts.push(pt);
				else break; // The series was broken, so stop checking
				i++;
			} while(pt != null);
			return pts;
		}
		
		// This function builds a Point from one of the target cabinet part's child clips.
		// "ref" is the name of the target child clip while "vis set the visibility of the clip.
		public function getPoint(ref:String,vis:Boolean=true):Vector {
			if(ref in this) {
				var clip:MovieClip = this[ref] as MovieClip;
				if(clip != null) {
					clip.visible = true;
					var bb:Rectangle = clip.getRect(_cabinet);
					var cx:Number = (bb.left + bb.right) / 2;
					var cy:Number = (bb.top + bb.bottom) / 2;
					clip.visible = vis;
					return new Vector(cx,cy);
				}
			}
			return null;
		}
		
		// Use this function to add a particle to a group and automatically it invisible 
		// if the game's "show wires" is off.
		public function addHiddenParticle(p:AbstractParticle,g:Group=null) {
			if(p != null) {
				if(g == null) g = _group;
				if(g != null) g.addParticle(p);
				if(_cabinet.game != null) p.sprite.visible = _cabinet.game.showWires;
			}
		}
		
		// Use this function to add a constraint to a group and automatically it invisible 
		// if the game's "show wires" is off.
		public function addHiddenConstraint(c:AbstractConstraint,g:Group=null) {
			if(c != null) {
				if(g == null) g = _group;
				if(g != null) g.addConstraint(c);
				if(_cabinet.game != null) c.sprite.visible = _cabinet.game.showWires;
			}
		}
		
		// Particle System Functions
		
		// Use this function to set up interactions between different cabinet parts after
		// they've been added to the cabinet.
		// This function will be overridden by most sub-classes.
		public function checkInteractionsFor(other:CabinetPart):void {}
		
		// Use this function to add collidables to a group without adding redundant entries.
		static public function addCollidable(g1:Group,g2:Group):void {
			if(g1 != null && g2 != null) {
				if(g1.collisionList.indexOf(g2) < 0) g1.addCollidable(g2);
			}
		}
		
		// Messaging Functions
		
		// Use this function to send an event up through the heirarchy so anyone can hear it.
		public function broadcast(ev:Event):void {
			dispatchEvent(ev);
			if(_cabinet != null) {
				_cabinet.dispatchEvent(ev);
				if(_cabinet.game != null) _cabinet.game.dispatchEvent(ev);
			}
		}
		
	}
}