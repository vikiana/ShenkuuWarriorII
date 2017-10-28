package com.neopets.games.inhouse.shootergame.assets.targets
{
	import caurina.transitions.Tweener;
	
	import com.neopets.games.inhouse.shootergame.SharedListener;
	import com.neopets.games.inhouse.shootergame.abstract.AbstractLayer;
	import com.neopets.games.inhouse.shootergame.abstract.AbstractProp;
	import com.neopets.games.inhouse.shootergame.abstract.AbstractTarget;
	import com.neopets.games.inhouse.shootergame.utils.LibraryLoader;
	import com.neopets.games.inhouse.shootergame.utils.Mathematic;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.MovieClip;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	
	
	/**
	 *	Blatering Beech Boss! It's a special kind of target becouse it contains other targets.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 10.0
	 *	
	 * 
	 *	@author Viviana Baldarelli
	 *	@since  05.12.2009
	 */
	public class FirstBoss extends AbstractTarget
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		private static const HITS_TO_DESTROY:Number = 6;
		private static const POINT_VALUE:Number = 10;
		
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		//its parent container
		private var _lc:AbstractLayer;
		//counters
		private var _hitCount:Number;
		//components
		private var _leftarm:FallingTarget;
		private var _rightarm:FallingTarget;
		private var _leftfoot:FallingTarget;
		private var _rightfoot:FallingTarget;
		public var body:FallingTarget;
		//flags
		public var isActive:Boolean;
		private var _hitSomething:Boolean;
		//Limbs Array
		private var _elementsArray:Array;
		
		
		/**
	 	*	Constructor
	 	*/
		public function FirstBoss()
		{
			super();
			_active = true;
			_destroyed = false;
			_hitCount = 0;
		}
		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		override public function init(sl:SharedListener, pValue:Number, layer:AbstractLayer):void {
			_pointsValue = pValue;
			_sl = sl;
			_lc = layer;
			_elementsArray = [];
			isActive = false;
			_hitSomething = false;
			//build boss
			var bpClass:Class = LibraryLoader.getLibrarySymbol("TARGET_tree_body");
			body = new bpClass ();
			body.x = 0;
			body.y = -165;
			body.init (_sl, POINT_VALUE, _lc);
			addChild (body);
			_lc.elementsArray.push (body);
			bpClass = LibraryLoader.getLibrarySymbol("TARGET_tree_leftarm");
			_leftarm = new bpClass ();
			_leftarm.x = -36;
			_leftarm.y = -104;
			_leftarm.init (_sl, POINT_VALUE, _lc);
			addChild (_leftarm);
			_lc.elementsArray.push (_leftarm);
			bpClass = LibraryLoader.getLibrarySymbol("TARGET_tree_rightarm");
			_rightarm = new bpClass ();
			_rightarm.x = 23;
			_rightarm.y = -93;
			_rightarm.init (_sl, POINT_VALUE, _lc);
			addChild (_rightarm);
			_lc.elementsArray.push (_rightarm);
			bpClass = LibraryLoader.getLibrarySymbol("TARGET_tree_leftfoot");
			_leftfoot = new bpClass ();
			_leftfoot.x = -38;
			_leftfoot.y = -63;
			_leftfoot.init (_sl, POINT_VALUE, _lc);
			addChild (_leftfoot);
			_lc.elementsArray.push (_leftfoot);
			bpClass = LibraryLoader.getLibrarySymbol("TARGET_tree_rightfoot");
			_rightfoot = new bpClass ();
			_rightfoot.x = 40;
			_rightfoot.y = -61;
			_rightfoot.init (_sl, POINT_VALUE, _lc);
			addChild (_rightfoot);
			_lc.elementsArray.push (_rightfoot);
			//
			var shadow:DropShadowFilter = new DropShadowFilter();
			shadow.distance = 8;
			shadow.angle = 271;
			shadow.strength = 0.2;
			this.filters = [shadow];
			//EVENT LISTENERS
			_sl.addEventListener(SharedListener.COLLIDE_BOSS, addBullet);
			_sl.addEventListener(SharedListener.GAME_END, cleanUpBoss);
		}
	
		//------------------------------------------------------------------------------------
		//  EVENT HANDLERS
		//-------------------------------------------------------------------------------------
		private function addBullet (e:CustomEvent):void {
			if (e.oData.T ==_lc){
			//	trace ("BOSS HIT CHECK");
				isActive = false;
		     	var localP:Point = new Point (e.oData.X, e.oData.Y);
		     	var globalP:Point = _lc.localToGlobal(localP);
		     	var target:MovieClip;
		     	//check all elements for collision
		     	for (var i:int =0; i<_lc.elementsArray.length; i++){
		     		if (_lc.elementsArray[i] is AbstractTarget){
		     			target =_lc.elementsArray[i];
		     			if (target.hitTestPoint (globalP.x, globalP.y, true)){
		     				if (target !=body){
		     					target.hitReaction();
		     					_hitSomething = true;
		     				} else {
		     					//Boss body hit (last)
		     					if (_lc.elementsArray.length<=1){
		     						target.hitReaction();
		     					}
		     				}
		     			}
		     		} else if (_lc.elementsArray[i] is AbstractProp){
		     			target =_lc.elementsArray[i];
		     			if (target.hitTestPoint (globalP.x, globalP.y, true)){
		     				_hitSomething = true;
		     				//NO REACTION	
		     			}
		     		}
		     	}
		 	}  
		 }
		 
		 public function cleanUpBoss (e:CustomEvent):void {
		 	_sl.removeEventListener(SharedListener.COLLIDE_BOSS, addBullet);
			_sl.removeEventListener(SharedListener.GAME_END, cleanUpBoss);
			//
		 	_sl.sendCustomEvent(SharedListener.PLAY_SOUND, {name:"RobotMetalCollapse", loop:false}, false, true);
			for (var i:uint=0; i<_lc.elementsArray.length; i++){
				var target:AbstractTarget = _lc.elementsArray[i];
				target.rotateAndFall ();
			}
		}
	}
}