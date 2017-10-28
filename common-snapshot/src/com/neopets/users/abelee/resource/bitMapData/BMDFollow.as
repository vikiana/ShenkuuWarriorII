/**
 *	DESCRIPTION HERE
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

package com.neopets.users.abelee.resource.bitMapData
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	
	
	
	public class nameHere
	{
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		private var variable
		
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		public function nameHere():void
		{
			
		}
		
		//----------------------------------------
		//GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------
	}
	
}


import caurina.transitions.Tweener;

var _sp:Sprite = new Sprite()
var _sp2:Sprite = new Sprite()
var circle:Circle = new Circle()
var bmd:BitmapData = new BitmapData(550, 400, true, 0);
var bm:Bitmap = new Bitmap(bmd, "auto", true);
addChild(_sp);
_sp.addChild(bm);
addChild(_sp2)
_sp2.addChild(circle)

addEventListener(Event.ENTER_FRAME, handleDraw);

var bf:BlurFilter = new BlurFilter(20, 20, 3);
bm.filters = [bf];

function handleDraw(e:Event):void {
	Tweener.addTween(circle, {x:mouseX, y:mouseY, time:2});
	bmd.draw(stage);
	bmd.scroll(-10, 5);
}