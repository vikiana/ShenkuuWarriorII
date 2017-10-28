/* AS3
	Copyright 2009
*/
package  com.neopets.games.inhouse.G1156.gui
{
	import com.neopets.util.data.EmbedObjectData;
	import com.neopets.games.inhouse.G1156.displayObjects.Rocks;
	import com.neopets.games.inhouse.G1156.document.G1156_AssetDocument;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 *	This Controls the Rock Explosions
	 *	Please use ASDocs if you can for your notes
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern G1156
	 * 
	 *	@author Clive Henrick
	 *	@since  10.26.2009
	 */
	 
	public class RockExplosion extends Sprite 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var mArray:Array;

		protected var mAssetInstanceLibrary:G1156_AssetDocument;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function RockExplosion():void{
			super();
			setupVars();
		}
		

		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
			public function init (pAssetEmbedObj:G1156_AssetDocument):void
		{
			mAssetInstanceLibrary = pAssetEmbedObj;
		}
		
		/**
		 * @Note: Makes a Rock Explosion at the desired Location
		 * @param			pX		int			The X for the Explosion
		 * @param			pY			int			The Y for the Explosion
		 */
		 
		public function makeExplosion(pX:int, pY:int):void
		{
			
			var tRock:Rocks = mAssetInstanceLibrary.getLibraryObject("Rocks", Rocks) as Rocks;
			tRock.addEventListener(tRock.EVENT_END, onKillRock, false, 0, true);
			tRock.x = pX;
			tRock.y = pY;
			addChild(tRock);
			mArray.push(tRock);
			tRock.start();
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		protected function setupVars():void
		{
			mArray = [];	
		}
		
		protected function onKillRock(evt:Event):void
		{
			var tRock:Rocks = Rocks(evt.currentTarget);
			removeChild(tRock);
			var tIndex:int = mArray.indexOf(tRock);
			mArray.splice(tIndex);
			tRock = null;
		}
	}
	
}
