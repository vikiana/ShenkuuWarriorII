/**
 *	DESCRIPTION HERE
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

package  com.neopets.users.abelee.utils
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class SupportFunctions
	{
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		//private var variable
		
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		public function SupportFunctions():void
		{
			
		}
		
		//----------------------------------------
		//GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//PUBLIC METHODS
		//----------------------------------------
		
		public static function removeAllChildren(displayObj:DisplayObject):void
		{
			while ((displayObj as Sprite).numChildren) 
			{
				(displayObj as Sprite).removeChildAt(0)
			}
		}
		
		
		public static function getChildAsMovieClip(pScope:Object, pChild:String):MovieClip
		{
			//trace ("waht is my scope", pScope, pChild)
			var child:MovieClip = MovieClip(pScope.getChildByName(pChild))
			return child;
		}
		
		public function makeBitmapCopy(pSource:DisplayObject):Bitmap
		{
			var myData:BitmapData = new BitmapData (pSource.width, pSource.height);
			myData.draw(pSource);
			var myCopy:Bitmap = new Bitmap(myData);
			return myCopy;
		}
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------
	}
	
}