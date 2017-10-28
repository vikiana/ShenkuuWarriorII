//Marks the right margin of code *******************************************************************
package com.neopets.games.marketing.destination.sega.pages
{
	import caurina.transitions.Tweener;
	
	import com.neopets.games.marketing.destination.sega.widgets.ReleaseDate;
	import com.neopets.projects.destination.destinationV3.AbsPageWithBtnState;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	
	/**
	 * public class GuardiansLandingPage extends AbsPageWithBtnState
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class SegaLandingPage extends AbsPageWithBtnState
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
		//on stage
		public var owl1:MovieClip;
		public var owl2:MovieClip;
		public var owl3:MovieClip;
		public var owl4:MovieClip;
		public var owl6:MovieClip;
		public var infoBox_mc:MovieClip;
		//public var owlinfo_mc:MovieClip;
		public var date:MovieClip;
		
		public var play_btn:MovieClip;
		public var gallery_btn:MovieClip;
		public var trivia_btn:MovieClip;
		public var website_btn:MovieClip;
		public var nick_btn:MovieClip;
		public var clips_btn:MovieClip;
		public var about_btn:MovieClip;
		
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
		 * Creates a new public class GuardiansLandingPage extends AbsPageWithBtnState instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function SegaLandingPage(pName:String=null, pView:Object=null)
		{
			super(pName, pView);
			
			//owlinfo_mc.scaleX = owlinfo_mc.scaleY = 0;
			infoBox_mc.gotoAndStop(1);
			
			//play_btn.gotoAndStop(1);  
			gallery_btn.gotoAndStop(1);  
			trivia_btn.gotoAndStop(1);  
			website_btn.gotoAndStop(1);  
			nick_btn.gotoAndStop(1);  
			clips_btn.gotoAndStop(1);  
			about_btn.gotoAndStop(1); 
			
			//play_btn.buttonMode = true;
			gallery_btn.buttonMode = true;
			trivia_btn.buttonMode = true;
			website_btn.buttonMode = true;
			nick_btn.buttonMode = true;
			clips_btn.buttonMode = true;
			about_btn.buttonMode = true;
			
			//play_btn.label_txt.htmlText  =  "Play Game";
			/*gallery_btn.label_txt.htmlText  =  "Gallery";
			trivia_btn.label_txt.htmlText  =  "Daily Trivia";
			website_btn.label_txt.htmlText  =  "<font size='10'>Official Website</font>";
			website_btn.label_txt.y += 3;
			nick_btn.label_txt.htmlText  =  "Club Nick"
			clips_btn.label_txt.htmlText  =  "<font size='11'>Guardians Clips</font>";
			clips_btn.label_txt.y += 2;*/
			
			releaseDate.init("09/18/2010", "09/23/2010", "09/24/2010");
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		public function dim():void {
			//shade.alpha = 0;
		}
		//--------------------------------------------------------------------------
		// Protected Methods
		//--------------------------------------------------------------------------
		/**
		 * Changing glow color to yellow. Also, no "over" state for buttons. These arwe the owls buttons.
		 */
		override protected function handleMouseOver(evt:MouseEvent):void
		{
			var mc:MovieClip;
			if (evt.target.name == "btnArea")
			{
				mc = evt.target as MovieClip
				if (!mc.buttonMode) mc.buttonMode = true;
				//MovieClip(mc.parent).gotoAndStop("over")
				MovieClip(mc.parent).filters = [new GlowFilter(0xFFFFFF, 1, 16, 16, 2, 3)]
				displayOwlDescription (int(mc.parent.name.charAt(3))+1);
				trace ("displaying owl info: "+int(mc.parent.name.charAt(3)));
			} else if (evt.target.name == "btnAreaLink"){
				mc = evt.target as MovieClip
				MovieClip(mc.parent).bkg.gotoAndPlay (2);
			}
		}
		
		override protected function handleMouseOut(evt:MouseEvent):void {
			var mc:MovieClip;
			if (evt.target.name == "btnArea")
			{
				mc = evt.target as MovieClip
				MovieClip(mc.parent).filters = null
				hideOwlDescription();
			} else if (evt.target.name == "btnAreaLink"){
				mc = evt.target as MovieClip
				MovieClip(mc.parent).bkg.gotoAndStop (1);
			}
		}
		
		//--------------------------------------------------------------------------
		// Private Methods
		//--------------------------------------------------------------------------
		private function displayOwlDescription (index:int){
			infoBox_mc.gotoAndStop(index);
			//owlinfo_mc.gotoAndStop(index);
			//Tweener.addTween(owlinfo_mc, {scaleX:1, scaleY:1, time:1, transition:"easeoutelastic"});
		}
		
		private function hideOwlDescription():void {
			infoBox_mc.gotoAndStop(1);
			//Tweener.addTween(owlinfo_mc, {scaleX:0, scaleY:0, time:0.3, transition:"easeoutquint"});
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