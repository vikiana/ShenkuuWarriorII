package com.neopets.games.inhouse.shootergame
{
	
	import com.neopets.games.inhouse.shootergame.abstract.AbstractLayer;
	import com.neopets.games.inhouse.shootergame.assets.layers.*;
	import com.neopets.util.events.CustomEvent;
	
	import flash.events.Event;
	

	/**
	 *	This the layers manager class. Handles creation and movements of all layers. Destruction of layers in handleb by the layer container.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 10.0
	 *	
	 * 
	 *	@author Viviana Baldarelli
	 *	@since  03.19.2009
	 */
	public class LayersManager
	{
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		private var _lArray:Array;
		private var _lc:LayerContainer;
		private var _sl:SharedListener;
		private var _lad:LevelDefinition;
	
		/**
	 	*	Constructor
	 	* 
	 	* @param ld   LayerDefiniiton 
	 	* @param lc   LayerContainer
	 	* @param lad  LevelDefinition
	 	*
		*
	 	*/
		public function LayersManager()
		{
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		 public function initialize (sl:SharedListener, lc:LayerContainer, lad:LevelDefinition):void {
		 	//references
		 	_lc = lc;
			_sl = sl;
			_lad = lad;
			//
		 	_lArray = new Array ();
		 	//first level start
		 	_sl.addEventListener(SharedListener.LEVEL_START, startScrolling);
		 	//next stages
		 	_sl.addEventListener(SharedListener.START_LAYER, startScrolling);
		 	_sl.addEventListener(SharedListener.STOP_LAYER, stopScrolling);
		 };
		 

		 /**
		 * @Note: This is to create layers based on layer definitions and to pass them the shared listener
		 * @param		layerName			String
		 * @param		layerDefinition		LayerDefinition
		 */
		 public function createLayer (layerDefinition:LayerDefinition):AbstractLayer{
		 	var layer:AbstractLayer;
		 	var symbol:Class = layerDefinition.asset;
		 	layer = new symbol ();
		 	if (layer){
		 		_lc.addChild(layer);
		 		_lArray.push (layer);
		 	}
			return layer;
		 }
		 
		 public function initLayer (layer:AbstractLayer, layerDefinition:LayerDefinition, sl:SharedListener, lm:LayersManager):void {
		 	layer.init (layerDefinition, _sl, _lc);
		 	if (layer){
		 		layer.name = layerDefinition.name;
		 		if (layerDefinition.posZ){
		 			layer.z = layerDefinition.posZ;
		 		}
		 	}
		 }
		 
		 public function cleanUp():void {
		 
			if (_lc.hasEventListener(Event.ENTER_FRAME)){
				_lc.removeEventListener(Event.ENTER_FRAME, scroll);
			}
			if (_sl.hasEventListener(SharedListener.LEVEL_START)){
				_sl.removeEventListener(SharedListener.LEVEL_START, startScrolling);
			}
			if (_sl.hasEventListener(SharedListener.START_LAYER)){
				_sl.removeEventListener(SharedListener.START_LAYER, startScrolling);
			}
			if (_sl.hasEventListener(SharedListener.STOP_LAYER)){
				_sl.removeEventListener(SharedListener.STOP_LAYER, stopScrolling);
			}
			_lArray = null;
			_lc = null;
			_sl = null;
			_lad = null;
		 };
		 
		 //--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		private function checkLayers (e:CustomEvent):void {
			for (var i:int=0; i<_lArray.length ; i++){
				if (!e.oData.layer.ready){
					return;
				} else {
				 	if (i == _lArray.length-1){
				 		//perform this check if the layers take time to load
				 	}
				}
			}
		}
		
		//Seldom used. The flag 'moving' in the layers is used instead
		private function stopScrolling (e:CustomEvent):void {
			if (_sl.hasEventListener(SharedListener.STOP_LAYER)){
				_sl.removeEventListener(SharedListener.STOP_LAYER, stopScrolling);
			}
			_sl.addEventListener(SharedListener.LEVEL_START, startScrolling);
			_lc.removeEventListener(Event.ENTER_FRAME, scroll);
		}
		
		
		//Invoked one time at the beginning of the game. Invoked by LEVEL_START  the first time and  START_LAYER all other times.
		private function startScrolling (e:CustomEvent):void {
			if (_sl.hasEventListener(SharedListener.LEVEL_START)){
				_sl.removeEventListener(SharedListener.LEVEL_START, startScrolling);
			}
			_sl.addEventListener(SharedListener.STOP_LAYER, stopScrolling);
			_lc.addEventListener(Event.ENTER_FRAME, scroll);

			//Timers to issue obstacles
			for (var i:int =0 ; i<_lArray.length; i++){
				if (_lArray[i] is  FirstLayer || _lArray[i] is  SecondLayer){
					_lArray[i].createTimer(e.oData.stageNo);
					 _lArray[i].doIssue = true;
				}
			}
		}
		
		//ENTERFRAME event. The only movement handled by enterframe is the layers movement. Everything else is done by tweens.
		private function scroll(e:Event):void {
			for (var i:int =0 ; i<_lArray.length; i++){
				if (_lArray[i].moving){
					_lArray[i].scroll();
				}
			}
		} 
	
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		public function get lArray ():Array{
			return _lArray;
		}
		
		public function get lc ():LayerContainer{
			return _lc;
		}
		
		public function set lc (value:LayerContainer):void {
			_lc = value;
		}
	}
}