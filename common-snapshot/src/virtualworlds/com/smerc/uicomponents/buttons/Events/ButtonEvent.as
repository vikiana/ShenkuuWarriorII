package virtualworlds.com.smerc.uicomponents.buttons.Events
{	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import virtualworlds.com.smerc.uicomponents.buttons.ISmercButton;
	
	/**
	* ...
	* @author Bo
	*/
	public class ButtonEvent extends Event
	{
		/**
		 * An ISmercButton was clicked on
		 * @eventType ButtonEvent.SMERCBUTTON_CLICK_EVT
		 */
		public static const SMERCBUTTON_CLICK_EVT:String = "SmercButtonClickEvent";
		
		/**
		 * An ISmercButton was double-clicked on
		 * @eventType ButtonEvent.SMERCBUTTON_DOUBLE_CLICK_EVT
		 */
		public static const SMERCBUTTON_DOUBLE_CLICK_EVT:String = "SmercButtonDoubleClickEvent";
		
		/**
		 * An ISmercButton was moused-down
		 * @eventType ButtonEvent.SMERCBUTTON_MOUSE_DOWN_EVT
		 */
		public static const SMERCBUTTON_MOUSE_DOWN_EVT:String = "SmercButtonMouseDownEvent";
		
		/**
		 * An ISmercButton was moved over
		 * @eventType ButtonEvent.SMERCBUTTON_MOUSE_MOVE_EVT
		 */
		public static const SMERCBUTTON_MOUSE_MOVE_EVT:String = "SmercButtonMouseMoveEvent";
		
		/**
		 * An ISmercButton moused-up on.
		 * @eventType ButtonEvent.SMERCBUTTON_MOUSE_UP_EVT
		 */
		public static const SMERCBUTTON_MOUSE_UP_EVT:String = "SmercButtonMouseUpEvent";
		
		/**
		 * An ISmercButton moused-out on.
		 * @eventType ButtonEvent.SMERCBUTTON_MOUSE_OUT_EVT
		 */
		public static const SMERCBUTTON_MOUSE_OUT_EVT:String = "SmercButtonMouseOutEvent";
		
		/**
		 * An ISmercButton moused-over.
		 * @eventType ButtonEvent.SMERCBUTTON_MOUSE_OVER_EVT
		 */
		public static const SMERCBUTTON_MOUSE_OVER_EVT:String = "SmercButtonMouseOverEvent";
		
		/**
		 * An ISmercButton was mouse-wheeled on
		 * @eventType ButtonEvent.SMERCBUTTON_MOUSE_WHEEL_EVT
		 */
		public static const SMERCBUTTON_MOUSE_WHEEL_EVT:String = "SmercButtonMouseWheelEvent";
		
		/**
		 * An ISmercButton was rolled-out
		 * @eventType ButtonEvent.SMERCBUTTON_ROLL_OUT_EVT
		 */
		public static const SMERCBUTTON_ROLL_OUT_EVT:String = "SmercButtonRollOutEvent";
		
		/**
		 * An ISmercButton was rolled-over
		 * @eventType ButtonEvent.SMERCBUTTON_ROLL_OVER_EVT
		 */
		public static const SMERCBUTTON_ROLL_OVER_EVT:String = "SmercButtonRollOverEvent";
		
		/**
		 * An ISmercButton was held down.
		 * @eventType ButtonEvent.SMERCBUTTON_HELD_DOWN_EVT
		 */
		public static const SMERCBUTTON_HELD_DOWN_EVT:String = "SmercButtonHeldDownEvent";
		
		/**
		 * The ISmercButton associated with the event for this class.
		 */
		protected var _smercButton:ISmercButton;
		
		/**
		 * The original MouseEvent that initiated this event to be dispatched.
		 */
		protected var _mouseEvent:MouseEvent;
		
		/**
		 * 
		 * @param	type:			Same as Event.type
		 * @param	a_smercButton:	The ISmercButton associated with this class.
		 * @param	a_mouseEvent:	The MouseEvent that is to be associated with this event.  Generally, the 
		 * 							MouseEvent that caused this event to be dispatched.
		 * @param	bubbles:		Same as Event.bubbles.
		 * @param	cancelable:		Same as Event.cancelable.
		 */
		public function ButtonEvent(type:String, a_smercButton:ISmercButton, a_mouseEvent:MouseEvent, 
									bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			
			_smercButton = a_smercButton;
			
			_mouseEvent = a_mouseEvent;
			
		}//end ButtonEvent() constructor.
		
		/**
		 * Getter for the MouseEvent that we were created with.
		 */
		public function get mouseEvent():MouseEvent
		{
			return _mouseEvent;
		}//end get mouseEvent()
		
		/**
		 * Getter for the ISmercButton that we're associated with.
		 */
		public function get smercButton():ISmercButton
		{
			return _smercButton;
		}//end get smercButton()
		
		/**
		 * 
		 * @return	A new clone of this ButtonEvent, for purposes of re-dispatching.
		 */
		override public function clone():Event
		{
			return new ButtonEvent(type, _smercButton, _mouseEvent, bubbles, cancelable);
			
		}//end clone()
		
	}//end class ButtonEvent
	
}//end package com.smerc.uicomponents.Buttons.Events
