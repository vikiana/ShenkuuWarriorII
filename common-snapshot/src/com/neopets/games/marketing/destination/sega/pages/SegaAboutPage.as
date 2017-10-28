//Marks the right margin of code *******************************************************************
package com.neopets.games.marketing.destination.sega.pages
{
	import caurina.transitions.Tweener;
	
	import com.neopets.games.marketing.destination.sega.SegaControl;
	import com.neopets.games.marketing.destination.sega.widgets.ReleaseDate;
	import com.neopets.projects.destination.destinationV3.AbsPageWithBtnState;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.users.abelee.utils.ViewManager_v3;
	import com.neopets.users.vivianab.LibraryLoader;
	import com.neopets.users.vivianab.MathUtilities;
	import com.neopets.util.events.CustomEvent;
	
	import com.neopets.games.marketing.destination.sega.widgets.Scroller;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	
	/**
	 * public class GuardiansGalleryPage extends AbsPageWithBtnState
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class SegaAboutPage extends AbsPageWithBtnState
	{
		//--------------------------------------------------------------------------
		// Costants
		//--------------------------------------------------------------------------	
		public const OX:Number = 48;
		public const OY:Number = 124;
		//--------------------------------------------------------------------------
		//Public properties
		//--------------------------------------------------------------------------	
		public var shade:MovieClip;
		public var close_btn:MovieClip;
		public var date:MovieClip;
		public var gallery:MovieClip;
		public var nextBtn:MovieClip;
		public var prevBtn:MovieClip;
		public var about_txt:MovieClip;
		
		public var scrollbar: MovieClip;
		public var _scroller: Scroller;
		
		public var releaseDate:ReleaseDate;
	
		//--------------------------------------------------------------------------
		//Private properties
		//--------------------------------------------------------------------------	
		private var _iArray:Array = new Array ("barran", "boron", "noctus", "nyra", "soren");
		private var _images:Array = new Array();
		private var _count:int = 0;
		private var _currentindex:int = 0;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Creates a new public class GuardiansGalleryPage extends AbsPageWithBtnState instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function SegaAboutPage(pName:String=null, pView:Object=null)
		{
			super(pName, pView);
			shade.alpha = 0;
			close_btn.buttonMode = true;
			close_btn.label_txt.htmlText = "Close";
			//fade in
			addEventListener(SegaControl.PAGE_DISPLAY,onShown);
			
			_scroller = new Scroller (260);
			addChild(_scroller);
			_scroller.x = 382;
			_scroller.y = 211;
			//_scroller.init(about_txt);
			
			//dated conditional
			releaseDate.init("09/18/2010", "09/23/2010", "09/24/2010");
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		// Protected Methods
		//--------------------------------------------------------------------------	
		/**
		 * Changing glow color to yellow. Also, no "over" state for buttons. These arwe the owls buttons.
		 */
		override protected function handleMouseOver(evt:MouseEvent):void
		{
			var mc:MovieClip;
			if (evt.target.name == "btnAreaLink"){
				mc = evt.target as MovieClip
				MovieClip(mc.parent).bkg.gotoAndPlay (2);
			} else if (evt.target.name == "btnArea"){
				mc = evt.target as MovieClip
				MovieClip(mc.parent).filters = [new GlowFilter(0xFFFFFF, 1, 16, 16, 2, 3)];
			}
		}
		
		override protected function handleMouseOut(evt:MouseEvent):void {
			var mc:MovieClip;
			if (evt.target.name == "btnAreaLink"){
				mc = evt.target as MovieClip
				MovieClip(mc.parent).bkg.gotoAndStop (1);
			} else if (evt.target.name == "btnArea"){
				mc = evt.target as MovieClip
				MovieClip(mc.parent).filters = null
			}
		}
		
		override protected function handleObjClick(e:CustomEvent):void
		{
			//trace (e.oData.DATA.parent.name, e.oData.DATA.parent)
			var i:int;
			if (e.oData.DATA.parent != null && e.oData.DATA.name == "btnArea")
			{
				/*var objName:String = e.oData.DATA.parent.name;	//name of the clicked obj
				switch (objName)
				{
					case "nextBtn":
						goto("next");
						//upIndex();
					break;
					case "prevBtn":
						goto ("prev");
					break;
				}*/
			}
		}
		//--------------------------------------------------------------------------
		// Private Methods
		//--------------------------------------------------------------------------
		private function onShown (e:Event):void {
			
				//var _scroller:Scroller = new Scroller (260);
				//addChild(_scroller);
				//_scroller.x = 382;
				//_scroller.y = 211;
			_scroller.init(about_txt);
			
			_scroller.reset();
			shade.alpha = 0;
			Tweener.addTween(shade, {alpha:0.8, time:0.8, transition:"linear"});
		}
		
				
		
		
		
		//--------------------------------------------------------------------------
		// Event Handlers
		//--------------------------------------------------------------------------	
		
		//--------------------------------------------------------------------------
		// Getters/Setters
		//--------------------------------------------------------------------------
	}
}