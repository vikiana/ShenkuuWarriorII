//Marks the right margin of code *******************************************************************
package com.neopets.projects.np10.data.vo
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.net.registerClassAlias;

	/**
	 * public class ExtraStateVO
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class StateVO
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
		 * In order to test a new state when the app is offine, just make an instance of this and set all its variable as they were coming from the AMFPHP call.
		 */
		public var stateID:String;
		//this is the url to the swf that contains the enter and exit code for the additional state
		public var stateURL:String;
		
		public var stateClass:Class;
		
		public var from:String;
		public var to:String;
		public var errorState:String;
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
		 * Creates a new public class ExtraStateVO instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function StateVO(p_name:String, params:Object)
		{
			stateID = p_name;
			if (params){
				if (params.stateURL){
					stateURL = params.stateURL;
				}
				if (params.stateClass){
					stateClass = params.stateClass;
				}
				if (params.from){
					from = params.from
				}
				if (params.to){
					to = params.to;
				}
				if (params.errorState){
					errorState = params.errorState;
				}
			}
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		/**
		 * Description
		 * @param  value  of type <code>CustomClass</code> 
		 */
		public static function register(remoteClass:String):void
		{	
			registerClassAlias(remoteClass, com.neopets.projects.np10.data.vo.StateVO);		
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
	}
}