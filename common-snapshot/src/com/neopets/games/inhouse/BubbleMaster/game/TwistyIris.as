package com.neopets.games.inhouse.BubbleMaster.TwistyIris{

	import flash.display.*;

	
		
	public class TwistyIris extends MovieClip {
		
	public var p = y;
	public var pos = [p+2, p+1, p, p-1, p-2];
	public var pt:Point;
    public var a = Math.atan2(stage.mouseY - pt.y, stage.mouseX - pt.x) * 180 / Math.PI;

    public function TwistyIris():void
	{

		addEventListener(Event.ENTER_FRAME, look, false, 0, true);
	}

      
	private function look(e:Event):void {
		pt = new Point(x, y);
		pt = parent.localToGlobal(pt);
		if(a < -90) a = -90;
		if(a > 0) a =0;
		y = pos[Math.abs(Math.floor(a / 22.5))];
	}


	}

}