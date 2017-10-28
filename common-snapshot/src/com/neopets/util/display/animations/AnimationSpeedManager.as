package com.neopets.util.display.animations
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.Event;
	import flash.display.MovieClip;
	
	import com.neopets.util.display.animations.AnimationAccelerator;
	
	/**
	 *	This class lets you speed up or slow down multiple animations at once.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern Singleton
	 * 
	 *	@author Clive Henrick
	 *	@since 8.27.2009
	 */
	 
	public class AnimationSpeedManager extends EventDispatcher
	{
		//--------------------------------------
		//  PRIVATE / PROTECTED VARIABLES
		//--------------------------------------
		
		protected static const mInstance:AnimationSpeedManager = new AnimationSpeedManager( SingletonEnforcer ); 
		
		protected var accelerators:Array;
		
		protected var _multiplier:Number;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function AnimationSpeedManager(singletonEnforcer : Class = null)
		{
			if(singletonEnforcer != SingletonEnforcer){
				throw new Error( "Invalid Singleton access.  Use MenuManager.instance." ); 
			} else {
				accelerators = new Array();
			}
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public static function get instance():AnimationSpeedManager
		{ 
			return mInstance;	
		}
		
		public function get multiplier():Number { return _multiplier; }
		
		public function set multiplier(val:Number) {
			if(_multiplier != val) {
				_multiplier = val;
				// synch accelerators to our own multiplier
				for(var i:int = 0; i < accelerators.length; i++) {
					var accelerator:AnimationAccelerator = accelerators[i];
					accelerator.multiplier = _multiplier;
				}
			}
		}
		
		//--------------------------------------
		//  PUBLIC FUNCTIONS
		//--------------------------------------
		
		// This function ties the target movie clip to this manager's control.
		
		public function register(clip:MovieClip,start_pos:int=1,end_pos:int=-1):void {
			if(clip != null && getAcceleratorFor(clip) == null) {
				// set up listeners
				clip.addEventListener(Event.REMOVED_FROM_STAGE,onClipRemoved);
				// build accelerator
				var accelerator:AnimationAccelerator = new AnimationAccelerator(clip,start_pos,end_pos);
				accelerator.multiplier = _multiplier;
				accelerators.push(accelerator);
			}
		}
		
		// Use this function to remove a clip from the manager.
		
		public function drop(clip:MovieClip):void {
			var accelerator:AnimationAccelerator = getAcceleratorFor(clip);
			if(clip != null) {
				// remove accelerator
				var index:int = accelerators.indexOf(accelerator);
				accelerators.splice(index,1);
				// remove listeners
				clip.removeEventListener(Event.REMOVED_FROM_STAGE,onClipRemoved);
			}
		}
		
		//--------------------------------------
		//  PROTECTED FUNCTIONS
		//--------------------------------------
		
		// This retrieves the AnimationAccelerator associated with the target movieclip.
		
		protected function getAcceleratorFor(clip:MovieClip) {
			for(var i:int = 0; i < accelerators.length; i++) {
				var accelerator:AnimationAccelerator = accelerators[i];
				if(accelerator.target == clip) return accelerator;
			}
			return null;
		}
		
		//--------------------------------------
		//  EVENT LISTENERS
		//--------------------------------------
		
		// When a clip is removed, drop it's accelerator.
		
		protected function onClipRemoved(ev:Event) {
			var clip = ev.target as MovieClip;
			if(clip == null) return;
			drop(clip);
		}
		
	}
}

/**
 * @Note: This is to make sure there is only one version of this class at a time
 */
 
internal class SingletonEnforcer{}