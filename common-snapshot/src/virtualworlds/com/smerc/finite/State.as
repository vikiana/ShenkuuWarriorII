package virtualworlds.com.smerc.finite
{
	
	import flash.utils.getQualifiedClassName;
	
	import virtualworlds.com.smerc.interfaces.IState;
	import virtualworlds.com.smerc.interfaces.IStateMachine;
	
	/**
	* Basic implementation of a State. Useful for FiniteStateMachine.
	* 
	* @author Bo
	*/
	public class State implements IState
	{
		/**
		 * Nazme of this state.
		 */
		protected var _name:String;
		
		/**
		 * reference to the state machine that owns this state.
		 */
		private var _sm:IStateMachine;
		
		/**
		 * 
		 * @param	a_name:	String name of this state.
		 * @param	a_sm:	The StateMachine that owns this state.
		 */
		public function State(a_name:String, a_sm:IStateMachine)
		{
			if (!a_name || !a_sm)
			{
				throw new ArgumentError("State::State(): parameters a_name and a_sm must be non-null!");
			}
			
			this.name = a_name;
			
			_sm = a_sm;
			
		}//end State() constructor.
		
		/**
		 * get/set the name of this state.
		 * 
		 * By default, the name of the passed into the constructor.
		 * However, since StateMachines transition to different states
		 * by IState reference, the name can be changed dynamically.
		 */
		public function get name():String
		{
			return _name;
		}//end get name()
		public function set name(a_name:String):void
		{
			_name = a_name;
		}//end set name()
		
		/**
		 * get the State machine that owns this state.
		 */
		public function get stateMachine():IStateMachine
		{
			return _sm;
			
		}//end get stateMachine()
		
		/**
		 * set the State machine that owns this state.
		 */
		public function set stateMachine(a_sm:IStateMachine):void
		{
			_sm = a_sm;
			
		}//end set stateMachine()
		
		/**
		 * Handler for entering (and executing) this state.
		 */
		public function onEnter():void
		{
			// override this
			throw new Error("State::onEnter(): this function must be overridden! -- this=" + this);
			
		}//end onEnter()
		
		/**
		 * Handler for exiting this state.
		 */
		public function onExit():void
		{
			// override this
			throw new Error("State::onExit(): this function must be overridden! -- this=" + this);
			
		}//end onExit()
		
		/**
		 * @param	a_msg:	String message to handle.
		 * @param	a_data:	Object data message to handle.
		 * @return
		 */
		public function onMessage( msg:String, data:Object = null ):Boolean
		{
			// override this
			return false;
			
		}//end onMessage()
		
		/**
		 * To change the contents of the square brackets, override get myStringRep().
		 * @see #myStringRep
		 * 
		 * @return	String representation of this object.
		 */
		final public function toString():String
		{
			return ("[ " + this.myStringRep + " ]");
		}//end toString()
		
		/**
		 * The guts of the toString() output for this object.
		 * Override this for more detailed output in subclasses.
		 */
		protected function get myStringRep():String
		{
			return (getQualifiedClassName(this) + " name=" + this.name);
		}//end myStringRep()
		
	}//end class State
	
}//end package com.smerc.statemachines.finite
