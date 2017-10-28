/**
 *	(static) class that deals with all particle affects of this game
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  09.17.2009
 */

package com.neopets.games.inhouse.shenkuuSideScroller.misc
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.geom.Point;
	import flash.display.MovieClip;

	import flash.filters.BlurFilter;
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.projects.effects.particle.*;
	import com.neopets.games.inhouse.shenkuuSideScroller.dataObj.GameData;
	import com.neopets.games.inhouse.shenkuuSideScroller.canvas.*;
	import com.neopets.util.sound.SoundManager;
	import com.neopets.games.inhouse.shenkuuSideScroller.misc.Sounds
	import com.neopets.games.inhouse.shenkuuSideScroller.misc.AssetTool;
	import com.neopets.util.sound.GameSoundManager;

	
	public class ParticleBridge
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		private static var p1:MovieClip
		private static var p2:MovieClip
		private static var p3:MovieClip
		private static var p4:MovieClip
		private static var p5:MovieClip
		private static var p6:MovieClip
		private static var p7:MovieClip
		private static var p8:MovieClip
		public static var speed:Number = -GameData.movingSpeed
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function ParticleBridge():void
		{
			
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------

		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		public static function prepParticles():void
		{
			setupVars()
			//holder
			ImageManager.addHolder (GameData.particleSprite, GameData.stageWidth, GameData.stageHeight);
			ImageManager.addHolder (GameData.particleSprite2, GameData.stageWidth, GameData.stageHeight);
			//ImageManager.addHolder (GameData.particleSprite3, GameData.stageWidth, GameData.stageHeight);
			
			//particle images
			ImageManager.addParticleImage(p1, "p1")
			ImageManager.addParticleImage(p2, "p2")
			ImageManager.addParticleImage(p3, "p3")
			ImageManager.addParticleImage(p4, "p4")
			ImageManager.addParticleImage(p5, "p5")
			ImageManager.addParticleImage(p6, "p6")
			ImageManager.addParticleImage(p7, "p7")
			ImageManager.addParticleImage(p8, "p8")
		}
		
		
		public static function resetHolders():void
		{
			ImageManager.resetHolders()
		}
		
		public static function showFireWorks():void
		{
			//SoundManager.instance.soundPlay(Sounds.SND_FIRE);
			GameSoundManager.soundPlay(GameSoundManager.soundOn,Sounds.SND_FIRE)
			ParticleFormation.fireworks(ParticleManager.makeParticle(7), GameData.particleSprite,"p4", Math.random() * GameData.stageWidth ,Math.random() * GameData.stageHeight,10,0,.5,.1);
		}
		
		/*
		public static function showDeath(px:Number, py:Number):void
		{
			SoundManager.instance.soundPlay(Sounds.SND_FIRE);
			//ParticleFormation.fireworks(ParticleManager.makeParticle(20), GameData.particleSprite2,"p8", px, py,4,0,0,.05);
			ParticleFormation.smoke(ParticleManager.makeParticle(10), GameData.particleSprite2, "p8",px , py, 1, 1, -4, -2, .8);
		}
		*/
		
		
		public static function showMissileShoot(px:Number, py:Number):void
		{
			ParticleFormation.smoke(ParticleManager.makeParticle(2), GameData.particleSprite, "p8",px , py, 1, 1, speed, -2, .8);
			//ParticleFormation.fireworks(ParticleManager.makeParticle(4), GameData.particleSprite2,"p4", px ,py,3,0,.5,.1);
		}
		
		
		
		
		/**
		 *	Show weather if it's other than "none"
		 **/
		public static function showParticle(pmx:Number = NaN, pmy:Number = NaN):void
		{	
			//various particles
			if (!isNaN(pmx)  && !isNaN(pmy) && CanvasManager.lineOn) showLineTrail(pmx, pmy);
			showShipTrail();
			showWeather()
			showImpact()
			
			//run image manager to update the particles
			ImageManager.showParticles();
		}
		
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		private static function setupVars():void
		{
			p1 = AssetTool.getMC("ParticleMC");
			p2 = AssetTool.getMC("Particle2MC");
			p3 = AssetTool.getMC("Particle3MC");
			p4 = AssetTool.getMC("Particle4MC");
			p5 = AssetTool.getMC("Particle5MC");
			p6 = AssetTool.getMC("Particle6MC");
			p7 = AssetTool.getMC("Particle7MC");
			p8 = AssetTool.getMC("Particle8MC");
		}
		
		
		/**
		 *	Show line trail
		 **/
		private static function showShipTrail():void
		{
			//if (true)//!Boolean(Math.floor(Math.random() * 3)))
			//if (!Boolean(GameData.player.invincible) && !Boolean(Math.floor(Math.random() * 3)))
			if (!Boolean(GameData.player.invincible))//!Boolean(Math.floor(Math.random() * 3)))
			{
				ParticleFormation.smoke2(ParticleManager.makeParticle(1), GameData.particleSprite2, "p1", GameData.player.px - 30 , GameData.player.py + 62 + Math.random() *2 ,0, 0, -Math.random() + speed/3, .2, .1, .07);
				
				ParticleFormation.smoke2(ParticleManager.makeParticle(1), GameData.particleSprite2, "p1", GameData.player.px - 34 , GameData.player.py - 42- + Math.random() *2 , 0, 0, -Math.random()+ speed/3, .2, .1, .07);
			}
		}
		
		
		
		
		/**
		 *	Show line trail
		 **/
		private static function showLineTrail(pmx:Number, pmy:Number):void
		{
			var num:int = Math.round(Math.random() * 2) + 5				
			var xvel:Number = Math.random() + (speed - .5)
			var yvel:Number = Math.random() - .5 
			var xgrav:Number = Math.random() *.8 -.4
			var ygrav:Number = Math.random()  *.8 -.4
			ParticleFormation.stream(ParticleManager.makeParticle(1), GameData.particleSprite, "p"+ num.toString(), pmx, pmy, xvel, yvel, xgrav, ygrav, 0, 0.03, 10)
		}
		
		
		public static function showTrail2(pmx:Number, pmy:Number):void
		{
			if (!Boolean(Math.floor(Math.random() * 4)))
			{
				var xvel:Number = Math.random()  + 8
				var yvel:Number = Math.random() - .5 
				var xgrav:Number = Math.random() *.8 -.4
				var ygrav:Number = Math.random()  *.8 -.4
				ParticleFormation.stream(ParticleManager.makeParticle(1), GameData.particleSprite, "p8", pmx + 20, pmy, xvel, yvel, xgrav, ygrav, 0, 0.06, 10)
			}
		}
		
		
		
		/**
		 *	Show weather if it's other than "none"
		 **/
		private static function showWeather():void
		{
			
			if (GameData.weather != "none")
			{
				if (!Boolean(Math.floor(Math.random() * 7)))
				{
					switch (GameData.weather)
					{
						case "snow":
							var px:Number = Math.random() * (GameData.stageWidth + 100)
							var py:Number = GameData.wGrav.y > 0 ? -10: GameData.stageHeight + 10;
							var xgrav:Number =  Math.random() * -GameData.currSpeed/ 2 - 3 
							var ygrav:Number =  (Math.random() * GameData.currSpeed / 2 + 3) //* GameData.wGrav.y
							
							ParticleFormation.stream(ParticleManager.makeParticle(1), GameData.particleSprite, "p4", px, py, 0, 0, xgrav, ygrav, 0, 0.1, 80)
							
							break;
					}
				}
			}
		}
		
		
		
		/**
		 *	Show particle effects on impact point
		 **/
		private static function showImpact():void
		{
			if (GameData.impactArray.length > 0)
			{
				var pt:Point = GameData.impactArray.shift()
				ParticleFormation.fireworks(ParticleManager.makeParticle(Math.ceil(Math.random() * 3) + 3), GameData.particleSprite, "p3", pt.x , pt.y, 10, speed/2, .5, 0.1);
				showImpact()
			}
		}
		
		

		
		
		
		
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
	}
	
}
