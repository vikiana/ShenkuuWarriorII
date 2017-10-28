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

 
package com.neopets.projects.destination.destinationV2.movieTheater.popups
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	
	import caurina.transitions.Tweener;
	
	import com.neopets.games.marketing.destination.movieCentral.widgets.SynopsisScroller;
	import com.neopets.projects.destination.destinationV2.AbsPageWithBtnState;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

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
		
		public var contentTxt_mc:Sprite;
		public var mask_mc:MovieClip;
		
		private var _scroller:SynopsisScroller;
		
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
			mPopUp.contentTxt_mc.contentTxt.htmlText = pText;
		}
		
		public function setLogo(plogo:Bitmap):void
		{
			mPopUp.logoBox.addChild (plogo);
		}
		

		public function addScroller():void {
			if (!_scroller){
				var realHeight:Number = mPopUp.contentTxt_mc.height;
				if (realHeight > mPopUp.mask_mc.height){
					_scroller = new SynopsisScroller (mPopUp.mask_mc.height);
					mPopUp.addChild(_scroller);
					_scroller.x = 743;
					_scroller.y = 157;
					_scroller.init(mPopUp.contentTxt_mc);
				} //else {
				//_scroller.init(mPopUp.contentTxt_mc);
				//}
			}
		}
		
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		protected override function setupPage():void
		{
			addImage("PopUp_Message", "popup");
			mPopUp = PopUp_Message(getChildByName("popup"))
		}
		
		/*	//VIV: add scroller
		if (mPopUp.contentTxt.height > mPopUp.mask_mc.height){
		mPopUp.contentTxt.mask = mPopUp.mask_mc;
		addScroller (mPopUp.contentTxt);
		} else {
		mPopUp.mask_mc.visible = false;
		}*/
		
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