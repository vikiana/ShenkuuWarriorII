package com.neopets.users.abelee.resource.particles
{
	import flash.display.*;
	
	public class Particle extends Sprite{
		//position
		private var _lastX:Number;
		private var _lastY:Number;
		private var _currX:Number;
		private var _currY:Number;
		
		//spead, velosiy and direction
		private var _radAngle:Number;
		private var _speed:Number;	
		private var _gravity:Number
		private var _friction:Number
		private var _vx:Number
		private var _vy:Number
	
		//image appearance fade out
		private var _image:DisplayObject;		//this maybe a class or bitmap
		private var _orientaionAngle:Number;
		private var _alphaRate:Number;
		private var _rotate:Boolean;
		
		private var _scale:Boolean
		
		//Determines when paticle should die or recycled 
		//private var _active:Boolean;
		
		//Array that particle should exist in
		private var _parentArray:Array
		
		public function Particle(pArray:Array,
								 x:int, 
								 y:int, 
								 _spriteRef:DisplayObject, 
								 gravity:Number = 0, 
								 friction:Number = 1,
								 alphaRate:Number = 1,
								 power:Number = 10, 
								 variation:Number = 5,
								 rotate:Boolean = false,
								 scale:Boolean = false,
								 scaleRate:Number = .2) {
			
			_parentArray = pArray;
			_image = _spriteRef
			_rotate = rotate
			_lastX = _currX  = _image.x = x
			_lastY = _currY  = _image.y = y
			_gravity = gravity
			_friction = friction
			_alphaRate = alphaRate
			_scale = scale
			_speed	= Math.random()* variation + power//speed range = 10 - 15 by defautl
			_radAngle = Math.random()* Math.PI * 2 //rage 0 to 3.14 * 2 gives whole circle
			_vx = Math.cos(_radAngle) * _speed
			_vy = Math.sin(_radAngle) * _speed
			addChild(_image)
			if (_scale) {
				_image.scaleX = _image.scaleY = scaleRate + Math.random() * (1-scaleRate)
			}
			//
		}
		
		public function moveParticle ():void {
			_gravity *= _friction
			_vy += _gravity 
			_vx *= _friction //+ (Math.random() -.5) * .5
			_vy *= _friction //+ (Math.random() -.5) * .5
			
			_lastX = _currX 
			_lastY = _currY 
			_currX += _vx 
			_currY += _vy 
			
			updateDisplayImg()
			
			if ((Math.abs(_vx) < .001 && Math.abs(_vy) < .001) || _image.alpha <= 0) {
				//_active = false
				for (var i in _parentArray) {
					if (_parentArray[i] == this) {
						_parentArray.splice(i, 1)
					}
				}
				cleanup();
			}
			
		}
		
		public function cleanup():void
		{
			removeChild(_image)
			
			_lastX = undefined;
			_lastY = undefined;
			_currX = undefined;
			_currY = undefined;
			_radAngle = undefined;
			_speed = undefined;
			_gravity = undefined;
			_friction = undefined;
			_vx = undefined;
			_vy = undefined;
			_image = null;
			_orientaionAngle = undefined;
			_alphaRate= undefined;
			_rotate = undefined;
			_scale = undefined;
			
			_parentArray = undefined;
		}
		private function updateDisplayImg():void {
			
			if (_rotate) {
				var radAngle:Number = Math.atan2(_currY -_lastY, _currX - _lastX)
				var angle:Number =  radAngle * 180 / Math.PI
				_image.rotation = angle
			}
			_image.x = _currX
			_image.y = _currY
			_image.alpha *= _alphaRate
		}
	}
}