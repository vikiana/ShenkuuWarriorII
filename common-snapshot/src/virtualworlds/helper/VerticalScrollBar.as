package virtualworlds.helper
{
	import caurina.transitions.Tweener;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * VerticalScrollBar is a utility used in the Hud as well as the NPC's and other in-world speech bubbles that acts as a controller for scrolling TextFields
	 * @author Smerc
	 */
	public class VerticalScrollBar extends MovieClip
	{
		private var MOVE_PER_EXECUTE:int;

		private var MINIMUM_SLIDER_SIZE:int;
		
		private var _sourceMC:MovieClip;
		private var _slider:*;
		private var _sliderTrack:*;
		
		private var _upButton:*;
		private var _downButton:*;
		
		private var _content_mc:MovieClip;
		private var _content_mask:MovieClip;
		
		private var _totalDistance:int;
		
		private var _draggingSlider:Boolean = false;
		private var _upButtonPressed:Boolean = false;
		private var _downButtonPressed:Boolean = false;
		
		private var maxContentHeight:int;
		private var minContentHeight:int;
		private var dist:int;
		
		private var maxHeight:int;
		private var minHeight:int;
		
		/**
		 * Constructor
		 * @param	p_sourceMC MovieClip The MovieClip containint the assets 'slide' 'sliderTrack' 'upButton'  and 'downButton' to act as the GUI control
		 */
		public function VerticalScrollBar(p_sourceMC:MovieClip) 
		{
			_sourceMC = p_sourceMC;
			_slider = _sourceMC.slider;
			_sliderTrack = _sourceMC.sliderTrack;
			_upButton = _sourceMC.upButton;
			_downButton = _sourceMC.downButton;
			_content_mc = _sourceMC.content_mc;
			_content_mask = _sourceMC.content_mask;
			
			MINIMUM_SLIDER_SIZE = _slider.height;
			
			setup();
		}
		
		/**
		 * Sets up the size of the scrollbar slider and resets its position to the top of the sliderTrack
		 * 
		 * @scrollToBottom: Boolean : If the scrollbar has to start from the bottom. See 
		 *                            the working of Chatlog for example. 
		 */
		public function setup(scrollToBottom:Boolean = false):void {
			
			_slider.removeEventListener(MouseEvent.MOUSE_DOWN, dragSlider);
			_slider.removeEventListener(MouseEvent.MOUSE_UP, stopDragSlider);
			
			_upButton.removeEventListener(MouseEvent.MOUSE_DOWN, upButtonDown);
			_upButton.removeEventListener(MouseEvent.MOUSE_UP, ButtonUp);
			_upButton.removeEventListener(MouseEvent.MOUSE_OUT, ButtonUp);
			
			_downButton.removeEventListener(MouseEvent.MOUSE_DOWN, downButtonDown);
			_downButton.removeEventListener(MouseEvent.MOUSE_UP, ButtonUp);
			_downButton.removeEventListener(MouseEvent.MOUSE_OUT, ButtonUp);
			
			setSliderSize();
			
			MOVE_PER_EXECUTE = 5;
			maxContentHeight = _content_mask.y;
			minContentHeight = _content_mask.y - _content_mc.height + _content_mask.height - 10;
			
			//Arvind - 06/15/09
			if(!scrollToBottom) {
				_slider.y = _sliderTrack.y + _sliderTrack.height - _slider.height;
				_content_mc.y = _content_mask.y;
				_content_mc.mask = _content_mask;
			}
			else {
				_slider.y = _sliderTrack.y + _sliderTrack.height - _slider.height;
				_content_mc.y = maxContentHeight - (_content_mc.height-_content_mask.height);
				_content_mc.mask = _content_mask;
			}
			
			dist = maxContentHeight - minContentHeight;
			
			maxHeight = _sliderTrack.y + _sliderTrack.height - _slider.height;
			minHeight = _sliderTrack.y;
			
			if(!scrollToBottom) {
				_slider.y = minHeight
			}
			//_sliderTrack.addEventListener(MouseEvent.CLICK, trackClick);
			
		}
		
		
		
		/**
		 * When _upButton or _downButton is released
		 * @private
		 * @param	e
		 */
		private function ButtonUp(e:MouseEvent):void 
		{
			_downButtonPressed = false;
			_upButtonPressed = false;
		}
		
		/**
		 * When _downButton is pressed
		 * @private
		 * @param	e
		 */
		private function downButtonDown(e:MouseEvent):void 
		{
			_downButtonPressed = true;
		}
		
		/**
		 * When _upButton is pressed
		 * @private
		 * @param	e
		 */
		private function upButtonDown(e:MouseEvent):void 
		{
			_upButtonPressed = true;
		}
		
		
		/**
		 * Event handler fired when the slider is no longer being dragged
		 * @private
		 * @param	e MouseEvent
		 */
		private function stopDragSlider(e:MouseEvent):void 
		{
			_sourceMC.stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragSlider);
			_draggingSlider = false;
		}
		
		/**
		 * Event handler that begins the dragging of the slider
		 * @private
		 * @param	e
		 */
		private function dragSlider(e:MouseEvent):void 
		{
			_sourceMC.stage.addEventListener(MouseEvent.MOUSE_UP, stopDragSlider);
			_draggingSlider = true;
		}
		
		/**
		 * Override of the execute function that moves the content according to the location of the slider
		 */
		public function execute():void {
			
			var move:Boolean = false;
			
			if (_draggingSlider) {
				var sliderLoc:int = _sourceMC.mouseY - (_slider.height / 2);
				
				if (sliderLoc < minHeight)
					_slider.y = minHeight;
				else if (sliderLoc > maxHeight)
					_slider.y = maxHeight;
				else
					_slider.y = _sourceMC.mouseY - (_slider.height / 2);
					
				move = true;
			}
			else if (_upButtonPressed) {
				if (_slider.y - MOVE_PER_EXECUTE > minHeight)
					_slider.y -= MOVE_PER_EXECUTE;
				move = true;
			}
			else if (_downButtonPressed) {
				if (_slider.y + MOVE_PER_EXECUTE < maxHeight)
					_slider.y += MOVE_PER_EXECUTE;
				move = true;
			}
			if(move){
				dist = maxContentHeight - minContentHeight;
				var distPercentage:Number = (_slider.y - minHeight) / (maxHeight - minHeight);				
				Tweener.addTween(_content_mc, {y: maxContentHeight - (_content_mc.height-_content_mask.height) * distPercentage, time: .5});
			}
		}
		
		
		/**
		 * Determines appropriate size for scrollbar slider
		 * @private
		 */
		private function setSliderSize():void
		{
			if (_content_mc.height <= _content_mask.height)
			{
				_slider.height = _sliderTrack.height;
				showScrollbar(false);
			}
			else{ 
				_slider.height = _sliderTrack.height / (_content_mc.height / _content_mask.height);
				if (_slider.height < MINIMUM_SLIDER_SIZE)	
					_slider.height = MINIMUM_SLIDER_SIZE;
					
				showScrollbar(true);
				addEventListeners();
			}
		}
		
		/**
		 * Helper function to hide/show the scrollbar if it isn't/is being used
		 * @private
		 * @param	show
		 */
		private function showScrollbar(show:Boolean):void
		{
			if (show)
			{
				_slider.visible = true;
				_sliderTrack.visible = true;
				_upButton.visible = true;
				_downButton.visible = true;
			}
			else
			{
				_slider.visible = false;
				_sliderTrack.visible = false;
				_upButton.visible = false;
				_downButton.visible = false;
			}
		}
		
		/**
		 * Helper fucntion that adds all the needed event listeners
		 * @private
		 */
		private function addEventListeners():void
		{
			_slider.addEventListener(MouseEvent.MOUSE_DOWN, dragSlider);
			_slider.addEventListener(MouseEvent.MOUSE_UP, stopDragSlider);
			
			_upButton.addEventListener(MouseEvent.MOUSE_DOWN, upButtonDown);
			_upButton.addEventListener(MouseEvent.MOUSE_UP, ButtonUp);
			_upButton.addEventListener(MouseEvent.MOUSE_OUT, ButtonUp);
			
			_downButton.addEventListener(MouseEvent.MOUSE_DOWN, downButtonDown);
			_downButton.addEventListener(MouseEvent.MOUSE_UP, ButtonUp);
			_downButton.addEventListener(MouseEvent.MOUSE_OUT, ButtonUp);
		}
		
	}
	
}