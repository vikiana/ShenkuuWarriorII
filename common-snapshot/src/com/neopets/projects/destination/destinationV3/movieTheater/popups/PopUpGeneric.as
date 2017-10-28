/**
 *	main theater.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  07.16.2009
 */
 
 //----------------------------------------
 //	OVERALL FLOW
 //----------------------------------------

 
package com.neopets.projects.destination.destinationV3.movieTheater.popups
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	
	import com.neopets.util.events.CustomEvent;
	import com.neopets.projects.destination.destinationV3.AbsPageWithBtnState;
	import caurina.transitions.Tweener;
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------
		
	public class PopUpGeneric extends AbsPageWithBtnState
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		var mPopUp:PopUp_Message;	//library item
		var mViewObj:Object
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		
		public function PopUpGeneric(pName:String = null, pView:Object = null):void
		{
			super (pName)
			pView.addEventListener(pView.OBJ_CLICKED, handleObjClick, false, 0, true)
			mViewObj = pView
			setupPage ();
		}
		
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		public function setText(pText:String):void
		{
			mPopUp.contentTxt.htmlText = pText
		}
		
		public function setLogo(plogo:Bitmap):void
		{
			mPopUp.logoBox.addChild (plogo);
		}
		
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		protected override function setupPage():void
		{
			addImage("PopUp_Message", "popup");
			mPopUp = PopUp_Message(getChildByName("popup"))
		}
		
		
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------

		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		protected override function handleObjClick(evt:CustomEvent):void
		{
			if (evt.oData.DATA.name == "btnArea")
			{
				switch (evt.oData.DATA.parent.name)
				{
					case "closeBtn":
						mViewObj.removeEventListener(mViewObj.OBJ_CLICKED, handleObjClick)
						cleanup()
						break;
						
				}
			}
			
		}
		
		
	}
}