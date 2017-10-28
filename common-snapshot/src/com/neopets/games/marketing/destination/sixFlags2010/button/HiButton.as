/* AS3
Copyright 2008
*/


package com.neopets.games.marketing.destination.sixFlags2010.button
{
	import caurina.transitions.*;
	import caurina.transitions.properties.FilterShortcuts;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.utils.Timer;
		
	/**
	 *	This is for Simple Control of a Button with a Little More Extras
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Clive Henrick
	 *	@since  5.12.2010
	 */
	
	public class HiButton extends Button
	{
		protected var mEffectFilter:GlowFilter;
		
		public var title_txt:TextField;
		
		public function HiButton()
		{
			super();
			setupButtonVars();
		}
		
		/**
		 *@Note Resets the Button to the first frame 
		 */
		
		public override function reset():void
		{
			gotoAndStop(1);
			this.filters = [];
			
		}
		
		public function setTitleText(txt:String):void {
			title_txt.text = txt;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		protected override function rollOverHandler():void 
		{
			this.filters = [mEffectFilter];
		}
		
		protected override function rollOutHandler():void 
		{
			this.filters = [];
		}
		
		protected override function mouseDownHandler():void 
		{
		}
		
		protected function setupButtonVars():void
		{
			mEffectFilter = new GlowFilter();
		}
		
	
		
		
		
	}
}