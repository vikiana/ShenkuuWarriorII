package com.neopets.users.vivianab
{
	import com.neopets.users.vivianab.LibraryLoader;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class Scroller extends MovieClip
	{	
		
		private const  GAP:Number = 4;
		
		private var _downAr:MovieClip;
		private var _upAr:MovieClip;
		private var _scrub:MovieClip;
		
		private var _bounds:Rectangle;
		
		private var _content:Sprite;
		
		private var _prevY:Number;
		
		protected var groove_color:Number = 0xE08400;
		
		
		public function Scroller(scrollerHeight:Number)
		{
			super();
			setup (scrollerHeight);	
		}
		
		/**
		 * 
		 * @param scrollerHeight
		 * @return 
		 * 
		 */
		public function setup (scrollerHeight:Number){
			_upAr = LibraryLoader.createElement("scrollerarrow", 0, 0, this) as MovieClip;
			_upAr.y += 5;
			_downAr = LibraryLoader.createElement("scrollerarrow", 0, scrollerHeight, this) as MovieClip;
			_downAr.rotation = 180;
			_downAr.y -= 5;
			_scrub = LibraryLoader.createElement("scrollerscrub", 0, _upAr.height+GAP, this) as MovieClip;
			//adjust y pos
			_scrub.y += _scrub.height/2;
			
			var scrubHeight:Number = scrollerHeight - _downAr.height*2 - GAP*2 - _scrub.height;
			
			var groove:Sprite = new Sprite ();
			groove.graphics.beginFill(groove_color);
			groove.graphics.drawRect(_scrub.x-2.5,_scrub.y-_scrub.height/2, 5 ,scrubHeight+ _scrub.height);
			groove.graphics.endFill();
			addChild(groove);
			
			swapChildren(groove, _scrub);
			
			_bounds = new Rectangle (0, _upAr.height+GAP+_scrub.height/2, 0, scrubHeight);
		}
		
		public function init(content:Sprite):void {
			_scrub.buttonMode = true;
			_content = content;
			_scrub.addEventListener(MouseEvent.MOUSE_DOWN, dragScroller, false, 0, true);
			trace (_scrub, _downAr.visible, _upAr.x, this.stage, _content, this.parent.parent.parent);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragScroller, false, 0, true);
			//buttons
			_downAr.addEventListener(MouseEvent.MOUSE_DOWN, scrollUp, false, 0, true);
			_upAr.addEventListener(MouseEvent.MOUSE_DOWN, scrollDown, false, 0, true);
		}
		
		
		private function scrollUp(e:MouseEvent):void{
			if (_content.y + _content.height >= _bounds.bottom){
				_content.y-=10;
				if (_scrub.y + 10*_bounds.height/(_content.height -_bounds.height-GAP*2-_scrub.height/2) <= _bounds.height+_scrub.height+GAP){
					_scrub.y += 10*_bounds.height/(_content.height -_bounds.height-GAP*2-_scrub.height/2);
				} else {
					_scrub.y = _bounds.height+_scrub.height+GAP;
				}
			}
		}
		private function scrollDown(e:MouseEvent):void{
			if (_content.y <=0){
				_content.y+=10;
				if (_scrub.y - 10*_bounds.height/(_content.height -_bounds.height-GAP*2-_scrub.height/2) >= _scrub.height/2+GAP){
					_scrub.y -= 10*_bounds.height/(_content.height -_bounds.height-GAP*2-_scrub.height/2);
				} else {
					_scrub.y = _scrub.height/2+GAP
				}
			} 
		}
		
		public function reset():void {
			_scrub.y = _upAr.height+GAP+_scrub.height/2;
			_content.y = 0;
		}
		
		
		private function dragScroller(e:MouseEvent):void {
			trace ("down");
			MovieClip(e.target).startDrag(false, _bounds);
			_prevY = _scrub.y;
			addEventListener(Event.ENTER_FRAME, dragContent, false, 0, true);
		}
		
		private function stopDragScroller (e:MouseEvent):void {
			_scrub.stopDrag();
			removeEventListener(Event.ENTER_FRAME, dragContent);
		}
		
		private function dragContent(e:Event):void {
			_content.y += (_prevY-_scrub.y)*(_content.height-_bounds.height-GAP*2)/_bounds.height;
			_prevY = _scrub.y;
		}

	}
}