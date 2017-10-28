package virtualworlds.com.smerc.uicomponents.buttons
{	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.spicefactory.lib.logging.LogContext;
	import org.spicefactory.lib.logging.Logger;
	
	import virtualworlds.com.smerc.uicomponents.buttons.Events.ButtonEvent;
	
	/**
	* ...
	* @author Bo
	*/
	public class SmercButton extends Sprite implements ISmercButton
	{
		protected static const log:Logger = LogContext.getLogger(SmercButton);
		/**
		 * The default number of MS between re-dispatching 
		 * com.smerc.uicomponents.Buttons.Events.ButtonEvent#SMERCBUTTON_HELD_DOWN_EVT
		 */
		public static const DEFAULT_HELD_DOWN_MS:int = 33;
		
		/**
		 * The current state of the button (UP, OVER, DOWN, DISABLED)
		 */
		protected var _currentStateNum:int = -1;
		
		/**
		 * The Sprite used for our MouseEvent listening.
		 */
		protected var _hitArea:Sprite;
		
		/**
		 * This is the contents of which we extract all the parts of a SmercButton.
		 */
		protected var _buttonContents:MovieClip;
		
		/**
		 * For our paused state.
		 */
		protected var _bPaused:Boolean = false;
		
		/**
		 * Determines whether we're dispatching the Held-Down Event. Default is 'false'.
		 */
		protected var _bDispatchesHeldDownEvents:Boolean = false;
		
		/**
		 * The Timer that does the dispatching of the ButtonEvent.SMERCBUTTON_HELD_DOWN_EVT
		 * @see com.smerc.uicomponents.Buttons.Events.ButtonEvent#SMERCBUTTON_HELD_DOWN_EVT
		 */
		protected var _heldDownDispatchTimer:Timer;
		
		/**
		 * The number of MS between intervals of dispatching ButtonEvent.SMERCBUTTON_HELD_DOWN_EVT
		 * @see com.smerc.uicomponents.Buttons.Events.ButtonEvent#SMERCBUTTON_HELD_DOWN_EVT
		 */
		protected var _heldDownDispatchMS:int;
		
		/**
		 * The MouseEvent that we dispatch with the ButtonEvent.SMERCBUTTON_HELD_DOWN_EVT
		 * @see com.smerc.uicomponents.Buttons.Events.ButtonEvent#SMERCBUTTON_HELD_DOWN_EVT
		 */
		protected var _heldDownMouseEvt:MouseEvent;
		
		/**
		 * 
		 * @param	a_mc:			MovieClip that contains all the parts of a SmercButton.
		 * 							Specifically, it should have a Sprite labelled "hitArea_mc"
		 * 							that encompasses all its frames.  It should also have four frames
		 * 							1 (UP), 2 (OVER), 3 (DOWN), 4 (DISABLED).
		 * 
		 * @param	a_bAddContents:	Boolean to tell the SmercButton to add the a_mc to itself.
		 * 							Only do this if a_mc is a new instance and should be positioned
		 * 							by positioning the SmercButton, itself.
		 * 							Set to 'false' if a_mc is apart of some other image and you don't
		 * 							wish it to be accidentally moved by adding it to the SmercButton.
		 */
		public function SmercButton(a_mc:MovieClip, a_bAddContents:Boolean = true)
		{
			_buttonContents = a_mc;
			
			if (!_buttonContents)
			{
				log.warn("SmercButton(): parameter 'a_mc' is NOT a MovieClip! returning.");
				return;
			}
			
			extractStatesAndSet(a_bAddContents);
			
			// If we couldn't extract a hit-area, use this entire object.
			if (!_hitArea)
			{
				_hitArea = _buttonContents;
			}
			
			// Put ourselves in our default up-state
			this.gotoState(this.UP);
			
			//make the button initialized with no functionality.
			//
			
			this.pause(true);
			
			if (this.stage)
			{
				addedToStageHandler();
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true);
			}
			
		}//end SmercButton()
		
		/**
		 * Used to acquire the guts of this object.  The buttonContents is 
		 * what this 'button' was built with.
		 */
		public function get buttonContents():MovieClip
		{
			return _buttonContents;
		}//end get buttonContents()
		
		/**
		 * THE UP-FRAME NUMBER OF OUR VISUAL REPRESENTATIVE'S STATES.
		 */
		protected function get UP():int
		{
			return 1;
		}//end get UP()
		
		/**
		 * THE OVER-FRAME NUMBER OF OUR VISUAL REPRESENTATIVE'S STATES.
		 */
		protected function get OVER():int
		{
			return 2;
		}//end get OVER()
		
		/**
		 * THE DOWN-FRAME NUMBER OF OUR VISUAL REPRESENTATIVE'S STATES.
		 */
		protected function get DOWN():int
		{
			return 3;
		}//end get DOWN()
		
		/**
		 * THE DISABLED-FRAME NUMBER OF OUR VISUAL REPRESENTATIVE'S STATES.
		 */
		protected function get DISABLED():int
		{
			return 4;
		}//end DISABLED()
		
		/**
		 * This adds all the default listeners to its _hitArea to re-route the MouseEvents.
		 */
		protected function addListeners():void
		{
			// Add listeners to our hitArea for our functionality.
			_hitArea.addEventListener(MouseEvent.CLICK, onButtonClick, false, 0, true);
			_hitArea.addEventListener(MouseEvent.DOUBLE_CLICK, onButtonDoubleClick, false, 0, true);
			_hitArea.addEventListener(MouseEvent.MOUSE_DOWN, onButtonMouseDown, false, 0, true);
			_hitArea.addEventListener(MouseEvent.MOUSE_MOVE, onButtonMouseMove, false, 0, true);
			_hitArea.addEventListener(MouseEvent.MOUSE_UP, onButtonMouseUp, false, 0, true);
			_hitArea.addEventListener(MouseEvent.MOUSE_OUT, onButtonMouseOut, false, 0, true);
			_hitArea.addEventListener(MouseEvent.MOUSE_OVER, onButtonMouseOver, false, 0, true);
			_hitArea.addEventListener(MouseEvent.MOUSE_WHEEL, onButtonMouseWheel, false, 0, true);
			_hitArea.addEventListener(MouseEvent.ROLL_OUT, onButtonRollOut, false, 0, true);
			_hitArea.addEventListener(MouseEvent.ROLL_OVER, onButtonRollOver, false, 0, true);
		}//end addListeners()
		
		/**
		 * Removes all of the default listeners from its _hitArea.
		 */
		protected function removeListeners():void
		{
			// Add listeners to our hitArea for our functionality.
			_hitArea.removeEventListener(MouseEvent.CLICK, onButtonClick);
			_hitArea.removeEventListener(MouseEvent.DOUBLE_CLICK, onButtonDoubleClick);
			_hitArea.removeEventListener(MouseEvent.MOUSE_DOWN, onButtonMouseDown);
			_hitArea.removeEventListener(MouseEvent.MOUSE_MOVE, onButtonMouseMove);
			_hitArea.removeEventListener(MouseEvent.MOUSE_UP, onButtonMouseUp);
			_hitArea.removeEventListener(MouseEvent.MOUSE_OUT, onButtonMouseOut);
			_hitArea.removeEventListener(MouseEvent.MOUSE_OVER, onButtonMouseOver);
			_hitArea.removeEventListener(MouseEvent.MOUSE_WHEEL, onButtonMouseWheel);
			_hitArea.removeEventListener(MouseEvent.ROLL_OUT, onButtonRollOut);
			_hitArea.removeEventListener(MouseEvent.ROLL_OVER, onButtonRollOver);
			
		}//end removeListeners()
		
		/**
		 * Destroys this SmercButton.
		 * 
		 * @param	...args
		 */
		public function destroy(...args):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			if(_hitArea)
			{
				_hitArea.removeEventListener(MouseEvent.CLICK, onButtonClick);
				_hitArea.removeEventListener(MouseEvent.DOUBLE_CLICK, onButtonDoubleClick);
				_hitArea.removeEventListener(MouseEvent.MOUSE_DOWN, onButtonMouseDown);
				_hitArea.removeEventListener(MouseEvent.MOUSE_MOVE, onButtonMouseMove);
				_hitArea.removeEventListener(MouseEvent.MOUSE_UP, onButtonMouseUp);
				_hitArea.removeEventListener(MouseEvent.MOUSE_OUT, onButtonMouseOut);
				_hitArea.removeEventListener(MouseEvent.MOUSE_OVER, onButtonMouseOver);
				_hitArea.removeEventListener(MouseEvent.MOUSE_WHEEL, onButtonMouseWheel);
				_hitArea.removeEventListener(MouseEvent.ROLL_OUT, onButtonRollOut);
				_hitArea.removeEventListener(MouseEvent.ROLL_OVER, onButtonRollOver);
				
				_hitArea = null;
			}
			
			_currentStateNum = -1;
			
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
			
			_buttonContents = null;
			
			_bDispatchesHeldDownEvents = false;
			if (_heldDownDispatchTimer)
			{
				_heldDownDispatchTimer.stop();
				_heldDownDispatchTimer.removeEventListener(TimerEvent.TIMER, onButtonMouseHeldDown);
				_heldDownDispatchTimer = null;
			}
			
			_heldDownMouseEvt = null;
			
		}//end destroy()
		
		/**
		 * 
		 * @param	a_bool:					Boolean to determine whether or not the ISmercButton should
		 * 									dispatch the ButtonEvent.SMERCBUTTON_HELD_DOWN_EVT on itself.
		 * 
		 * @param	a_heldDownDispatchMS:	int number of MS between dispatching the 
		 * 									ButtonEvent.SMERCBUTTON_HELD_DOWN_EVT.
		 * 
		 * @see com.smerc.uicomponents.Buttons.Events.ButtonEvent#SMERCBUTTON_HELD_DOWN_EVT
		 */
		public function setDispatchesHeldDownEvents(a_bool:Boolean, a_heldDownDispatchMS:int = 33):void
		{
			_bDispatchesHeldDownEvents = a_bool;
			
			if(_bDispatchesHeldDownEvents)
			{
				_heldDownDispatchMS = a_heldDownDispatchMS;
			}
			else if(_heldDownDispatchTimer)
			{
				// Since we're not to dispatch the held-down events, 
				// stop the timer from firing, and stop listening to its events.
				_heldDownDispatchTimer.removeEventListener(TimerEvent.TIMER, onButtonMouseHeldDown);
				_heldDownDispatchTimer.stop();
			}
			
			if(_bDispatchesHeldDownEvents && _heldDownDispatchMS <= 0)
			{
				trace(this.name + "::setDispatchesHeldDownEvents(): _heldDownDispatchMS=" + _heldDownDispatchMS
						+ " <= 0, setting to default=" + SmercButton.DEFAULT_HELD_DOWN_MS);
				
				_heldDownDispatchMS = SmercButton.DEFAULT_HELD_DOWN_MS;
			}
			
		}//end set dispatchesHeldDownEvents()
		
		/**
		 * Getter to determine if we're dispatching the held-down events.
		 */
		public function get dispatchesHeldDownEvents():Boolean
		{
			return _bDispatchesHeldDownEvents;
		}//end set dispatchesHeldDownEvents()
		
		/**
		 * By default does nothing.
		 * Override for functionality.
		 * Triggered when the SmercButton is added to the stage.
		 * 
		 * @param	a_evt
		 */
		protected function addedToStageHandler(a_evt:Event = null):void
		{
			
		}//end addedToStageHandler()
		
		protected function onButtonClick(a_mouseEvt:MouseEvent):void
		{
			this.dispatchEvent(new ButtonEvent(ButtonEvent.SMERCBUTTON_CLICK_EVT, this, a_mouseEvt));
		}//end onButtonClick()
		
		protected function onButtonDoubleClick(a_mouseEvt:MouseEvent):void
		{
			this.dispatchEvent(new ButtonEvent(ButtonEvent.SMERCBUTTON_DOUBLE_CLICK_EVT, this, a_mouseEvt));
		}//end onButtonDoubleClick()
		
		protected function onButtonMouseDown(a_mouseEvt:MouseEvent):void
		{
			this.gotoState(this.DOWN);
			
			this.dispatchEvent(new ButtonEvent(ButtonEvent.SMERCBUTTON_MOUSE_DOWN_EVT, this, a_mouseEvt));
			
			if (_bDispatchesHeldDownEvents)
			{
				if (!_heldDownDispatchTimer)
				{
					_heldDownDispatchTimer = new Timer(_heldDownDispatchMS, 0);
				}
				else
				{
					_heldDownDispatchTimer.removeEventListener(TimerEvent.TIMER, onButtonMouseHeldDown);
					_heldDownDispatchTimer.stop();
					_heldDownDispatchTimer = new Timer(_heldDownDispatchMS, 0);
				}
				_heldDownMouseEvt = a_mouseEvt;
				_heldDownMouseEvt.relatedObject = _hitArea;
				_heldDownDispatchTimer.addEventListener(TimerEvent.TIMER, onButtonMouseHeldDown, false, 0, true);
				_heldDownDispatchTimer.start();
				onButtonMouseHeldDown(); // Dispatch the event initially, just for good measure.
			}
			
		}//end onButtonMouseDown()
		
		protected function onButtonMouseHeldDown(a_timerEvt:TimerEvent = null):void
		{
			this.dispatchEvent(new ButtonEvent(ButtonEvent.SMERCBUTTON_HELD_DOWN_EVT, this, _heldDownMouseEvt));
		}//end onButtonMouseHeldDown()
		
		protected function onButtonMouseMove(a_mouseEvt:MouseEvent):void
		{
			this.dispatchEvent(new ButtonEvent(ButtonEvent.SMERCBUTTON_MOUSE_MOVE_EVT, this, a_mouseEvt));
			
			// If we're dispatching held-down ButtonEvents, update the mouseEvent that's sent off with it.
			if (_heldDownDispatchTimer && _heldDownDispatchTimer.running)
			{
				_heldDownMouseEvt.relatedObject = _hitArea;
				_heldDownMouseEvt = a_mouseEvt;
			}
			
		}//end onButtonMouseMove()
		
		protected function onButtonMouseUp(a_mouseEvt:MouseEvent):void
		{
			this.gotoState(this.OVER);
			this.dispatchEvent(new ButtonEvent(ButtonEvent.SMERCBUTTON_MOUSE_UP_EVT, this, a_mouseEvt));
			
			if (_heldDownDispatchTimer)
			{
				_heldDownDispatchTimer.stop();
			}
			
		}//end onButtonMouseUp()
		
		protected function onButtonMouseOut(a_mouseEvt:MouseEvent):void
		{
			this.dispatchEvent(new ButtonEvent(ButtonEvent.SMERCBUTTON_MOUSE_OUT_EVT, this, a_mouseEvt));
			
			if (_heldDownDispatchTimer)
			{
				_heldDownDispatchTimer.stop();
			}
			
		}//end onButtonMouseOut()
		
		protected function onButtonMouseOver(a_mouseEvt:MouseEvent):void
		{
			this.dispatchEvent(new ButtonEvent(ButtonEvent.SMERCBUTTON_MOUSE_OVER_EVT, this, a_mouseEvt));
		}//end onButtonMouseOver()
		
		protected function onButtonMouseWheel(a_mouseEvt:MouseEvent):void
		{
			this.dispatchEvent(new ButtonEvent(ButtonEvent.SMERCBUTTON_MOUSE_WHEEL_EVT, this, a_mouseEvt));
		}//end onButtonMouseWheel()
		
		protected function onButtonRollOut(a_mouseEvt:MouseEvent):void
		{
			this.gotoState(this.UP);
			this.dispatchEvent(new ButtonEvent(ButtonEvent.SMERCBUTTON_ROLL_OUT_EVT, this, a_mouseEvt));
			
			if (_heldDownDispatchTimer)
			{
				_heldDownDispatchTimer.stop();
			}
			
		}//end onButtonRollOut()
		
		protected function onButtonRollOver(a_mouseEvt:MouseEvent):void
		{
			this.gotoState(this.OVER);
			this.dispatchEvent(new ButtonEvent(ButtonEvent.SMERCBUTTON_ROLL_OVER_EVT, this, a_mouseEvt));
		}//end onButtonRollOver()
		
		
		/**
		 * takes all of the necessary parts for a SmercButton from the construction
		 * parameter a_mc.
		 * 
		 * @param	a_bAddContents:	Boolean to determine whether the _buttonContents
		 * 							should be added to this.
		 */
		protected function extractStatesAndSet(a_bAddContents:Boolean):void
		{
			if (a_bAddContents)
			{
				this.addChild(_buttonContents);
			}
			
			_hitArea = _buttonContents.getChildByName("hitArea_mc") as Sprite;
			
		}//end extractStatesAndSet()
		
		/**
		 * Puts us in the specified button state. 
		 * Should the _buttonContents have less frames than the requested a_stateNum, 
		 * the _buttonContents are told to gotoAndStop(_buttonContents.totalFrames).
		 * 
		 * @param	a_stateNum:	Number of the state (frame) to enter.
		 * @see #UP
		 * @see #DOWN
		 * @see #OVER
		 * @see #DISABLED
		 */
		protected function gotoState(a_stateNum:int):void
		{
			if (_buttonContents.totalFrames < a_stateNum)
			{
				a_stateNum = _buttonContents.totalFrames;
			}
			_buttonContents.gotoAndStop(a_stateNum);
			_currentStateNum = a_stateNum;
			
		}//end gotoState()
		
		/**
		 * Sets the visual state, but not the data state.  That is, 
		 * one may visually set a button to the up, down, over, or disabled state, 
		 * though it won't actually be in that state.
		 * @param	a_stateNum
		 */
		public function gotoVisualState(a_stateNum:int):void
		{
			_buttonContents.gotoAndStop(a_stateNum);
		}//end gotoVisualState()
		
		/**
		 * Is the button paused?
		 */
		public function get paused():Boolean
		{
			return _bPaused;
		}//end get paused()
		
		/**
		 * Set or clear the paused status of the ISmercButton
		 * @param	a_bool
		 */
		public function pause(a_bool:Boolean):void
		{
			//
			
			_bPaused = a_bool;
			
			if(_hitArea)
			{
				_hitArea.buttonMode = (!a_bool);
				_hitArea.mouseEnabled = (!a_bool);
			}
			
			if(a_bool)
			{
				//Make us look disabled, but don't use the gotoState, as that will set our _currentStateNum,
				// which is used on unpausing.
				_buttonContents.gotoAndStop(this.DISABLED);
				this.removeListeners();
				if (_bDispatchesHeldDownEvents && _heldDownDispatchTimer)
				{
					_heldDownDispatchTimer.stop();
					_heldDownDispatchTimer.removeEventListener(TimerEvent.TIMER, onButtonMouseHeldDown)
				}
			}
			else
			{
				this.gotoState(this.UP);
				this.addListeners();
				if (_bDispatchesHeldDownEvents && _heldDownDispatchTimer)
				{
					_heldDownDispatchTimer.addEventListener(TimerEvent.TIMER, onButtonMouseHeldDown, false, 0, true);
				}
			}
			
		}//end pause()
		
	}//end class SmercButton
	
}//end package com.smerc.uicomponents.Buttons
