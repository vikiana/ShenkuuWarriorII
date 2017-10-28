//Marks the right margin of code *******************************************************************
package com.neopets.games.marketing.destination.guardians.pages
{
	import caurina.transitions.Tweener;
	
	import com.neopets.games.marketing.destination.guardians.GuardiansControl;
	import com.neopets.projects.destination.destinationV3.AbsPageWithBtnState;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.users.abelee.utils.ViewManager_v3;
	import com.neopets.users.vivianab.LibraryLoader;
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
	public class GuardiansGalleryPage_old extends AbsPageWithBtnState
	{
		//--------------------------------------------------------------------------
		// Costants
		//--------------------------------------------------------------------------	
		public const ORIGINX:Number = 48;
		public const ORIGINY:Number = 124;
		//--------------------------------------------------------------------------
		//Public properties
		//--------------------------------------------------------------------------	
		public var shade:MovieClip;
		public var close_btn:MovieClip;
		public var date:MovieClip;
		public var gallery:MovieClip;
		public var nextBtn:MovieClip;
		public var prevBtn:MovieClip;
	
		//--------------------------------------------------------------------------
		//Private properties
		//--------------------------------------------------------------------------	
		private var _iArray:Array = new Array ("barran", "boron", "noctus", "nyra", "soren");
		private var _images:Array = new Array();
		
		
		private var _count:int = 0;
		private var _currentindex:int = 0;
		private var _destX:Number;
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
		public function GuardiansGalleryPage_old(pName:String=null, pView:Object=null)
		{
			super(pName, pView);
			shade.alpha = 0;
			close_btn.buttonMode = true;
			nextBtn.buttonMode = true;
			prevBtn.buttonMode = true;
			nextBtn.gotoAndStop(1);
			prevBtn.gotoAndStop(1);
			addEventListener(GuardiansControl.PAGE_DISPLAY,onShown);
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
				MovieClip(mc.parent).filters = [new GlowFilter(0xFFFF00, 1, 16, 16, 2, 3)];
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
			if (e.oData.DATA.parent != null && e.oData.DATA.name == "btnArea")
			{
				var objName:String = e.oData.DATA.parent.name;	//name of the clicked obj
				switch (objName)
				{
					case "nextBtn":
						goto ("next");						
					break;
					case "prevBtn":
						goto("prev");
					break;
				}
			}
		}
		//--------------------------------------------------------------------------
		// Private Methods
		//--------------------------------------------------------------------------
		private function goto (direction:String):void {
			var previndex:int = _currentindex;
			switch (direction){
				case "next":
					if (_currentindex+1 < _images.length){
						_currentindex++;
					} else {
						_currentindex = 0;
					}
				break;
				case "prev":
					if (_currentindex-1 >= 0){
						_currentindex--;
					} else {
						_currentindex = _images.length-1;
					}
				break;
			}
			var dX:Number = _images[_currentindex].x - ORIGINX;
			for (var i:int=0; i<_images.length; i++){
				Tweener.addTween (_images[i], {x:_images[i].x - dX, time:0.5, transition:"easeoutquad"});//, onComplete:callback, onCompleteParams:params});
			}
			reposition (direction);
		}
		
		private function reposition (direction:String):void {
			//reference image for repositioning
			var imageIndex:int;
			var refImageIndex:int;
			var refImage:Sprite;
			var image:Sprite;
			switch (direction){
				case "next":
					//get image to reposition
					if (_currentindex >= 3){
						imageIndex = _currentindex-3;
					} else {
						imageIndex = _images.length-1;
					}
					image = _images[imageIndex];
					//get reference image for repositioning
					if (imageIndex>0){
						refImageIndex = imageIndex-1;
					} else {
						refImageIndex = _images.length-1;
					}
					refImage = _images[refImageIndex];
					//reposition
					image.x = refImage.x+refImage.width;
				break;
				case "prev":
					//get image to reposition
					if (_currentindex<=_images.length-4){
						imageIndex = _currentindex+3;
					} else {
						imageIndex = 0;
					}
					//get reference image for repositioning
					if (imageIndex<_images.length-1){
						refImageIndex = imageIndex+1;
					} else {
						refImageIndex = 0;
					}
					refImage = _images[refImageIndex];
					//reposition
					image.x = refImage.x-image.width;
				break;
			}
			trace (direction, "showing", _currentindex, "reposition", imageIndex,"on", refImageIndex);
		}

		
		//blask bkg fades in
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
					//position the images starting from the middleone
					for (var i:int=0; i<_images.length; i++){
						_images[i].x = _images[i].x - 1360;
					}
					_currentindex = 2;
					//fade in
					Tweener.addTween(_images, {alpha:1, time:0.3});
					//after loading the images move the close button to top
					swapChildren(close_btn, _images[_images.length-1]);
					_count=-1;
				}
			}
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
			sp.x = ORIGINX +_images.length * sp.width;
			sp.y = ORIGINY;
			sp.alpha = 0;
			//mask
			//var imask:MovieClip = LibraryLoader.createElement("Gallery_mask", ORIGINX, ORIGINY, this);
			//sp.mask = imask;
			_images.push(sp);
			addChild(sp);
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