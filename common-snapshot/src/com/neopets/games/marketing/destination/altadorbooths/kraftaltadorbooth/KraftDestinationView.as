/**
 *	Popsicle Destination Document Class
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 *	@modified Nov.2009
 */

package com.neopets.games.marketing.destination.altadorbooths.kraftaltadorbooth
{
	import com.neopets.games.marketing.destination.altadorbooths.common.AltadorAlleyDestinationView;
	import com.neopets.projects.destination.destinationV3.AbsView;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.util.flashvars.FlashVarManager;
	import com.neopets.util.servers.NeopetsServerFinder;
	
	import flash.net.Responder;
	
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	
	public class KraftDestinationView extends AltadorAlleyDestinationView
	{
		//----------------------------------------
		// 	CONSTANTS
		//-----------------------------------------
		private const NEOCONTENT_ID:String = "1710";
		private const LIB_PATH:String = "sponsors/altadoralley/kraft_assets.swf";
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		
		/**
		 *	instantiate control class and set up project ID
		 **/
		public function KraftDestinationView():void
		{
			super();
			Parameters.assetPath = LIB_PATH;
		}
		
		//----------------------------------------
		//GETTERS AND SETTORS
		//----------------------------------------
	
		
		
		//----------------------------------------
		//PUBLIC METHODS
		//----------------------------------------

		//----------------------------------------
		//PROTECTED METHODS
		//----------------------------------------
		override protected function initialize ():void {
			init (new KraftDestinationControl(), NEOCONTENT_ID, true, mServers.isOnline)
		}
		
		override protected function createLoadingSign():void{
			var ls:KraftPreloader = new KraftPreloader ();
			ls.name = "preloader";
			addChild(ls);
		}
		
		
	

		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------
		
		
	}
}