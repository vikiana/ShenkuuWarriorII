package com.neopets.games.inhouse.shootergame.utils
{
	import com.neopets.games.inhouse.shootergame.abstract.AbstractODE;
	
	/**
	 *	This the bullet ODE class. Not used in the current version of the game.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 10.0
	 *	
	 * 
	 *	@author Viviana Baldarelli
	 *	@since  03.26.2009
	 */
	public class SimpleBulletODE extends AbstractODE
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		//Gravitational Accelleration is defined positive since the axis system in flash is opposite to the standard one
		public const G:Number = 9.81;
		
		/**
		* 
		* Constructor
		* 
		* @param		ld		LayerDefinition: it is used to create the boss. 
		* @param		sl		SharedListener: if it is not passed by the outer shell, it's created 
		* @param		sl		SharedListener: if it is not passed by the outer shell, it's created 
		*/
		public function SimpleBulletODE(xO:Number=0, yO:Number=0, zO:Number=0, vxO:Number=0, vyO:Number=0, vzO:Number=0, time:Number=0)
		{
			super(6);
			//Load the initial position, velocity andtime values into the s fields and q array from the ODE class
			s = time;
			setQAt(vxO, 0);
			setQAt(xO, 1);
			setQAt(vyO, 2);
			setQAt(yO, 3);
			setQAt(vzO, 4);
			setQAt(zO, 5);
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		public function getVx ():Number {
			return getQAt(0);
		}
		
		public function getVy ():Number {
			return getQAt(2);
		}
		
		public function getVz ():Number {
			return getQAt(4);
		}
		
		public function getX ():Number {
			return getQAt(1);
		}
		
		public function getY ():Number {
			return getQAt(3);
		}
		
		public function getZ ():Number {
			return getQAt(5);
		}
		
		public function getTime ():Number {
			return s;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Note: This method updates the velocity and positon of the bullet according to the gravity-only model
		 * @param		pEvent			String
		 * @param		pObject			Object
		 * @param		pBubbles		Boolean
		 * @param		pCancelable		Boolean
		 */
		 public function updateLocationAndVelocity (dt:Number):void {
		 	//get the current location, velocity and time values from the values stored in the ODE class
		 	var time:Number = s;
		 	var vxO:Number = getQAt(0);
		 	var xO:Number = getQAt(1);
		 	var vyO:Number = getQAt(2);
		 	var yO:Number = getQAt(3);
		 	var vzO:Number = getQAt(4);
		 	var zO:Number = getQAt(5);
		 	
		 	//Update the xyz locations and the z-component of velocity. The x and y velocities don't change.
		 	var X:Number = xO + vxO*dt;
		 	var Z:Number = zO + vzO*dt;
		 	var vy:Number = vyO + G*dt;
		 	var Y:Number = yO + vyO*dt + 0.5*G*dt*dt;
		 	
		 	//Update time 
		 	time +=dt;
		 	
		 	//Load new values into ODE arrays and fields
		 	s = time;
		 	setQAt (X, 1);
		 	setQAt (Y, 3);
		 	setQAt (vy, 2);
		 	setQAt (Z, 5);
		 };
		 
		 //Because SimpleBulletODE doesn't solve any ODE's we don't overwrite the getRightHandSide method.

	}
}