package com.neopets.games.inhouse.ExtremeHerderII
{
	//===============================================================================
	// IMPORTS
	//===============================================================================
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	
	public class GenericButton extends MovieClip
	{
		//===============================================================================
		// CONSTRUCTOR GenericButton
		//===============================================================================
		public function GenericButton( pButtonClass : String, 
									   pName : String, 
									   pX : Number = 0, 
									   pY : Number = 0,  
									   pScaleX : Number = 1, 
									   pScaleY : Number = 1,
									   pScale9Grid : Boolean = false,
									   pScale9GridW : Number = 0,
									   pScale9GridH : Number = 0 )
		{			
			var tAssetLocation : ApplicationDomain = GlobalGameReference.mInstance.mGameStartUp.mAssetLocation;
			
			if( tAssetLocation.hasDefinition( pButtonClass ) )
			{
				//trace( this + " says: button asset found" );
				var tBtnClass      : Class = tAssetLocation.getDefinition( pButtonClass ) as Class;
				var tBtn           : MovieClip = new tBtnClass( );
				
				tBtn.name = "button_asset";
				tBtn.stop( );
				this.name = pName;
				this.x = pX;
				this.y = pY;	
				
				if( pScale9Grid )
				{
					var tSlice9Grid : Rectangle = new Rectangle( -pScale9GridW * .5, -pScale9GridH * .5, pScale9GridW, pScale9GridH );
					tBtn.scale9Grid = tSlice9Grid;					
				}
				tBtn.scaleX = pScaleX;
				tBtn.scaleY = pScaleY;		
				
				this.mouseEnabled  = true;
				this.buttonMode    = true;
				this.useHandCursor = true;
				this.mouseChildren = false;
				
				var tDropShadowFilter : DropShadowFilter = new DropShadowFilter( );
				tBtn.filters = new Array( tDropShadowFilter );
				
				this.addEventListener( MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true );
				this.addEventListener( MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true );
				
				addChild( tBtn );
				
				/**
				 * visualize the center area of scaled asset
				 */
				/* if( pScale9Grid )
				{
					var tScale9GridRect : Shape = new Shape;
					tScale9GridRect.graphics.beginFill( 0xff0000 );
					tScale9GridRect.graphics.drawRect( tBtn.scale9Grid.x, tBtn.scale9Grid.y, tBtn.scale9Grid.width, tBtn.scale9Grid.height );
					tScale9GridRect.graphics.endFill( );
					addChild( tScale9GridRect );
				} */
			}
			
			else
			{
				trace( this + " says: button asset not found" );
			}
				
		} // end constructor
		
		//===============================================================================
		// 	FUNCTION onMouseOver
		//===============================================================================
		private function onMouseOver( evt : MouseEvent ):void
		{		
			//trace( "onMouseOver called" );
			var tBtn : MovieClip = this.getChildByName( "button_asset" ) as MovieClip;
			tBtn.gotoAndStop( "on" );
			
		} // end onMouseOver
		
		//===============================================================================
		// 	FUNCTION onMouseOut
		//===============================================================================
		private function onMouseOut( evt : MouseEvent ):void
		{
			//trace( "onMouseOut called" );
			var tBtn : MovieClip = this.getChildByName( "button_asset" ) as MovieClip;
			tBtn.gotoAndStop( "off" );
			
		} // end onMouseOut
	}
}