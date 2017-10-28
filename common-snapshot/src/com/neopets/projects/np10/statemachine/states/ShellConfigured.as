//Marks the right margin of code *******************************************************************
package com.neopets.projects.np10.statemachine.states
{
	import com.neopets.projects.np10.data.vo.GameShellConfigVO;
	import com.neopets.projects.np10.data.vo.GameStatesVO;
	import com.neopets.projects.np10.data.vo.PreloaderConfigVO;
	import com.neopets.projects.np10.data.vo.PrizeVO;
	import com.neopets.projects.np10.statemachine.interfaces.IGameState;
	import com.neopets.projects.np10.util.EncryptedVar;
	
	import flash.display.Shape;
	import flash.display.Sprite;

	/**
	 * public class SetupShell implements IGameState
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class ShellConfigured  extends AbstractState implements IGameState
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
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Creates a new public class SetupShell implements IGameState instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 */
		public function ShellConfigured()
		{
			super();
		}
		
		
		override public function enter():void {
			
		}
		
		override public function exit ():void {
			//_GM.changeState(GameStatesVO.);
		}
	
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		/**
		 * Description
		 * @param  value  of type <code>CustomClass</code> 
		 */
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
	}
}