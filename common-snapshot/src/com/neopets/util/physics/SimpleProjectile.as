//Marks the right margin of code *******************************************************************
package com.neopets.util.physics
{
	
	/**
	 * public class SimpleProjectile extends AbstractODE
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class SimpleProjectile extends AbstractODE
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
		public static const G:Number = 9.81
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
		 * Creates a new public class SimpleProjectile extends AbstractODE instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function SimpleProjectile(xO:Number=0, yO:Number=0, vxO:Number=0, vyO:Number=0, time:Number=0)
		{	
			super(4);
			//Load the initial position, velocity andtime values into the s fields and q array from the ODE class
			s = time;
			setQAt(vxO, 0);
			setQAt(xO, 1);
			setQAt(vyO, 2);
			setQAt(yO, 3);
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		/**
		 * This method updates the velocity and positon of the bullet according to the gravity-only model
		 * 
		 */
		public function updateLocationAndVelocity (dt:Number):void {
			//get the current location, velocity and time values from the values stored in the ODE class
			var time:Number = s;
			var vxO:Number = getQAt(0);
			var xO:Number = getQAt(1);
			var vyO:Number = getQAt(2);
			var yO:Number = getQAt(3);
			//var vzO:Number = getQAt(4);
			//var zO:Number = getQAt(5);
			
			//Update the xyz locations and the z-component of velocity. The x and y velocities don't change.
			var X:Number = xO + vxO*dt;
			//var Z:Number = zO + vzO*dt;
			var vy:Number = vyO + G*dt;
			var Y:Number = yO + vyO*dt + 0.5*G*dt*dt;
			
			//Update time 
			time +=dt;
			
			//Load new values into ODE arrays and fields
			s = time;
			setQAt (X, 1);
			setQAt (Y, 3);
			setQAt (vy, 2);
			//setQAt (Z, 5);
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
		public function getVx ():Number {
			return getQAt(0);
		}
		
		public function getVy ():Number {
			return getQAt(2);
		}
		
		public function getX ():Number {
			return getQAt(1);
		}
		
		public function getY ():Number {
			return getQAt(3);
		}
		
		public function getTime ():Number {
			return s;
		}
	}
}