
/* AS3
	Copyright 2008
*/
package com.neopets.util.managers
{
	import com.neopets.projects.np9.system.NP9_Evar;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 *	THis is a way to Store the Score in an Encrypted Value
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author Clive Henrick
	 *	@since  8.13.09
	 */
	 
	public class  ScoreManager extends EventDispatcher
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var mScore:NP9_Evar;
		
		private static const mInstance:ScoreManager = new ScoreManager( SingletonEnforcer);
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function ScoreManager(singletonEnforcer : Class = null):void
		 {
		 		if(singletonEnforcer != SingletonEnforcer)
		 		{
					throw new Error( "Invalid Singleton access.  Use MenuManager.instance." ); 
				}

				setupVars();	
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public static function get instance():ScoreManager
		{ 
			return mInstance;	
		} 
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		  /**
		 * @Note: Change the Score to this Va;ue
		 * @param		pValue		Number 		The Number you want to change the score to
		 */
		 
		 public function changeScoreTo(pValue:Number):void
		 {
			mScore.changeTo(pValue);
		 }
		 
		   /**
		 * @Note: Change by this Amount
		 * @param		pValue		Number 		The Number you want to change the score by
		 */
		 
		 public function changeScore(pValue:Number):void
		 {
			mScore.changeBy(pValue);
		 }
		 
		  /**
		 * @Note: Returns the Value in the Encrypted Variable
		 */
		 
		 public function getValue():Number
		 {
			return mScore.show();
		 }
		 
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		private function setupVars():void
		{
				mScore = new NP9_Evar(0);
		}
	}
	
}

/**
 * @Note: This is to make sure there is only one version of this class at a time
 */
 
internal class SingletonEnforcer{}