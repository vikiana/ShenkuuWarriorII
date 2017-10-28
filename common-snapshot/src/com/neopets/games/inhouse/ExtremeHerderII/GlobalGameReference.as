package com.neopets.games.inhouse.ExtremeHerderII
{	
	//===============================================================================
	// IMPORTS
	//===============================================================================
		
	public class GlobalGameReference
	{
		//===============================================================================
		// VARS & CONSTANTS
		//===============================================================================
		private static var mReturnedInstance : GlobalGameReference;
		internal var mGameStartUp : GameStartUp;		
		
		//===============================================================================
		// CONSTRUCTOR GameStartUpReference
		//	- make sure this can't be called so give it a required parameter of a private
		//		class
		//===============================================================================
		public function GlobalGameReference( pPrivCl : PrivateClass ) { };
		
		//===============================================================================
		// FUNCTION getInstance
		//	- this is the function through which this class is actually instantiated
		//		it checks if an instance of the class already exists. if it does, it
		//		returns the existing instance, if it doesn't it creates a new instance
		//===============================================================================
		internal static function get mInstance( ):GlobalGameReference
		{
			if( GlobalGameReference.mReturnedInstance == null ) 
			{
				GlobalGameReference.mReturnedInstance = new GlobalGameReference( new PrivateClass( ) );
				//trace( "GlobalGameReference instantiated" );
			}
			else
			{
				//trace( "Sorry, an instance of GlobalGameReference already exists" );
			}
			return GlobalGameReference.mReturnedInstance;
		}
		
		//===============================================================================
		// FUNCTION init
		//===============================================================================
		internal function init( pGameStartUp : GameStartUp ):void
		{
			//trace( "init in GlobalGameReference called" );
			mGameStartUp = pGameStartUp;
		}

	} // end class
	
} // end package

//===============================================================================
// CLASS PrivateClass
//	- a private class is required in AS3 so that it can be passed to the
//		constructor of the Singleton class
//===============================================================================
class PrivateClass
{
	public function PrivateClass( )
	{
		//trace( "PrivateClass in GlobalGameReference instantiated" );
	}

} // end class