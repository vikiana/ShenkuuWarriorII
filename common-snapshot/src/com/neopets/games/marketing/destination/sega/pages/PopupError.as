//Marks the right margin of code *******************************************************************
package com.neopets.games.marketing.destination.sega.pages
{
	import caurina.transitions.Tweener;
	
	import com.neopets.games.marketing.destination.sega.SegaControl;
	import com.neopets.games.marketing.destination.sega.widgets.ReleaseDate;
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
	public class PopupError extends AbsPageWithBtnState
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

		public var close_btn:MovieClip;
		public var error_txt:TextField;
		public var shade:MovieClip;
		
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
		public function PopupError(pName:String=null, pView:Object=null)
		{
			super(pName, pView);
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		public function init (message:String):void {
			error_txt.text = message;
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