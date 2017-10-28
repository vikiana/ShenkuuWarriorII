/**
 *	Kraft Destination: daily prize popup.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 10 
 *	@author Viviana Baldarelli
 *	@since  5.6.2010
 */
package com.neopets.games.marketing.destination.altadorbooths.common
{
	import com.neopets.projects.destination.destinationV3.AbsPageWithBtnState;
	import com.neopets.projects.destination.destinationV3.TrackingProxy;
	import com.neopets.util.tracker.NeoTracker;
	
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;

	
	public class DailyPrizePopup extends AbsPageWithBtnState
	{
		
		private static const VALUABLEPRIZE_AWARDED:int = 16210;
		
		public var close_btn:MovieClip;
		public var inventory_btn:MovieClip;
		
		public var content1:MovieClip;
		public var content2:MovieClip;
		public var content3:MovieClip;
		protected var _maxContent:int;

		
		
		public var prizeimage_mc:MovieClip;
		public var prizename_text:TextField;
		public var message_text:TextField;
		
		protected var _prizeName:String;
	
		
		//----------------------------------------
		//	CONSTRUCTOR
		//----------------------------------------
		public function DailyPrizePopup(pName:String=null, pView:Object=null, maxContent:int=1)
		{
			super (pName, pView);
			init(maxContent);
		}
		
		protected function init(maxContent:int):void{
			_maxContent = maxContent;
			content1.visible = false;
			content2.visible = false;
			content3.visible = false;
		}
		
		public function displayPrize (title:String, imageURL:String=""):void {
			reset();
			if (imageURL!=""){
				//Prize
				_prizeName = title;
				var lr:URLRequest =  new URLRequest (imageURL);
				var ldr:Loader = new Loader();
				ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, setPrize, false, 0, true);
				ldr.load(lr);
			} 
			NeoTracker.instance.trackNeoContentID (VALUABLEPRIZE_AWARDED);
			TrackingProxy.sendADLinkCall('AltadorAlley2010 - Daily Bonus Awarded');
		}
		
		public function setVisible (n:int):void {
			var cName:String;
			for (var i:int =1; i<=_maxContent; i++){
				cName = "content"+i;
				if (i==n){
					getChildByName(cName).visible = true;
				} else {
					getChildByName(cName).visible = false;
				}
			}
		}
		
		public function reset():void {
			for (var i:int =0; i< content1.prizeimage_mc.numChildren; i++){
				if (content1.prizeimage_mc.contains(prizeimage_mc.getChildAt(i))){
					content1.prizeimage_mc.removeChild (prizeimage_mc.getChildAt(i));
				}
			}
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		protected function setPrize (e:Event):void {
			e.target.removeEventListener (Event.COMPLETE, setPrize);
			content1.prizeimage_mc.addChild(e.target.loader.content);
			content1.prizename_text.text =_prizeName;
		}
	}
}