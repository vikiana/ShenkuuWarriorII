
/* AS3
	Copyright 2008
*/
package com.neopets.util.flashvars
{
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 *	This class provides global access to the stage's flash vars.  It also lets you set default 
	 *  values for flash vars.
	 *  The code in this class is based on Abe's FlashVarFinder class.
	 *  The class is similar to Sam's FlashVarsManager class but doesn't require the mc.core.Application class.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author David Cary
	 *	@since  4.13.10
	 */
	 
	public class  FlashVarManager extends EventDispatcher
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------		
		protected static const mInstance:FlashVarManager = new FlashVarManager( SingletonEnforcer);
		protected var _flashVars:Object;
		protected var _root:DisplayObject;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function FlashVarManager(singletonEnforcer : Class = null):void
		 {
		 		if(singletonEnforcer != SingletonEnforcer)
		 		{
					throw new Error( "Invalid Singleton access.  Use FlashVarManager.instance." ); 
				}
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get initialized():Boolean { return _root != null; }
		
		public static function get instance():FlashVarManager
		{ 
			return mInstance;	
		} 
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Use this function to try finding the target variable.
		 * @param		id			String 		Name of the flash var
		 */
		 
		public function getVar(id:String):Object {
			if(_flashVars == null) return null;
			if(id in _flashVars) return _flashVars[id];
			else return null;
		}
		
		public function get flashVars():Object{
			return _flashVars;
		}
		
		/**
		 * @Use this function extracts values from the root object.
		 * @param		display_obj		Object		On stage display object used to find root.
		 * @param		force_init		Boolean		Overwrite values even if already initialized
		 */
		 
		public function initVars(display_obj:DisplayObject,force_init:Boolean=false):void {
			// abort if we already have a root and aren't forcing an overwrite
			if(_root != null && !force_init) return;
			// see if we can find a valid root for the target
			if(display_obj == null) return;
			var root_obj:DisplayObject = display_obj.root;
			if(root_obj == null) return;
			// If we've already loaded data from that root object, don't do it again.
			if(root_obj !=  _root) {
				// create a flash var storage object if needed
				if(_flashVars == null) _flashVars = new Object();
				// get the root loader
				var info:LoaderInfo = root_obj.loaderInfo;
				// extract the loader parameters
				if(info != null) {
					var params:Object = info.parameters;
					if(params != null) {
						for(var i:String in params) {
							_flashVars[i] = params[i];
						} // end of parameter loading loop
					} // end of parameters check
				} // end of loader info checking
				_root = root_obj; // store new root
				dispatchEvent(new Event(Event.INIT)); // let listeners know we're initialized
			} // end of root match check
		}
		
		/**
		 * @Use this function to set up a default value for the variable.
		 * @param		id			String 		Name of the flash var
		 * @param		val			Object 		Value being assigned to the variable
		 */
		 
		public function setDefault(id:String,val:Object):void {
			if(_flashVars == null) _flashVars = new Object();
			// check if the value has already been set
			if(!(id in _flashVars)) _flashVars[id] = val;
		}
		 
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
	}
	
}

/**
 * @Note: This is to make sure there is only one version of this class at a time
 */
 
internal class SingletonEnforcer{}