package com.neopets.users.abelee.resource.particles
{
	import flash.display.Sprite
	import flash.display.DisplayObject
	import flash.display.Stage
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;

	public class CreateParticleEffects extends Sprite {
		
		public static const RANDOM_PARTICLE:String = "randomParticle";
		public static const CIRCLE_PARTICLE:String = "circleParticle";
		public static const TRIANGLE_PARTICLE:String = "triangleParticle";
		public static const RECTANGLE_PARTICLE:String = "rectangleParticle";
		
		private var myTimer		:Timer
		private var _parArray	:Array
		private var _freeparArray	:Array
		private var _sfSprite 	:Sprite
		private var mSetFilter	:Boolean;
		private var mColor		:Number;
		private var mRunning	:Boolean;
		private var mParticleGenerator: ParticleGenerator;
				
		public function CreateParticleEffects (sp:Sprite, sp2:Sprite = null){//, img:*) {
			//_particleImg = img
			init(sp, sp2)
		}
		
		private function init(sp:Sprite, sp2:Sprite = null) {
			mSetFilter	= false
			mColor		= 0xFFFFFF
			_sfSprite = sp
			if (sp2 == null) {
				addChild(_sfSprite)
			}else {
				sp2.addChild(_sfSprite)  //why in the world did I do this???
			}
			_parArray = new Array()
			_freeparArray = new Array()
			myTimer = new Timer(40)
			myTimer.addEventListener(TimerEvent.TIMER, moveParticles)
			myTimer.start()
			mRunning = true
			mParticleGenerator = new ParticleGenerator();
		}
		
		public function run():void
		{
			if (!mRunning)
			{	mRunning = true;
				myTimer.start()
			}
		}
		
		
		public function reset() 
		{
			
			myTimer.stop()
			mRunning = false
			cleanupEachParticle();
			//_parArray = null;
			//_sfSprite = null;
			
		}
		
		public function createParticles(x:Number, 
										y:Number, 
										_particleImg:*,
										n:uint = 15, 
										gravity:Number = 0,
										friction:Number = .9,
										alphaRate:Number = .9,
										power:Number = 3,
										variation:Number = .5,
										rotate:Boolean = false,
										scale:Boolean = false,
										scaleRate:Number = .2):void 
		{
			for (var i:uint = 0; i < n; i++) {
				var p:Particle = new Particle (_parArray, x , y, new _particleImg, gravity, friction ,alphaRate, power, variation, rotate, scale)
				_parArray.push(p)
				_sfSprite.addChild(p)
			}
		}
		
		public function createParticlesByGraphics
		(
		 	pParticleObject:Object,
		 	x:Number, 
			y:Number, 
			n:uint = 15, 
			gravity:Number = 0,
			friction:Number = .9,
			alphaRate:Number = .9,
			power:Number = 3,
			variation:Number = .5,
			rotate:Boolean = false,
			scale:Boolean = false,
			scaleRate:Number = .2
		):void 
		//##########
		{			
			for (var i:uint = 0; i < n; i++) {
				var particleImage:Sprite;
				var randomSize:Number;
				switch (pParticleObject.TYPE)
				{
					
					case CIRCLE_PARTICLE:
						randomSize = isNaN(pParticleObject.RANDOM_SIZE)? undefined: pParticleObject.RANDOM_SIZE;
						particleImage = mParticleGenerator.generateCircle
										(
							 				pParticleObject.RADIUS,
											pParticleObject.COLOR,
											pParticleObject.LINE,
											pParticleObject.LINE_COLOR,
											randomSize
											
										);
						break;
					
					case RECTANGLE_PARTICLE:
						randomSize = isNaN(pParticleObject.RANDOM_SIZE)? undefined: pParticleObject.RANDOM_SIZE;
						particleImage = mParticleGenerator.generateRectangle
										(
							 				pParticleObject.WIDTH,
											pParticleObject.HEIGHT,
											pParticleObject.COLOR,
											pParticleObject.LINE,
											pParticleObject.LINE_COLOR,
											randomSize
										);
						break;
					
					case TRIANGLE_PARTICLE:
						randomSize = isNaN(pParticleObject.RANDOM_SIZE)? undefined: pParticleObject.RANDOM_SIZE;
						particleImage = mParticleGenerator.generateTriangle
										(
							 				pParticleObject.WIDTH,
											pParticleObject.HEIGHT,
											pParticleObject.COLOR,
											pParticleObject.LINE,
											pParticleObject.LINE_COLOR,
											randomSize
										);
						break;
					case RANDOM_PARTICLE:
						randomSize = isNaN(pParticleObject.RANDOM_SIZE)? undefined: pParticleObject.RANDOM_SIZE;
						particleImage = mParticleGenerator.generateRandom
										(
										 	pParticleObject.RADIUS,
							 				pParticleObject.WIDTH,
											pParticleObject.HEIGHT,
											pParticleObject.COLOR,
											pParticleObject.LINE,
											pParticleObject.LINE_COLOR,
											randomSize
										);
						break;
				}
				
				
				
				var p:Particle = new Particle (_parArray, x , y, particleImage, gravity, friction ,alphaRate, power, variation, rotate, scale)
				_parArray.push(p)
				_sfSprite.addChild(p)
			}
		}
		
		public function createFreeParticles(x:Number, 
										y:Number, 
										_particleImg:*,
										n:uint = 15, 
										xGravity:Number = 0,
										yGravity:Number = 0,
										friction:Number = .9,
										alphaRate:Number = .9,
										power:Number = 3,
										variation:Number = .5,
										rotate:Boolean = false,
										scale:Boolean = false,
										scaleRate:Number = .2,
										maxNumber:uint = 60):void {
			for (var i:uint = 0; i < n; i++) {
				if (_freeparArray.length < maxNumber) {
					var p:FreeParticle = new FreeParticle (_freeparArray, x , y, new _particleImg, xGravity,yGravity, friction ,alphaRate, power, variation, rotate)
					_freeparArray.push(p)
					//trace (_freeparArray.length)
					_sfSprite.addChild(p)
				}
			}
		}
		
		private function moveParticles(e:TimerEvent):void {
			for (var i in _parArray) {
				_parArray[i].moveParticle()
			}
			for (var j in _freeparArray) {
				_freeparArray[j].moveParticle()
			}
		}
		
		private function cleanupEachParticle():void {
			for (var i in _parArray) {
				_parArray[i].cleanup()
			}
			_parArray = []
		}
		
		public function cleanUpParticles():void {
			myTimer.stop()
			myTimer.removeEventListener(TimerEvent.TIMER, moveParticles)
			_parArray = null;
			_sfSprite = null;
		}
		
		
		
		public function cleanup():void {
			//cleanupEachParticle();
			myTimer.stop()
			myTimer.removeEventListener(TimerEvent.TIMER, moveParticles)
			/*
			_parArray = null;
			_sfSprite = null;
			myTimer = null
			_parArray = null
			_freeparArray = null
			_sfSprite = null
			mSetFilter = undefined
			mColor = undefined
			*/
		}
		
		
		/*
		========================================
		particle formations and variations
		========================================
		*/
		/*
		public function createTrail(n:uint, color:Number):void {
			if (! _timerRunning) {
				_timerRunning = true
				_myTimer = new Timer (50, n)
				_myTimer.addEventListener(TimerEvent.TIMER, createTrailAffect)
				_myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, removeTimer)
				_myTimer.start()
			}
		}
		*/
		/*
		private function createTrailAffect(e:TimerEvent):void {
			var pos:Vector = _ball.ballPos
			_sfx.createParticles (pos.x, pos.y, ParticleImage2,  2 , .4, .9, .9, 1, 2)
		}
		*/
		
		/*
		----------------------------------------
		manage filters
		----------------------------------------
		*/
		private function manageFilter(b:Boolean):void {
			if (b) {
				var color:Number = mColor
				var myFilter:GlowFilter = new GlowFilter (color, 1, 4, 4, 2, 3)
				var myFilters:Array = new Array();
				myFilters.push(myFilter)
				_sfSprite.filters = myFilters
			}else {
				_sfSprite.filters = new Array;
			}
		}
		
		/*
		========================================
		setter and getters
		========================================
		*/
		public function set setFilter(b:Boolean):void {
			mSetFilter = b
			manageFilter(mSetFilter);
		}
		
		
	}
	
}