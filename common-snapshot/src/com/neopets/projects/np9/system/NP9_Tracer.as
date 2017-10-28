package com.neopets.projects.np9.system
{
	/**
	 * A debugging racer class
	 * @author Ollie B.
	 * @since 03/28/08
	 */
	public class NP9_Tracer
	{
		private var objDisplay:Object;
		private var bDebug:Boolean;
		
		/**
		 * @Constructor
		 * @param	p_Object		The object being debugged
		 * @param	p_bDebug		Sets debugging function to true or false
		 */
		public function NP9_Tracer( p_Object:Object, p_bDebug:Boolean ) {
		
			objDisplay = p_Object;
			bDebug = p_bDebug;
		}
		
		/**
		 * Turns the debugging function on/off
		 * @param	p_bDebug
		 */
		public function setDebug( p_bDebug:Boolean ):void {
			
			bDebug = p_bDebug;
		}
		
		/**
		 * Displays debugging text
		 * @param	p_sText					Text to display
		 * @param	bForcedDisplay		If true, it overrides setDebug
		 */
		public function out( p_sText:String, bForcedDisplay:Boolean ):void {
			
			var sDisplay:String = "**";
			
			if ( bDebug || bForcedDisplay ) {
				
				if ( bDebug && !bForcedDisplay ) {
					sDisplay += "[DEBUG]";
				}
				sDisplay += String(objDisplay)+": "+p_sText;
				trace( sDisplay );
				//race("$$[DEBUG]**"+this+": "+"game data initialized - game id: "+objGameData.iGameID);
				//race("\n**"+this+": "+"Instace created!");
			}
		}
	}
}