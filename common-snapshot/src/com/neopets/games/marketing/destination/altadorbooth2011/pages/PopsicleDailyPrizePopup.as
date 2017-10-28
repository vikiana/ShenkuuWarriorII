/**
 *	Popsicle Destination: daily prize popup.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 10 
 *	@author Viviana Baldarelli
 *	@since  5.6.2010
 */
package com.neopets.games.marketing.destination.altadorbooth2011.pages
{
	com.neopets.games.marketing.destination.altadorbooth2011.pages.DailyPrizePopup
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

	
	public class PopsicleDailyPrizePopup extends DailyPrizePopup
	{
		
		//tracked on server
		private const PICK_NEOPOINTS:int = 16207;
		private const PICK_PRIZE:int = 16206;
		private const PICK_JOKE:int = 16205;
		
		
		public var content4:MovieClip;
		//----------------------------------------
		//	CONSTRUCTOR
		//----------------------------------------
		public function PopsicleDailyPrizePopup(pName:String=null, pView:Object=null, maxContent=1)
		{
			super (pName, pView, maxContent);
		}
		
		override protected function init(maxContent:int):void {
			super.init(maxContent);
			content4.visible = false;
		}
		
		override public function displayPrize (title:String, imageURL:String=""):void {
			reset();
			var path:String;
			var handler:Function;
			//is title is a number (neopoints)
			_prizeName = title;
			if (int(_prizeName.charAt(0)) > 0){
				handler = setPoints;
			} else {
				handler = setPrize;
			}
			//if it has no path is a joke. Reset the handler as well.
			if (imageURL==""){
				path = "http://images.neopets.com/items/toy_gag_bowtie.gif";
				handler = setJoke;
			} else {
				path = imageURL;
			}			

			//load image
			var lr:URLRequest =  new URLRequest (path);
			var ldr:Loader = new Loader();
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, handler);
			ldr.load(lr);
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		protected function setPoints (e:Event):void {
			setVisible(4);
			//NeoTracker.instance.trackNeoContentID (PICK_NEOPOINTS);
			//TrackingProxy.sendADLinkCall('AltadorAlley2010 - Neopoints Awarded');
			content4.prizeimage_mc.visible = true;
			content4.prizeimage_mc.addChild(e.target.loader.content);
			content4.prizename_text.text ="You've Picked: Neopoints!";
			content4.message_text.text ="What a surprise! You've grabbed "+_prizeName+" to add to your stash.";
		}
	
		override protected function setPrize (e:Event):void {
			setVisible(1);
			//NeoTracker.instance.trackNeoContentID (PICK_PRIZE);
			//TrackingProxy.sendADLinkCall('AltadorAlley2010 - Virtual Prize Awarded');
			content1.prizeimage_mc.addChild(e.target.loader.content);
		}
		
		
		
		
		protected function setJoke(e:Event):void {
			setVisible(4);
			//NeoTracker.instance.trackNeoContentID (PICK_JOKE);
			//TrackingProxy.sendADLinkCall('AltadorAlley2010 - Joke Awarded');
			content4.prizeimage_mc.addChild(e.target.loader.content);
			content4.prizename_text.text = "You've Picked: A Fun Riddle!";
			content4.message_text.htmlText = _prizeName;
		}
	}
}