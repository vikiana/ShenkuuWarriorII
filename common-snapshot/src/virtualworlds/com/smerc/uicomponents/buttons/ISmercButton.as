package virtualworlds.com.smerc.uicomponents.buttons
{
	import flash.events.IEventDispatcher;
	
	/**
	* ...
	* @author Bo
	*/
	public interface ISmercButton extends IEventDispatcher
	{
		/**
		 * For proper clean-up of the ISmercButton.
		 * @param	...args
		 */
		function destroy(...args):void;
		
		/**
		 * Is the button paused?
		 */
		function get paused():Boolean;
		
		/**
		 * Set or clear the paused status of the ISmercButton
		 * @param	a_bool
		 */
		function pause(a_bool:Boolean):void;
		
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
		function setDispatchesHeldDownEvents(a_bool:Boolean, a_heldDownDispatchMS:int = 33):void;
		
	}//end interface ISmercButton
	
}//end package com.smerc.uicomponents.Buttons
