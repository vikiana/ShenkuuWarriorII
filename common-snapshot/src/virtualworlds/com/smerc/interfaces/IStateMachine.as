package virtualworlds.com.smerc.interfaces
{
	
	/**
	* ...
	* @author Bo
	*/
	public interface IStateMachine
	{
		/**
		 * Starting the StateMachine will generally have it enter it's initial state.
		 */
		function start():void;
		
		/**
		 * Here, we exit our current state.
		 */
		function finish():void;
		
		/**
		 * Call this to transition to a new state, thus exiting the current and entering the new.
		 * 
		 * @param	a_targetState:	IState to enter.
		 */
		function transition( a_targetState:IState ):void;
		
		/**
		 * Send a message to the current state.
		 * @param	a_msg:	String message to send.
		 * @param	a_data:	Data portion of the message to send (optional).
		 */
		function sendMessage( a_msg:String, a_data:Object = null):void;
		
		/**
		 * Getter for the current state of the machine.
		 */
		function get currentState():IState;
		
		function getName():String;
		
	}//end interface IStateMachine
	
}//end package com.smerc.statemachines.interfaces
