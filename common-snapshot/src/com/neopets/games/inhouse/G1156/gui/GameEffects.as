/* AS3
	Copyright 2008
*/
package  com.neopets.games.inhouse.G1156.gui
{
	import com.neopets.games.inhouse.G1156.gameEngine.GameCore;
	import com.neopets.games.inhouse.G1156.events.GameEvents;
	import com.neopets.projects.effects.particle.*;
	import com.neopets.util.events.MultitonEventDispatcher;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	
	/**
	 *	Used to create simple Particle Effects for this Game
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern Abe Particle Effects System
	 * 
	 *	@author Clive Henrick
	 *	@since  9.21.2009
	 */
	 
	public class GameEffects
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var mSharedEventDispatcher:MultitonEventDispatcher;
		protected var mApplicationDomain:ApplicationDomain;
		protected var mStageWidth:int;
		protected var mStageHeight:int;

		private var mEffectSprite:Sprite;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function GameEffects():void
		{
			setupVars();	
		}
		
		public function init (pApplicationDomain:ApplicationDomain, pStageWidth:int, pStageHeight:int):Sprite
		{
			mApplicationDomain = pApplicationDomain;
			mStageWidth = pStageWidth;
			mStageHeight = pStageHeight;
			mEffectSprite = new Sprite();	
			
			var Particle1Class:Class = mApplicationDomain.getDefinition("PS_star_red") as Class
			var Particle1:Sprite = new Particle1Class () as Sprite;
			
			var Particle2Class:Class = mApplicationDomain.getDefinition("PS_star_yellow") as Class
			var Particle2:Sprite = new Particle2Class () as Sprite;
			
			var Particle3Class:Class = mApplicationDomain.getDefinition("PS_star_purple") as Class
			var Particle3:Sprite = new Particle3Class () as Sprite;
			
			var Particle4Class:Class = mApplicationDomain.getDefinition("PS_star_green") as Class
			var Particle4:Sprite = new Particle4Class () as Sprite;
		
			ImageManager.addParticleImage(Particle1, "particle1")
			ImageManager.addParticleImage(Particle2, "particle2")
			ImageManager.addParticleImage(Particle3, "particle3")
			ImageManager.addParticleImage(Particle4, "particle4")
			
			ImageManager.addHolder (mEffectSprite, mStageWidth, mStageHeight);
			
			return mEffectSprite;
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get effectSprite():Sprite
		{
			return mEffectSprite;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public  function startFireWorksEffect(pX:Number,pY:Number, pParticleNum:int = 1):void
		{
			var num:int = 1;
			var rad:int = Math.ceil(Math.random() * 10 +8);
			var particleNum:int	= Math.ceil(Math.random() * 2+ 2)
			ExtendedParticleFormation.RockBurst(ParticleManager.makeParticle(particleNum), mEffectSprite, "particle"+ pParticleNum, pX, pY, rad,0,1,.2,3);

			mSharedEventDispatcher.addEventListener(GameEvents.GAME_QUICK_TIMER_EVENT, update, false, 0, true);
			
		}
		
		public  function startSmokeEffect(pX:Number,pY:Number,pParticleNum:int = 2):void
		{
			var num:int = 2;
			var rad:int = Math.ceil(Math.random() * 8 + 2);
			var particleNum:int	= Math.ceil(Math.random() * 2 + 2)
			ParticleFormation.smoke(ParticleManager.makeParticle(particleNum), mEffectSprite, "particle"+ pParticleNum, pX, pY, rad);

			mSharedEventDispatcher.addEventListener(GameEvents.GAME_QUICK_TIMER_EVENT, update, false, 0, true);
			
		}
		
		public  function startSteamEffect(pX:Number,pY:Number,pParticleNum:int = 2):void
		{
			var num:int = 2;
			var rad:int = Math.ceil(Math.random() * 16 + 6);
			var particleNum:int	= Math.ceil(Math.random() * 2 + 3)
			ParticleFormation.stream(ParticleManager.makeParticle(particleNum), mEffectSprite, "particle"+ pParticleNum, pX, pY, rad);

			mSharedEventDispatcher.addEventListener(GameEvents.GAME_QUICK_TIMER_EVENT, update, false, 0, true);
			
		}
		
		/**
		 * @Note: Called from the Main App to Cycle the Effects
		 */
		 
		public function update(evt:Event):void
		{
			ImageManager.showParticles();
		}
	
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		protected function setupVars():void
		{
			mSharedEventDispatcher = MultitonEventDispatcher.getInstance(GameCore.KEY);
			
		}
	}
	
}
