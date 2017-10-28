package com.neopets.util.loading
{
	import flash.events.IEventDispatcher;
	import com.neopets.util.loading.LoadingManager;
	
	public interface ILoadingManager extends IEventDispatcher
	{
	
		function get defaultURL():String; 
		
		function set defaultURL(pDefaultURL:String):void;
		
		function get loadedItems():Array;
		
		function get activeLoading():Boolean;
		
		function get allLoaded():Boolean;
		
		function get localTestingFlag():Boolean
			
		/**
		 * @Note: Init the Loading Manager
		 * @Param		pDefaultURL		String			What goes before all the additional Items to be loaded IE: All items start with a "http://images50.neopets.com" for the URL Address
		 * @Param		pLocalTesting	String			Sets the loaderContext for the loading of files
		 * */
		
		function init (pDefaultURL:String = "http://images50.neopets.com", pLocalTesting:Boolean = true):void
		
		/**
		 * @Note	 For Adding Item to a LoadingEngine.
		 * 	@Setup List				
		 
		 * 	@param		pUrl						String			Required		Default PathWay from the Document Class to the File
		 * 	@param		pId							String			Required		What you want the Loaded to be called for reference
		 * 	@param		pApplicationdomain			String			Required		The Default ApplocationDomain For the Item
		 * 	@param		pData						Object			Optional		An Object that You can Pass infomation that you want Tied to the Loaded Object. 
		 * 	@param		pOverrideURL				String			Optional		Will Over ride the defaultURL used for loading an Object.															
		 * 	@param		pSendEvent					Boolean			Optional		Will send an event when it is loaded or initialised
		 
		 */
		
		
		function addItemToLoad(pUrl:String, pId:String, pApplicationdomain:String = "add_child", pData:Object = null, pOverrideURL:String = null, pSendEvent:Boolean = false):void
		
		/**
		 * @note	Starts to load all items in the loadList
		 */
		
		function startLoadingList():void
			
		/**
		 * @note	 Loads One Item Only from the LoadList
		 * @param	pID		String		The Id of the Item you want to Load		
		 */
		
		function loadOneItem(pID:String):void
			
		/**
		 * @Note: Unloads all the Objects for Memory CleanUp.
		 */
		
		function cleanUpAllMemory():void
			
		/**
		 * @Note: Unloads named Loader Object for Memory CleanUp.
		 * @param		pObjectID		String		The ID of an Object to be removed from the Loading Manager
		 */
		
		function deleteLoaderObj(pObjectID:String):void
			
		/**
		 * Returning an Object that has been Loaded its Name
		 * @param			pObjectName			String			Name of the Object you want returned
		 **/
		
		function getLoadedObj(pObjectID:String):* 
			
		/**
		 *  * Returning an LoadingEngine Storage Object by ObjectName
		 * @param			pObjectName			String			Name of the Object you want returned
		 **/
		
		function getLoaderObj(pObjectID:String):*
			
			
	}
}