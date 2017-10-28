package virtualworlds.com.smerc.interfaces
{	
	/**
	* The base Interface for states.
	* 
	* @author Bo
	*/
	public interface IState
	{
		/**
		 * Implement handling of entering (and executing) this state, here.
		 */
		function onEnter():void;
		
		/**
		 * Implement handling of exiting this state, here.
		 */
		function onExit():void;
		
		/**
		 * get/set the name of this state.
		 * 
		 * By default, the name of the passed into the constructor.
		 * However, since StateMachines transition to different states
		 * by IState reference, the name can be changed dynamically.
		 */
		function get name():String;
		function set name(a_name:String):void;
		
		/**
		 * get/set the State machine that owns this state.
		 */
		function get stateMachine():IStateMachine;
		function set stateMachine(a_sm:IStateMachine):void;
		
		
		/**
		 * The state's handler of a message.
		 * 
		 * @param	a_type:	String message sent.
		 * @param	a_data:	Object data of the message.
		 * @return
		 */
		function onMessage( a_type:String, a_data:Object = null ):Boolean;
		
	}//end interface IState
	
}