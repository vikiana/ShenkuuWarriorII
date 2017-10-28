/**
 *	It a popup that'll show when user finds a flag 
 *	(it is considered as "page" since it'll be added directly on to the stage)
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */
	

package com.neopets.games.marketing.destination.sixFlags
{
	
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.utils.getDefinitionByName;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.AbstractPage
	import abelee.resource.easyCall.QuickFunctions;
	import com.neopets.util.events.CustomEvent;
	import caurina.transitions.Tweener;
	
	
	
	public class SixFlagsPopUp extends AbstractPage {
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		private var mMessage:String;	// message to show
		private var mFoundAll:Boolean;	// true if all flags are found (when the last flag is just found)
		
		//----------------------------------------
		//CONSTRUCTOR
		//----------------------------------------
		
		// set up popup
		public function SixFlagsPopUp(pMessage:String = null , foundAll:Boolean = false) {
			
			super()
			mMessage = pMessage;
			mFoundAll = foundAll
			
			// if all flags are found, request grand prize frist: once it succeeds creat popup
			if (mFoundAll)
			{
				var url:String = "/sponsors/sixflags/service.php?method=prize"
				var loader:URLLoader = new URLLoader ();
				loader.addEventListener(Event.COMPLETE, init, false, 0, true)
				loader.addEventListener(IOErrorEvent.IO_ERROR, loadingError, false, 0, true)
				loader.load(new URLRequest (url))
			}
			else
			{
				init()
			}
		}		
		
		//----------------------------------------
		//GETTERS AND SETTERS
		//----------------------------------------
		
		//----------------------------------------
		//PUBLIC METHODS
		//----------------------------------------
		
		
		//----------------------------------------
		//PROTECTED METHODS
		//----------------------------------------
		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
		
		//set up popup
		private function init(evt:Event = null):void
		{
			if (evt != null)
			{	
				//actually this will return xml so better check but later.  now I am time crunched.
				evt.target.removeEventListener(Event.COMPLETE, init)
				evt.target.removeEventListener(IOErrorEvent.IO_ERROR, loadingError)
			}
			setupPage()
			setupMessage(mMessage, mFoundAll)
		}
		
		//handle error on php request
		private function loadingError(evt:IOErrorEvent):void
		{
			trace ("Error has occured:" + evt);
		}
		
		//show the popup
		protected override function setupPage():void
		{
			addImage("GenericPopup", "FoundFlagPopup",600, 0);
			y = -100
			Tweener.addTween(this,{y:0, time:1})
		}
		
		// set up the text and image (flag or the prize) based on what they are given
		private function setupMessage(pMessage:String, foundAll:Boolean):void
		{
			var popup:MovieClip = getChildByName("FoundFlagPopup") as MovieClip
			popup.descriptionText.text = pMessage
			if (foundAll)
			{
				placeTextButton("Btn_Generic", "prizeClose", "Close", 650, 70)	
				addImage("SixFlagsPrize", "prize",680, 0);
				var prize:MovieClip = getChildByName("prize") as MovieClip
				prize.scaleX = prize.scaleY = .5
			}
			else 
			{
				placeTextButton("Btn_Generic", "viewFlag", "View", 650, 70)
				addImage("ImageFlag", "flag",700, 20);
				var item:MovieClip = getChildByName("flag") as MovieClip
				item.scaleX = item.scaleY = .5
			}
		}
		
		
		
		
		//----------------------------------------
		//EVENT LISTENER
		//----------------------------------------
		
		
	}
}
		