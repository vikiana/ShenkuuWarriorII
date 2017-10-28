package com.neopets.games.inhouse.ExtremeHerderII
{
	//===============================================================================
	// IMPORTS
	//===============================================================================
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	
	public class GenericSmallTextFieldBG extends MovieClip
	{
		//===============================================================================
		// CONSTRUCTOR GenericSmallTextFieldBG
		//===============================================================================
		public function GenericSmallTextFieldBG( pFieldClass : String, 
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
			
			if( tAssetLocation.hasDefinition( pFieldClass ) )
			{
				//trace( this + " says: button asset found" );
				var tFieldClass      : Class = tAssetLocation.getDefinition( pFieldClass ) as Class;
				var tField           : MovieClip = new tFieldClass( );
				this.name = pName;
				this.x = pX;
				this.y = pY;
				
				if( pScale9Grid )
				{
					var tSlice9Grid : Rectangle = new Rectangle( -pScale9GridW * .5, -pScale9GridH * .5, pScale9GridW, pScale9GridH );
					tField.scale9Grid = tSlice9Grid;					
				}
				tField.scaleX = pScaleX;
				tField.scaleY = pScaleY;
				
				addChild( tField );
				
				/**
				 * visualize the center area of scaled asset
				 */
				/* if( pScale9Grid )
				{
					var tScale9GridRect : Shape = new Shape;
					tScale9GridRect.graphics.beginFill( 0xff0000 );
					tScale9GridRect.graphics.drawRect( tField.scale9Grid.x, tField.scale9Grid.y, tField.scale9Grid.width, tField.scale9Grid.height );
					tScale9GridRect.graphics.endFill( );
					addChild( tScale9GridRect );
				} */
			}
			
			else
			{
				trace( this + " says: button asset not found" );
			}
				
		}
	}
}