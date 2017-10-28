//Marks the right margin of code *******************************************************************
package com.neopets.vendor.splashworks.NeopetsBattlefieldLegends.net.vo
{
	
	import flash.net.getClassByAlias;
	import flash.net.registerClassAlias;
	import flash.utils.getQualifiedClassName;
	
	
	/**
	 * public class PlayerVO. This is the AS class that maps the PlayerVO object sent in with the getUserData call.
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/29/2010</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class PlayerVO 
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
		public var achievements:Object; 

		public var inventory:Object; 

		public var is_valid:Boolean;
		
		public var nc_balance:int;
		
		public var username:String;
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
		 * Creates a new public class PlayerVO instance.
		 * 
		 * <span class="hide"></span>
		 * 
		 */
		public function PlayerVO()
		{
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		/**
		 * Registers this VO as a remote class.
		 * 
		 * @param  remoteClass  String   name of the PHP vo class corresponding to this one.
		 */
		public static function register(remoteClass:String):void
		{	
			registerClassAlias(remoteClass, com.neopets.vendor.splashworks.NeopetsBattlefieldLegends.net.vo.PlayerVO);		
		}
		
		/**
		 * It sets default values. These can be used in testing, if a connection is not available, to test different scenarios.
		 */ 
		public function setUpDefaultValues():void {
			trace ("USING DEFAULT VALUES");
			//setting up default values.
			achievements = new Object();
			inventory = new Object();
			
			
			achievements.maps = new Array();
			
			inventory.maps = new Array();
			inventory.towers = new Array ();
			
			is_valid = true;
			
			nc_balance = 0;
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