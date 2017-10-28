//Marks the right margin of code *******************************************************************
package com.neopets.users.vivianab
{
	
	/**
	 * public class Math
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class MathUtilities
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
		 * Creates a new public class Math instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function MathUtilities()
		{
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		/**
		 * Finds the highest number in an array
		 * @param  array   Make sure it's an array of numbers or ints
		 */
		public static function maxValue (array:Array ):Number {
			var mxm:Number = array[0];
			for (var i:int=0; i<array.length; i++) {
				if (array[i]>mxm) {
					mxm = array[i];
				}
			}
			return mxm;
		};
		
		/**
		 * Finds the lowest number in an array
		 * @param  array   Make sure it's an array of numbers or ints
		 */
		public static function minValue (array:Array ):Number {
			var min:Number = array[0];
			for (var i:int=0; i<array.length; i++) {
				if (array[i]<min) {
					min = array[i];
				}
			}
			return min;
		};
		

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