/* AS3
	Copyright 2009 Neopets
*/

package com.neopets.util.trace
{
	import flash.trace.Trace;
	
	
	/**
	 *	This needs to contain information about the Class and what it is used for
	 *	Please use ASDocs if you can for your notes
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author Clive Henrick
	 *	@since  3.04.2009
	 */
	 
	public class TraceOut
	{
		
		//--------------------------------------
		// PUBLIC VARIABLES
		//--------------------------------------
		
		public static var traceFlag:Boolean = true;
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		 
		public function TraceOut(){ }
		
		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Note: This is an example
		 * @param		pText					String 		The Trace Message
		 * @param		pForcedDisplay		Boolean 	To Force a Message
		 */
		
		public static function out( pText:String, pForcedDisplay:Boolean = false ):void {
			
			var sDisplay:String = "**";
			
			if ( traceFlag || pForcedDisplay ) 
			{
				trace( pText );
			}
		}
		
	}
	
}
