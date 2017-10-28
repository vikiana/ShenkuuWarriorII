

/* AS3
	Copyright 2009
*/
package  com.neopets.games.inhouse.G1156.gameEngine
{
	import caurina.transitions.*;
	
	import com.neopets.games.inhouse.G1156.dataObjects.MovementObjData;
	import com.neopets.games.inhouse.G1156.displayObjects.AbsInteractiveDisplayObject;
	import com.neopets.games.inhouse.G1156.displayObjects.JumperObj;
	import com.neopets.games.inhouse.G1156.displayObjects.MapFloor;
	import com.neopets.games.inhouse.G1156.displayObjects.MapSection;
	import com.neopets.games.inhouse.G1156.displayObjects.MovingObstacle;
	import com.neopets.games.inhouse.G1156.displayObjects.Obstacle;
	import com.neopets.games.inhouse.G1156.displayObjects.PowerUp;
	import com.neopets.games.inhouse.G1156.events.GameEvents;
	import com.neopets.games.inhouse.G1156.reference.SoundID_G1156;
	import com.neopets.util.display.scrolling.ScrollDownQueue;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.events.MultitonEventDispatcher;
	import com.neopets.util.input.KeyManager;
	import com.neopets.util.sound.SoundManager;
	
	import fl.motion.CustomEase;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	/**
	 *	This is for Controlling Movement of Objects and Stage and there Interaction
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern G1156
	 * 
	 *	@author Clive Henrick
	 *	@since  10.12.2009
	 */
	 
	public class DefaultGameMovement extends EventDispatcher 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected  var mSharedEventDispatcher:MultitonEventDispatcher;
		protected var mGCDisplay:GameApplication;
		protected var mJumper:JumperObj;
		protected var mJumperFreeMovementSpeed:int;
		protected var mMapScrollResetTimer:Timer
		protected var mMapScrollChangeLock:Boolean;
		public  var mJumperFreeFallLock:Boolean;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function DefaultGameMovement():void{
			super();
			setupVars();
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Note: This is for the Starting of the Class
		 */
		 
		 public function init(pGameCoreDisplay:GameApplication):void
		 {
		 	mGCDisplay = pGameCoreDisplay;
		 	
		 	var tKeyManager:KeyManager = mGCDisplay.keyManager;
			tKeyManager.getCommand("LeftArrow").addEventListener(KeyboardEvent.KEY_DOWN,onMoveJumper,false,0,true);
		 	tKeyManager.getCommand("RightArrow").addEventListener(KeyboardEvent.KEY_DOWN,onMoveJumper,false,0,true);
		 	tKeyManager.getCommand("UpArrow").addEventListener(KeyboardEvent.KEY_DOWN,onMoveJumper,false,0,true);
		 	tKeyManager.getCommand("DownArrow").addEventListener(KeyboardEvent.KEY_DOWN,onMoveJumper,false,0,true);
		 	tKeyManager.getCommand("UpArrow").addEventListener(KeyboardEvent.KEY_UP,onResetJumper,false,0,true);
		 	tKeyManager.getCommand("DownArrow").addEventListener(KeyboardEvent.KEY_UP,onResetJumper,false,0,true);
		 	
		 	mJumper = mGCDisplay.jumper;
		 	mGCDisplay.scrollingManager.addEventListener(ScrollDownQueue.EVENT_COMPLETED_SCROLLING, onMapStoppedScrolling, false, 0, true);
			
		 }
		 

		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		/**
		 * @Note When a Key is Up
		 */
		 
		 protected function onResetJumper(evt:KeyboardEvent):void
		 {
		 
		 	
		 	if (evt.keyCode == Keyboard.DOWN || evt.keyCode == Keyboard.UP)
		 	{
		 		var tMovementData:MovementObjData = mGCDisplay.movementData;
		 			
 		 		mJumper.turnOnResetToCenter();		
 		 		
 		 		var tFallSpeed:int; 
 		 		
 		 		if (tMovementData.mActiveFallSpeed == undefined || !tMovementData.hasOwnProperty("mActiveFallSpeed"))
 		 		{
 		 			tFallSpeed = 110;	
 		 		}
 		 		else
 		 		{
 		 			tFallSpeed =tMovementData.mActiveFallSpeed;	
 		 		}
 		 		
 		 		mGCDisplay.scrollingManager.startScrolling(0,tFallSpeed);
 		 		mMapScrollChangeLock = false;
		 	}
		 	
		 }
		 
		/**
		 * @Note When a Key is Pressed
		 */
		 
		protected function onMoveJumper(evt:KeyboardEvent):void
		{

			var tMovementData:MovementObjData = mGCDisplay.movementData;
		//	trace("DefaultGameMovement: parachuteReleased / parachuteActionLock  >", mJumper.parachuteReleased, " / ", mJumper.parachuteActionLock);
			
			if (mJumper.parachuteReleased)
			{
				if ( !mJumper.parachuteActionLock)
				{
						
					switch (evt.keyCode)
					{
						case Keyboard.LEFT:
							mJumper.setDirection(Keyboard.LEFT);
							mJumper.freeFallAction(mJumper.ACTION_RIGHT);		
						break;
						case Keyboard.RIGHT:
							mJumper.setDirection(Keyboard.RIGHT);
							mJumper.freeFallAction(mJumper.ACTION_LEFT);		
						break;
						case Keyboard.DOWN:
							mJumper.setDirection(Keyboard.DOWN);
							mJumper.freeFallAction(mJumper.ACTION_DOWN);
							
							if ( !mMapScrollChangeLock)
							{
								mMapScrollChangeLock = true;
								mGCDisplay.scrollingManager.startScrolling(0,tMovementData.mActiveUpSpeed);
								mMapScrollResetTimer.start();
							}
						
					
						break;
						case Keyboard.UP:
							mJumper.setDirection(Keyboard.UP);
							mJumper.freeFallAction(mJumper.ACTION_UP);
							if ( !mMapScrollChangeLock)
							{
								mMapScrollChangeLock = true;
								mGCDisplay.scrollingManager.startScrolling(0,tMovementData.mActiveDownSpeed);
								mMapScrollResetTimer.start();
							}

						break;
					}
					
								
				}
				
			}
			
		}
		
		
		
		/**
		 * @Note: Detects when a Collision Happens on a Stage
		 * @param		evt.oData.collisionArray			Array			The Collision Array
		 * @param		evt.oData.id							String		The ID of the Wall with the Collision
		 * @param		evt.oData.type						String		Type of Object that is causing the Collision
		 */
		

		protected function onDisplayobjCollisionEvent (evt:CustomEvent):void
		{
			
			
			var dx:Number;
			var dy:Number;
			var tNewX:Number;
			var tNewY:Number;
			var collisions:Array;
			var collision:Object;
			var tSoundManager:SoundManager = SoundManager.instance;

			
			switch (evt.oData.type)
			{
				case MapSection.COLLISION_TYPE:
						var tMapSection:MapSection = evt.oData.object;
						//trace("onDisplayobjCollisionEvent Type:",tMapSection.id);
						
						if ( !tMapSection.lockdown)
						{
							tSoundManager.soundPlay(SoundID_G1156.SND_WALL_IMPACT);
							mGCDisplay.rockEffects.makeExplosion(mJumper.x, mJumper.y);
							tMapSection.lockdown = true;
							mJumper.freeFallAction(mJumper.ACTION_HURT);
							mSharedEventDispatcher.dispatchEvent(new CustomEvent({changeAmount:5},GameEvents.HEALTH_CHANGE));	
					
						}
						
						collisions =  evt.oData.collisionArray;
						if(collisions.length)
						{
							collision = collisions[0];
							dx = Math.cos(collision.angle) * mJumper.width;
							dy = Math.sin(collision.angle) * (mJumper.width);
							tNewX = Math.floor(mJumper.x - dx);
							tNewY= Math.floor(mJumper.y - dy);
							
							// Stop the Jumper from moving out of the Stage Area with the Tween and stop the preset movement of the Jumper
							mJumper.clearAllVelocity();
							mJumper.autoMovementLock = true;
							
							if (tNewY > GameApplication.STAGE_BOTTOM_RESTRICTION || tNewY < GameApplication.STAGE_TOP_RESTRICTION)
							{
								tNewY = mJumper.y;
							}
							
							Tweener.addTween(
				           		mJumper, 
				           		{
				           			x:tNewX, 
				           			y:tNewY,
				           			time:.75, 
				           			onComplete:turnOnEffect,
				           			onCompleteParams:[tMapSection]
				           		}
				           	);  			
						}
						
				break;
				case Obstacle.COLLISION_TYPE:
					var tObstacle:Obstacle = evt.oData.object;
					if ( !tObstacle.lockdown)
					{
					//	trace("onDisplayobjCollisionEvent Type:",tObstacle.id);
						tSoundManager.soundPlay(SoundID_G1156.SND_WALL_IMPACT);
						mGCDisplay.gameEffects.startFireWorksEffect(mJumper.x, mJumper.y,1);	
						tObstacle.lockdown = true;
						mJumper.freeFallAction(mJumper.ACTION_HURT);
						mSharedEventDispatcher.dispatchEvent(new CustomEvent({changeAmount:5},GameEvents.HEALTH_CHANGE));	
					
					
						collisions  =  evt.oData.collisionArray;
						if(collisions.length)
						{
							collision = collisions[0];
							dx = Math.cos(collision.angle) * tObstacle.width;
							dy = Math.sin(collision.angle) * (tObstacle.width);
							
							tNewX= mJumper.x - dx;
							tNewY= mJumper.y - dy;
							
							// Stop the Jumper from moving out of the Stage Area with the Tween and stop the preset movement of the Jumper
							mJumper.clearAllVelocity();
							mJumper.autoMovementLock = true;
							
							if (tNewY > GameApplication.STAGE_BOTTOM_RESTRICTION || tNewY < GameApplication.STAGE_TOP_RESTRICTION)
							{
								tNewY = mJumper.y;
							}
							
							Tweener.addTween(
				           		mJumper, 
				           		{
				           			x:tNewX, 
				           			y:tNewY,
				           			time:.5, 
				           			transition:"easeInOutQuad",
				           			onComplete:turnOnEffect,
				           			onCompleteParams:[tObstacle]
				           		}
				           	); 
			           	} 			
					}
				
				break;
				case MovingObstacle.COLLISION_TYPE:
					var tMovingObstacle:MovingObstacle = evt.oData.object;
					
					if ( !tMovingObstacle.lockdown)
					{
						//	trace("onDisplayobjCollisionEvent Type:",tMovingObstacle.id);
						
							tSoundManager.soundPlay(SoundID_G1156.SND_MOVING_OBJ);
							mGCDisplay.gameEffects.startFireWorksEffect(mJumper.x, mJumper.y,1);	
							tMovingObstacle.lockdown = true;
							mJumper.freeFallAction(mJumper.ACTION_HURT);
							mSharedEventDispatcher.dispatchEvent(new CustomEvent({changeAmount:10},GameEvents.HEALTH_CHANGE));	
					
							collisions  =  evt.oData.collisionArray;
							if(collisions.length)
							{
								collision = collisions[0];
							}
							
							
							mSharedEventDispatcher.dispatchEvent(new CustomEvent({id:tMovingObstacle.id},GameEvents.SEND_DEACTIVATE_EVENT));	
					}
				break;
				case PowerUp.COLLISION_TYPE:
					var tPowerUp:PowerUp = evt.oData.object;
			
					if ( !tPowerUp.lockdown)
					{
					//	trace("onDisplayobjCollisionEvent Type:",tPowerUp.mBaseClass);
						
						tPowerUp.lockdown = true;
						mSharedEventDispatcher.dispatchEvent(new CustomEvent({id:tPowerUp.id},GameEvents.SEND_DEACTIVATE_EVENT));	
						
						switch (tPowerUp.powerUpType)
						{
							case PowerUp.POWERUP_TYPE_3:
								tSoundManager.soundPlay(SoundID_G1156.SND_POWERUP1);
								mGCDisplay.gameEffects.startSmokeEffect(mJumper.x, mJumper.y,2);	
								mSharedEventDispatcher.dispatchEvent(new CustomEvent({changeAmount:15},GameEvents.TIME_CHANGE));	
							break;
							case PowerUp.POWERUP_TYPE_1:
								tSoundManager.soundPlay(SoundID_G1156.SND_POWERUP2);
								mGCDisplay.gameEffects.startSmokeEffect(mJumper.x, mJumper.y,4);	
								mSharedEventDispatcher.dispatchEvent(new CustomEvent({changeAmount:-20},GameEvents.HEALTH_CHANGE));	
							break;
							case PowerUp.POWERUP_TYPE_2:
								tSoundManager.soundPlay(SoundID_G1156.SND_POWERUP3);
								mGCDisplay.gameEffects.startSmokeEffect(mJumper.x, mJumper.y,3);	
								mSharedEventDispatcher.dispatchEvent(new CustomEvent({changeAmount:125},GameEvents.SCORE_CHANGE));	
							break;
							case PowerUp.POWERUP_TYPE_RUBY_L:
								tSoundManager.soundPlay(SoundID_G1156.SND_POWERUPGEM);
								mGCDisplay.gameEffects.startSmokeEffect(mJumper.x, mJumper.y,3);	
								mSharedEventDispatcher.dispatchEvent(new CustomEvent({changeAmount:50},GameEvents.SCORE_CHANGE));	
							break;
							case PowerUp.POWERUP_TYPE_RUBY_S:
								tSoundManager.soundPlay(SoundID_G1156.SND_POWERUPGEM);
								mGCDisplay.gameEffects.startSmokeEffect(mJumper.x, mJumper.y,3);	
								mSharedEventDispatcher.dispatchEvent(new CustomEvent({changeAmount:25},GameEvents.SCORE_CHANGE));	
							break;
							case PowerUp.POWERUP_TYPE_EMERALD_L:
								tSoundManager.soundPlay(SoundID_G1156.SND_POWERUPGEM);
								mGCDisplay.gameEffects.startSmokeEffect(mJumper.x, mJumper.y,3);	
								mSharedEventDispatcher.dispatchEvent(new CustomEvent({changeAmount:75},GameEvents.SCORE_CHANGE));	
							break;
							case PowerUp.POWERUP_TYPE_EMERALD_S:
								tSoundManager.soundPlay(SoundID_G1156.SND_POWERUPGEM);
								mGCDisplay.gameEffects.startSmokeEffect(mJumper.x, mJumper.y,3);	
								mSharedEventDispatcher.dispatchEvent(new CustomEvent({changeAmount:50},GameEvents.SCORE_CHANGE));	
							break;
							case PowerUp.POWERUP_TYPE_DIAMOND_L:
								tSoundManager.soundPlay(SoundID_G1156.SND_POWERUPGEM);
								mGCDisplay.gameEffects.startSmokeEffect(mJumper.x, mJumper.y,3);	
								mSharedEventDispatcher.dispatchEvent(new CustomEvent({changeAmount:100},GameEvents.SCORE_CHANGE));	
							break;
							case PowerUp.POWERUP_TYPE_DIAMOND_S:
								tSoundManager.soundPlay(SoundID_G1156.SND_POWERUPGEM);
								mGCDisplay.gameEffects.startSmokeEffect(mJumper.x, mJumper.y,3);	
								mSharedEventDispatcher.dispatchEvent(new CustomEvent({changeAmount:50},GameEvents.SCORE_CHANGE));	
							break;
						}

					}
					
					
				break;
				case MapFloor.COLLISION_TYPE:
					var tMapFloor:MapFloor = evt.oData.object;
					mJumperFreeFallLock = true;
					
					//Lose Jumper Vec
					mJumper.clearAllVelocity();
					mJumper.autoMovementLock = true;
					mJumper.parachuteActionLock = true;
					
					if ( !tMapFloor.lockdown)
					{
						tMapFloor.lockdown = true;
						//trace("onDisplayobjCollisionEvent Type:",tMapFloor.id);
						
		
						tSoundManager.soundPlay(SoundID_G1156.SND_LANDING);
						mGCDisplay.gameEffects.startFireWorksEffect(mJumper.x, mJumper.y,2);	
						mGCDisplay.scrollingManager.stopScrolling();
						mSharedEventDispatcher.dispatchEvent(new CustomEvent({id:tMapFloor.id},GameEvents.SEND_DEACTIVATE_EVENT));	
						mSharedEventDispatcher.dispatchEvent(new Event(GameApplication.EVENT_PLAYER_LANDED));
						
						mJumper.freeFallAction(mJumper.ACTION_LAND);	
						
						//Stop Player Movement for the last Free Fall Section
						mJumper.parachuteActionLock = true;
				
						
						if (this.hasEventListener(Event.ENTER_FRAME))
				 		{
				 			this.removeEventListener(Event.ENTER_FRAME,onJumperSelfMove);	
				 		}
				 		else
				 		{
				 			mSharedEventDispatcher.removeEventListener(GameEvents.GAME_TIMER_EVENT, onJumperSelfMove);	
				 		}
					}
					
					
				break;
			}
	
		}
		
		/**
		 * @Note: When the Last Map is Displayed and Map stopped scrolling
		 */
		 protected function onMapStoppedScrolling (evt:Event):void
		 {
		 	
		 	//trace("####################### MapStopScrolling ###########################");
		 	if ( !mJumperFreeFallLock)
		 	{
		 			if (mJumper.parachuteReleased)
				 	{
				 		mJumperFreeMovementSpeed = Math.floor(mGCDisplay.movementData.mActiveFallSpeed / 20);
				 	}
				 	else
				 	{
				 		mJumperFreeMovementSpeed =  Math.floor(mGCDisplay.movementData.mFallSpeed /20);	
				 	}
				 	
				 	if (GameCore.USE_TIMER)
			 		{
			 			mSharedEventDispatcher.addEventListener(GameEvents.GAME_TIMER_EVENT, onJumperSelfMove, false, 0, true);
			 		}
			 		else
			 		{
			 			this.addEventListener(Event.ENTER_FRAME,onJumperSelfMove, false, 0, true);	
			 		}
			 		
			 		mJumper.turnOffResetToCenter();
			 		
			 		//Stop Player Movement for the last Free Fall Section
			 		mJumper.parachuteActionLock = true;			
				 }
		 
		 }
		 
		 protected function onJumperSelfMove(evt:Event):void
		 {
		 	mJumper.y += 	mJumperFreeMovementSpeed;	
		 }
		 
		  /**
		 * @Note Turns on the Effect after the key Lock is Off
		 */
		 
		 protected function resetMapScrollSpeed (evt:TimerEvent):void
		 {
		 	//mJumper.parachuteActionLock = false;	
		 	//mGCDisplay.scrollingManager.startScrolling(0,mGCDisplay.movementData.mActiveFallSpeed);
		 	//mMapScrollChangeLock = false;
		 }
		
				/**
		 * @Note: This is for Reseting the MovementClass
		 */
		 
		 protected function onResetNextLevel(evt:CustomEvent):void
		{
			mMapScrollChangeLock = false;
			mJumperFreeFallLock = false;	
		}
		
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		private function setupVars():void
		{
			mSharedEventDispatcher = MultitonEventDispatcher.getInstance(GameCore.KEY);
			mSharedEventDispatcher.addEventListener( AbsInteractiveDisplayObject.EVENT_DISPLAYOBJ_COLLISION, onDisplayobjCollisionEvent,false,0,true);
			mSharedEventDispatcher.addEventListener(GameEvents.LEVEL_RESET, onResetNextLevel, false,0,true);
			
			mMapScrollResetTimer = new Timer(1500,1);
			mMapScrollResetTimer.addEventListener( TimerEvent.TIMER_COMPLETE, resetMapScrollSpeed, false, 0, true);
			mMapScrollChangeLock = false;
			mJumperFreeFallLock = false;
		}
		
		/**
		 * @Note Turns on the Effect after the Tween is complete
		 * @param  		pArray			Array				The Array of Params
		 */
		 
		 protected function turnOnEffect (pDisplayObject:AbsInteractiveDisplayObject):void
		 {
		 	pDisplayObject.lockdown = false;	
		 	mJumper.autoMovementLock = false;
		 }
		 
		
		 
	}
	
}
