/**
 *	Contains most of the game properties
 *	@NOTE there are other properties that are specific to an object so be sure to check other classes if you can't find them here  
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  aug.2009
 */




package com.neopets.games.inhouse.shenkuuSideScroller.dataObj
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.utils.Timer;
	import flash.display.Sprite;
	import flash.geom.Point
	import flash.filters.GlowFilter;
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.games.inhouse.shenkuuSideScroller.characters.*
	import com.coreyoneil.collision.CollisionList;
	
	
	
	
	public class GameData
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------

		public static const SPEED_NORMAL:int = 25;
		public static const SPEED_FAST:int = 8;
		public static const SPEED_SLOW:int = 50;
		public static const PRE_LEVEL:String = "buffer_before_level_starts";
		public static const ON_LEVEL:String = "level_is_playing";
		public static const END_LEVEL:String = "buffer_for_level_end_animation";
		public static const PRE_LEVEL_DURATION:int = 60;
		public static const END_LEVEL_DURATION:int = 90;
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		
		//singleton
		private static var mReturnedInstance:GameData;
	
		//Main components
		private var mRootMC:Object;	//root of the entire game
		private var mStageHeight:Number;
		private var mStageWidth:Number;
		
		
		//Game phase
		private var mGameLevel:int = 1; //current level
		private var mCurrPhase:String = GameData.PRE_LEVEL	//current phase of level
		private var mPhaseCount:int = GameData.PRE_LEVEL_DURATION; //buffer before the game starts

		
		//Game components 
		private var mMainTimer:Timer; //Main game timer that runs the game
		private var mScore:int = 0;
		private var mDist:int = 0; //Arbitrary distance the player has covered
		private var mMovingSpeed:int = 6; //Default arbitrary distance the player "moves" per time unit
		private var mCurrSpeed:int = mMovingSpeed; //current moving speed
		private var mSpeedFactor:Number = 1; //this number will change to account for speed change for chars
		private var mCanvasDecay:Number = .92;
		private var mCanvasDecayFast:Number = .88;
		private var mFgSpeed:Number;//foreground moving speed
		private var mMgSpeed:Number;//midground moving speed
		private var mBgSpeed:Number;//background moving speed
		private var mDefltWeather:String = "none";
		private var mDefltWGrav:Point = new Point (0, 0.1)
		private var mWeather:String;
		private var mWGrav:Point;
		private var mPlayerCollision:CollisionList;	// collision list between line and player
		private var mOtherCollision:CollisionList;	// collision list between linea and others
		
		
		//Characters
		private var mMainPlayer:MainCharacter //MainCharacter
		private var mDefltPos:Point = new Point (200, 300)
		private var mClosingGrav:Point = new Point (1, 0);
		private var mClosingVel:Point = new Point (4, 0);
		private var mDefltVel:Point = new Point (0, 0)
		private var mMorphedItemVel:Point= new Point (-1, -2.5)
		private var mMorphedItemGrav:Point= new Point (0, .07)
		private var mAnchorX:Number = 250; //x point where player will go back to when left alone
		private var mMarker:Marker;//level or game end marker
		private var mEnemyArray:Array = [];	//enemy array to be (re)used
		private var mHelperArray:Array = [];//helper array to be (re)used
		private var mActiveUArray:Array = [];//unbreakable enemies that are currently on the stage
		private var mActiveEArray:Array = [];//enemies that are currently on the stage
		private var mActiveHArray:Array = [];//helpers that are currently on the stage
		private var mImpactArray:Array;//coordinates of impact point b/w player and objects
		
		
		//Game Effects
		private var mSlowOn:Boolean = false; //when true, enemies moves at speed * mSlowRate
		private var mSlowRate:Number = .5; //rate enemies should move at when mSlowOn is true
		private var mSpeedCount:int = 0; //duration of "speed up" should take affect
		public static var BaseFilter:Array = null//[new GlowFilter (0xFFFFFF, 1, 8, 8, 5, 3)]
		public static var ShieldFilter:Array = null//[new GlowFilter (0xFFFF00, 1, 8, 8, 5, 3)]
		
		//Holders
		private var mUISprite:Sprite = new Sprite (); //UI components are placed
		private var mBackdropSprite:Sprite = new Sprite(); //the real "background" 
		private var mBackgrndSprite:Sprite	= new Sprite (); //background objects are placed
		private var mMidgrndSprite:Sprite = new Sprite ();  //Midground objects are placed
		private var mForegrndSprite:Sprite = new Sprite (); //forground objects are placed
		private var mObjsSprite	:Sprite	= new Sprite (); //sprite for all interactive objects 
		private var mParticleSprite	:Sprite	= new Sprite (); //particle effects layer
		private var mParticleSprite2:Sprite	= new Sprite (); //particle effects layer
		private var mParticleSprite3:Sprite	= new Sprite (); //particle effects layer
		private var mFeedbackSprite	:Sprite	= new Sprite (); //various feedback, popup sprite

		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function GameData (pClass:PrivateClass):void 
		{
			
		}
		
		
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public static function get instance ():GameData
		{
			if (mReturnedInstance == null)
			{
				mReturnedInstance = new GameData (new PrivateClass());
			}
			return mReturnedInstance;
		}
		
		public static function get rootMC()			:Object 	{ return GameData.instance.mRootMC;}
		public static function get mainTimer()		:Timer 		{ return GameData.instance.mMainTimer;}
		public static function get player()			:MainCharacter 	{ return GameData.instance.mMainPlayer;}
		public static function get itemVel()		:Point 		{ return GameData.instance.mMorphedItemVel;}
		public static function get itemGrav()		:Point 		{return GameData.instance.mMorphedItemGrav;}
		public static function get dftPos()			:Point 		{ return GameData.instance.mDefltPos;}
		public static function get closingVel()		:Point 		{ return GameData.instance.mClosingVel;}
		public static function get closingGrav()	:Point 		{ return GameData.instance.mClosingGrav;}
		public static function get dftVel()			:Point 		{ return GameData.instance.mDefltVel;}
		public static function get dftWeather()		:String 	{ return GameData.instance.mDefltWeather;}
		public static function get dftWGrav()		:Point 		{ return GameData.instance.mDefltWGrav;}
		public static function get weather()		:String 	{ return GameData.instance.mWeather;}
		public static function get wGrav()			:Point 		{ return GameData.instance.mWGrav;}
		public static function get marker()			:Marker 	{ return GameData.instance.mMarker;}
		public static function get timeCount()		:int 		{ return GameData.instance.mPhaseCount;}
		public static function get anchorX()		:Number 	{ return GameData.instance.mAnchorX;}
		public static function get currPhase()		:String 	{ return GameData.instance.mCurrPhase;}
		public static function get speedCount()		:int 		{ return GameData.instance.mSpeedCount;}
		public static function get impactArray()	:Array 		{ return GameData.instance.mImpactArray;}
		public static function get activeEnemies()	:Array 		{ return GameData.instance.mActiveEArray;}
		public static function get activeUnbreakables():Array 	{ return GameData.instance.mActiveUArray;}
		public static function get activeHelpers()	:Array		{ return GameData.instance.mActiveHArray;}
		public static function get enemies()		:Array 		{ return GameData.instance.mEnemyArray;}
		public static function get helpers()		:Array		{ return GameData.instance.mHelperArray;}
		public static function get slowOn()			:Boolean	{ return GameData.instance.mSlowOn;}
		public static function get slowRate()		:Number		{ return GameData.instance.mSlowRate;}
		public static function get stageHeight()	:Number		{ return GameData.instance.mStageHeight;}
		public static function get stageWidth()		:Number		{ return GameData.instance.mStageWidth;}
		public static function get particleSprite()	:Sprite		{ return GameData.instance.mParticleSprite;}
		public static function get particleSprite2():Sprite		{ return GameData.instance.mParticleSprite2;}
		public static function get particleSprite3():Sprite		{ return GameData.instance.mParticleSprite3;}
		public static function get objsSprite()		:Sprite		{ return GameData.instance.mObjsSprite;}
		public static function get bdSprite()		:Sprite		{ return GameData.instance.mBackdropSprite;}
		public static function get bgSprite()		:Sprite		{ return GameData.instance.mBackgrndSprite;}
		public static function get mgSprite()		:Sprite		{ return GameData.instance.mMidgrndSprite;}
		public static function get fgSprite()		:Sprite		{ return GameData.instance.mForegrndSprite;}
		public static function get uiSprite()		:Sprite		{ return GameData.instance.mUISprite;}
		public static function get fbSprite()		:Sprite		{ return GameData.instance.mFeedbackSprite;}
		public static function get score()			:int		{ return GameData.instance.mScore;}
		public static function get dist()			:int		{ return GameData.instance.mDist;}
		public static function get movingSpeed()	:int		{ return GameData.instance.mMovingSpeed;}
		public static function get currSpeed()		:int		{ return GameData.instance.mCurrSpeed;}
		public static function get speedFactor()	:Number		{ return GameData.instance.mSpeedFactor;}
		public static function get canvasDecay()	:Number		{ return GameData.instance.mCanvasDecay;}
		public static function get canvasDecayFast():Number		{return GameData.instance.mCanvasDecayFast;}
		public static function get fgSpeed()		:Number		{ return GameData.instance.mFgSpeed;}
		public static function get mgSpeed()		:Number		{ return GameData.instance.mMgSpeed;}
		public static function get bgSpeed()		:Number		{ return GameData.instance.mBgSpeed;}
		public static function get gameLevel()		:int		{ return GameData.instance.mGameLevel;}
		public static function get collisionP()	:CollisionList{return GameData.instance.mPlayerCollision;}
		public static function get collisionA()	:CollisionList{return GameData.instance.mOtherCollision;}
		
		
		public static function set impactArray(pa:Array):void 	{ GameData.instance.mImpactArray = pa;}
		public static function set weather(pw:String)	:void 	{ GameData.instance.mWeather = pw;}
		public static function set wGrav(pg:Point)		:void 	{ GameData.instance.mWGrav = pg;}
		public static function set timeCount(pi:int)	:void 	{GameData.instance.mPhaseCount = pi;}
		public static function set currPhase(pcp:String):void 	{GameData.instance.mCurrPhase = pcp;}
		public static function set player(pp:MainCharacter):void {GameData.instance.mMainPlayer = pp;};
		public static function set marker(pm:Marker)	:void 	{ GameData.instance.mMarker = pm;}
		public static function set rootMC(pRoot:Object)	:void 	{ GameData.instance.mRootMC = pRoot;}
		public static function set mainTimer(pt:Timer)	:void 	{ GameData.instance.mMainTimer = pt;}
		public static function set speedCount(pInt:int)	:void 	{ GameData.instance.mSpeedCount = pInt;}
		public static function set slowOn(pb:Boolean)	:void	{ GameData.instance.mSlowOn = pb;}
		public static function set stageHeight(ph:Number):void	{ GameData.instance.mStageHeight = ph;}
		public static function set stageWidth(pw:Number):void	{ GameData.instance.mStageWidth = pw;}
		public static function set anchorX(px:Number)	:void 	{ GameData.instance.mAnchorX = px;}
		public static function set score(pNum:int)		:void 	{ GameData.instance.mScore = pNum;}
		public static function set dist(pNum:int)		:void	{ GameData.instance.mDist = pNum;}
		public static function set movingSpeed(pNum:int):void	{ GameData.instance.mMovingSpeed = pNum;}
		public static function set currSpeed(pNum:int)	:void	{ GameData.instance.mCurrSpeed = pNum;}
		public static function set speedFactor(pNum:Number):void	{ GameData.instance.mSpeedFactor = pNum;}
		public static function set fgSpeed(pNum:Number)	:void	{ GameData.instance.mFgSpeed = pNum;}
		public static function set mgSpeed(pNum:Number)	:void	{ GameData.instance.mMgSpeed = pNum;}
		public static function set bgSpeed(pNum:Number)	:void	{ GameData.instance.mBgSpeed = pNum;}
		public static function set gameLevel(pNum:int)	:void	{ GameData.instance.mGameLevel = pNum;}
		public static function set collisionP(cl:CollisionList):void {GameData.instance.mPlayerCollision = cl;}
		public static function set collisionA(cl:CollisionList):void {GameData.instance.mOtherCollision = cl;}		

	}
}

class PrivateClass
{
	public function PrivateClass()
	{
	}
}
	
