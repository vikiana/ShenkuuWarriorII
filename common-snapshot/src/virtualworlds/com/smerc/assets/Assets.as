package virtualworlds.com.smerc.assets
{
	import com.adobe.utils.DictionaryUtil;
	
	import flash.media.Sound;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	import org.spicefactory.lib.logging.LogContext;
	import org.spicefactory.lib.logging.Logger;
	
	/**
	* This Singleton stores sounds and swf assets in the root or seperate ApplicationDomains.
	* 
	* @author Sam
	*/
	public class Assets
	{
		protected static const log:Logger = LogContext.getLogger(Assets);
		
		private static var _instance:Assets = null;
		private static var _calledFromGetInstance:Boolean = false;
		
		// The dictionary of ApplicationDomains using a context String as keys.
		private var _contextLibrary:Dictionary;
		
		// Dictionary of sounds with String names as keys.
		private var _soundsDict:Dictionary;
		
		/**
		 * Constructor.
		 * Also constructs the internal _contextLibrary and _snoundsDict, both with weak keys.
		 */
		public function Assets()
		{
			if ( _instance || !_calledFromGetInstance) 
				throw new Error("Assets is a singleton class");
				
			_contextLibrary = new Dictionary(true);
			_soundsDict = new Dictionary(true);
			
		}//end constructor()
		
		/**
		 * Acquires the instance of this Singleton.
		 */
		public static function get instance():Assets
		{
			if ( !_instance )
			{
				_calledFromGetInstance = true;
				_instance = new Assets();
				_calledFromGetInstance = false;
			}
			
			return _instance;
		}//end get instance()
		
		/**
		 * Add a sound to this storage.
		 * 
		 * @param	a_key:	<String> to reference a sound by.
		 * @param	a_snd:	<Sound> to be stored.
		 */
		public function addSound(a_key:String, a_snd:Sound):void
		{
			_soundsDict[a_key] = a_snd;
			
		}//end addSound()
		
		/**
		 * 
		 * @param	a_key: <String> key that this sound was stored as.
		 * @return	<Sound> instance referenced at a_key, or null if one doesn't exist.
		 * 			<br/><b>NOTE:</b> If the specified key isn't in the dictionary, the sound
		 * 			with a key which *contains* the key inside of it, is returned.
		 */
		public function getSound(a_key:String):Sound
		{
			var snd:Sound = _soundsDict[a_key];
			
			if (!snd)
			{
				// search for a sound with a similar name.
				var allKeys:Array = DictionaryUtil.getKeys(_soundsDict);
				var tmpSoundName:String;
				var indexOfKey:int = -1;
				for (var i:int = 0; i < allKeys.length; i++)
				{
					tmpSoundName = allKeys[i];
					if (!tmpSoundName)
					{
						continue;
					}
					
					indexOfKey = tmpSoundName.indexOf(a_key);
					if (indexOfKey >= 0)
					{
						snd = _soundsDict[tmpSoundName];
						break;
					}
				}
			}
			
			return snd;
			
		}//end getSound()
		
		/**
		 * Get the key for where a Sound is stored.
		 * 
		 * @param	a_snd:	<Sound> To find the key for.
		 * @return			<String> Name for which a_snd is stored at.
		 */
		public function getNameForSound(a_snd:Sound):String
		{
			var soundName:String;
			
			if (!a_snd)
			{
				log.warn("Assets::getNameForSound(): a_snd=null! Returning null.");
				return null;
			}
			
			var allKeys:Array = DictionaryUtil.getKeys(_soundsDict);
			var tmpSoundName:String;
			var tmpSnd:Sound;
			var indexOfKey:int = -1;
			for (var i:int = 0; i < allKeys.length; i++)
			{
				tmpSoundName = allKeys[i];
				if (!tmpSoundName)
				{
					continue;
				}
				
				tmpSnd = _soundsDict[tmpSoundName];
				
				if (tmpSnd == a_snd)
				{
					soundName = tmpSoundName;
					break;
				}
			}
			
			return soundName;
			
		}//end getNameForSound()
		
		/**
		 * 
		 * @return	<Array> of Sound instances that have been stored here..
		 */
		public function getAllSounds():Array
		{
			return DictionaryUtil.getValues(_soundsDict);
		}//end getAllSounds()
		
		public function getAllSoundKeys():Array
		{
			return DictionaryUtil.getKeys(_soundsDict);
		}//end getAllSoundKeys()
		
		/**
		 * Stores the ApplicationDomain as a specific context.
		 * 
		 * @param	a_contextName:	String name to store a_appDomain at.
		 * @param	a_appDomain:	The ApplicationDomain to store.
		 */
		public function addNewContext( a_contextName:String, a_appDomain:ApplicationDomain ):ApplicationDomain
		{
			//
			var existingAppDomain:ApplicationDomain = _contextLibrary[a_contextName];
			if (existingAppDomain)
			{
				// An app domain at this context name already exists, return it.
				return existingAppDomain;
			}
			_contextLibrary[a_contextName] = a_appDomain;
			
			return a_appDomain;
			
		}//end addNewContext()
		
		/**
		 * 
		 * @param	a_qClassName:	String qualified classname to find in the ApplicationDomain at a_context.
		 * @param	a_context:		String context to use for acquiring the ApplicationDomain to which the class
		 * 							specified by a_qClassName is stored.
		 * 
		 * @return					Class object of the Class represented by a_qClassName within the
		 * 							ApplicationDomain specified by a_context.
		 */
		public function getAssetClass( a_qClassName:String, a_context:String = null ):Class
		{
			var appDomain:ApplicationDomain;
			
			if ( a_context )
			{
				appDomain = _contextLibrary[a_context] as ApplicationDomain;
			}
			else
			{
				appDomain = ApplicationDomain.currentDomain;
			}
			
			var classRef:Class = null;
			try
			{
				classRef = appDomain.getDefinition(a_qClassName) as Class;
			}
			catch (e:Error)
			{
				log.warn("Assets::getAssetClass(): Unable to acquire " + a_qClassName 
													+ " in context=" + a_context + "\nCaught error=" + e);
			}
			
			return classRef;
			
		}//end getAssetClass()
		
	}//end Assets
	
}//end com.smerc.assets