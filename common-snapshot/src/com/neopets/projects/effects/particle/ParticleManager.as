/**
 *	Singleton Design Pattern (in a static format)
 *
 *	Particle Manager will keep track of active and inactive particless
 *	When particles are created, they'll be stored in active array.
 *	When particles have decayed, they'll be stored in inactive array. 
 *	When new particles are needed, it'll pull particles from inactive array and make them active
 *	If there are no inactive particles, it'll create new particles
 *
 *	@NOTE: to use this, one must init this first
 *	
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  08.18.2009
 */

package com.neopets.projects.effects.particle
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------

	
	
	public class ParticleManager
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		private static var mReturnedInstance:ParticleManager;
		private var mActiveParticles:Array 	// active particles are stored here
		private var mInactiveParticles:Array	// inactive particles are stored here
		private var mInitiated:Boolean = false	//true once it's initiated
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function ParticleManager(pPrivCl : PrivateClass):void
		{
			
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public static function get instance( ):ParticleManager
		{
			if( ParticleManager.mReturnedInstance == null ) 
			{
				ParticleManager.mReturnedInstance = new ParticleManager( new PrivateClass( ) );
				ParticleManager.instance.init()	// this can be called outside if needed be, to do it comment this line and use "ParticleManager.setup()"
			}
			
			return ParticleManager.mReturnedInstance
		}
				
		public static function get activeParticles():Array
		{
			return ParticleManager.instance.activeParticles()
		}
		
		public static function get inactiveParticles():Array
		{
			return ParticleManager.instance.inactiveParticles()
		}
		
		
		
		
		
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		public static function setup():void
		{
			ParticleManager.instance.init()
		}
		
		public static function makeParticle(pNum:uint = 1):Array 
		{
			return ParticleManager.instance.createParticle(pNum);
		}
		
		public static function sortParticles():void
		{
			ParticleManager.instance.sortParticles();
		}
		
		public static function resetParticles():void
		{
			ParticleManager.instance.resetParticles();
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		
		private function activeParticles():Array
		{
			return mActiveParticles
		}
		
		private function  inactiveParticles():Array
		{
			return mInactiveParticles
		}
		
		/**
		 *	Once instance is created, init should be called to have initial setup
		 **/
		private function init():void
		{
			if (!mInitiated)
			{
				trace ("\n//////////\nParticle Manager initiated\n//////////\n")
				mInitiated = true
				mActiveParticles = [];
				mInactiveParticles = [];
				trace (mInitiated, mActiveParticles.length, mInactiveParticles.length)
			}
		}
		
		
		/**
		 *	If inactive array is empty then create particles and put them in active array
		 *	Otherwise, recycle inactive particle
		 *	@NOTE:	this returns the array of particles that was just built/created
		 *	@PARAM		pNum:uint		Number of particles to be created
		 **/
		private function createParticle(pNum:uint = 1):Array
		{
			if (pNum <= 0)
			{
				return [];	// if there is no more, return empty array
			}
			else 
			{
				var num:uint = pNum;
				var tempArray:Array = [];	// array holds created particles
				if (mInactiveParticles.length == 0)	// if inactive is empty create new particles
				{
					while (num > 0)
					{
						num--
						var particle:BaseParticle = new BaseParticle ()
						mActiveParticles.push(particle)
						tempArray.push(particle)
					}
					
					return tempArray
				}
				else
				{
					//otherwise take a particle from inactive, reset it and call the function again
					var tempParticle:AbsParticle = AbsParticle(mInactiveParticles.pop())
					tempParticle.reset()
					mActiveParticles.push(tempParticle)
					tempArray.push(tempParticle)
					return (tempArray.concat(createParticle(num -1)))
				}
			}
		
		}
		
		
		/**
		 *	Taked decayed particles and move them over from active to inactive array
		 *	This should be called every frame
		 **/
		private function sortParticles():void
		{
			var newArray:Array = []
			while (mActiveParticles.length > 0)
			{
				var tempParticle:AbsParticle = AbsParticle(mActiveParticles.shift());
				tempParticle.decay <= 0 ? mInactiveParticles.push(tempParticle):newArray.push(tempParticle);
			}
			mActiveParticles = newArray
		}
		
		/**
		 *	more all particles in active Array to reserve
		 **/
		private function resetParticles():void
		{
			while (mActiveParticles.length > 0)
			{
				var tempParticle:AbsParticle = AbsParticle(mActiveParticles.shift());
				tempParticle.reset();
				mInactiveParticles.push(tempParticle);
			}
			mActiveParticles = []
		}
		
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
	}
	
}

//
class PrivateClass
{
	public function PrivateClass( )
	{
		//trace( "PrivateClass in GlobalGameReference instantiated" );
	}

} 