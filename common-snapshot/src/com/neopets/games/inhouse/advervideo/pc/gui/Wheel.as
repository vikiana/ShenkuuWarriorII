
/* AS3
 *	Copyright 2008
 */
package com.neopets.games.inhouse.advervideo.pc.gui {
	
	import flash.display.MovieClip;
 	import flash.events.EventDispatcher;
    import flash.events.Event;
	import flash.utils.Timer;
	import flash.filters.BlurFilter;
	
	/**
	 *	Class to control Acara
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author Bill Wetter
	 *	@since  03.06.2010
	 */
	public class Wheel extends MovieClip {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static var SPIN_COMPLETE:String = "wheel_spin_complete";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------

		public    var wheelValues:Array=[];
		private   var wheelOffset:int = 0;
		private   var wheelValuesRewardIndex:int=5;
		public    var WheelSlices:*;
		public    var WheelFlipper:MovieClip;
		public    var ySpeed:Number= 43.5;
		public    var yFriction:Number= .54;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */ 
		public function Wheel():void {
		    super();
			setupVars();
			//trace("init me");
	
		}
		
		public function init():void {
			setupVars();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
			
		public function getWheelValuesRewardIndex():int {
			return wheelValuesRewardIndex;
		}

		public function addWheelValue(val) {
			wheelValues.push(val);
		}
				
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		public function reset():void {
			WheelSlices.y = 1;
			this.resetWheelSliceValues();
		}
		
		public function startSpin():void {
			WheelSlices.y = 1;
			WheelFlipper.gotoAndStop("flip");
			addEventListener(Event.ENTER_FRAME, onSpin);
			ySpeed = 33.5;
			yFriction = .54;
			wheelOffset = 0;
			var bFilter:BlurFilter = new BlurFilter();
			bFilter.blurY = 2;
			WheelSlices.filters = [bFilter];
		}
		
		public function stopSpin():void {
			WheelFlipper.gotoAndStop("unflip");
			removeEventListener(Event.ENTER_FRAME, onSpin);
			dispatchEvent(new Event(Wheel.SPIN_COMPLETE));
			wheelOffset = 0;
			wheelValues=[];
			WheelSlices.filters = [];
		}
		
		/**
		 * @Note: handles frame rotation
		 */
		 
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		private function onSpin(e:Event):void {
		
			if (WheelSlices.y >= 64) { //147
				WheelSlices.y = 1;
				resetWheelSliceValues(-1);
			}	
	
			if (ySpeed <= 2) {				
				ySpeed = 0;
				stopSpin();
			} else {
				ySpeed -= yFriction;
			}			
			WheelSlices.y += ySpeed;
		}
		
		//--------------------------------------
		//  PRIVATE INSTANCE METHODS
		//--------------------------------------
		
		private function setupVars():void {
			wheelValuesRewardIndex = 5
			WheelFlipper.gotoAndStop("unflip");
		}
		
		public function resetWheelSliceValues(offsetVal:int=-1):void {
			
			wheelOffset += offsetVal;
			
			for (var i:Number = 0; i < wheelValues.length; i++) {
				
				var tWheelDataIndex_num:Number =   i + wheelOffset;
				//OFFSET IS 0 OR NEGATIVE - ALWAYS- correct that to keep it close to 0
				while (tWheelDataIndex_num < 0) {
					tWheelDataIndex_num += wheelValues.length;
				}
				//SET TEXT
				//Object(wheelSlices_array[i]).message_txt.htmlText = wheelData.wheelValues_array[tWheelDataIndex_num] + "   " +  _level0.IDS_NP;
				MovieClip(WheelSlices.getChildByName("wheelSlice" +i)).message_txt.text = wheelValues[tWheelDataIndex_num] + " NP";
			}
			
		}

	}
	
}
