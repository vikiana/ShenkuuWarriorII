package com.neopets.games.inhouse.shootergame.assets.ginterface
{
	import caurina.transitions.Tweener;
	
	import com.neopets.games.inhouse.shootergame.abstract.AbstractGears;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	
	/** 
	* 
	* 	Asset Class: name all gears in symbol g0 --> g(n-1), in order of dependency. Also, define n as total number of gears in the symbol and t as initial rotation time.
	*
	*	@langversion ActionScript 3.0
	*	@playerversion Flash 10.0
	*	
	* 
	*	@author Viviana Baldarelli
	*	@since  05.01.2009
	*/
	public class GearsGroup extends AbstractGears
	{

		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		private var _n:Number;
		private var _t:Number;
		private var _tArray:Array;
		private var _gArray:Array;
		
		public var n:TextField;
		public var t:TextField;
		//temp 
		public var count:int=0;
		
		
		/**
	 	*	Constructor
	 	*/
		public function GearsGroup()
		{
			super();
			n.visible = false;
			t.visible = false;
			_n = Number(n.text);
			_t = Number(t.text);
		
		}
		
		
		//--------------------------------------
		//  PUBLIC AND PROTECTED
		//--------------------------------------
		public function startMoving ():void {
			var cw:Boolean;
			for (var i:int = 0; i<_tArray.length; i++){
				if (i/2 == Math.floor(i/2)){
					cw = true;
				} else {
					cw = false;
				}
				addTween (_gArray[i], _tArray[i], cw);
			}
		}
		
		
		public function stopMoving ():void {
			for (var i:int = 0; i<_gArray.length; i++){
				Tweener.removeTweens (_gArray[i], {rotation:0});
				Tweener.removeTweens (_gArray[i], {rotation:181});
				Tweener.removeTweens (_gArray[i], {rotation:180});
			}
		}
		
		
		protected override function init(e:Event=null):void {
			_tArray = [];
			_gArray = [];
			for (var i:Number = 0; i<_n; i++){
				var gear2:MovieClip = this["g"+i];
				if (i>0){
					var gear1:MovieClip = this["g"+String(i-1)];
					//trace(_t+", gear1: "+gear1+", gear2: "+gear2);
					_t = getDependentGearTime (_t, gear1, gear2)
				}
				_gArray.push (gear2);
				_tArray.push (_t);
			}
			//startMoving ();
		}
		
		
		
		//--------------------------------------
		//  PRIVATE
		//--------------------------------------
		private function addTween (target:MovieClip, time:Number, CW:Boolean):void {
			var direction:Number = (CW) ? 181 : -181;
			var params:Array = [target, time, CW];
			if (count<=5){
				Tweener.addTween (target, {rotation:direction, time:time, transition:"linear", onComplete:addTweenBack, onCompleteParams:params});
			} else {
				stopMoving();
				return;
			}
			count++;
		}
		
		private function addTweenBack (target:MovieClip, time:Number, CW:Boolean):void {
			var params:Array = [target, time, CW];
			Tweener.addTween (target, {rotation:0, time:time, transition:"linear", onComplete:addTween, onCompleteParams:params});
		}
		
	}
}