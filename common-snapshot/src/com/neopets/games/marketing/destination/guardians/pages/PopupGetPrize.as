//Marks the right margin of code *******************************************************************
package com.neopets.games.marketing.destination.guardians.pages
{
	import caurina.transitions.Tweener;
	
	import com.neopets.games.marketing.destination.guardians.GuardiansControl;
	import com.neopets.games.marketing.destination.guardians.widgets.ReleaseDate;
	import com.neopets.projects.destination.destinationV3.AbsPageWithBtnState;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	/**
	 * public class PopupGetPrize extends PopupNotLoggedIn
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class PopupGetPrize extends AbsPageWithBtnState
	{
		//--------------------------------------------------------------------------
		// Costants
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		//--------------------------------------------------------------------------
		//Public properties
		//--------------------------------------------------------------------------	
		public var imageHolder:MovieClip;
		public var close_btn:MovieClip;
		public var inventory_btn:MovieClip;
		public var prizeName_txt:TextField;
		public var shade:MovieClip;
		
		public var releaseDate:ReleaseDate;
		
		//--------------------------------------------------------------------------
		//Private properties
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Creates a new public class PopupGetPrize extends PopupNotLoggedIn instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function PopupGetPrize(pName:String=null, pView:Object=null)
		{
			super(pName, pView);
			shade.alpha = 0;
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		public function init (name:String, url:String):void {
			inventory_btn.label_txt.htmlText = "Inventory";
			close_btn.label_txt.htmlText = "Close";
			inventory_btn.buttonMode = true;
			close_btn.buttonMode = true;
			inventory_btn.bkg.gotoAndStop(1);
			close_btn.bkg.gotoAndStop(1);
			//
			prizeName_txt.text = name;
			//
			var l:Loader = new Loader();
			l.contentLoaderInfo.addEventListener(Event.COMPLETE, initImage, false, 0, true);
			var req:URLRequest = new URLRequest (url);
			l.load (req);
			addEventListener(GuardiansControl.PAGE_DISPLAY,onShown);
			
			releaseDate.init("09/18/2010", "09/23/2010", "09/24/2010");
		}
		//--------------------------------------------------------------------------
		// Protected Methods
		//--------------------------------------------------------------------------
		override protected function handleMouseOver(evt:MouseEvent):void
		{
			var mc:MovieClip;
			if (evt.target.name == "btnAreaLink"){
				mc = evt.target as MovieClip
				MovieClip(mc.parent).bkg.gotoAndPlay (2);
			}
		}
		
		override protected function handleMouseOut(evt:MouseEvent):void {
			var mc:MovieClip;
			if (evt.target.name == "btnAreaLink"){
				mc = evt.target as MovieClip
				MovieClip(mc.parent).bkg.gotoAndStop (1);
			}
		}
		//--------------------------------------------------------------------------
		// Private Methods
		//--------------------------------------------------------------------------	
		private function onShown (e:Event):void {
			shade.alpha = 0;
			Tweener.addTween(shade, {alpha:0.8, time:0.8, transition:"linear"});
		}
		
		private function initImage(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE, initImage);
			imageHolder.addChild (e.target.content);
		}
		//--------------------------------------------------------------------------
		// Event Handlers
		//--------------------------------------------------------------------------	
		/**
		 * Handler for CustomEvent.
		 * 
		 * @param event The <code>CustomEvent</code>
		 * 
		 */
		//--------------------------------------------------------------------------
		// Getters/Setters
		//--------------------------------------------------------------------------
	}
}