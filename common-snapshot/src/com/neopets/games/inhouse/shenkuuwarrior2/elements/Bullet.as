//Marks the right margin of code *******************************************************************
package com.neopets.games.inhouse.shenkuuwarrior2.elements
{
	import caurina.transitions.Tweener;
	
	import com.neopets.games.inhouse.shenkuuwarrior2.gamedata.GameInfo;
	import com.neopets.games.inhouse.shenkuuwarrior2.gamedata.Parameters;
	import com.neopets.users.vivianab.DashedLine;
	import com.neopets.util.collision.geometry.CircleArea;
	import com.neopets.util.collision.objects.CollisionProxy;
	import com.neopets.util.collision.objects.CollisionSensor;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	
	/**
	 * public class bullet extends Sprite
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class Bullet 
	{
		//--------------------------------------------------------------------------
		// Costants
		//--------------------------------------------------------------------------	
		/**
		 * The permanence of the trailer
		 */
		public static const TRAILER_TIME:Number = 0.5;
		//--------------------------------------------------------------------------
		//Public properties
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		//--------------------------------------------------------------------------
		//Private properties
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		//classes
		protected var _trailClass:Class;
		//spatial
		protected var _container:Sprite;
		protected var _bb:MovieClip;
		
		protected var _aimline:Sprite;
		protected var _bounds:Rectangle;
		//initial velocity
		protected var vxo:Number = 0;
		protected var vyo:Number = 0;
		//velocity
		protected var _vx:Number;
		protected var _vy:Number;
		
		//physics
		protected var _g:Number = GameInfo.G;
		protected var _drag:Number = GameInfo.DRAG;
		protected var _bounce:Number = GameInfo.BOUNCE_HOOK;
		//collision engine
		protected var _proxy:CollisionProxy;
		//_launchforce represents the actual force used.
		protected var _launchforce:Number = GameInfo.HOOK_LAUNCH_F;
		//timer interval
		protected var T:Number = GameInfo.T_INTERVAL/GameInfo.G_MULTIPLIER;
		protected var t:Number = T;
		//flags
		protected var _hasAimline:Boolean;
		protected var _launched:Boolean = false;
		protected var _falling:Boolean = false;
		protected var _reset:Boolean = false;

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * The Bullet class manages the movement of a bullet object. Optionally, it has a trail and an aimline.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 * 
		 * @param bullet Sprite of the bullet display obj
		 * @param container  			the display object container
		 * @param trailerBulletClass 	the Class representing the trailer object (optional)
		 * @param aimlin Boolean 		whether or not the bullet has a aimline (optional)
		 *
		 * 
		 */
		public function Bullet(bullet:MovieClip, container:Sprite, trailerBullet:Class=null, aimline:Boolean = false)
		{
			super();
			//container
			_container = container;
			_bb = bullet;
			
			_hasAimline = aimline;

			if (trailerBullet){
				_trailClass = trailerBullet;
			}
			//
			setUp();
			// make sure the coliision proxy is properly set up
			if(_bb != null) {
				if(_bb.stage != null) onProxyInit();
				else _bb.addEventListener(Event.ADDED_TO_STAGE,onProxyInit);
			}
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------
		public function pointandshoot(refMc:MovieClip=null):Boolean{
			
			clearAimLine();
			
			//costant  force
			var angleRad:Number = Math.atan2(_bb.y-_container.mouseY, _container.mouseX-_bb.x);
			
			_vx = _launchforce * Math.cos (angleRad);
			_vy = _launchforce * Math.sin(angleRad)*-1;
			//trace ("initial velocity", _vx, _vy)
			//new
			shoot();
			return true;
		}
		
		
		public function hook():void {
			_launched = false;
			t = T;
		}
		
		
		public function update (endlevel:Boolean=false):void{ 
			//var angle:Number;
			if (_launched && !isReset){
				
				//gravity accelleration (y only)
				var g:Number = _g*t;
				//trace (_g, t, g);
				
				//calculate new velocity
				_vx = _vx*_drag;
				_vy = _vy*_drag + g;
				//angle
				//angle = Math.atan2(_vx, _vy)*180/Math.PI-180;
				//_bb.rotation = - angle;

				
				//check collision with bounds
				if (_bb.x +_bb.width/2 > _bounds.x +_bounds.width){
					_bb.x = _bounds.x+_bounds.width-_bb.width/2;
					_vx = -_vx*_drag*_bounce;
					//trace ("change dir left");
				};
				if ( _bb.x - _bb.width/2 < _bounds.x){
					_bb.x = _bounds.x + _bb.width/2;
					_vx = -_vx*_drag*_bounce;
				}
				
				//set the _falling flag
				if (_bb.y < _bb.y+_vy){
					_falling = true;
				} else {
					_falling = false;
				}
				
				//apply
				_bb.x += _vx;//*scale;
				_bb.y += _vy;//*scale;
				makeTrail();
				_proxy.synch();
				
				//time increment
				t += T;
				
			
			} else {
			    //pointing: THIS NOW HAPPENS IN THE WARRIOR SYMBOL, WHER ETHE AIMER IS LOCATED
				/*if (_container.mouseX < GameInfo.STAGE_WIDTH && _container.mouseX > 0 && _container.mouseY < GameInfo.STAGE_HEIGHT && _container.mouseY > 0){
					aim (_container.mouseX, _container.mouseY);
				}
				angle = - Math.atan2( _bb.x -_container.mouseX, _bb.y - _container.mouseY)*180/Math.PI;
				//_bb.rotation = angle;
				_aimer.rotation = angle;*/
			}
		}
		
		public function clearAimLine():void {
			//for (var i:int = 0;  i < _aimline.numChildren; i++){
			//	_aimline.removeChildAt(i);
			//}
		}
		
		public function reset ():void {
			trace (this, "reset");
			isReset = true;
			_bb.x = GameInfo.STAGE_WIDTH/2;
			_bb.y = GameInfo.STAGE_HEIGHT -_bb.height/2;
			_vx = vxo;
			_vy = vyo;
			t = T;
			_launched = false;
			_falling = false;
		}
				
		public function cleanUp():void {
			Tweener.removeAllTweens();
			//remove children
			//remove all children
			for (var i:int = _container.numChildren-1; i>=0; i--){
				_container.removeChildAt(i);
			}
			//TODO: IMPLEMENT THIS PROPERLY
		}
		//--------------------------------------------------------------------------
		// Private/Protected Methods
		//--------------------------------------------------------------------------	
		protected function setUp():void {
			//Parameters
			updateParameters();
			//bounds
			_bounds = new Rectangle (0,0, GameInfo.STAGE_WIDTH, GameInfo.STAGE_HEIGHT);
			//bullet
			_container.addChild(_bb);
			_bb.x = GameInfo.STAGE_WIDTH/2;
			_bb.y = GameInfo.STAGE_HEIGHT-_bb.height/2;
			//aimline
			if (_hasAimline){
				_aimline = new Sprite ();
				_container.addChild (_aimline);
			}
			//initial velocity
			_vx = vxo;
			_vy = vyo;
		}
		
		
		protected function makeTrailBullet ():DisplayObject{
			var trb:DisplayObject = new _trailClass();
			Tweener.addTween(trb, {alpha:0, time:TRAILER_TIME, onComplete:removeTrailer, onCompleteParams:[trb]});
			return trb;
		}

		
		protected function removeTrailer(trailB:Sprite):void {
			if (_container.contains(trailB)){
				_container.removeChild(trailB);
			}
		}
		
		protected function makeTrail():void {
			if (_trailClass){
				//make trail
				var trb:DisplayObject = makeTrailBullet();
				trb.x = _bb.x;
				trb.y = _bb.y;
				_container.addChild(trb);
			}
		}
		
		public function updateParameters ():void {
			_g = Parameters.instance.g;
			_launchforce = Parameters.instance.hook_force;
			_drag = Parameters.instance.drag;
		}
		
		//--------------------------------------------------------------------------
		// Event Handlers
		//--------------------------------------------------------------------------	
		protected function aim (X:Number, Y:Number):void {
			if (_hasAimline){
				clearAimLine();
				var dashy:DashedLine = new DashedLine(0.5,0xff0000,new Array(3,3,3,3,3,3,3,3));
				dashy.moveTo(_bb.x, _bb.y);
				dashy.lineTo(X-2, Y+2);
				_aimline.addChild(dashy);
			}
		}
		
		protected function shoot(e:KeyboardEvent=null):void {
			_launched = true;
		}
		
		protected function onProxyInit(ev:Event=null):void {
			if(_bb != null && _bb.stage != null) {
				if(_proxy == null) _proxy = new CollisionProxy(_bb);
				_proxy.area = new CircleArea(_bb);
				_proxy.trailLevel = CollisionSensor.LINE_TRAIL;
				//_proxy.synchLevel = CollisionProxy.ALWAYS_SYNCH;
				_proxy.addTo(GameInfo.COLLISION_SPACE);
				_bb.removeEventListener(Event.ADDED_TO_STAGE,onProxyInit);
			}
		}
		
		//--------------------------------------------------------------------------
		// Getters/Setters
		//--------------------------------------------------------------------------
		public function get displayObject():Sprite{
			return _bb;
		}
		
		public function set hasAimLine (value:Boolean):void {
			_hasAimline = value;
		}
		
		public function get isReset ():Boolean{
			return _reset;
		}
		
		public function set isReset (value:Boolean):void {
			_reset = value;
		}
		
		public function get proxy ():CollisionProxy{
			return _proxy;
		}
		
		public function get vy ():Number {
			return _vy;
		}
		
		public function get vx ():Number {
			return _vx;
		}

	}
}