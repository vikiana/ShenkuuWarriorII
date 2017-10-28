package com.neopets.games.inhouse.shootergame.assets.targets
{
	import com.neopets.games.inhouse.shootergame.SharedListener;
	import com.neopets.games.inhouse.shootergame.abstract.AbstractLayer;
	import com.neopets.games.inhouse.shootergame.abstract.AbstractTarget;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	/**
	 *	This is the rotating support for targets. Rotary targets are very processor intensive, so use sparingly ;>)
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 10.0
	 *	
	 * 
	 *	@author Viviana Baldarelli
	 *	@since  05.12.2009
	 */
	public class Rotary extends AbstractTarget
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const RADIUS:Number = 50;
		
		//--------------------------------------
		// PRIVATE VARIABLES
		//--------------------------------------
		private var _lc:MovieClip;
		private var _layer:AbstractLayer;
		private var _positions:Array;
		
		
		/**
	 	*	Constructor
	 	*/
		public function Rotary()
		{
			super();	
		}
		
		
		//--------------------------------------
		// PUBLIC 
		//--------------------------------------
		
		override public function init (sl:SharedListener, pValue:Number, layer:AbstractLayer):void {
			_sl = sl;
			var posa:Array = new Array (0, -RADIUS, 0, false);
			//x is r*sin(30) and y is r*cos(30). 120 is the rotation, false is the status of the position.
			var posb:Array = new Array (RADIUS*0.866, RADIUS*0.5, 120, false);
			var posc:Array = new Array (-posb[0], posb[1],-120, false );
			_positions = [posa, posb, posc];
		
		}
		
		
		public function addTarget (target:AbstractTarget):void {
			for (var i:uint = 0; i<_positions.length; i++){
				var p:Array = _positions[i];
				if ( p[3]==false){
					addChild (target);
					target.x = p[0];
					target.y = p[1];
					target.rotation = p[2];
					p[3]= true;
					return;
				}
			}
		}
	}
}