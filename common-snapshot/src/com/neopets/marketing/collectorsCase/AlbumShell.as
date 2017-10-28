/* AS3
	Copyright 2008
*/
package com.neopets.marketing.collectorsCase
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.events.Event;
	import com.neopets.marketing.collectorsCase.loadedData.AlbumData;
	import virtualworlds.lang.TranslationManager;
	import virtualworlds.net.AmfDelegate;
	import flash.net.Responder;
	
	/**
	 *	This class displays the info for a single collector's case item.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  10.07.2009
	 */
	public class AlbumShell extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const TRANSLATION_ID:int = 1150;
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _album:ItemAlbum;
		protected var _tabBar:TabBar;
		protected var _loadingScreen:MovieClip;
		protected var _loadList:LoaderQueue;
		protected var popUpLayer:PopUpLayer;
		protected var translator:TranslationManager;
		protected var transData:AppTranslationData;
		protected var delegate:AmfDelegate;
		protected var albumData:AlbumData;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function AlbumShell():void{
			//DebugTracer.addTextfieldTo(this,width,height); // use this to mimic traces in the browser
			loadList = new LoaderQueue();
			// set up component linkages
			_album = this["album_mc"];
			tabBar = this["tabs_mc"];
			_loadingScreen = this["loading_mc"];
			// initialize flash var tracking
			FlashVarManager.setDefault("image_server","images50.neopets.com");
			FlashVarManager.setDefault("script_server","dev.neopets.com");
			FlashVarManager.setDefault("language","en");
			FlashVarManager.initVars(root);
			// set up communication with php
			delegate = new AmfDelegate();
			delegate.gatewayURL = FlashVarManager.getURL("script_server","/amfphp/gateway.php");
		    delegate.connect();
			// ask amf-php for list of months
			var responder : Responder = new Responder(onMonthsResult, onMonthsFault);
		    delegate.callRemoteMethod("NcMallCollectorCaseService.getMonthList",responder);
		}		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get album():ItemAlbum { return _album; }
		
		public function set album(inst:ItemAlbum) {
			album = inst;
			if(_tabBar != null) _tabBar.target = album;
		}
		
		public function get loadList():LoaderQueue { return _loadList; }
		
		public function set loadList(list:LoaderQueue) {
			// clear previous loading list
			if(_loadList != null) {
				_loadList.removeEventListener(Event.COMPLETE,onLoadComplete);
			}
			// set new loading list
			_loadList = list;
			if(_loadList != null) {
				_loadList.addEventListener(Event.COMPLETE,onLoadComplete);
			}
		}
		
		public function get tabBar():TabBar { return _tabBar; }
		
		public function set tabBar(inst:TabBar) {
			// clear previous bar
			if(_tabBar != null) _tabBar.target = null;
			// set up new bar
			_tabBar = inst;
			if(_tabBar != null) {
				_tabBar.loadList = _loadList;
				_tabBar.target = album;
			}
		}
		
		/**
		 * @This function initializes our values from those of an unspecified data object.
		 * @param		info		Object 		Source of initialization values
		 */
		 
		public function initFrom(info:AlbumData):void {
			if(info == null) return;
			// initialize our album
			if(_album != null) {
				_album.loadAlbum(info);
			}
			// start loading images
			_loadList.startLoading();
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @This function broadcasts when the loader has finished it's load operation.
		 */
		
		public function onLoadComplete(ev:Event) {
			if(_loadingScreen != null) _loadingScreen.visible = false;
		}
		
		/**
		 * Amf success for getMonthList call
		*/
		public function onMonthsResult(msg:Object):void
		{
			trace("success: event: " + msg);
			// set up translation data
			translator = TranslationManager.instance;
			var lang:String = FlashVarManager.getVar("language") as String;
			transData = new AppTranslationData();
			// overwrite the default month names
			if(msg is Array) {
				var list:Array = msg as Array;
				for(var i:int = 0; i < list.length; i++) {
					transData["IDS_MONTH_"+String(i+1)] = list[i];
				}
			}
			// finish translation
			var baseURL:String = FlashVarManager.getVar("script_server") as String;
			translator.addEventListener(Event.COMPLETE,onTranslationComplete);
			translator.init(lang,TRANSLATION_ID,14,transData,baseURL);
		}
		
		/**
		 * Amf fault for getMonthList call
		*/
		public function onMonthsFault(msg:Object):void
		{
			trace("fault: event: " + msg);
			// start translation
			translator = TranslationManager.instance;
			var lang:String = FlashVarManager.getVar("language") as String;
			transData = new AppTranslationData();
			var baseURL:String = FlashVarManager.getVar("script_server") as String;
			translator.addEventListener(Event.COMPLETE,onTranslationComplete);
			translator.init(lang,TRANSLATION_ID,14,transData,baseURL);
		}
		
		/**
		 * @Wait for translation before loading the album.
		 */
		public function onTranslationComplete(ev:Event):void {
			// add pop up layer
			popUpLayer = new PopUpLayer();
			addChild(popUpLayer);
			// make amfphp call
			var responder : Responder = new Responder(onAllDataResult, onAllDataFault);
		    delegate.callRemoteMethod("NcMallCollectorCaseService.getAllCollectionsData",responder);
			// remove translation listener
			translator.removeEventListener(Event.COMPLETE,onTranslationComplete);
		}
		
		/**
		 * Amf success for getAllCollectionsData call
		*/
		public function onAllDataResult(msg:Object):void
		{
			trace("success: event: " + msg);
			albumData = new AlbumData();
			albumData.initFrom(msg);
			// make a second pass to load user specific data
			var responder : Responder = new Responder(onUserDataResult, onUserDataFault);
		    delegate.callRemoteMethod("NcMallCollectorCaseService.getUserCollections",responder);
		}
		
		/**
		 * Amf fault for getUserCollectionsData call
		*/
		public function onAllDataFault(msg:Object):void
		{
			trace("fault: event: " + msg);
			albumData = new AlbumData();
			albumData.useTestValues();
			initFrom(albumData);
		}
		
		/**
		 * Amf success for getUserCollectionsData call
		*/
		public function onUserDataResult(msg:Object):void
		{
			trace("success: event: " + msg);
			if(albumData != null) {
				albumData.initUser(msg);
				initFrom(albumData);
			}
		}
		
		/**
		 * Amf fault for getAllCollectionsData call
		*/
		public function onUserDataFault(msg:Object):void
		{
			trace("fault: event: " + msg);
			if(albumData != null) initFrom(albumData);
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}