package virtualworlds.com.smerc.finite
{
	
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	import org.spicefactory.lib.logging.LogContext;
	import org.spicefactory.lib.logging.Logger;
	
	import virtualworlds.com.smerc.interfaces.IState;
	import virtualworlds.com.smerc.interfaces.IStateMachine;
	
	/**
	* ...
	* @author Bo
	*/
	public class FiniteStateMachine extends EventDispatcher implements IStateMachine
	{
		protected static const log:Logger = LogContext.getLogger(FiniteStateMachine);
		/**
		 * the initial state to enter.
		 */
		protected var _initialState:IState;
		
		/**
		 * The current state of the machine.
		 */
		protected var _currState:IState;
		
		/**
		 * the name of this instance of this machine.
		 */
		protected var name:String;
		
		/**
		 * Used for instance name construction, keeping track of the number of FiniteStateMachines
		 * and all subclasses of this class that use the default constructor.
		 */
		private static var _constructionCnt:int = 0;
		
		/**
		 * In this constructor, 'create()' is called.  Override it for further non-default behavior.
		 * @see #create()
		 */
		public function FiniteStateMachine(a_name:String = "FiniteStateMachine" )
		{
			if (!a_name)
			{
				a_name = "FiniteStateMachine";
			}
			
			name = a_name + "_" + _constructionCnt;
			
			_constructionCnt++;
			
			create();
			
		}//end FiniteStateMachine() constructor.
		
		public function getName():String
		{
			return name;
			
		}//end getName()
		
		/**
		 * Doesn't do anything in this base class.  It's here merely for overriding.
		 */
		protected function create():void
		{
			
		}//end create()
		
		/**
		 * Here, we enter our initial state.  So, our initial state must be set ahead of time.
		 * @see #setInitialState()
		 */
		public function start():void
		{
			enter( _initialState );
			
		}//end start()
		
		/**
		 * Here, we exit our current state.
		 * @see #exit()
		 */
		public function finish():void
		{
			exit(_currState);
		}//end finish()
		
		/**
		 * Transition to a new state.
		 * 
		 * @param	a_targetState:	The target state to transition to.
		 */
		public function transition( a_targetState:IState ):void
		{
			if (a_targetState.stateMachine != this)
			{
				log.warn("FiniteStateMachine::transition(" + a_targetState 
																	+ "): a_targetState.stateMachine=" + a_targetState.stateMachine.getName()
																	+ " != this=" + this.getName() + ", returning.");
				return;
			}
			
			if ( _currState && _currState == a_targetState )
			{
				selfTransition();
			}
			else
			{
				if (_currState)
				{
					exit( _currState );
				}
				
				enter( a_targetState );
			}
			
		}//end transition()
		
		/**
		 * Send a message (and data) to the current state within this machine.
		 * 
		 * @param	a_msg:	String message to send.
		 * @param	a_data:	Data to send in the message.
		 */
		public function sendMessage( a_msg:String, a_data:Object = null):void
		{
			_currState.onMessage( a_msg, a_data );
			
		}//end sendMessage()

		/**
		 * Getter for the current state of the machine.
		 */
		public function get currentState():IState
		{
			return _currState;
			
		}//end get currentState()
		
		/**
		 * Set the initial state of the machine.  this is necessary before
		 * calling start().
		 * 
		 * @see #start()
		 * 
		 * @param	a_state:	IState to be the initial state to enter.
		 */
		protected function setInitialState( a_state:IState ):void
		{
			_initialState = a_state;
			
		}//end setInitialState()
		
		/**
		 * Transition from the current state to the current state.
		 * This calls onExit on the current state, and then onEnter on the current state.
		 * 
		 */
		protected function selfTransition():void
		{
			_currState.onExit();
			_currState.onEnter();
			
		}//end selfTransition()
		
		/**
		 * 
		 * @param	a_state:	IState to enter.
		 */
		protected function enter( a_state:IState ):void
		{
			_currState = a_state;
			a_state.onEnter();
			
		}//end enter()
		
		/**
		 * 
		 * @param	a_state:	IState to exit.
		 */
		protected function exit(a_state:IState):void
		{
			a_state.onExit();
			
		}//end exit()
		
		/**
		 * To change the contents of the square brackets, override get myStringRep().
		 * @see #myStringRep
		 * 
		 * @return	String representation of this object.
		 */
		override final public function toString():String
		{
			return ("[ " + this.myStringRep + " ]");
		}//end toString()
		
		/**
		 * The guts of the toString() output for this object.
		 * Override this in subclasses for different details in the guts of toString()'s return.
		 */
		protected function get myStringRep():String
		{
			return (getQualifiedClassName(this) + " name=" + this.name 
					+ " _initialState=" + _initialState + " _currState=" + _currState);
			
		}//end myStringRep()
		
	}//end class FiniteStateMachine
	
}//end package com.smerc.statemachines.finite
