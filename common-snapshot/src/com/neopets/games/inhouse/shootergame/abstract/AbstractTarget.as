package com.neopets.games.inhouse.shootergame.abstract
{
	
	
	import com.neopets.games.inhouse.shootergame.SharedListener;
	import com.neopets.games.inhouse.shootergame.assets.targets.FirstBoss;
	
	import flash.display.MovieClip;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	
	
	/**
	 *	This the abstract class for all targets.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 10.0
	 *	
	 * 
	 *	@author Viviana Baldarelli
	 *	@since  05.6.2009
	 */
	public class AbstractTarget extends MovieClip
	{
	
		//--------------------------------------
		//  PROTECTED VARIABLES
		//--------------------------------------
		//reference
		protected var _sl:SharedListener;
		//flags
		//active is to determine if the target is 'hitable' or not
		protected var _active:Boolean;
		protected var _destroyed:Boolean;
		//index
		protected var _posIndex:Number;
		//misc
		public var timeLapse:Number;
		protected var _targetType:String;
		protected var _symbol:Class;
		protected var _pointsValue:Number;
		
		/**
	 	*	Constructor
	 	*/
		public function AbstractTarget()
		{
			super();
			cacheAsBitmap = true;
			_destroyed = false;
			_posIndex = 0;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		public function init(sl:SharedListener, pValue:Number, layer:AbstractLayer):void {
			_pointsValue = pValue;
			_sl = sl;
			var shadow:DropShadowFilter = new DropShadowFilter();
			shadow.distance = 8;
			shadow.angle = 271;
			shadow.strength = 0.2;
			this.filters = [shadow];
		}
		
		public function hitReaction (hitPoint:Point = null):void {
			trace ("Abstract hitReaction: please override this method in class: "+this);
		}
	
	
		public function removeFromParent():void {
			if (parent){
				parent.removeChild(this);
			}
		}
	
	
		public function destroy():void
		{
			_active = false;
			_destroyed = true;
			//removing from container
			removeFromParent();
			//remove from array
			if (_sl){
				_sl.sendCustomEvent(SharedListener.DESTROY_TARGET, {target:this, type:"", message:""}, false, true);
			}
			_sl = null;
		}
	
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		public function set active (value:Boolean):void {
			_active = value;
		}
		
		public function set destroyed (value:Boolean):void {
			_destroyed = value;
		}
		public function get destroyed ():Boolean {
			return _destroyed;
		}
		
		public function get targetType ():String {
			return _targetType;
		}
		
		public function set targetType (value:String):void {
			_targetType = value;
		}

		public function get posIndex ():Number{
			return _posIndex;
		}
		
		public function set posIndex (value:Number):void{
			_posIndex = value;
		}
	}
}