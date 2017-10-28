/* AS3
	Copyright 2008
*/
package com.neopets.games.inhouse.G1156.managers
{
	import com.neopets.games.inhouse.G1156.document.BasicEmbedAssets;
	import com.neopets.games.inhouse.G1156.document.G1156_AssetDocument;
	import com.neopets.util.data.EmbedObjectData;
	import com.neopets.util.managers.EmbededObjectsManager;
	
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
	 
	public class ExtendedEmbededObjectsManager extends EmbededObjectsManager
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		
		protected var mAssetStorage:G1156_AssetDocument;
		protected var mBasicLoadingObjects:BasicEmbedAssets;
		
		private static const mInstance:ExtendedEmbededObjectsManager = new ExtendedEmbededObjectsManager( SingletonEnforcer);
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		  public function ExtendedEmbededObjectsManager(singletonEnforcer : Class = null):void
		 {
		 		
		 		if(singletonEnforcer != SingletonEnforcer)
		 		{
					throw new Error( "Invalid Singleton access.  Use ExtendedEmbededObjectsManager.instance." ); 
				}
				setupVars();
				
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public static function get instance():ExtendedEmbededObjectsManager
		{ 
			return mInstance;	
		} 
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		
		
		/**
		 * @NOTE: Create Objects is used to Create a Object from an Embded Object. You must
		 * use this system if you want to type an Embed SWF to its document Class.
		 */
		 
		protected override function createObjects(evt:Event):void
		{
			
			var LoadedClassName:String = getQualifiedClassName(evt.target.content);
			var appDomain:ApplicationDomain = evt.target.content.loaderInfo.applicationDomain;
			var LoadedClass:Object = appDomain.getDefinition(LoadedClassName);
			
			trace("Embeded createObjects:", LoadedClass);
			
			var tEmbedData:EmbedObjectData;
			switch (LoadedClass)
			{
				case G1156_AssetDocument:
					mAssetStorage = evt.target.content;
					mAssetStorage.setApplicationDomain(appDomain);
					tEmbedData = new EmbedObjectData(G1156_AssetDocument,mEmededClassArray[1],appDomain,mAssetStorage);
					mEmbedDataObjectArray.push(tEmbedData);
					mEmbedItemCount++;
				break;
				case BasicEmbedAssets:
					mBasicLoadingObjects = evt.target.content;
					tEmbedData = new EmbedObjectData(BasicEmbedAssets,mEmededClassArray[0],appDomain,mBasicLoadingObjects);
					mEmbedDataObjectArray.push(tEmbedData);
					mEmbedItemCount++;
				break;
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
		
		
	}
	
}

/**
 * @Note: This is to make sure there is only one version of this class at a time
 */
 
internal class SingletonEnforcer{}