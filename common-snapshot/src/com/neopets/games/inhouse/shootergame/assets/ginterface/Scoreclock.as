package com.neopets.games.inhouse.shootergame.assets.ginterface
{
	import caurina.transitions.Tweener;
	
	import flash.display.MovieClip;


	/** 
	* 
	* 	Assets class: scoreclock is a complicated machine!!
	*
	*	@langversion ActionScript 3.0
	*	@playerversion Flash 10.0
	*	
	* 
	*	@author Viviana Baldarelli
	*	@since  05.28.2009
	*/
	public class Scoreclock extends MovieClip
	{
		
		//--------------------------------------
		// PRIVATE VARIABLES
		//--------------------------------------
		private var _leftCount:int;
		private var _rightCount:int;
		
		/**
		 * 
		 * Constructor
		 * 
		*/
		public function Scoreclock()
		{
			super();
		}
		
		//--------------------------------------
		// PUBLIC METHODS
		//--------------------------------------
		public function displayScore(score:Number):void {
			var flatScore:Number = Math.floor (score);
			if (String(score).charAt(1)){
				var leftNum:Number =Number( String(score).charAt(1));//Math.floor (flatScore/10);
				clockRotation (clockleft, clocklensleft.clock, leftNum, _leftCount, true);
			} else {
				clockRotation (clockleft, clocklensleft.clock, 0, _leftCount, true);
			}
			var rightNum:Number =Number( String(score).charAt(0));//score - (leftNum*10);
			clockRotation (clockright, clocklensright.clock, rightNum,_rightCount, false);
			gearsgroup1.startMoving ();
			_leftCount = 0;
			_rightCount = 0;
		}
		
		public function advanceOne (totalSteps:String):void {
			var step:Number = 36;
			var decine:Number;
			var unita:Number;
			if (totalSteps.length == 2){
				decine = Number(totalSteps.charAt(0));
				unita = Number (totalSteps.charAt(1));
			} else if (totalSteps.length == 1){
				unita = Number(totalSteps.charAt(0));
			}else if (totalSteps.length == 3){
				decine = Number(totalSteps.charAt(1));
				unita = Number (totalSteps.charAt(2));
			}
			//if a number for tens exist, check units: if the unit number is 0, the tens number has to step forward.
			if (decine){
				if (unita == 0){
					Tweener.addTween([clockleft, clocklensleft.clock], {rotation:-step*decine, time:0.3, transition:"easeOutInExpo"});
					Tweener.addTween([clockright, clocklensright.clock],  {rotation:-step*unita, time:0.3, transition:"easeOutInExpo"});
					rotateNumbers(clocklensright.clock, unita, false);
					rotateNumbers(clockright, unita, false);
				}
			}
			if (unita != 0){
				Tweener.addTween([clockright, clocklensright.clock],  {rotation:-step*unita, time:0.3, transition:"easeOutInExpo"});
				rotateNumbers(clocklensright.clock, unita, false);
				rotateNumbers(clockright, unita, false);
			}
			if (decine && unita==0){
				rotateNumbers(clocklensleft.clock, decine, false);
				rotateNumbers(clockleft, decine, false);
			}
		}	
		//--------------------------------------
		// PRIVATE METHODS
		//--------------------------------------
	
		private function clockRotation (c:MovieClip, clens:MovieClip, cifra:Number, count:Number, left:Boolean):void {
			if (count <= cifra){
				var newR:Number;
				var cou:Number;
				if (left){
					newR = 36*count;
				} else {
					newR = -36*count;
				}
				Tweener.removeTweens(clens, [rotation]);
				if (left){
					Tweener.addTween(c, {rotation:newR, time:0.1, transition:"linear", onComplete:clockRotation, onCompleteParams:[c, clens, cifra, _leftCount, left]});
				} else {
					Tweener.addTween(c, {rotation:newR, time:0.1, transition:"linear", onComplete:clockRotation, onCompleteParams:[c, clens, cifra, _rightCount, left]});
				}
				Tweener.addTween(clens, {rotation:newR, time:0.1, transition:"linear"});
				if (left){
					_leftCount ++;
				} else {
					_rightCount++;
				}
				if (count>1){
					rotateNumbers(c, cifra, left);
					rotateNumbers(clens, cifra, left);
				}
			} else {
				rotateNumbers(c, cifra, left);
				rotateNumbers(clens, cifra, left);
				gearsgroup1.stopMoving ();
				return;
			}
		}
		/*private function clockRotation (c:MovieClip, clens:MovieClip, cifra:Number, count:Number, left:Boolean):void {
			if (count <= cifra){
				var newR:Number;
				var cou:Number;
				if (left){
					newR = 36*count;
				} else {
					newR = -36*count;
				}
				Tweener.removeTweens(clens, [rotation]);
				if (left){
					Tweener.addTween(c, {rotation:newR, time:0.1, transition:"linear", onComplete:clockRotation, onCompleteParams:[c, clens, cifra, _leftCount, left]});
				} else {
					Tweener.addTween(c, {rotation:newR, time:0.1, transition:"linear", onComplete:clockRotation, onCompleteParams:[c, clens, cifra, _rightCount, left]});
				}
				Tweener.addTween(clens, {rotation:newR, time:0.1, transition:"linear"});
				if (left){
					_leftCount ++;
				} else {
					_rightCount++;
				}
				if (count>1){
					rotateNumbers(c, cifra, left);
					rotateNumbers(clens, cifra, left);
				}
			} else {
				rotateNumbers(c, cifra, left);
				rotateNumbers(clens, cifra, left);
				gearsgroup1.stopMoving ();
				return;
			}
		}*/
		
		private function rotateNumbers (c:MovieClip, cifra:Number, left:Boolean):void {
			var r:Number;
			for (var i:int = 0; i<10; i++){
					if (left){
						r= 36//36*cifra;
					}else {
						r = -36;
					}
					c["n"+i].rotation -= r;
				}
		}
		
	}
}