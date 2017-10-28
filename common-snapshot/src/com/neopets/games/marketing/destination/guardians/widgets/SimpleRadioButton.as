package com.neopets.games.marketing.destination.guardians.widgets
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class SimpleRadioButton extends MovieClip
	{
		
		private var _isOn:Boolean = false;
		
		public function SimpleRadioButton()
		{
			super();
			addEventListener(MouseEvent.ROLL_OVER, handleRollOver, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, handleRollOut, false, 0, true);
			addEventListener(MouseEvent.CLICK, handleClick, false, 0, true);
		}
		
		private function handleRollOver(e:MouseEvent):void {
			if (!_isOn){
				gotoAndStop("on");
			}
		}
		
		private function handleRollOut(e:MouseEvent):void {
			if (!_isOn){
				gotoAndStop("off");
			}
		}
		private function handleClick(e:MouseEvent):void {
			if (!_isOn){
				gotoAndStop("selected");
				_isOn = true;
			} else {
				gotoAndStop("off");
				_isOn = false;
			}
		}
		
		
		public function toggleSelect (select:Boolean):void {
			if (select){
				gotoAndStop("selected");
				_isOn = true;
			} else {
				gotoAndStop("off");
				_isOn = false;
			}
		}
		
		public function get isOn():Boolean {
			return _isOn;
		}
		public function set isOn(value:Boolean):void {
			_isOn = value;
		}
	}
}