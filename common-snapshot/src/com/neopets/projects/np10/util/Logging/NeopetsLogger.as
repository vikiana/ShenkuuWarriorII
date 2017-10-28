//Marks the right margin of code *******************************************************************
package com.neopets.projects.np10.util.Logging
{

	
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import org.osmf.logging.Logger;

	/**
	 * public class DebugLogger extends Logger
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class NeopetsLogger extends Logger
	{
		//--------------------------------------------------------------------------
		// Costants
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		public static const DEBUG:String = "debug level";
		public static const INFO:String = "info level";
		public static const DISABLED:String = "disabled";
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
		 * Creates a new public class DebugLogger extends Logger instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function NeopetsLogger(category:String="disabled")
		{
			super(category);
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		/**
		 * This is called when the trace statement is used for debugging.
		 * 
		 * @param  message  of type <code>String</code> 
		 * @param ...rest Additional parameters that can be subsituted in the  
	 	 * message parameter at each "{x}" location, where x is an zero-based
	 	 * integer index into the Array of values specified.
		 * 
		 */
		override public function debug (message:String, ...rest):void {
			var loc:String = "";
			if (rest[0]){
				loc = rest[0].toString();
			} 
			if (category == DEBUG){
				trace ("DEBUG", loc, message)
			}
		}
		
		
		/**
		 * This is used when there is the need to trace an information that doesn't need to be hidden from end user.
		 * 
		 * @param  message  of type <code>String</code> 
		 * @param ...rest Additional parameters that can be subsituted in the  
		 * message parameter at each "{x}" location, where x is an zero-based
		 * integer index into the Array of values specified.
		 * 
		 */
		override public function info (message:String, ...rest):void {
			var loc:String = "";
			if (rest[0]){
				loc = rest[0].toString();
			} 
			trace ("INFO", loc, message)
		}
		
		override public function warn (message:String, ...rest):void {
			trace (this, "- this method is not yet implemented. Please use 'debug' or 'info'");
		}
		override public function fatal (message:String, ...rest):void {
			trace (this, "- this method is not yet implemented. Please use 'debug' or 'info'");
		}
		override public function error (message:String, ...rest):void {
			trace (this, "- this method is not yet implemented. Please use 'debug' or 'info'");
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