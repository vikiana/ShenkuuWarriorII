// This class holds information about a swf or movieclip being used as a scene.
// Author: David Cary
// Last Updated: June 2008

package com.neopets.games.inhouse.pinball{
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import com.neopets.games.inhouse.pinball.gui.GameScene;
	import com.neopets.games.inhouse.pinball.ShellControl;
	import com.neopets.games.inhouse.pinball.GameShell;
	import fl.transitions.Tween;
	
	public class SceneData {
		protected var _id:String;
		protected var _displayObject:DisplayObject;
		protected var _scene:GameScene;
		protected var transitions:Array;
		public var tween:Tween;
		
		public function SceneData(tag:String,src:DisplayObject,dest:ShellControl) {
			_id = tag;
			_displayObject = src;
			if(_displayObject != null) {
				if(src is Loader) {
					var ldr:Loader = src as Loader;
					_scene = ldr.contentLoaderInfo.content as GameScene;
				} else _scene = src as GameScene;
				if(dest != null) {
					_displayObject.visible = false;
					if(_scene != null) _scene.controller = dest;
				}
			}
			transitions = new Array();
		}
		
		// Accessor Functions
		
		public function get id():String { return _id; }
		
		public function get display():DisplayObject { return _displayObject; }
		
		public function get scene():GameScene { return _scene; }
		
		public function addTransition(tag:String,func:Function):Object {
			if(func == null) return null;
			// check if the transition already exists
			var trans:Object = getTransition(tag);
			if(trans != null) return trans;
			// if not, try to create a new transition
			trans = {otherID:tag,func:func};
			transitions.push(trans);
			return trans;
		}
		
		public function getTransition(tag:String) {
			var trans:Object;
			for(var i:int = 0; i < transitions.length; i++) {
				trans = transitions[i];
				if(trans.otherID == tag) return trans;
			}
			return null;
		}
		
		// Conversion Functions
		
		public function toString():String {
			return _id + ":" + _scene;
		}
		
	}
	
}