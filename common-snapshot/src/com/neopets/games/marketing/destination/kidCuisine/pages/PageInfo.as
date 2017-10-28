/**
 *	MAIN LANDING PAGE
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

package com.neopets.games.marketing.destination.kidCuisine.pages
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.destinationV2.AbsPageWithBtnState;
	import com.neopets.projects.destination.destinationV2.NeoTracker;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.external.ExternalInterface;
	
	public class PageInfo extends AbsPageWithBtnState
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		private var mWelcomeTxt:String = "Kid Cuisine is always searching high and low for mouthwatering new meals... but he's never gone this high!\n\nWe blasted him deep into space to find the wildest, awesomest, tastiest foods in the universe. Every time he lands on a planet, he mails us a postcard. And whenever he finds a tasty new food, he collects it in his Galactic Pack and brings it back to Earth to be part of an incredible new Kid Cuisine® meal. Be on the lookout for KC's out-of-this-world new Galactic meals, including Cosmic Chicken Nuggets and Mac & Cheese Galaxy at a supermarket near you and find out how you can get your own free Galactic Pack just like KC!\n\nAnd keep an eye out for KC's Planetary Postcards hidden all over Neopets and Nick.com. Collect 'em all and you could win tons of virtual prizes! Plus you can enter for a chance to win a weekend at Space Camp®!! "
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function PageInfo(pName:String = null, pView:Object = null):void
		{
			super(pName, pView);
			setupPage ()
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		protected override function setupPage():void
		{
			addImage("InfoPage", "infoPage");
		}
		
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		override protected function handleMouseOver(evt:MouseEvent):void
		{
			if (evt.target.name == "btnArea")
			{
				var mc:MovieClip = evt.target as MovieClip
				if (!mc.buttonMode) mc.buttonMode = true;
				MovieClip(mc.parent).gotoAndPlay("over")
				MovieClip(mc.parent).filters = [new GlowFilter(0xFFFFFF, 1, 5, 5, 3, 5), new GlowFilter(0x3399FF, 1, 8, 8, 5, 5)]
			}
		}
		
		
		
		override protected function handleObjClick(e:CustomEvent):void
		{
			trace ("    FROM ABS PAGE:", e.oData.DATA.parent.name, e.oData.DATA.parent)
			var objName:String = e.oData.DATA.parent.name;
			var uReq:URLRequest;
			switch (objName)
			{
				case "postcard":
					//NeoTracker.triggerTrackURL("http://ad.doubleclick.net/clk;216211440;15177704;s?http://www.neopets.com/sponsors/kidcuisine/index.phtml?page=hunt")
					//NeoTracker.sendTrackerID(14663);
					break;
					
				case "sweepstake":
					//NeoTracker.triggerTrackURL("http://ad.doubleclick.net/clk;216211630;15177704;t?http://www.nick.com/neopets/sweepstakes/kidcuisine/")
					//NeoTracker.sendTrackerID(14529);
					break;
					
				case "neoplanet51":
					//link to planet51 on Neopets
					NeoTracker.triggerTrackURL("http://ad.doubleclick.net/clk;219135122;15177704;x?http://www.neopets.com/sponsors/planet51/")
					NeoTracker.processClickURL(15279, "_self");
					break;
					
				case "planet51":
					//link to planet51
					NeoTracker.triggerTrackURL("http://ad.doubleclick.net/clk;219135168;15177704;h?http://kidcuisine.eprize.net/planet51")
					NeoTracker.processClickURL(15280);
					break;
				
				/*case "alienAttack":
					uReq = new URLRequest ("http://www.neopets.com/games/play.phtml?game_id=1141");
					navigateToURL(uReq);
					NeoTracker.sendTrackerID(14992);
					//Omniture
					runJavaScript ("Kid Cuisine Hot Dog Game");
					//Phase II
					NeoTracker.triggerTrackURL("http://ad.doubleclick.net/clk;218112152;15177704;u?http://www.neopets.com/games/play.phtml?game_id=1141");
					break;*/
					
				case "feedAPet":
					uReq = new URLRequest ("http://www.neopets.com/sponsors/kidcuisine/index.phtml?page=feedapet");
					navigateToURL(uReq);
					NeoTracker.sendTrackerID(14993);
					//Phase II
					NeoTracker.triggerTrackURL("http://ad.doubleclick.net/clk;218112095;15177704;a?http://www.neopets.com/sponsors/kidcuisine/index.phtml?page=feedapet");
					break;
				//case "
			}
		}
		
		private function runJavaScript(scriptID:String):void
		{

			trace (this+" run javascript "+scriptID);
			if (ExternalInterface.available)
			{
				try
				{
					ExternalInterface.call("sendADLinkCall", scriptID) 
					
				}
				catch (e:Error)
				{
					trace ("Handle Error in JavaScript")
				}
			}
		}
		
	}
	
}