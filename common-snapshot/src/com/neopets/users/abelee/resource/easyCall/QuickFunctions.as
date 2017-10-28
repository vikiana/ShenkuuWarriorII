/**
 *	DESCRIPTION HERE
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

package  com.neopets.users.abelee.resource.easyCall
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	
	
	public class QuickFunctions
	{
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		//private var variable
		
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		public function QuickFunctions():void
		{
			
		}
		
		//----------------------------------------
		//GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//PUBLIC METHODS
		//----------------------------------------
		/*
		public function removeChildren(displayObj:DisplayObject):void
		{
			while ((displayObj as MovieClip).numChildren) 
			{
				(displayObj as MovieClip).removeChildAt(0)
			}
		}
		*/
		public function removeChildren(displayObj:DisplayObject):void
		{
			while ((displayObj as Sprite).numChildren) 
			{
				(displayObj as Sprite).removeChildAt(0)
			}
		}
		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------
	}
	
}