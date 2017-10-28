/**
 *	Class to deal with UI
 *	In essence this class assumes a movie clip in a library that UI components
 *	For this game, life gage, pen gage, score, etc.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  09.15.2009
 */

package com.neopets.games.inhouse.shenkuuSideScroller.misc
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.events.EventDispatcher
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.util.events.CustomEvent;
	import com.neopets.games.inhouse.shenkuuSideScroller.dataObj.GameData;
	
	//test
	import com.neopets.projects.effects.particle.*;
	
	
	public class UI extends EventDispatcher
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------		
		public static const UI_ACTIVITY:String = "user_interacted_with_ui";
		public static const GAME_END:String   = "game_end_clicked_UI";
		public static const MEMORY_TOGGLE:String   = "toggle_render_capacity";
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		
		private static var mReturnedInstance:UI; //singleton instance
		private var mImage:MovieClip;		//main popup MC pulled from library
		
		
		
		
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		
		public function UI(pPrivCl : PrivateClass):void
		{			
		}
		
		
		
		
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		/**
		 *	Singleton Pattern
		 **/
		public static function get instance( ):UI
		{
			if( UI.mReturnedInstance == null ) 
			{
				UI.mReturnedInstance = new UI( new PrivateClass( ) );
			}
			return UI.mReturnedInstance;
		}
		
		
		
		/**
		 *	Get the UI image, it should be called only after init has been called
		 **/
		public static function get image():MovieClip
		{
			return UI.instance.mImage;
		}
		
		
		
		
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		/**
		 *	sets the image of the popup
		 *	@PRAAM		pImage		MovieClip		popup instance, from library or ext.art asses 
		 **/
		public static function init(pImage:MovieClip  = null):void
		{
			trace (1)
			UI.instance.mImage = pImage;
			trace (2)
			UI.image.closeButton.addEventListener(MouseEvent.MOUSE_DOWN, UI.instance.onCloseClicked, false, 0, true);
			trace (3)
			UI.image.memoryButton.addEventListener(MouseEvent.MOUSE_DOWN, UI.instance.onMemoryClicked, false, 0, true);
			trace (4)
			UI.image.closeButton.buttonMode = true;
			trace (5)
			UI.image.scoreText.text = "0";
		}
		
		
		/**
		 * test
		 **/
		private static function testStats():void
		{
			UI.image.enemies.text = GameData.enemies.length.toString()
			UI.image.Aenemies.text = GameData.activeEnemies.length.toString()
			UI.image.helpers.text = GameData.helpers.length.toString()
			UI.image.Ahelpers.text = GameData.activeHelpers.length.toString()
			UI.image.particle.text = ParticleManager.activeParticles.length.toString()
			UI.image.Rparticle.text = (ParticleManager.activeParticles.length + ParticleManager.inactiveParticles.length ).toString();
		}
		 
		/**
		 *	update the pen bar
		 *	@PARAM		pEnergyLevel		Number		player's energy level, between 0 to 1
		 **/
		public static function updatePenGage (pEergyLevel:Number):void
		{
			UI.image.penGage.energy.scaleX = pEergyLevel;
		}
		
		
		
		/**
		 *	change the life bar
		 *	@PARAM		pEnergyLevel		Number		player's energy level, between 0 to 1
		 **/
		public static function updateLifeGage (pEergyLevel:Number):void
		{
			UI.image.lifeGage.energy.scaleX = pEergyLevel;
		}
		
		
		/**
		 *	update the score text (actual score number)
		 *	@PARAM		pScore		Number		Score to be displayed
		 **/
		public static function updateScoreText (pScore:Number):void
		{
			UI.image.scoreText.text = pScore.toString();
		}
		
		
		
		public static function controlLifeBar():void
		{
			var diff:Number = GameData.player.life - (UI.image.lifeGage.energy.scaleX * 100)
			var inc:Number
			if (Math.abs(diff) > 1)
			{
				inc = diff > 0 ? 1: -1;
				UI.image.lifeGage.energy.scaleX += inc/100
			}
			//testStats();
		}
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------

		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		protected function onCloseClicked (e:MouseEvent):void
		{
			dispatchEvent (new CustomEvent ({TYPE:UI.GAME_END}, UI.UI_ACTIVITY));
		}
		
		protected function onMemoryClicked (e:MouseEvent):void
		{
			dispatchEvent (new CustomEvent ({TYPE:UI.MEMORY_TOGGLE}, UI.UI_ACTIVITY));
		}
		
		
	}
	
}


class PrivateClass{public function PrivateClass( ){}} 