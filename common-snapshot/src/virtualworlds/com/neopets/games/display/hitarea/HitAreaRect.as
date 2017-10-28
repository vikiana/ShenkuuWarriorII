
/**
 *  HitAreaRect
 * 
 *  @author Nate Altschul
 *  @description allows you to create a dynamic hitArea
 *  draws rect of new hitArea
 * 
 */

package virtualworlds.com.neopets.games.display.hitarea
{
	
	import flash.display.Sprite;
	
	public class HitAreaRect
	//extends UIComponent
	extends Sprite
	{
		public static var className:String = "com.nickjr.display.HitAreaRect";
	
		public function HitAreaRect(t_x:Number,t_y:Number,t_w:Number,t_h:Number,t_color:uint = 0xFFFFFF) 
		{
			drawRect(0,0,t_w,t_h,t_color);
			x = t_x;
			y = t_y;
			width = t_w;
			height = t_h;
			cacheAsBitmap = true;
			//visible = false;
		}

        private function drawRect(t_x:Number, t_y:Number, t_w:Number, t_h:Number, color:uint = 0xFFFFFF):void // Shape 
        {
			graphics.beginFill(color);
            graphics.lineStyle(1, color);
            graphics.drawRect(t_x, t_y, t_w, t_h);
            graphics.endFill();
            //parent.addChild(child);
            //return child;
        }

	}

}
