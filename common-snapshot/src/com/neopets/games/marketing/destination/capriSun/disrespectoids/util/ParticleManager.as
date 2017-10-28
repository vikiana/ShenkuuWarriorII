
package com.neopets.games.marketing.destination.capriSun.disrespectoids.util
{
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.util.ParticleRecord;
	
	/**
	 *	This class manages particle records for every display object container that uses them.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern Multiton
	 * 
	 *	@author David Cary
	 *	@since 6.17.2010
	 */
	 
	public class ParticleManager extends ParticleRecord
	{
		//--------------------------------------
		//  CONSTANTS
		//--------------------------------------
		protected const MULTITON_MSG:String = "ParticleManager instance for this Multiton key already constructed!";
		
		//--------------------------------------
		//  PRIVATE / PROTECTED VARIABLES
		//--------------------------------------
		// The Multiton Facade instanceMap.
		protected static var instanceMap:Array = new Array(); 

		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function ParticleManager(con:DisplayObjectContainer)
		{
			super(con);
			if (instanceFor(con) != null) {
				throw Error(MULTITON_MSG);	
			}
			instanceMap.push(this);
			addEventListener(Event.REMOVED,onRemoval);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public static function getInstance(con:DisplayObjectContainer):ParticleManager
		{
			var inst:ParticleManager = instanceFor(con);
			if(inst == null) inst = new ParticleManager(con);
			return inst;
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		// This function is used internally to check for an existing instance.
		
		protected static function instanceFor(con:DisplayObjectContainer):ParticleManager {
			var inst:ParticleManager;
			for(var i:int = 0; i < instanceMap.length; i++) {
				inst = instanceMap[i];
				if(inst.container == con) return inst;
			}
			return null;
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
		
		// When this manager is removed, take it off the instance map.
		
		protected static function onRemoval(ev:Event) {
			var inst:ParticleManager = ev.target as ParticleManager;
			if(inst != null) {
				var index:int = instanceMap.indexOf(inst);
				instanceMap.splice(index,1);
			}
		}
	
	}
}
