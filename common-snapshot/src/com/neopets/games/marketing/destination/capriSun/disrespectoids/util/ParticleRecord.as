
package com.neopets.games.marketing.destination.capriSun.disrespectoids.util
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	
	import com.neopets.util.general.GeneralFunctions;
	
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.util.IParticle;
	
	/**
	 *	This class manages particle lists across every display object container that uses them.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern Multiton
	 * 
	 *	@author David Cary
	 *	@since 6.17.2010
	 */
	 
	public class ParticleRecord extends EventDispatcher
	{
		//--------------------------------------
		//  PRIVATE / PROTECTED VARIABLES
		//--------------------------------------
		protected var _container:DisplayObjectContainer;
		protected var _particles:Array;

		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function ParticleRecord(con:DisplayObjectContainer=null) {
			_container = con;
			_particles = new Array();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get container():DisplayObjectContainer { return _container; }
		
		public function set container(con:DisplayObjectContainer) {
			clearParticles();
			// clear listeners
			if(_container != null) {
				_container.removeEventListener(Event.REMOVED,onContainerRemoved);
			}
			// set up new listeners
			_container = con;
			if(_container != null) {
				_container.addEventListener(Event.REMOVED,onContainerRemoved);
			}
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		// Use this function to remove all particles from the target container.
		
		public function clearParticles():void {
			var particle:DisplayObject;
			while(_particles.length > 0) {
				particle = _particles.pop();
				if(_container != null) _container.removeChild(particle);
			}
		}
		
		// Use this function to retrieve an unused particle of the target class.
		
		public function getFreeParticle(class_def:Class):DisplayObject {
			// cycle through all particles
			var particle:DisplayObject;
			var i_part:IParticle;
			for(var i:int = 0; i < _particles.length; i++) {
				particle = _particles[i];
				// check if particle is a valid type
				if(class_def == null || particle is class_def) {
					if(particle is IParticle) {
						i_part = particle as IParticle;
						if(!i_part.active) {
							i_part.active = true;
							return particle;
						}
					} else return particle;
				}
			}
			// if we got this far the particle doesn't exist, so create it now.
			particle = new class_def();
			if(_container != null) _container.addChild(particle);
			_particles.push(particle);
			return particle;
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
		
		// Clear all particles when the container is removed.
		
		protected function onContainerRemoved(ev:Event) {
			clearParticles();
			// clear our container
			container = null;
			// let listeners know we've been cleared
			dispatchEvent(new Event(Event.REMOVED));
		}
	
	}
}
