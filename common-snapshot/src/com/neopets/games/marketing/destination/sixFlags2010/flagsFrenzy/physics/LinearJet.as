
/* AS3
	Copyright 2008
*/

package com.neopets.games.marketing.destination.sixFlags2010.flagsFrenzy.physics
{
	
	/**
	 *	Use this class to mimic jet of pressurized fluid along a single axis.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author David Cary
	 *	@since  02.23.2010
	 */
	 
	public class LinearJet extends Object
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//   VARIABLES
		//--------------------------------------
		public var position:Number;
		public var tailLength:Number;
		protected var _baseForce:Number;
		protected var _forceLoss:Number;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function LinearJet(size:Number=10,max:Number=10,min:Number=1):void{
			super();
			tailLength = size;
			setForce(max,min);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Use this function to figure how much force the jet exerts at this point.
		
		public function getForceAt(coord:Number):Number {
			if(tailLength == 0) return 0; // make sure we have a tail
			// check how far along the tail the target is
			var diff:Number = coord - position;
			var percent:Number = diff / tailLength;
			// check if the target is in range
			if(percent < 0 || percent > 1) return 0;
			// if we got this far, apply an appropriately scaled force
			var force:Number = _baseForce + percent * _forceLoss;
			if(tailLength > 0) return force;
			else return -force;
		}
		
		// use this function to set our chance in forces as we get further from the base
		
		public function setForce(v1:Number,v2:Number) {
			_baseForce = v1;
			_forceLoss = v2 - v1;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
