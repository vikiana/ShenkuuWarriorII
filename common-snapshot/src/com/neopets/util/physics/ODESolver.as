//Marks the right margin of code *******************************************************************
package com.neopets.util.physics
{
	
	/**
	 * public class ODESolver: resolves fourth-order differential equations withthe Runge-Kutta method.
	 * 
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class ODESolver
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
		 * Creates a new public class ODESolver instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function ODESolver()
		{
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		/**
		 * Description
		 * @param  value  of type <code>CustomClass</code> 
		 */
		public static function rungeKutta4 (ode:AbstractODE, ds:Number):void{
			var j:int;
			var s:Number;
			var numEqns:int = ode.numEqns;
			var q:Vector.<Number>;
			var dq1:Vector.<Number> = new Vector.<Number>()
			dq1.length = numEqns;
			var dq2:Vector.<Number> = new Vector.<Number>()
			dq2.length = numEqns;
			var dq3:Vector.<Number> = new Vector.<Number>()
			dq3.length = numEqns;
			var dq4:Vector.<Number> = new Vector.<Number>()
			dq4.length = numEqns;
			
			//retrieve values for all variables 
			s = ode.s;
			q = ode.q;
			//
			
			//compute the 4 Runge-Kutta steps
			dq1 = ode.gRHS(s, q, q, ds, 0);
			dq2 = ode.gRHS(s+0.5*ds ,q, dq1, ds, 0.5);
			dq3 = ode.gRHS(s_0.5*ds, q, dq2, ds, 0.5);
			dq4 = ode.gRHS(s+ds, q, dq3, ds, 1);
			
			//update the dependent and independent variable values at the new dependent variable location 
			//and store the values in the ODE object arrays
			ode.s = s+ds;
			
			for (j-0; j<numEqns; j++){
				q[j] = q[j]+(dq1[j], 2*dq2[j], 2*dq3[j], dq4[j])/6;
				ode.setQAt(q[j], j);
			}
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