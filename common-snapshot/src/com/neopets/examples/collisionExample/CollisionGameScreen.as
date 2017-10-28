
/* AS3
	Copyright 2008
*/
package com.neopets.examples.collisionExample
{
	import com.neopets.projects.gameEngine.gui.Interface.GameScreen;
	
	import com.neopets.util.collision.CollisionManager;
	
	/**
	 *	This class simply extends the normal game screen to add a drawing canvas to show the geometry
	 *  used by the collision system.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@NP9 Game System
	 * 
	 *	@author David Cary
	 *	@since  10.21.2009
	 */
	 
	public class CollisionGameScreen extends GameScreen
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		// This constant lets all collidables know what we've named out main collision space.
		// If you don't want to name your name collision space this constant is not needed.
		// Instead you can simply replace these name references with null.
		public static const MAIN_SPACE:String = "main_space";
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------		
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function CollisionGameScreen():void
		{
			super();
			
			// You only need these lines if you want to see the geometry bounds used by the collision
			// detection system.  The system itself works fine without them.
			CollisionManager.addSpace(MAIN_SPACE); // make sure the space exists by trying to add it now
			CollisionManager.addCanvas(MAIN_SPACE,this); // let the space attach a drawing layer to this screen
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		 
		 
	}
	
}
