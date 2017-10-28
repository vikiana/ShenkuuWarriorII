











package com.neopets.users.abelee.resource.particles
{
	import flash.display.*;
	
	public class FreeParticle extends Sprite{
		//position
		private var _lastX:Number;
		private var _lastY:Number;
		private var _currX:Number;
		private var _currY:Number;
		
		//spead, velosiy and direction
		private var _radAngle:Number;
		private var _speed:Number;	
		private var _xForce:Number
		private var _yForce:Number
		
		private var _friction:Number
		private var _vx:Number
		private var _vy:Number
	
		//image appearance fade out
		private var _image:DisplayObject;		//this maybe a class or bitmap
		private var _orientaionAngle:Number;
		private var _alphaRate:Number;
		private var _rotate:Boolean;
		
		private var _scale:Boolean
		
		private var _alphaFactor:Number = 1
		
		//Determines when paticle should die or recycled 
		//private var _active:Boolean;
		
		//Array that particle should exist in
		private var _parentArray:Array
		
		public function FreeParticle(pArray:Array,
								 x:int, 
								 y:int, 
								 _spriteRef:DisplayObject, 
								 xForce:Number = 0,
								 yForce:Number = 0,
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
			_yForce = yForce;
			_xForce = xForce
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
			_image.alpha = .05
			//
		}
		
		public function moveParticle ():void {
			_yForce *= _friction
			_xForce *= _friction
			_vy += _yForce
			_vx += _xForce
			_vx *= _friction + (Math.random() -.5) * .5
			_vy *= _friction + (Math.random() -.5) * .5
			
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
				removeChild(_image)
			}
			
		}
		
		private function updateDisplayImg():void {
			/*
			if (_rotate) {
				var radAngle:Number = Math.atan2(_currY -_lastY, _currX - _lastX)
				var angle:Number =  radAngle * 180 / Math.PI
				_image.rotation = angle
			}*/
			_image.x = _currX
			_image.y = _currY
			if (_alphaFactor == 1 && _image.alpha < 1) {
				_image.alpha += .05
			}else if (_alphaFactor == 1 && _image.alpha >= 1) {
				_alphaFactor = -1
			}else {
				_image.alpha *= _alphaRate
			}
		}
	}
}