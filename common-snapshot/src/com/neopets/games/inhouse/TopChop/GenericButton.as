package com.neopets.games.inhouse.TopChop
{
	import flash.display.MovieClip;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	
	public class GenericButton extends MovieClip
	{
		
		public function GenericButton( ) : void
		{
			mouseEnabled  = true;
			buttonMode    = true;
			useHandCursor = true;
			mouseChildren = false;
			
			//add  drop shadow
			var tDropShadowFilter : DropShadowFilter = new DropShadowFilter( );
			filters = new Array( tDropShadowFilter );
			
		}
	}
}
