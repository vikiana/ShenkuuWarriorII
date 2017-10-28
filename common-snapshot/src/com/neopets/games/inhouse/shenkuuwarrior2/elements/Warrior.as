//Marks the right margin of code *******************************************************************
package com.neopets.games.inhouse.shenkuuwarrior2.elements
{
	import caurina.transitions.Tweener;
	
	import com.neopets.games.inhouse.shenkuuwarrior2.elements.Bullet;
	import com.neopets.games.inhouse.shenkuuwarrior2.gamedata.GameInfo;
	import com.neopets.games.inhouse.shenkuuwarrior2.gamedata.Parameters;
	import com.neopets.games.inhouse.shootergame.utils.Mathematic;
	import com.neopets.util.collision.geometry.CircleArea;
	import com.neopets.util.collision.objects.CollisionProxy;
	import com.neopets.util.collision.objects.CollisionSensor;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.sound.SoundManager;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	
	
	/**
	 * public class Warrior extends Bullet
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class Warrior extends Bullet
	{
		//--------------------------------------------------------------------------
		// Costants
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		//--------------------------------------------------------------------------
		//Public properties
		//--------------------------------------------------------------------------	
		//--------------------------------------------------------------------------
		//Private properties
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		//bounds
		private var _newY:Number;
		//physics
		protected var _ropePull:Number = GameInfo.ROPE_PULL_F;
		protected var _slowdown:Number = 1;
		//flags
		private var _tipPointFlag:Boolean = false;
		private var _scrollbg:Boolean = false;
		private var _onGround:Boolean = true;
		private var _powerup:Boolean = false;
		private var _kpowerup:Boolean = false;
		//
		private var _pu_xdir:Number = 1;
		
		private var _altitude:Number;
		
		
		//embedded mcs
		public var arm:MovieClip;
		public var aimer:MovieClip;
		public var arrow:MovieClip;
		public var hitarea:Sprite;
		
		private var _isSoundOn:Boolean = true;
		
	
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Creates a new public class Warrior extends Bullet instance.
		 * 
		 */
		public function Warrior(bullet:MovieClip, container:Sprite, trailerBullet:Class=null, aimline:Boolean=false)
		{
			
			super(bullet, container, trailerBullet, aimline);
			
			_newY = _bb.y;
			_bb.gotoAndStop(1);
			_altitude = 0;
		}
	
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		/**
		 * This is the formula that regulates the pull that the rope has on the warrior. It's proportional to the distance to the ledge: the farther 
		 * the ledge, the stronger the pull.
		 * 
		 * @param  hookX  
		 * @param  hookY 
		 * 
		 */
		public function launch (hookX:Number, hookY:Number):void {
			if (_isSoundOn){
				SoundManager.instance.soundPlay(GameInfo.WARRIOR_GRUNT_SOUND+String(Mathematic.randRange(1, 3)), false, 0, 0, 0.3);
			}
			_tipPointFlag = false;
			_slowdown = 1;
			//OLD: pull force depends on distance from ledge
			//_vx = (hookX - _bb.x)* _ropePull;
			//_vy = (hookY - _bb.y)* _ropePull;
			//NEW: pull force is level-specific
			var angleRad:Number = Math.atan2(_bb.y-_container.mouseY, _container.mouseX-_bb.x);
			_vx = _ropePull * Math.cos (angleRad);
			_vy = _ropePull * Math.sin(angleRad)*-1;
			_launched = true;
			_falling = false;
			trace ("LAUNCH");
		}
		
		/**
		 * This calculates the time it'll take to the warrior to reach the ledge she just hooked to.
		 * 
		 * @param  destY	y position of the ledge  
		 * 
		 */
		public function getReachLedgeTime (destY:Number):Number {
			//trace (this, "GET REACH TIME");
			var t:Number = destY - (_vy*_drag)/_g;
			//t *= GameInfo.T_INTERVAL*GameInfo.G_MULTIPLIER;
			return t;
		}
		
	
		override public function update (endlevel:Boolean=false):void{ 
			
			//warrior facing 
			if (_container.mouseX > _bb.x){
				_bb.scaleX = -1;
			} else {
				_bb.scaleX = 1;
			}
			
			//reset g
			var g:Number =0;
			
			if (_launched && !isReset){
				
				if (!_powerup){
					
					if (!_onGround){
						//gravity accelleration (y only)
						g = _g*t;
						//trace (G, t, g);
					}
					//trace ("onGround", _onGround, "g", g);
					if (_falling || _onGround){
						//trace ("falling");
						_slowdown = 1;
					} 
					

					//calculate new velocity
					_vx = _vx*_drag;
					_vy = (_vy/_slowdown)*_drag + g ;
					
					//apply velocity to all
					if (endlevel){
						//_bb.x += _vx;
						_vy = 30;
						_bb.y += _vy;
						_scrollbg = true;
						return;
					}
					
					//check collision with bounds
					if (_bb.x +_bb.width/2 > _bounds.x +_bounds.width){
						_bb.x = _bounds.x+_bounds.width-_bb.width/2;
						_vx = - Parameters.instance.bounce;
						//trace ("change dir left");
					};
					if ( _bb.x - _bb.width/2 < _bounds.x){
						_bb.x = _bounds.x + _bb.width/2;
						_vx = + Parameters.instance.bounce;
						//trace ("change dir right");
					}
					
					//KITE PUSH
					if (_kpowerup){
						//trace ("kite powerup");
						_tipPointFlag = false;
						_falling = false;
						_vy *= GameInfo.KITE_FORCE;
						_kpowerup = false;
					}
					
				
					//apply
					_bb.x += _vx;
					
					//time increment
					t += T;
				
				} else if (_powerup) {
					//flying powerup "trip"
					var newx:Number = _bb.x+GameInfo.POWERUP_XSPEED*_pu_xdir;
					if ( newx >= GameInfo.STAGE_WIDTH-10 || newx <= 10){
						_pu_xdir*=-1;
					}
					//x mov: floating gently left to right
					_bb.x += GameInfo.POWERUP_XSPEED*_pu_xdir;
					
					//y mov: constant speed 
					_vy = - GameInfo.POWERUP_YSPEED;
					
					
					if (_falling){
						//since the powerup will take me up again, I need to set these to false;
						_tipPointFlag = false;
						_falling = false;
						
					}

				} 
				
				//APPLY vertical movement either to warrior or to background
				
				//calculate new velocity
				_newY += _vy;
				
				//if y velocity is positive, the warrior is falling
				//trace ("TIPOINTFLAG", _tipPointFlag);
				if (_vy > 0 && !_tipPointFlag){
					//trace ("WARRIOR FALLING");
					if (_isSoundOn){
					 	SoundManager.instance.soundPlay(GameInfo.WARRIOR_FALLING_SOUND, false, 0, 0, 0.5);
					}
					_tipPointFlag = true;
					_falling = true;
					//remove kite powerup, if applicable
					//if (_bb.currentLabel == GameInfo.KITE_AIR_MOVING || _bb.currentLabel == GameInfo.KITE_AIR_READY || _bb.currentLabel == GameInfo.KITE_AIR_THROW || _bb.currentLabel == GameInfo.PETPET_AIR_MOVING || _bb.currentLabel == GameInfo.PETPET_AIR_READY || _bb.currentLabel == GameInfo.PETPET_AIR_THROW){
					//TODO  add falling animation
					_bb.gotoAndStop(GameInfo.FALLING);
					//} 
					if (!_powerup){
						_newY = _bb.y;
					}
				}
				
				//if the warrior reached the max height, the bkg and other elements will scroll instead
				if (_newY > GameInfo.MAX_Y){
					_bb.y = _newY;
					makeTrail();
					_scrollbg = false;
				} else {
					_scrollbg = true;
				}
				
				
				//scrolling down
				if (_newY > GameInfo.STAGE_HEIGHT){
					_scrollbg = true;
				} else {
					//update altitude (stop lowering if warrior is falling)
					_altitude+=_vy;
				}
				
				_proxy.synch();
				
			} 
			

			//pointing the aimer
			var angler:Number = Math.atan2( _bb.x -_container.mouseX, _bb.y - _container.mouseY);
			var min:Number;
			var max:Number;
			if (_bb.scaleX >0){
				min = 0;
				max = Math.PI/2;
			} else {
				min = -Math.PI/2;
				max = 0;
			}
			if (angler > min && angler < max){
					var angle:Number = angler *180/Math.PI;
					if (_bb.aimer){
						_bb.aimer.arrow.rotation = - angle*_bb.scaleX;
					}
			}
		}
	
		
		public function slowDown():void {
			_slowdown = Parameters.instance.slowdown;//_ropePull// - _ropePull / 5;
		}
		
		//NOT IN USE - CAN BE USED FOR A POWERUP THAT LAYERS OVER OTHER POWERUPS
		/*public function highlite (flag:Boolean):void {
			if (flag){
				_bb.filters = new Array(new GlowFilter ());
			} else {
				_bb.filters = null;
			}
		}*/
		
		public function aimArm(X:Number, Y:Number):void {
			//position and rotation
			var angler:Number = - Math.atan2( _bb.x -X, _bb.y - Y);
			//var xoffset:Number = tail.height * Math.sin(angler);
			//var yoffset:Number = tail.height * Math.cos(angler);
			_bb.arm.rotation = angler*180/Math.PI*_bb.scaleX;
			//arm.x = _bb.x+xoffset;
			//arm.y = _bb.y-yoffset;
		}
		
		public function finalAnimation():void {
			//reset();
			_bb.scaleX = -1;
			_bb.x = GameInfo.STAGE_WIDTH/2-20;
			_bb.gotoAndStop ("jump-animation");
		}
	
		
		override public function updateParameters ():void {
			super.updateParameters();
			_ropePull = Parameters.instance.warrior_force;
		}
		     
		override public function reset ():void {
			super.reset();
			_newY = _bb.y;
			_powerup = false;
			_altitude = 0;
			_bb.gotoAndStop(1);
		}
	
		//--------------------------------------------------------------------------
		// Protected Methods
		//--------------------------------------------------------------------------
		//DELETE: The following statement was to test the "swinging arm" feature, but the the effect was not very good. 
		/*override protected function setUp():void {
			super.setUp();
			if (_hasAimline){
				_aimline = _arm;
			}
		}*/
		
		//DELETE: The following statement was to test the "swinging arm" feature, but the the effect was not very good. 
		/*override protected function aim (X:Number, Y:Number):void {
			if (_hasAimline){
				//position and rotation
				var angler:Number = - Math.atan2( _bb.x -_container.mouseX, _bb.y - _container.mouseY);
				_aimline.rotation = angler*180/Math.PI;
			}
		}*/
		override protected function onProxyInit(ev:Event=null):void {
			if(_bb != null && _bb.stage != null) {
				if(_proxy == null) _proxy = new CollisionProxy(_bb);
				_proxy.area = new CircleArea(_bb.hitarea);
				_proxy.trailLevel = CollisionSensor.LINE_TRAIL;
				//_proxy.synchLevel = CollisionProxy.ALWAYS_SYNCH;
				_proxy.addTo(GameInfo.COLLISION_SPACE);
				_bb.removeEventListener(Event.ADDED_TO_STAGE,onProxyInit);
			}
		}

		//--------------------------------------------------------------------------
		// Private Methods
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		// Event Handlers
		//--------------------------------------------------------------------------	
		//--------------------------------------------------------------------------
		// Getters/Setters
		//--------------------------------------------------------------------------
		public function get bkgVy ():Number {
			if (_scrollbg){return _vy;} 
			return 0;
		}
		
		public function set vy (value:Number):void {
			_vy = value;
		}
		
		public function get altitude ():Number {
			return Math.floor(Math.abs(_altitude));
		}
		
		public function set onGround(value:Boolean):void {
			_onGround = value;
		}
		
		public function get onGround():Boolean {
			return _onGround;
		}
		
		public function set isPowerup (value:Boolean):void {
			_powerup = value;
		}
		
		public function get isPowerup():Boolean{
			return _powerup;
		}
		
		public function set isKitePowerup (value:Boolean):void {
			_kpowerup = value;
		}
		
		public function set isSoundOn (value:Boolean):void {
			_isSoundOn = value;
		}

		
	}
}