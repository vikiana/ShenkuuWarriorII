package  com.neopets.util.physics
{
	/**
	 *	This the ODE Class. It solves all sorts of differential equations. Subclass this to write specific movement classes.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	
	 * 
	 *	@author Viviana Baldarelli
	 *	@since  12.26.2006
	 */
	public class AbstractODE {
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		//declare fields used by the class
		// number of equations to solve
		private var _numEqns:uint;
		// Array of dependent variables: using Vector for better performance
		private var _q:Vector.<Number>;
		//independent variable
		private var _s:Number;
		//right hand side solved values
		private var _allVars:Array;
		
		/**
		* 
		* Constructor
		* 
		* @param  numEqns  Number of the equations to solve.
		*/
		public function AbstractODE(numEqns:uint):void {
			_numEqns = numEqns; 
			_q = new Vector.<Number> ();
			_q.length = _numEqns;
			_allVars = [];
		}

		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------

		public function get numEqns ():uint {
			return _numEqns;
			//trace("rungrKutta4 - _numEqns: "+_numEqns);
		}
		
		public function get s():Number {
			return _s;
		}
		
		public function getQAt(index:uint):Number {
			return _q[index];
		}

		public function get q():Vector.<Number> {
			return _q;
		}
		
		public function set s(value:Number):void {
			_s = value;
		}
		
		public function setQAt(value:Number, index:Number):void {
			_q[index] = value;
		}
		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Note: This last method solves the right side of the equations.
		 * @param		s			Number     Independent variable
		 * @param		q			Vector.<Number>   Array of values
		 * @param		deltaQ		Array
		 * @param		ds      	Number
		 * @param		qScale      Number
		 */
		public function gRHS(s:Number, q:Vector.<Number>, deltaQ:Array, ds:Number, qScale:Number):Array {
			return _allVars[s, q, deltaQ, ds, qScale];
		}
	}

}