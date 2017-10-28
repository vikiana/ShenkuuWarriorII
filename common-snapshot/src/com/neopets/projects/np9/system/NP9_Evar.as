// ---------------------------------------------------------------------------------------
// Evar Class
// ---------------------------------------------------------------------------------------
package com.neopets.projects.np9.system
{
	// -----------------------------------------------------------------------------------
	/**
	 * <p>Used for encrypting string and numerical values for use in games.</p>
	 * <p>Each evar saves one and only one value</p>
	 * 
	 * @author Ollie B.
	 * @since 03/28/08
	 */
	public class NP9_Evar {

		/**
		 * Values are broken up and held in an array.
		 */
		private var aEvar:Array;
		
		/**
		 * @Constructor
		 * Creates and initializes the evar value
		 * @param	xVar		Value to be saved
		 */
		public function NP9_Evar( xVar:* )
		{
			aEvar = [];
			create(xVar);
			//race("\n**"+this+": "+"Evar created! Value: "+String(xVar));
		}
		
		/**
		 * <p>Create the new evar and store it in array</p>
		 * <p>Strings are broken up and stored in an array in their character code form</p>
		 * <p>Numbers are multiplied by a randomly generated number, and stored in the form [<encryptor value>][<encrypted value>]</p>
		 * @param	xVar	Value to be saved
		 */
		private function create(xVar:*):void
		{
			aEvar = [];
			var _local5:Array = [];
			var _local6:String = typeof (xVar);
			if (_local6.toLowerCase() == "string") {
				_local5.push(0);
				var _local4:Array = [];
				var _local2:int = 0;
				while (_local2 < xVar.length) {
					_local4.push(xVar.charCodeAt(_local2));
					_local2++;
				}
				_local5.push(_local4);
			} else if (_local6.toLowerCase() == "number") {
				_local5.push(11 + int(Math.random()*100));
				_local5.push(xVar * _local5[0]);
			}
			aEvar.push(_local5);
		}
		
		/**
		 * Changes the value of this evar to a new value
		 * @param	xVar	Value to be saved
		 */
		public function changeTo(xVar:*):void
		{
			create(xVar);
		}
		
		/**
		 * Changes the current saved value by this value
		 * @param	xValue	Value to change by
		 */
		public function changeBy(xValue:*):void
		{
			if (aEvar[0][0] > 0) {
				aEvar[0][1] = aEvar[0][1] + (aEvar[0][0] * xValue);
			} else {
				var _local2:int = 0;
				while (_local2 < xValue.length) {
					aEvar[0][1].push(xValue.charCodeAt(_local2));
					_local2++;
				}
			 }
		}
		
		/**
		 * Outputs the saved value
		 * @return	Value saved in this evar
		 */
		public function show():*
		{
			if (aEvar[0][0] > 0) {
				return (aEvar[0][1] / aEvar[0][0]);
			} else {
				var _local3:String = "";
				var _local2:int = 0;
				while (_local2 < aEvar[0][1].length) {
					_local3 = _local3 + String.fromCharCode(aEvar[0][1][_local2]);
					_local2++;
				}
				return (_local3);
			 }
		}		
	}
}
