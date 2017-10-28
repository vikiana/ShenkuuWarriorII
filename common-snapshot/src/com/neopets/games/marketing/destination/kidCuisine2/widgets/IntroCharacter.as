/**
 *	This class handles movieclips that jump to a random frame when they're added to the stage.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  01.04.2010
 */

package com.neopets.games.marketing.destination.kidCuisine2.widgets
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	
	
	public class IntroCharacter extends MovieClip
	{
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var _model:MovieClip;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function IntroCharacter():void {
			model = this["model_mc"];
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get model():MovieClip { return _model; }
		
		public function set model(clip:MovieClip) {
			_model = clip;
			if(_model != null) {
				if(_model.totalFrames > 1) {
					var index:int = Math.ceil(Math.random() * _model.totalFrames);
					_model.gotoAndStop(index);
				}
			}
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------

	}
	
}