/*
 Neopets adaption - 2/2010
*/
package com.neopets.games.inhouse.BubbleMaster.game{
	import flash.display.*;
	import flash.events.*;
	
	public class StartScreen extends MovieClip {
		private var doc:Object;
		private var scope:Object;
		
		// added MN refereces 2/2010
		public var iBtn:MovieClip;
		public var cBtn:MovieClip;
		public var goBtn:MovieClip;
		public var instructions:MovieClip;
		public var credits:MovieClip;
		
		public function StartScreen(viewport:Object):void {
			scope = viewport;
			doc = scope.doc;
			x = 320;
			y = 225;
			
			iBtn.addEventListener(MouseEvent.ROLL_OVER, function(){iBtn.iBar.gotoAndStop('on');} );
			iBtn.addEventListener(MouseEvent.ROLL_OUT, function(){iBtn.iBar.gotoAndStop('off');} );
			iBtn.addEventListener(MouseEvent.CLICK, showInstructions);
			
			cBtn.addEventListener(MouseEvent.ROLL_OVER, function(){cBtn.cBar.gotoAndStop('on');} );
			cBtn.addEventListener(MouseEvent.ROLL_OUT, function(){cBtn.cBar.gotoAndStop('off');} );
			cBtn.addEventListener(MouseEvent.CLICK, showCredits);
			
			goBtn.addEventListener(MouseEvent.ROLL_OVER,function(){goBtn.gotoAndStop('on');} );
			goBtn.addEventListener(MouseEvent.ROLL_OUT, function(){goBtn.gotoAndStop('off');} );
			goBtn.addEventListener(MouseEvent.CLICK, initGame);
			
			instructions.menuBtn.addEventListener(MouseEvent.CLICK, function() {initScreen();} );
			credits.menuBtn.addEventListener(MouseEvent.CLICK, function() {initScreen();} );
			
			addEventListener(Event.ADDED_TO_STAGE, function() {initScreen();} );
		}
		
		private function initScreen():void {
			instructions.visible = false;
			credits.visible = false;
			iBtn.visible = true;
			cBtn.visible = true;
			iBtn.iBar.gotoAndStop('off');
			cBtn.cBar.gotoAndStop('off');
			goBtn.gotoAndStop('off');
		}
		
		private function initGame(e:MouseEvent):void {
			parent.removeChild(this);
			doc.startGame();
		}
		
		private function showInstructions(e:MouseEvent):void {
			iBtn.visible = false;
			cBtn.visible = false;
			instructions.gotoAndStop(1);
			instructions.visible = true;
		}
		
		private function showCredits(e:MouseEvent):void {
			iBtn.visible = false;
			cBtn.visible = false;
			credits.gotoAndStop(1);
			credits.visible = true;
		}
		
	}
	
}