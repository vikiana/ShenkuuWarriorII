package com.neopets.games.inhouse.FreakyFactoryAS3.game
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
			
	public class FreakyFactoryAS3_Core extends Sprite
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		private var mTestMC : MovieClip;		
		private var mRootMC : MovieClip;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */			
		public function FreakyFactoryAS3_Core( ):void
		{
			super( );
			
			trace( this +  " says: FreakyFactoryAS3_Core constructed" );
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		public function setRoot( pRootMC : MovieClip ):void
		{
			mRootMC = pRootMC
		}
		
		internal function init( ):void
		{
			var tTestMCClass : Class = getDefinitionByName( "TestAsset" ) as Class;
			mTestMC = new tTestMCClass( );
			addChild( mTestMC );			
		}
		
		internal function startGame( ):void
		{
			mTestMC.x = 0;
			this.addEventListener(Event.ENTER_FRAME, testEventHandler, false, 0, true );
		}
		
		internal function endGame( ):void
		{
			this.removeEventListener(Event.ENTER_FRAME, testEventHandler );
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		private function testEventHandler( evt : Event ):void
		{
			trace( "testEventHandler in " + this + " called" );
			mTestMC.x++;
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------		
	
	}
}
