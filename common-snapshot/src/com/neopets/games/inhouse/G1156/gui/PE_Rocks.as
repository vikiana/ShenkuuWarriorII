
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
	 *	Used to create a Rock Particle Effect
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern Abe Particle Effects System
	 * 
	 *	@author Clive Henrick
	 *	@since  9.21.2009
	 */
	 
	public class PE_Rocks
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
		 
		public function PE_Rocks():void
		{
			setupVars();	
		}
		
		public function init (pApplicationDomain:ApplicationDomain, pStageWidth:int, pStageHeight:int):Sprite
		{
			mApplicationDomain = pApplicationDomain;
			mStageWidth = pStageWidth;
			mStageHeight = pStageHeight;
			mEffectSprite = new Sprite();	
			
			//var holderFilters:Array = [ new GlowFilter (0xFFFFFF, 1, 4, 4, 3, 3),new BlurFilter (4, 4, 3)]
			//var trailFilters:Array = [new BlurFilter (2, 2, 1)]
			
			var Particle1Class:Class = mApplicationDomain.getDefinition("PS_Rock1") as Class
			var Particle1:Sprite = new Particle1Class () as Sprite;
			
			var Particle2Class:Class = mApplicationDomain.getDefinition("PS_Rock2") as Class
			var Particle2:Sprite = new Particle2Class () as Sprite;
			
			var Particle3Class:Class = mApplicationDomain.getDefinition("PS_Rock3") as Class
			var Particle3:Sprite = new Particle3Class () as Sprite;
			
			var Particle4Class:Class = mApplicationDomain.getDefinition("PS_Rock4") as Class
			var Particle4:Sprite = new Particle4Class () as Sprite;
			
			var Particle5Class:Class = mApplicationDomain.getDefinition("PS_Rock5") as Class
			var Particle5:Sprite = new Particle5Class () as Sprite;
			
			var Particle6Class:Class = mApplicationDomain.getDefinition("PS_Rock6") as Class
			var Particle6:Sprite = new Particle6Class () as Sprite;
			
			ImageManager.addParticleImage(Particle1, "rock1")
			ImageManager.addParticleImage(Particle2, "rock2")
			ImageManager.addParticleImage(Particle3, "rock3")
			ImageManager.addParticleImage(Particle4, "rock4")
			ImageManager.addParticleImage(Particle5, "rock5")
			ImageManager.addParticleImage(Particle6, "rock6")
			
			//ImageManager.addHolder (mEffectSprite, mStageWidth, mStageHeight,null,true,.6);
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
		
		public  function startFireWorksEffect(pX:Number,pY:Number):void
		{
			var num:int = Math.ceil(Math.random() * 5);
			var rad:int = Math.ceil(Math.random() * 10 +4);
			var particleNum:int	= Math.ceil(Math.random() * 5 + 2)
			ParticleFormation.fireworks(ParticleManager.makeParticle(particleNum), mEffectSprite, "rock"+ num.toString(), pX, pY, rad);

			mSharedEventDispatcher.addEventListener(GameEvents.GAME_QUICK_TIMER_EVENT, update, false, 0, true);
			
		}
		
		public  function startSmokeEffect(pX:Number,pY:Number):void
		{
			var num:int = Math.ceil(Math.random() *5);
			var rad:int = Math.ceil(Math.random() * 8 + 2);
			var particleNum:int	= Math.ceil(Math.random() * 5 + 2)
			ParticleFormation.smoke(ParticleManager.makeParticle(particleNum), mEffectSprite, "particle"+ num.toString(), pX, pY, rad);

			mSharedEventDispatcher.addEventListener(GameEvents.GAME_QUICK_TIMER_EVENT, update, false, 0, true);
			
		}
		
		public  function startRockEffect(pX:Number,pY:Number):void
		{
			var num:int = Math.ceil(Math.random() * 5);
			var num2:int = Math.ceil(Math.random() * 5);
			var rad:int = Math.ceil(Math.random() * 20 + 20);
			var rad2:int = Math.ceil(Math.random() * 7 + 6);
			var particleNum:int	= Math.ceil(Math.random() * 2+2)
			var particleNum2:int	= Math.ceil(Math.random() * 6+2)
			
			ParticleFormation.RockBurst(ParticleManager.makeParticle(particleNum), mEffectSprite, "rock"+ num.toString(), pX, pY, rad2,0,1,.2,2);

			ParticleFormation.RockBurst(ParticleManager.makeParticle(particleNum), mEffectSprite, "rock"+ num2.toString(), pX, pY, rad,1,2,.2,4);

			mSharedEventDispatcher.addEventListener(GameEvents.GAME_QUICK_TIMER_EVENT, update, false, 0, true);
			
		}
		
		/**
		 *	Create genric moving particle(s)
		 *
		 *	@PARAM		pArray		Array		Array of praticles
		 *	@PARAM		pHolder		Sprite		Where particles should appear
		 *	@PARAM		pImageName	String		Name of the particle image that should be shown
		 *	@PARAM		px			Number		x position of the particle ***Make it random pts of x width
		 *	@PARAM		py			Number		y position of the particle
		 *	@PARAM		pxvel		Number		initial x velocity
		 *	@PARAM		pyvel		Number 		initial y velocity
		 *	@PARAM		pxg			Number		x gravity (force)
		 *	@PARAM		pyg			Number		y gravity (force)
		 *	@PARAM		pFric		Number		friction
		 *	@PARAM		decay		Number		rate the particle should decay: lower number = longer life
		 *	@PARAM		delay		Number		mesurement of unit delay before decay starts
		 **/
		 
		public  function startSteamEffect(pX:Number,pY:Number):void
		{
			var num:int = Math.ceil(Math.random() * 5);
			var num2:int = Math.ceil(Math.random() * 5);
			var rad:int = Math.ceil(Math.random() * 16 + 6);
			var particleNum:int	= Math.ceil(Math.random() * 2+2)
			
			ParticleFormation.stream(ParticleManager.makeParticle(particleNum), mEffectSprite, "rock"+ 2, pX, pY, rad,.5,2,2,0,.5);
			ParticleFormation.stream(ParticleManager.makeParticle(particleNum), mEffectSprite, "rock"+ 3, pX + 30, pY+20, rad);

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
