/* AS3
	Copyright 2008
*/
package com.neopets.util.managers
{
	import com.neopets.util.data.EmbedObjectData;
	import com.neopets.games.inhouse.G1156.document.BasicEmbedAssets;
	import com.neopets.games.inhouse.G1156.document.G1156_AssetDocument;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.utils.getQualifiedClassName;
	
	import mx.core.MovieClipLoaderAsset;
	
	/**
	 *	Setups all the Embeded Objects
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author Clive Henrick
	 *	@since  9.27.2009
	 */
	 
	public class EmbededObjectsManager extends EventDispatcher
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const EVENT_EMBEDED_READY:String = "TheEmbededITemsAreReady";
		public static const BASIC_STORAGE_CLASS:Class = BasicEmbedAssets;
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var mEmededClassArray:Array;
		
		protected var mEmbedDataObjectArray:Array;

		protected var mEmbedItemCount:int;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		  public function EmbededObjectsManager():void
		 {
				setupVars();	
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------

		
		public function getEmbededAssetsObject (pClass:Class):EmbedObjectData
		{
			var tCount:int = mEmbedDataObjectArray.length;
			var tEmbedObjectData:EmbedObjectData;
			
			for (var z:int = 0; z < tCount; z++)
			{
				if (EmbedObjectData(mEmbedDataObjectArray[z]).mClass == pClass)
				{
					tEmbedObjectData = EmbedObjectData(mEmbedDataObjectArray[z]);
					break;
				}
			}
			
			return 	tEmbedObjectData;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Note: This Takes Embeded Classes and Starts the Process to Get the Objects
		 * @param		evt.oData.array			Array			The Array of the embeded Classes
		 */
		 
		public function setupEmdedItems(pEmdedClassArray:Array):void
		{
			mEmededClassArray = pEmdedClassArray;
			var tCount:int = mEmededClassArray.length;
		
			var tRefMCLoaderAsset:MovieClipLoaderAsset = new mEmededClassArray[0];
			Loader(tRefMCLoaderAsset.getChildAt(0)).contentLoaderInfo.addEventListener(Event.COMPLETE,createObjects);


		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		
		
		/**
		 * @NOTE: Create Objects is used to Create a Object from an Embded Object. You must
		 * use this system if you want to type an Embed SWF to its document Class.
		 * THIS CLASS IS DESIGNED TO BE OVERRIDED in your GAME. See G1156>MANAGERS>ExtendedEmbededObjectsManager
		 */
		 
		protected function createObjects(evt:Event):void
		{
			
			var LoadedClassName:String = getQualifiedClassName(evt.target.content);
			var appDomain:ApplicationDomain = evt.target.content.loaderInfo.applicationDomain;
			var LoadedClass:Object = appDomain.getDefinition(LoadedClassName);
			
			trace("Embeded createObjects:", LoadedClass);
			
			var tEmbedData:EmbedObjectData;
			switch (LoadedClass)
			{
			
			}
			
			
			
			if (mEmbedItemCount >= mEmededClassArray.length)
			{
				this.dispatchEvent(new Event(EmbededObjectsManager.EVENT_EMBEDED_READY));
			}
			else
			{
				var tRefMCLoaderAsset:MovieClipLoaderAsset = new mEmededClassArray[mEmbedItemCount];
				Loader(tRefMCLoaderAsset.getChildAt(0)).contentLoaderInfo.addEventListener(Event.COMPLETE,createObjects);
			}
				
			}	
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		protected function setupVars():void
		{
			mEmededClassArray = [];
			mEmbedDataObjectArray = [];
			mEmbedItemCount = 0;
		}
		
		
	}
	
}
