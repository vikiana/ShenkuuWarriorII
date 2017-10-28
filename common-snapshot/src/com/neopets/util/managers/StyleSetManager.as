//Marks the right margin of code *******************************************************************
package com.neopets.util.managers
{
	//--------------------------------------
	//  Imports
	//--------------------------------------
	import com.neopets.events.StyleSetManagerEvent;
	import com.neopets.system.Server;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Security;
	
	import mx.styles.StyleManager;
	
	
	
	//--------------------------------------
	//  Class
	//--------------------------------------
	/**
	 * Loads a series of CSS swfs to style the applications fonts, skins, themes
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>02/08/09</td><td>samr</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 * 
	 * @example Here is a code example.  
     * <listing version="3.0" >
		//1
		private var _styleSetManager:StyleSetManager = StyleSetManager.getInstance(); //grabs 'global' lang value from PHP automatically
		
		//2
		_styleSetManager.addEventListener (StyleSetManagerEvent.ON_LOAD, onStyleSetManagerLoaded);
		
		//3
		_styleSetManager.loadStyleSet (StyleSetManager.TYPE_ID_CONTENT, TRANSLATION_ITEM_ID, StyleSetManager.THEME_ID_DEFAULT);
		
		//4
		public function onStyleSetManagerLoaded (aEvent: StyleSetManagerEvent) : void 
		{
			//really you do nothing, the styles are already kicked in by now
		}

	 * </listing>
	 *
     * <span class="hide">Any hidden comments go here.</span>
     *
	*/
	public class StyleSetManager extends EventDispatcher 
	{		
		
		//--------------------------------------
		//  Properties
		//--------------------------------------
		//PUBLIC GETTER/SETTERS
		/**
		 * The langcode to be loaded (ex. EN)
		 * 
		*/		
		private var _lang_str : String;
		public function set lang (aArgument : String) : void {  _lang_str = aArgument; }
		public function get lang () : String { return _lang_str; }
		
		/**
		 * The project item ID to be loaded (ex. 1135)
		 * 
		*/		
		private var _itemID_uint : uint;
		public function set itemID (aArgument : uint) : void {  _itemID_uint = aArgument; }
		public function get itemID () : uint { return _itemID_uint; }
		
		/**
		 * The project type ID to be loaded (ex. 4)
		 * 
		*/		
		private var _typeID_uint : uint;
		public function set typeID (aArgument : uint) : void {  _typeID_uint	 = aArgument; }
		public function get typeID () : uint { return _typeID_uint; }			

		
		/**
		 * The project theme ID to be loaded (ex. 0) Not used yet.  Future feature
		 * 
		*/		
		private var _themeID_uint : uint;
		public function set themeID (aArgument : uint) : void {  _themeID_uint = aArgument; }
		public function get themeID () : uint { return _themeID_uint; }

		
		//PUBLIC CONST
		/**
		 * This is the typical format of a simple comment for <code>PUBLIC_STATIC_CONSTANT</code>.
		 * 
		 * @default PUBLIC_STATIC_CONSTANT 
		*/
		public static const TYPE_ID_CONTENT : uint = TranslationManager.TYPE_ID_CONTENT
		
		
		/**
		 * This is the typical format of a simple comment for <code>PUBLIC_STATIC_CONSTANT</code>.
		 * 
		 * @default PUBLIC_STATIC_CONSTANT 
		*/
		public static const TYPE_ID_GAME : uint = TranslationManager.TYPE_ID_GAME;	
		
		/**
		 * This is the typical format of a simple comment for <code>PUBLIC_STATIC_CONSTANT</code>.
		 * 
		 * @default PUBLIC_STATIC_CONSTANT 
		*/
		public static const THEME_ID_DEFAULT : uint = 0; //means 'regular theme' (or maybe no theme?)
		
		
		//PRIVATE
		/**
		 * TranslationManager
		*/
		private var _translationManager						: TranslationManager = TranslationManager.getInstance();	
		
		/**
		 * Singleton enforcing
		*/
		private static var _instance						: StyleSetManager;

		/**
		 * XML object to hold the list of style URLS
		*/
		private static var _styleSetDefinition_xml			: XML;
		
		/**
		 * Loader to call the for the style urls
		*/
		private static var _styleSetDefinition_urlloader	: URLLoader;
			
		/**
		 * Currently loaded tier (4 total) 
		*/
		private static var _currentStyleSetTierIndex_uint	: uint;		
		
		
		/**
		 * Optionally this can be passed in and used INSTEAD of the external XML, 
		 * this is useful during development -samr 05/05/08
		*/		
		private	var _internalStylesURLS_array:Array;
		
		//--------------------------------------
		//  Constructor
		//--------------------------------------
		/**
		 * This is the typical format of a simple multiline comment
		 * such as for a <code>TemplateClass</code> constructor.
		 *
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * @param param1 Describe param1 here.
		 * @param param2 Describe param2 here.
		*/
		public function StyleSetManager (aEnforcer : SingletonEnforcer) 
		{	
		
			//SINGLETON
			if(aEnforcer == null){	throw new Error("Illegal call to StyleSetManager constructor; use StyleSetManager.getInstance() instead");}
			
			
			//VARIABLES
			
			//PROPERTIES
			_styleSetDefinition_xml = new XML( );
			_styleSetDefinition_urlloader = new URLLoader ();
			_lang_str = _translationManager.getLang(); 
			
			//METHODS
			
			//EVENTS

		}
		
		
		//--------------------------------------
		//  Methods
		//--------------------------------------		
		//PUBLIC	
		/**
		 * Singleton enforcing
		 *
		 * <span class="hide">Any hidden comments go here.</span>
		 * 
		 * @return StyleSetManager
		*/
		public static function getInstance() : StyleSetManager 
		{
			if(_instance == null){ 
				_instance = new StyleSetManager ( new SingletonEnforcer() );	
			}
			return _instance;
		}
		
		
		/**
		 * Use offline urls (for development) for the 4 tiers for a given project.
		 *
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * @param aInternalStylesURLS_array The array of style urls to call
		 * 
		 * @return void
		*/
		public function loadStylesFromInternalStyleSet (aInternalStylesURLS_array : Array) : void 
		{
			_internalStylesURLS_array = aInternalStylesURLS_array;
			
			//LOAD STYLESET
			loadStyleSetDefinition();

		}
		
		
		/**
		 * Load in and activate the full 4 tier styleset for a given project.
		 *
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * @param aTypeID_num The translation system type id of the project. (e.x. 4)
		 * @param aItemID_num The translation system item id of the project. (e.x. 1135)
		 * @param aThemeID_num The Style systems theme (0 for now) - future feature
		 * 
		 * @return void
		*/
		public function loadStylesFromExternalStyleSet (aTypeID_uint : uint, aItemID_uint : uint, aThemeID_uint : uint) : void 
		{
			_typeID_uint	 = aTypeID_uint;
			_itemID_uint	 = aItemID_uint;
			_themeID_uint	 = aThemeID_uint; 
			
			//LOAD STYLESET
			loadStyleSetDefinition();

		}
		
		
		/**
		 * Reload styleset.  (if internal settings, like lang, have changed it'll load new stuff,)
		 *
		 * <span class="hide">Any hidden comments go here.</span>
		 * 
		 * @return void
		*/
		public function reloadStyleSet () : void 
		{
			loadStyleSetDefinition();			
		}
		
		/**
		 * unLoad in and deactivate any current styles
		 *
		 * <span class="hide">Any hidden comments go here.</span>

		 * @return void
		*/
		public function unloadStyleSets () : void 
		{
			
			//styleset may be loaded internally for early development, or 
			//externally for live users (the desired default) - samr 05/05/08
			_currentStyleSetTierIndex_uint = 0;
			var styleURLs_array : Array;
			if (_internalStylesURLS_array) {				
				styleURLs_array = _internalStylesURLS_array;
			} else {
				styleURLs_array = _styleSetDefinition_xml.children()
			}
			
			//LOOP THROUGH AND UNLOAD
			for each (var styleURL_str : String in styleURLs_array) {
				
				try {
					StyleManager.unloadStyleDeclarations(styleURL_str, true);
					trace ("unloading: " + styleURL_str);
				} catch (e: Error) {
					trace (e);
				}
			}
			
			//DONE
			dispatchUnload();
			
		}
		
		//PRIVATE	

		/**
		 * Load the xml data for the style set definition (the urls for the 4 tiers)
		 *
		 * <span class="hide">Any hidden comments go here.</span>
		 * 
		 * @return void
		*/
		private function loadStyleSetDefinition () : void 
		{

			_styleSetDefinition_urlloader.addEventListener(Event.COMPLETE, onStyleSetDefinitionLoad);
			_styleSetDefinition_urlloader.addEventListener("fault", onStyleSetDefinitionFault);
			//todo ,add the real final url - samr 02/08/08
			
			var styleSetURL_str : String = Server.getWebServer() + "/style_set_manager/production/styleset_1135_4_0_en.xml";
			trace ("loadStyleSetDefinition() from" + styleSetURL_str);
			_styleSetDefinition_urlloader.load( new URLRequest( styleSetURL_str	));		
				
		}	
		
		/**
		 * Load the 4 tiers swfs.  As each loads it will automatically 'kick in' effecting the visuals of the app
		 *
		 * <span class="hide">Any hidden comments go here.</span>
		 * 
		 * @return void
		*/
		private function loadStyleSets () : void 
		{
			_currentStyleSetTierIndex_uint = 0;
			loadNextStyleSet ();	
		}
			
		/**
		 * Load the 4 tiers swfs.  As each loads it will automatically 'kick in' effecting the visuals of the app
		 *
		 * <span class="hide">Any hidden comments go here.</span>
		 * 
		 * @return void
		*/
						
		private function loadNextStyleSet () : void 
		{
			//styleset may be loaded internally for early development, or 
			//externally for live users (the desired default) - samr 05/05/08
			var styleURL_str : String = "";
			var maxTiers_uint : uint;
			if (_internalStylesURLS_array) {
				
				styleURL_str =  _internalStylesURLS_array[_currentStyleSetTierIndex_uint];
				maxTiers_uint = _internalStylesURLS_array.length;

			} else {
				
				styleURL_str = _styleSetDefinition_xml.children()[_currentStyleSetTierIndex_uint]
				maxTiers_uint = _styleSetDefinition_xml.children().length;
			}
				
			if (_currentStyleSetTierIndex_uint < maxTiers_uint) {
					
				try {
					//LOAD ONE MORE
					StyleManager.loadStyleDeclarations(styleURL_str);
				} catch (e: Error) {
					//needs work to do anything 
				}
				
				_currentStyleSetTierIndex_uint++;
				loadNextStyleSet();
			} else {
				//ALL LOADING IS DONE
				dispatchLoad(); 
			}
			
		}
		//--------------------------------------
		//  Events
		//--------------------------------------		
		//EventDispatchers
		/**
		 * Dispatches the StyleSetManagerEvent.ON_LOAD upon load success.
		*/
		[Event(name="ON_LOAD", type="com.neopets.events.StyleSetManagerEvent")]
		public function dispatchLoad () : void 
		{	
			dispatchEvent( new StyleSetManagerEvent( StyleSetManagerEvent.ON_LOAD, true, false ) );
		}	
		
		/**
		 * Dispatches the StyleSetManagerEvent.ON_FAULT upon load failure.
		*/
		[Event(name="ON_FAULT", type="com.neopets.events.StyleSetManagerEvent")]
		public function dispatchFault () : void 
		{	
			dispatchEvent( new StyleSetManagerEvent( StyleSetManagerEvent.ON_FAULT, true, false ) );
		}	

		/**
		 * Dispatches the StyleSetManagerEvent.ON_LOAD upon load success.
		*/
		[Event(name="ON_UNLOAD", type="com.neopets.events.StyleSetManagerEvent")]
		public function dispatchUnload () : void 
		{	
			dispatchEvent( new StyleSetManagerEvent( StyleSetManagerEvent.ON_UNLOAD, true, false ) );
		}
		
		//EventHandlers
		/**
		 * Handles the LoadEvent.LOAD event when the url xml comes in
		*/
		private function onStyleSetDefinitionLoad (aEvent : Event) : void 
		{			
			
			_styleSetDefinition_xml = new XML ((aEvent.target as URLLoader).data);
			trace ("onStyleSetDefinitionLoad: " + _styleSetDefinition_xml);	
			
			//
			loadStyleSets();
		}
		
		/**
		 * Handles the LoadEvent.FAULT 
		*/
		private function onStyleSetDefinitionFault (aEvent : Event) : void 
		{				
			trace ("onStyleSetDefinitionLoad: fault!");
		}
		
		
		
		
		
	}
}
	
	
//ENFORCES THE SINGLETON PATTERN
class SingletonEnforcer {}


/*

		public function reloadStyleDeclarationsSet () : void {
			
			Server.addAllAllowedDomains();
			try {
				StyleManager.loadStyleDeclarations(	URL, true, false);
				var tSWFLoader:SWFLoader = new SWFLoader ();
				tSWFLoader.addEventListener(Event.COMPLETE,onSWFLoaderComplete);
				tSWFLoader.load(URL);
			} catch (e:Error) {
				trace (e);	
						
			}	
		}


		public var tierIndex_num:Number = 1;
		//PRIVATE
		private function getStyleDeclarationsURL () : String {
			
			var tURL_str:String;
			
			//tURL_str =  Server.getWebServer()+"/transcontent/swf_css_loader.php" ;
			//tURL_str = "http://dev.neopets.com/transcontent/css/desktop_compiled/styles_EN_v1.swf";
			tURL_str = "./css/tiers/tier" + tierIndex_num  + "/styles_EN_v1.swf";
			
			if (Server.isFileOnline()) {
				tURL_str += getArgumentSuffix();
			}
			return tURL_str;			
			
		}
		
		private function getArgumentSuffix () : String {	
			return "?type_id=" + typeID_num+ "&item_id=" + itemID_num+ "&theme_id=" + themeID_num+ "&lang=" + lang_str + "";
		}
		
		

		public function onSWFLoaderComplete (aEvent:Event) : void {
			trace ("loaded!");
		}
		
		//OUTGOING

	
	}
}
*/
