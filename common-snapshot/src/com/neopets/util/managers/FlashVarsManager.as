package com.neopets.util.managers
{
	import mx.core.Application;
				 
	/**
	 * This assist in setting/getting vars from the app parameters
	 * which is filled via flashvars when deployed
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th>		<th>Author</th>		<th>Description</th></tr>
	 * <tr><td>01/28/08</td>	<td>samr</td>		<td>Class created.</td></tr>
	 * </table>
	 * </p>
	 * 
	 * @example Here is a code example.  
     * <listing version="3.0" >
	 * //Code example goes here.
	 * </listing>
	 *
     * <span class="hide">Any hidden comments go here.</span>
	*/
	public class FlashVarsManager
	{		
		/**
		 * Singleton enforcing instance for <code>FlashVarsManager</code>.
		*/
		private static var _instance : FlashVarsManager;
		
		/**
		 * The variable scope to inspect for the flashvars
		*/
		private var _target : Object = null;	
		public function get flashVars () : Object { return _target; }
		
		/**
		 * Expected Flashvar variable name.
		 * 
		 * @default username 
		*/
		public static const USERNAME : String = "username";
		
		/**
		 * Expected Flashvar variable name.
		 * 
		 * @default lang 
		*/
		public static const LANG : String = "lang";
		
		/**
		 * Expected Flashvar variable name.
		 * 
		 * @default applicationMode 
		*/
		public static const APPLICATION_MODE : String = "applicationMode";		
		
		
		/**
		 * Expected Flashvar variable name.
		 * 
		 * @default applicationMode 
		*/
		public static const GATEWAY_URL : String = "gatewayURL";		
		
		
		/**
		 * Expected Flashvar v name.
		 * 
		 * @default type_id 
		*/
		public static const TYPE_ID : String = "type_id";			
		
		/**
		 * Expected Flashvar variable name.
		 * 
		 * @default item_id 
		*/
		public static const ITEM_ID : String = "item_id";		
		
		/**
		 * Expected Flashvar variable name.
		 * 
		 * @default theme_id 
		*/
		public static const THEME_ID : String = "theme_id";
				
		/**
		 * Expected Flashvar variable name.
		 * 
		 * @default property_id 
		*/
		public static const PROPERTY_ID : String = "property_id";

		//--------------------------------------
		//
		//  Public Methods
		//
		//--------------------------------------	
				
		/**
		 * Constructor
		*/
		public function FlashVarsManager (aEnforcer : SingletonEnforcer) 
		{				
			if( aEnforcer == null ){
				throw new Error("Illegal call to FlashVarsManager constructor; use FlashVarsManager.getInstance() instead");
			}
		}		

		/**
		 * Singleton Enforcing
		 *
		 * <span class="hide">Any hidden comments go here.</span>
		 * 
		 * @return FlashVarsManager
		*/
		public static function getInstance() : FlashVarsManager 
		{
			if(_instance == null){
				_instance = new FlashVarsManager ( new SingletonEnforcer() );				
			}
			return _instance;
		}
		
		/**
		 * This links manager to the flashVars available.  Must be called on ApplicationComplete (or similarly 'late' timing) to be available.
		 *
		 * <span class="hide">Any hidden comments go here.</span>
		 * 
		 * @return void
		*/
		public function initApplicationParams() : void 
		{
			if (_target == null) {
				if (Application.application.parameters != null) {
					_target = Application.application.parameters; //FLEX APPS
				} else if (Application.application.root.parameters != null) {
					_target = Application.application.parameters; //AS3 ONLY APPS (RIGHT?) -SAMR 10/05/07	
				} else {
					throw new Error ("FlashVarsManager cannot find 'parameters'");
				}
			}
		}
		
		/**
		 * Used to add in defaults expected in flashVars in the deployed/integrated application
		 *
		 * @param aVariableName_str Case-sensitive string matching the name expected from flashVars via HTML embed.
		 * @param aDefaultValue Default value to be used when flashVar is not available (i.e. desktop authoring enviorment)
		 * 
		 * @return Matches the default value
		*/
		public function addFlashVarDefault (
		      aVariableName_str : String, aDefaultValue : Object, aForceSettingOfValue_boolean : Boolean = false) : *
		{			
			// just on case
			initApplicationParams();
			
			//race ("FlashVarsManager.addFlashVarDefault ("+aVariableName_str+","+aDefaultValue+")");
			
			//IF ITS NOT PASSED IN, USE THE DEFAULT
			if (_target[aVariableName_str] == null || aForceSettingOfValue_boolean == true) {
				_target[aVariableName_str] = aDefaultValue;
			} 
			return aDefaultValue;
		}		

		/**
		 * Used to add in defaults from the URL of the swf itself.  Flashvars are preferred for embed, but when one app loads another it may
		 * pass vars on the end of the query string.  This saves the effort of parsing the URL manually and passing in via addFlashVarDefault();
		 *
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * @param aURL_str The URL to be checked.  Can't use 'this.url' from in here because that may give the wrong context right?  -samr 02/04/08
		 * 
		*/
		public function forceFlashVarDefaultsFromURL (aURL_str : String ) : void 
		{			
			// just on case
			initApplicationParams();
			
			//READ IN THE PET TO BE LOADED			
			var tokens_array: Array = aURL_str.split("?");
			if (tokens_array.length > 1) {
				var passedParameters_array : Array = (tokens_array[1] as String).split("?");
				var nameValues_array : Array;
				
				//TODO - SWFLoader.source cannot contain '&' so I used '|' for now.  a better way?  samr 02/04/08
				nameValues_array = (tokens_array[1] as String).split("&");
				if (nameValues_array.length < 2) {
					nameValues_array = (tokens_array[1] as String).split("|");
				}
				for (var pair:String in nameValues_array) {
					var nameValue_array : Array = (nameValues_array[pair] as String).split("=");
					var name : String = nameValue_array[0]
					var value : String = nameValue_array[1]
					addFlashVarDefault	(name, value,true);
				}
			} 
		}		
	}
}

// the following class enforces the singleton pattern of TranslationManager
class SingletonEnforcer {}
