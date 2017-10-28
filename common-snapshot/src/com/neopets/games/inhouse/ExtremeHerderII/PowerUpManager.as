package com.neopets.games.inhouse.ExtremeHerderII
{
	//===============================================================================
	// IMPORTS
	//===============================================================================
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.system.ApplicationDomain;
	import flash.utils.Timer;
	
	public class PowerUpManager extends Sprite
	{
		//===============================================================================
		// VARS & CONSTANTS
		//===============================================================================
		// dispatched in timerUp to remove power up from stage
		internal static const REMOVE_POWER_UP        : String = "RemovePowerUp";
		
		// dispatched in activatePowerUp to activate power up display in Scoreboard
		internal static const ACTIVATE_POWER_UP_DISP : String = "ActivatePowerUpDisp";
		
		// dispatched in deactivatePowerUp to deactivate power up display in Scoreboard
		internal static const DEACTIVATE_POWER_UP_DISP : String = "DeactivatePowerUpDisp";
		
		// dispatched in deactivatePowerUp to deactivate effect of power up in ExtremeHerderIIGame
		internal static const DEACTIVATE_POWER_UP_EFFECT : String = "DeactivatePowerUpEffect";
		
		private var mAssetLocation : ApplicationDomain;
		private var mStage         : Stage;
		
		//=======================================
		// getter vars
		//=======================================
		private var gPowerUpOnStage : Boolean;
		private var gPowerUpActive  : Boolean;
		private var gPUOnStageTimer : Timer;
		private var gPUActiveTimer  : Timer;
		
		//===============================================================================
		// GETTERS & SETTERS
		//===============================================================================
		public function set mPowerUpOnStage( pValue : Boolean ):void { gPowerUpOnStage = pValue };
		public function get mPowerUpOnStage( ):Boolean { return gPowerUpOnStage };
		
		public function set mPowerUpActive( pValue : Boolean ):void { gPowerUpActive = pValue };
		public function get mPowerUpActive( ):Boolean { return gPowerUpActive };
		
		public function set mPUOnStageTimer( pValue : Timer ):void { gPUOnStageTimer = pValue };
		public function get mPUOnStageTimer( ):Timer { return gPUOnStageTimer };
		
		public function set mPUActiveTimer( pValue : Timer ):void { gPUActiveTimer = pValue };
		public function get mPUActiveTimer( ):Timer { return gPUActiveTimer };
		
		//===============================================================================
		// CONSTRUCTOR LevelManager
		//===============================================================================
		public function PowerUpManager( )
		{
			trace( this + " created" );
			
			// triggered when Samrin collects power up in ExtremeHerderGameII 
			Dispatcher.addEventListener( ExtremeHerderIIGame.ACTIVATE_POWER_UP, activatePowerUp );
			
			// triggered when Samrin collects power up in ExtremeHerderGameII 
			Dispatcher.addEventListener( ExtremeHerderIIGame.REMOVE_TIMER, removeTimer );
			
			// triggered when Samrin collects power up in ExtremeHerderGameII 
			Dispatcher.addEventListener( ExtremeHerderIIGame.REMOVE_ACTIVE_PU_TIMER, removeActivePUTimer );
			
			// triggered when game is over
			Dispatcher.addEventListener( ExtremeHerderIIGame.CLEAR_EVERYTHING, cleanUp );
			
			setupVars( );
			
		} // end constructor
		
		//===============================================================================
		// FUNCTION setPowerUp
		//===============================================================================
		internal function setPowerUp( ):PowerUp
		{
			//trace( "setPowerUp in " + this + " called" );
						
			mPowerUpOnStage = true;
			
			mPUOnStageTimer = new Timer( 10000, 1 );
			mPUOnStageTimer.start( );
			mPUOnStageTimer.addEventListener( TimerEvent.TIMER_COMPLETE, timerUp, false, 0, true );
			
			var tPowerUp : PowerUp;
			var tRand : int = Math.floor( Math.random( ) * 3 );
		
			switch( tRand )
			{
				case 0:
					/**
					 * speed up power up
					 */
					tPowerUp = new PowerUp( "SpeedUp" );
					tPowerUp.name = "speed_up_pu";
					tPowerUp.mSpeedUp.gotoAndStop( 2 );
					break;
					
				case 1:
					/**
					 * freeze power up
					 */
					tPowerUp = new PowerUp( "Freeze" );
					tPowerUp.name = "freeze_pu";
					tPowerUp.mFreeze.gotoAndStop( 2 );
					break;
					
				case 2:
					/**
					 * two petpets power up
					 */
					tPowerUp = new PowerUp( "TwoPPs" );
					tPowerUp.name = "two_pps_pu";
					tPowerUp.mTwoPPs.gotoAndStop( 2 );
					break;
				
				case 3:
					/**
					 * waypoint power up
					 */
					tPowerUp = new PowerUp( "Waypoint" );
					tPowerUp.name = "waypoint_pu";
					tPowerUp.mWaypoint.gotoAndStop( 2 );
					break;
				
				default:
					break;
			}
			
			return tPowerUp;
			
		} // end setPowerUp
		
		//===============================================================================
		// FUNCTION timerUp
		//===============================================================================
		private function timerUp( evt : TimerEvent ):void
		{
			trace( "timerUp in " + this + " called" );
			
			if( mPUOnStageTimer.hasEventListener( TimerEvent.TIMER_COMPLETE ) )
			{
				mPUOnStageTimer.removeEventListener( TimerEvent.TIMER_COMPLETE, timerUp );
			}
			
			mPUOnStageTimer = null;
			
			/**
			 * ExtremeHerderIIGame listens to REMOVE_POWER_UP event
			 * removes power up from stage if it was not collected by samrin
			 */
			Dispatcher.dispatchEvent( new Event( REMOVE_POWER_UP ) );
			
		} // end timerUp
		
		//===============================================================================
		// FUNCTION removeTimer
		//===============================================================================
		internal function removeTimer( evt : DataEvent ):void
		{
			trace( "removeTimer in " + this + " called" );	
			
			if( mPUOnStageTimer != null )
			{	
				mPUOnStageTimer.stop( );		
				
				if( mPUOnStageTimer.hasEventListener( TimerEvent.TIMER_COMPLETE ) )
				{
					mPUOnStageTimer.removeEventListener( TimerEvent.TIMER_COMPLETE, timerUp );
				}
				
				mPUOnStageTimer = null;
			}
			
		} // end removeTimer
		
		//===============================================================================
		// FUNCTION removeActivePUTimer
		//===============================================================================
		internal function removeActivePUTimer( evt : DataEvent ):void
		{
			trace( "removeTimer in " + this + " called" );
			
			if( mPUActiveTimer != null )
			{	
				mPUActiveTimer.stop( );		
				
				if( mPUActiveTimer.hasEventListener( TimerEvent.TIMER_COMPLETE ) )
				{
					mPUActiveTimer.removeEventListener( TimerEvent.TIMER_COMPLETE, deactivatePowerUp );
				}
				
				mPUActiveTimer = null;
			}
			
		} // end removeActivePUTimer
		
		//===============================================================================
		// FUNCTION activatePowerUp
		//	- Samrin collected power up so event was dispatched 
		//===============================================================================
		internal function activatePowerUp( evt : DataEvent ):void
		{
			trace( "activatePowerUp in " + this + " called" );
			
			var tName : String = evt.mData as String;
			 
			/**
			 * dispatch event so that power up in scoreboard will be activated as well
			 */
			Dispatcher.dispatchEvent( new DataEvent( ACTIVATE_POWER_UP_DISP, tName ) );
			
			/**
			 * start a timer that determines for how long the power up will be active
			 */
			mPUActiveTimer = new Timer( 5000, 1 );
			mPUActiveTimer.start( );
			mPUActiveTimer.addEventListener( TimerEvent.TIMER_COMPLETE, deactivatePowerUp, false, 0, true );
			
		} // end activatePowerUp
		
		//===============================================================================
		// FUNCTION deactivatePowerUp
		//===============================================================================
		private function deactivatePowerUp( evt : TimerEvent ):void
		{
			trace( "deactivatePowerUp in " + this + " called" );
			
			//var tPowerUpActiveTimer : Timer = evt.target as Timer;
			
			if( mPUActiveTimer.hasEventListener( TimerEvent.TIMER_COMPLETE ) )
			{
				mPUActiveTimer.removeEventListener( TimerEvent.TIMER_COMPLETE, deactivatePowerUp );
			}
			
			mPUActiveTimer = null;
			
			/**
			 * dispatch event to deactivate power up in Scoreboard
			 */
			Dispatcher.dispatchEvent( new DataEvent( DEACTIVATE_POWER_UP_DISP ) );
			
			/**
			 * dispatch event to deactivate effect of power up in ExtremeHerderIIGame
			 */
			Dispatcher.dispatchEvent( new DataEvent( DEACTIVATE_POWER_UP_EFFECT ) );
			
		} // end deactivatePowerUp
		
		//===============================================================================
		// FUNCTION cleanUp
		//===============================================================================
		private function cleanUp( evt : DataEvent ):void
		{
			if( Dispatcher.hasEventListener( ExtremeHerderIIGame.ACTIVATE_POWER_UP ) )
			{
				Dispatcher.removeEventListener( ExtremeHerderIIGame.ACTIVATE_POWER_UP, activatePowerUp );
			}
			
			if( Dispatcher.hasEventListener( ExtremeHerderIIGame.REMOVE_TIMER ) )
			{
				Dispatcher.removeEventListener( ExtremeHerderIIGame.REMOVE_TIMER, removeTimer );
			}
			
		} // end cleanUp
		
		//===============================================================================
		// FUNCTION setupVars
		//===============================================================================
		private function setupVars( ):void
		{
			mAssetLocation = GlobalGameReference.mInstance.mGameStartUp.mAssetLocation;
			mStage 		   = GlobalGameReference.mInstance.mGameStartUp.mMainTimeLine.stage;
			
		} // end setupVars
	}
}