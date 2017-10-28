package com.neopets.games.inhouse.ExtremeHerderII
{	
	//===============================================================================
	// IMPORTS
	//===============================================================================
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	dynamic public class KeyObject extends Proxy 
	{	
		//===============================================================================
		// VARS & CONSTANTS
		//===============================================================================	
		private static var mStage    : Stage;
		private static var mKeysDown : Object;
		
		//===============================================================================
		// CONSTRUCTOR KeyObject
		//===============================================================================
		public function KeyObject( pStage : Stage ) 
		{
			construct( pStage );
		}
		
		public function construct( pStage : Stage ):void 
		{
			KeyObject.mStage = pStage;
			mKeysDown = new Object();
			mStage.addEventListener( KeyboardEvent.KEY_DOWN, keyPressed );
			mStage.addEventListener( KeyboardEvent.KEY_UP, keyReleased );
		}
		
		flash_proxy override function getProperty( name : * ):* 
		{
			return ( name in Keyboard ) ? Keyboard[ name ] : -1;
		}
		
		public function isDown( keyCode : uint ):Boolean 
		{
			return Boolean( keyCode in mKeysDown );
		}
		
		public function deconstruct( ):void 
		{
			mStage.removeEventListener( KeyboardEvent.KEY_DOWN, keyPressed );
			mStage.removeEventListener( KeyboardEvent.KEY_UP, keyReleased );
			mKeysDown = new Object();
			KeyObject.mStage = null;
		}
		
		private function keyPressed( evt : KeyboardEvent ):void 
		{
			mKeysDown[ evt.keyCode ] = true;
		}
		
		private function keyReleased( evt : KeyboardEvent ):void 
		{
			delete mKeysDown[ evt.keyCode ];
		}
	}
}