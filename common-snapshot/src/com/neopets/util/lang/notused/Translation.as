package com.neopets.util.lang {
	
	//IMPORTS
	import flash.events.EventDispatcher;
	
	//METADATA
	
	/**
	* Class Description: AS3 Translation Class
 	* @author ChrisA 03/20/07
 	* holds translation variables
	*/
	

	dynamic public class Translation extends EventDispatcher {
		
		//*********************************
		//PROPERTIES
		//*********************************
		
		//SETTER/GETTER
		private var title_str: String;
		public function get title (): String { return title_str; }
		public function set title (aValue:String): void { title_str = aValue; }
		
		private var lang_str: String;
		public function get lang (): String { return lang_str; }
		public function set lang (aValue:String): void { lang_str = aValue; }	

		// KEEP THIS INFO ON THE TRANSLATION, NOT ON THE TRANSLATIONMANAGER.  tHAT WAY YOU COULD LOAD MULTIPLE-TRANS WITH DIFF LANGS, IF NEEDED - SAMR 10/05/07
		private var langGroup_str: String;
		public function get langGroup (): String { return langGroup_str; }
		public function set langGroup (aValue:String): void { langGroup_str = aValue; }	
			
		protected var translationData: TranslationData;
		public function get data (): TranslationData { return translationData; }
		public function set data (aValue:TranslationData): void { translationData = aValue; }
		
		private var itemID_uint: uint;
		public function get itemID (): uint { return itemID_uint; }
		
		private var typeID_uint: uint;
		public function get typeID (): uint { return typeID_uint; }
		
		private var _translationDataClass:Class;
		public function get translationDataClass (): Class { return _translationDataClass; }
		public function set translationDataClass (aValue:Class): void { _translationDataClass = aValue; }
		
		public var hello:String = "22";
		public var hello2:String;
		
		//*********************************
		//CONSTRUCTOR		
		//*********************************	
		public function Translation (aTypeID_uint:uint = 0, aItemID_uint:uint = 0,  aTranslationDataClass:Class = null) {
			
			typeID_uint = aTypeID_uint;	
			itemID_uint = aItemID_uint;	
			_translationDataClass = aTranslationDataClass; //tried to use this for dynamic typing, scapped that, useful? samr 01/18/08
			
			if (aTranslationDataClass != null) {		
				translationData = new aTranslationDataClass();
			}
			
		}
		
		
		//*********************************
		//METHODS
		//*********************************	
		//PUBLIC API

		// PRIVATE
		
		//*********************************
		//EVENTS
		//*********************************	
		//OUTGOING
		//INCOMING

	}
}