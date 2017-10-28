package com.neopets.games.inhouse.shootergame.assets.layers
{
	import com.neopets.games.inhouse.shootergame.LayerDefinition;
	import com.neopets.games.inhouse.shootergame.SharedListener;
	import com.neopets.games.inhouse.shootergame.ShooterGame;
	import com.neopets.games.inhouse.shootergame.abstract.AbstractLayer;
	import com.neopets.games.inhouse.shootergame.utils.LibraryLoader;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;

	/**
	 *	This background layer class
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 10.0
	 *	
	 * 
	 *	@author Viviana Baldarelli
	 *	@since  03.20.2009
	 */
	public class BackgroundLayer extends AbstractLayer
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		private static const SCROLLING_SPEED:Number = 20;
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		private var _ovl:Sprite;
		private var _currentElement:MovieClip;
		//reference to the stage number
		private var _sN:Number;


		/**
	 	*	Constructor
		*
	 	*/
		public function BackgroundLayer()
		{
			super();
			_sN = 1;
		}

		
		
		//-----------------------------------------------------------------
		//   PUBLIC METHODS
		//-----------------------------------------------------------------
		override public function scroll():void {
			if (moving){
				for (var i:int = 0; i< _elementsArray.length; i++){
					var item:DisplayObject = _elementsArray[i];
					item.x -= _scrollSpeed;
				}
				if (_currentElement.x <= -_currentElement.width/2){
					//NO MIDSTAGE OVERLAY VERSION--------to revert, un-comment the commented line and comment the uncommented :)----
					//_sl.sendCustomEvent (SharedListener.STAGE_START, {type:"EndStageOverlay", stageNo:_sN}, false, true);
					_sl.sendCustomEvent(SharedListener.STOP_GEARS, null, false, true);
					_sl.sendCustomEvent (SharedListener.START_LAYER, {stageNo:_lc.lm.lArray[2]._stageNo}, false, true);
					//---------------------------------------------------------------------------------------------------------
					_sl.sendCustomEvent(SharedListener.STOP_SOUND, {name:"ambiant_gear_loop"}, false, true);
					moving = false;
				}
			}
		}
		
		override public function cleanUp (e:CustomEvent=null):void {
			moving = false;
			removeCommonEventListeners();
			
			if (_sl.hasEventListener(SharedListener.LOAD_STAGE)){
				_sl.removeEventListener(SharedListener.LOAD_STAGE, moveLayer);
			}
			if (_sl.hasEventListener(SharedListener.STAGE_END)){
				_sl.removeEventListener (SharedListener.STAGE_END, endStage);
			}
			
			for (var i:uint=_elementsArray.length; i>0; i--){
				_elementsArray.splice (i, 1);
			}
			_elementsArray = null;
			
			for (i=numChildren-1; i>0; i--){
				removeChildAt(i);
			}
			
			cleanUpCommonElements();
			
			_ovl = null;
		}
		
		
		//-----------------------------------------------------------------
		//   PROTECTED METHODS
		//-----------------------------------------------------------------
		
		override protected function initialize():void{
			found = false;
			moving = false;
			if (_sN<=1){
				_elementsArray = createScrollingElements(_ld.bkgs, -55, -ShooterGame.STAGE_WIDTH/2);
				_currentElement  = _elementsArray[0];
				//
				//gradient overlay
				var ovl:Class = LibraryLoader.getLibrarySymbol("bkgOverlay");
				_ovl = new ovl();
				_ovl.width = 800;
				_ovl.height = 600;
				_ovl.alpha = 0.6;
				_ovl.blendMode = BlendMode.HARDLIGHT;
				addChild (_ovl);
			}
			//events listeners
			if (!_sl.hasEventListener(SharedListener.STAGE_END)){
				_sl.addEventListener (SharedListener.STAGE_END, endStage);
			}
			if (!_sl.hasEventListener(SharedListener.LOAD_STAGE)){
				_sl.addEventListener(SharedListener.LOAD_STAGE, moveLayer);
			}
			_scrollSpeed = SCROLLING_SPEED;
		};
		
		
		
		//-----------------------------------------------------------------
		//   EVENT HANDLERS
		//-----------------------------------------------------------------

		override protected function endStage(e:CustomEvent):void{
			_sN = e.oData.stageNo;
			if (_sN < _elementsArray.length){
				_currentElement = _elementsArray[_sN];
			}
		}
		
		private function moveLayer (e:CustomEvent):void {
			_sl.sendCustomEvent(SharedListener.PLAY_SOUND, {name:"ambiant_gear_loop", loop:true}, false, true);
			moving = true;
		}
		
	}
}