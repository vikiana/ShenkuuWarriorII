//Marks the right margin of code *******************************************************************
package com.neopets.games.marketing.destination.guardians.pages
{
	import caurina.transitions.Tweener;
	
	import com.neopets.games.marketing.destination.guardians.GuardiansControl;
	import com.neopets.projects.destination.destinationV3.AbsPageWithBtnState;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	/**
	 * public class PopupNotLoggedIn extends AbsPageWithBtnState
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class PopupNotLoggedIn extends AbsPageWithBtnState
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
		//public var close_btn:MovieClip;
		public var login_btn:MovieClip;
		public var signup_btn:MovieClip;
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
		 * Creates a new public class PopupNotLoggedIn extends AbsPageWithBtnState instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function PopupNotLoggedIn(pName:String=null, pView:Object=null)
		{
			super(pName, pView);
			shade.alpha = 0;
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		public function init ():void {
			login_btn.label_txt.htmlText = "Log In";
			signup_btn.label_txt.htmlText = "Sign Up";
			login_btn.buttonMode = true;
			signup_btn.buttonMode = true;
			//close_btn.buttonMode = true;
			login_btn.gotoAndStop(1);
			signup_btn.gotoAndStop(1);
			//close_btn.gotoAndStop(1);
			addEventListener(GuardiansControl.PAGE_DISPLAY,onShown);
		}
		//--------------------------------------------------------------------------
		// Protected Methods
		//--------------------------------------------------------------------------
		/**
		 * 
		 */
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