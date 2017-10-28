//Marks the right margin of code *******************************************************************
package com.neopets.games.marketing.destination.sega.pages
{
	import caurina.transitions.Tweener;
	
	import com.neopets.games.marketing.destination.sega.GuardiansControl;
	import com.neopets.games.marketing.destination.sega.widgets.ReleaseDate;
	import com.neopets.projects.destination.destinationV3.AbsPageWithBtnState;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.users.abelee.utils.ViewManager_v3;
	import com.neopets.users.vivianab.LibraryLoader;
	import com.neopets.users.vivianab.MathUtilities;
	import com.neopets.util.events.CustomEvent;
	
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
	public class GuardiansGalleryPage extends AbsPageWithBtnState
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
		public function GuardiansGalleryPage(pName:String=null, pView:Object=null)
		{
			super(pName, pView);
			shade.alpha = 0;
			close_btn.buttonMode = true;
			close_btn.label_txt.htmlText = "Close";
			nextBtn.buttonMode = true;
			prevBtn.buttonMode = true;
			nextBtn.gotoAndStop(1);
			prevBtn.gotoAndStop(1);
			//fade in
			addEventListener(GuardiansControl.PAGE_DISPLAY,onShown);
			//dated conditional
			releaseDate.init("09/18/2010", "09/23/2010", "09/24/2010");
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------
		public function startLoading ():void{
			loadNextImage();
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
				var objName:String = e.oData.DATA.parent.name;	//name of the clicked obj
				switch (objName)
				{
					case "nextBtn":
						goto("next");
						//upIndex();
					break;
					case "prevBtn":
						goto ("prev");
					break;
				}
			}
		}
		//--------------------------------------------------------------------------
		// Private Methods
		//--------------------------------------------------------------------------
		private function onShown (e:Event):void {
			shade.alpha = 0;
			Tweener.addTween(shade, {alpha:0.8, time:0.8, transition:"linear"});
		}
		
		private function loadNextImage ():void {
			if (_count>-1){
				if (_count < _iArray.length){
					trace ("loading image", _iArray[_count]);
					var URL:String;
					var loader:Loader;
					URL = Parameters.imageURL+"/sponsors/guardians/stills/"+_iArray[_count]+".jpg";
					loader = new Loader();
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, initImage, false, 0, true);
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, failedImage, false, 0, true);
					loader.load(new URLRequest(URL));
				} else {
					//move images to start from the middle image
					_currentindex = Math.ceil (_images.length/2);
					var dX:Number = _images[_currentindex].x - OX;
					for (var i:int =0; i<_images.length; i++){
						_images[i].x = _images[i].x-dX;
					}
					//fade in
					Tweener.addTween(_images, {alpha:1, time:0.3});
					_count=-1;
					//swap close btn to be on top
					swapChildren(close_btn, _images[_images.length-1]);
				}
			}
		}
		
		private function goto (direction:String):void {
			//reposition
			reposition (direction);
			//up/lower index
			switch (direction){
				case "next":
					if (_currentindex+1 < _images.length){
						_currentindex++;
					} else {
						_currentindex = 0;
					}
				break;
				case "prev":
					if (_currentindex-1 >=0){
						_currentindex--;
					} else {
						_currentindex= _images.length-1
					}
				break;
			}
			//move
			var dX:Number;
			var i:int;
			dX = _images[_currentindex].x - OX;
			for (i=0; i<_images.length; i++){
				Tweener.addTween (_images[i], {x:_images[i].x -dX, time:0.5, transition:"easeoutquad"});//onComplete:upIndex});
			}
		}
		
		private function reposition (direction:String):void {
			var reposImageIndex:int
			var n:Number;
			var refImage:Sprite;
			var ip:Array = getImagesPos();
			switch (direction){
				case "next":
					n = MathUtilities.minValue(ip)
					reposImageIndex = ip.indexOf(n);
					if (reposImageIndex-1>=0){
						refImage = _images [reposImageIndex-1]
					} else {
						refImage = _images [_images.length-1]
					}
					_images[reposImageIndex].x = refImage.x + refImage.width;
					break;
				case "prev":
					n = MathUtilities.maxValue(ip);
					reposImageIndex = ip.indexOf(n);
					if (reposImageIndex+1<_images.length){
						refImage = _images [reposImageIndex+1]
					} else {
						refImage = _images[0];
					}
					_images[reposImageIndex].x = refImage.x - _images[reposImageIndex].width;
					break;
			}
		}
		
		private function getImagesPos():Array{
			var a:Array = new Array();
			for (var i:Number =0; i<_images.length; i++){
				a.push (_images[i].x);
			}
			return a;
		}
		//--------------------------------------------------------------------------
		// Event Handlers
		//--------------------------------------------------------------------------	
		private function initImage(e:Event):void{
			e.target.removeEventListener(Event.COMPLETE, initImage);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, failedImage);
			var sp:Sprite = new Sprite ();
			sp.addChild(e.target.loader);
			//positioning
			sp.x = OX+ _images.length * sp.width;
			sp.y = OY;
			sp.alpha = 0;
			//adding
			addChild(sp);
			_images.push (sp);
			//mask
			var m:MovieClip = LibraryLoader.createElement("Gallery_mask", OX, OY, this);
			addChild (m);
			sp.mask = m;
			//next image
			_count++;
			loadNextImage();
		}
		
		private function failedImage(e:IOErrorEvent):void{
			trace (this, "Failed loading image", e);
			_count++;
			loadNextImage();
		}
		//--------------------------------------------------------------------------
		// Getters/Setters
		//--------------------------------------------------------------------------
	}
}