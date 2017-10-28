package com.neopets.users.abelee.resource.particles
{
	import flash.display.Sprite
	import flash.display.DisplayObject
	import flash.display.Stage
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	//import flash.events.Event;

	public class CreateParticles extends Sprite {
		
		private var myTimer		:Timer
		private var _parArray	:Array
		private var _sfSprite 	:Sprite
		//private var _particleImg:*
		
		public function CreateParticles (sp:Sprite){//, img:*) {
			//_particleImg = img
			init(sp)
		}
		
		private function init(sp:Sprite) {
			_sfSprite = sp
			//addChild(_sfSprite)
			_parArray = new Array()
			myTimer = new Timer(40)
			myTimer.addEventListener(TimerEvent.TIMER, moveParticles)
			myTimer.start()
		}
		
		public function createParticles(x:Number, 
										y:Number, 
										_particleImg:Class,
										n:uint = 15, 
										gravity:Number = 0,
										friction:Number = .9,
										alphaRate:Number = .9,
										power:Number = 3,
										variation:Number = .5,
										rotate:Boolean = false):void {
			for (var i:uint = 0; i < n; i++) {
				var p:Particle = new Particle (_parArray, x , y, new _particleImg, gravity, friction ,alphaRate, power, variation, rotate)
				_parArray.push(p)
				_sfSprite.addChild(p)
			}
		}
		
		
		
		
		private function moveParticles(e:TimerEvent):void {
			for (var i in _parArray) {
				_parArray[i].moveParticle()
			}
		}
		
		public function cleanUpParticles():void {
			myTimer.stop()
			myTimer.removeEventListener(TimerEvent.TIMER, moveParticles)
			/*
			for (var i:uint = 0; i < _sfSprite.numChildren; i++) {
			}*/
		}
		
		//setters and getters
		/*
		public function set image (pImg:DisplayObject):void {
			_particleImage = pImg
		}*/
	}
	
}