//Marks the right margin of code *******************************************************************
package com.neopets.projects.np10.statemachine
{
	import com.neopets.projects.np10.data.vo.GameStatesVO;
	import com.neopets.projects.np10.statemachine.interfaces.IGameState;
	import com.neopets.projects.np10.statemachine.interfaces.IState;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.utils.Dictionary;

	/**
	 * public class StateMachine
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class StateMachine
	{
		//--------------------------------------------------------------------------
		// Costants
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		//--------------------------------------------------------------------------
		//Public properties
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		//--------------------------------------------------------------------------
		//Private properties
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		private var _statesVO:GameStatesVO;
		
		private var _currentState:IGameState;
		
		//private var _states:Dictionary = new Dictionary (true);
		private var _states:Vector.<IGameState>;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Creates a new public class StateMachine instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function StateMachine(p_states:GameStatesVO=null)
		{
			//get default states
			if (p_states){
				_statesVO = p_states;
			} else {
				_statesVO = new GameStatesVO();
			}
			//create states in order
			//_states = new Dictionary (true);
			_states = new Vector.<IGameState>();
			var cl:Class;
			for (var i:int=0; i<_statesVO.defaultStates.length; i++){
				cl = _statesVO.defaultStates[i].stateClass;
				//_states[_statesVO.defaultStates[i].stateID] = new cl ();
				_states.push (new cl());
			}
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		/**
		 * Description
		 * @param  value  of type <code>CustomClass</code> 
		 */
		public function setInitialState ():void {
			_currentState = _states[0];
			_currentState.enter();
		}
		
		public function nextState ():void{
			_currentState = _states[_states.indexOf(_currentState)+1];
			_currentState.enter();
		}
		
		//--------------------------------------------------------------------------
		// Protected Methods
		//--------------------------------------------------------------------------	
		//--------------------------------------------------------------------------
		// Private Methods
		//--------------------------------------------------------------------------	
		//--------------------------------------------------------------------------
		// Event Handlers
		//--------------------------------------------------------------------------	
		/**
		 * Handler for CustomEvent.
		 * 
		 * @param event The <code>CustomEvent</code>
		 * 
		 */
		//--------------------------------------------------------------------------
		// Getters/Setters
		//--------------------------------------------------------------------------
		public function get currentState ():IGameState {
			return _currentState;
		}
		
	}
}