/*	AS 3.0
 *
 *	Basic format for as classes
 *	Author @ Abraham Lee
 *	
 *
 */
 
 package com.neopets.users.abelee.resources.particles
 {
	 
	 //--------------------------------------------------
	 // IMPORTS 
	 //--------------------------------------------------	 
	 import flash.display.Sprite;
	 
	 // TBD if particles should move timeline based or timer based
	 import flash.utils.Timer;
	 import flash.events.TimerEvent;	
	 import flash.events.Event;
	 
	 //--------------------------------------------------
	 // CUSTOM IMPORTS 
	 //--------------------------------------------------
	 
	 public class ParticleGenerator extends Sprite
	 {
		 //--------------------------------------------------
		 // VARIABLES
		 //--------------------------------------------------
		 private var mParticleArray:Array;
		 private var mActiveParticleArray:Array;
		 private var mInactiveParticleArray:Array;
		 private var mTimer:Timer;
		 
		 //--------------------------------------------------
		 // CONSTRUCTOR 
		 //--------------------------------------------------
		 public function ParticleGenerator ()
		 {
			 trace ("ParticleGenarator")
			 initVariables()
		 }
		 
		 //--------------------------------------------------
		 // SETTERS AND GETTERS
		 //--------------------------------------------------
		 
		 //--------------------------------------------------
		 // PUBLIC METHODS
		 //--------------------------------------------------
		 public function reset():void
		 {
			 
		 }
		 
		 public function pauseParticles():void
		 {
			 
		 }
		 
		 public function cleanup():void
		 { 
		 	mParticleArray = null;
			mActiveParticleArray = null;
			mInactiveParticleArray = null;
			mTimer.stop()
			mTimer = null;
		 }
		 
		 public function run():void
		 {
			addEventListener(Event.ENTER_FRAME, handleParticles)
		 }
		 
		 public function timerRun(n:Number):void
		 {
			 
		 }
		 
		 //particle behaviors
		 public function behaviorBasic(px:Number, py:Number, num:int):void
		 {
			 
		 }
		 
		 public function createCircleFormation(px:Number, py:Number, pNum:int, pRadius:Number, pPower:Number, pGravity:Array = null, pFriction:Number = 0):void
		 {
			 var pTerminateCond:Object = new Object ()
			 var particles:ParticleBehaviorCircleFormation = new ParticleBehaviorCircleFormation (px, py, pNum, pRadius, pPower, mParticleArray, ParticleImage, null, pGravity, pFriction);
			 addParticles ()
		 }
		 
		 
		 //--------------------------------------------------
		 // PRIVATE METHODS 
		 //--------------------------------------------------
		 private function initVariables():void
		 {
			mParticleArray = new Array ();
			mActiveParticleArray = new Array ();
			mInactiveParticleArray= new Array ();
			mTimer = new Timer (0);
		 }
		 
		
		 
		 private function addParticles():void
		 {
			for (var i in mParticleArray)
			{
				var particle:ParticleBasic = mParticleArray[i]
				addChild(particle.image);
			}
		 }
		 
		 private function removeParticle(p:ParticleBasic):void
		 {
			 for (var i in mParticleArray)
			{
				if (mParticleArray[i] == p)
				{
					mParticleArray.splice(i, 1);
				}
			}
		 }
		 //--------------------------------------------------
		 // EVENT LISTENER
		 //--------------------------------------------------
		  private function handleParticles (e:Event):void
		 {
			for (var i in mParticleArray)
			{
				var particle:ParticleBasic = mParticleArray[i]
				if (particle.active)
				{ 
					particle.update();
				}
				else
				{
					removeChild(particle.image)
					removeParticle(particle)
					//particle.cleanup()					
				}
			}
			//trace (mParticleArray.length);
		 } 
	 }
	 
 }
 
 