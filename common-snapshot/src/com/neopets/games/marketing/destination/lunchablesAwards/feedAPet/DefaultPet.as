/**
 *	Pet class for feedApet.  It simply extends AbstractPet
 *	no new stuff needed to be created
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

package com.neopets.games.marketing.destination.lunchablesAwards.feedAPet
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.destinationV2.feedapet.AbsPet
	import com.neopets.games.inhouse.shootergame.utils.LibraryLoader_v2;
	import flash.display.MovieClip;
	
	
	
	public class DefaultPet extends AbsPet
	{
		//----------------------------------------
		//VARIABLES
		//----------------------------------------

		
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		public function DefaultPet(p_name: String, p_pngurl: String, p_swfurl:String, p_fed_recently: Boolean, pLocalTesting:Boolean = false):void
		{
			super(p_name, p_pngurl, p_swfurl, p_fed_recently, pLocalTesting);
			var cl:Class = LibraryLoader_v2.getLibrarySymbol("pet_hilite");
			var image:MovieClip = new cl();
			image.name = "hilite";
			image.x = -11;
			image.y = -18;
			addChild(image);
			image.visible = false;
			
		}
		
		
		//----------------------------------------
		//GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//PUBLIC METHODS
		//----------------------------------------
		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------
	}
	
}