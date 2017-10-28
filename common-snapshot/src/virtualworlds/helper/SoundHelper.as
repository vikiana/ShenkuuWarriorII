package virtualworlds.helper
{
	import com.adobe.utils.DictionaryUtil;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import virtualworlds.helper.Fu.BaseClasses.BasicClass;
	import virtualworlds.helper.Fu.Helpers.gs.TweenFilterLite;
	import virtualworlds.helper.SoundHelperClasses.IMic;
	import virtualworlds.helper.SoundHelperClasses.SoundEmitter;
	import virtualworlds.helper.SoundHelperClasses.SoundEvent;
	
	public class SoundHelper extends BasicClass
	{
		private static const ENABLED:Boolean = true;
		
		// index of the loaded amount
		private var _index:uint = 0
		// the array of items to load
		private var _soundsArray:Array
		// the sound that is currently loading
		private var _currentLoadingSound:Sound
		// the dictionary of sound objects
		private var _soundsDictionary:Dictionary
		// the dictionary of sound objects by name
		private var _soundsDictionaryByName:Dictionary
		// the dictionary of sound objects by short name
		private var _soundsDictionaryByShortName:Dictionary
		// the current mic
		private var _currentMic:IMic
		//XML of changed sounds
		private static var soundTestData:XML = null;
		private static var assetListXML:XML = null;
		
		private var _muted:Boolean = false;
		
		private var _musicPlayingChannel1:SoundChannel
		private var _musicPlayingChannel2:SoundChannel
		
		private var _musicFade:SoundChannel
		
		public static const PLAYSOUND:String = "PLAYSOUND";
	
		public function set assetBaseURL(value:String):void { _assetBaseURL = value; };
		public function get assetBaseURL():String { return _assetBaseURL; };
		private var _assetBaseURL:String;  
		
		public function set muted(aMuteBool:Boolean):void{
			_muted = aMuteBool
			var sndTrnsform:SoundTransform
			if(_muted){
				sndTrnsform = new SoundTransform(0)
			}else{
				sndTrnsform = new SoundTransform(1)
			}
			SoundMixer.soundTransform = sndTrnsform
			
		}//end set muted()
		
		public function get muted():Boolean
		{
			return _muted;
			
		}//end get muted()
		
		public function SoundHelper()
		{
			if (!soundTestData) 
			{
				var xmlLoader:URLLoader = new URLLoader(); 
				var xmlData:XML = new XML(); 
				xmlLoader.addEventListener(Event.COMPLETE, XMLLoaded, false, 0, true);					
				xmlLoader.load(new URLRequest("config/soundList.xml")); 
			}
			if (!assetListXML)
			{
				var xmlLoaderAsset:URLLoader = new URLLoader(); 
				var xmlDataAsset:XML = new XML(); 
				xmlLoaderAsset.addEventListener(Event.COMPLETE, XMLLoadedAsset, false, 0, true);					
				xmlLoaderAsset.load(new URLRequest("config/assetList.xml")); 				
			}
			_soundsDictionary = new Dictionary()
			_soundsDictionaryByName = new Dictionary()
			_soundsDictionaryByShortName = new Dictionary()
		}
		
		private function XMLLoaded(e:Event):void
		{
			var loader:URLLoader = e.target as URLLoader;
			loader.removeEventListener(Event.COMPLETE, XMLLoaded);
			soundTestData = new XML(e.target.data);	
		}
		
		private function XMLLoadedAsset(e:Event):void
		{
			var loader:URLLoader = e.target as URLLoader;
			loader.removeEventListener(Event.COMPLETE, XMLLoadedAsset);
			assetListXML = new XML(e.target.data);	
		}
		
		
		/**
		 * returns the current mic object 
		 * @return 
		 * 
		 */		
		public function get currentMic():IMic{
			return _currentMic
		}
		
		/**
		 * plays a sound at a volume 
		 * @param aSoundName
		 * @param aVolume
		 * @return 
		 * 
		 */		
		public function playSound(aSoundName:String, aVolume:Number = 1):SoundChannel{
			if(ENABLED){
				var sndTransform:SoundTransform = new SoundTransform(aVolume)
				var snd:Sound = getSoundFromString(aSoundName)
				if(snd){
					var c:SoundChannel = snd.play(0,0,sndTransform)
				}
				return c
			}
			return null
		}
		
		public function playMusic(aSoundName:String):void{
			if(ENABLED){
				var snd:Sound = getSoundFromString(aSoundName)
				if(snd){
					if(_musicPlayingChannel1){
						_musicPlayingChannel1 = snd.play(0,9999)
					}else if(_musicPlayingChannel2){
						_musicPlayingChannel1 = snd.play(0,9999)
					}else{
						_musicPlayingChannel1 = snd.play(0,9999)
					}
					
				}
			}
		}
		
		public function crossFadeMusic(aSoundName:String, aVolume:Number):void{
			if(ENABLED){
				var snd:Sound = getSoundFromString(aSoundName)
				var st:SoundTransform
				var st2:SoundTransform
				var musicSoundTransform:SoundTransform = new SoundTransform(0.01)
				if(snd){
					if(  !_musicPlayingChannel1 || _musicPlayingChannel1.soundTransform.volume == 0){
						_musicPlayingChannel1 = snd.play(0,9999, musicSoundTransform)
						TweenFilterLite.to(_musicPlayingChannel1, 2,{volume:aVolume})
						if(_musicPlayingChannel2){
							TweenFilterLite.to(_musicPlayingChannel2, 2,{volume:0})
						}
					}else if(!_musicPlayingChannel2 || _musicPlayingChannel2.soundTransform.volume == 0 ){
						_musicPlayingChannel2 = snd.play(0,9999, musicSoundTransform)
						TweenFilterLite.to(_musicPlayingChannel2, 2,{volume:aVolume})
						if(_musicPlayingChannel1){
							TweenFilterLite.to(_musicPlayingChannel1, 2,{volume:0})
						}
					}else{
						_musicPlayingChannel1.stop()
						TweenFilterLite.to(_musicPlayingChannel2, 2,{volume:0})
						_musicPlayingChannel1 = snd.play(0,9999, musicSoundTransform)
						TweenFilterLite.to(_musicPlayingChannel1, 2,{volume:aVolume})
					}
				}
			}
		}
		
		public function fadeOutMusic():void
		{
			if(_musicPlayingChannel2){
				TweenFilterLite.to(_musicPlayingChannel2, 2,{volume:0})
			}
			
			if(_musicPlayingChannel1){
				TweenFilterLite.to(_musicPlayingChannel1, 2,{volume:0})
				
			}
		}
		

		/**
		 * returns the sound object from a string 
		 * @param aName
		 * @return 
		 * 
		 */		
		public function getSound(aName:String):Sound{
			return getSoundFromString(aName)
		}
		
		
		/**
		 * 
		 * @param	aName:	<String> name to find as a key to a Sound object.
		 * @return	<Sound> paired to aName key. <br /><br />
		 * 			<b>NOTE:</b> If the specific key aName is *NOT* in our dictionary, 
		 * 			the first key that *contains* the requested key aName is used to 
		 * 			lookup and return the Sound object.
		 */
		private function getSoundFromString(inName:String):Sound
		{
			var aName:String;
			if(soundTestData)
			{
				aName = soundTestData.sound.(@inCode == inName).attribute("actual");	
			}
			if(!soundTestData || !aName)
			{
				aName = inName;
			}
			
			var sound:Sound;
			var allKeys:Array = DictionaryUtil.getKeys(_soundsDictionaryByName);			
			do
			{
				// First place to look, in the short-name dictionary.
				sound = _soundsDictionaryByShortName[aName];
				if (sound)
				{
					// found the sound, return it.
					break;
				}
				
				// No luck in the short-name-dict, check the full-name dictionary.
				sound = _soundsDictionaryByName[aName];
				if (sound)
				{
					// found the sound, return it.
					break;
				}
				
				// Still no luck, look for a key that *contains* the requested key.
				allKeys = DictionaryUtil.getKeys(_soundsDictionaryByName);
				var tmpSndName:String;
				for (var i:int = 0; i < allKeys.length; i++)
				{
					tmpSndName = allKeys[i];
					if (!tmpSndName)
					{
						continue;
					}
					if (tmpSndName.indexOf(aName) >= 0)
					{
						// Found a key that contains the requested key, use that one, and stop looking.
						sound = _soundsDictionaryByName[tmpSndName];
						break;
					}
				}
				//if all else fails, check the assetList to ensure the sound exists
				//and make the sound out of the actual input string
				var assetData:XMLList = assetListXML.asset.(@id == aName);
				//var resourceManagerProxy:ResourceManagerProxy = PPPFacade.getInstance().retrieveProxy(ResourceManagerProxy.NAME) as ResourceManagerProxy;
				var url:String;
				if (assetData.length() > 0) {
					url = assetBaseURL + assetData.@name;
					sound = new Sound(new URLRequest(url));
					addSound(sound, aName);
					break;
				}
				assetData = assetListXML.asset.(@id == Globals.soundArrLink + aName);
				if (assetData.length() > 0) {
					url = assetBaseURL + assetData.@name;
					sound = new Sound(new URLRequest(url));
					addSound(sound, aName);
					break;
				}
				
				
			}
			while (false); // ensures that this loop only happens once.
			if (!sound)
			{
				log.warn("SoundHelper::getSoundFromString(): No sound of name " + aName + " exists.")
			}
			
			return sound;
			
		}//end getSoundFromString()
		
		
		/**
		 * sets this sound helpers mic 
		 * @param aIMic
		 * 
		 */		
		public function setMic(aIMic:IMic):void{
			_currentMic = aIMic
		}
		
		/**
		 * plays a sound from a mic aka, automatically does panning and volume based on location
		 * @param aSoundName the sound you wish to play
		 * @param aSoundPosition the position of the sound
		 * @param aRadius the radius of the sound
		 * @param aMic the mic you wish to play from (if no mic is specified in current mic)
		 * @return 
		 * 
		 */		
		
		public function playSoundFromMic(aSoundName:String, aSoundPosition:Point, aRadius:Number, aVolume:Number, aMic:IMic = null):SoundChannel{
			if(ENABLED){
				var mic:IMic
				if(aMic){
					mic = aMic
				}else{
					mic = _currentMic
				}
				if(!mic){
					return null
				}
				var maxDistance:Number = aRadius + mic.sensitivity			
				var currentDistance:Number = maxDistance - Point.distance(aSoundPosition, mic.position)
				if(currentDistance >0){
					var panDistance:Number = aSoundPosition.x - mic.position.x
					var volume:Number = currentDistance/maxDistance * aVolume
					var currentPanDistance:Number = panDistance/maxDistance
					var sndTransform:SoundTransform = new SoundTransform(volume, currentPanDistance)
					var sndChnl:SoundChannel = getSoundFromString(aSoundName).play(0,0,sndTransform)
					return sndChnl	
				}
			}
			return null
		}
		
		
		/**
		 * only used by a emitter, to start the sound and timer 
		 * @param aEmitter
		 * @param aDistance
		 * @return 
		 * 
		 */	
		 	
		public function playEmitterSound(aEmitter:SoundEmitter, aDistance:Number):SoundChannel{
			if(ENABLED){
				if(_currentMic){
					var maxDistance:Number = aEmitter.radius + _currentMic.sensitivity
					var panDistance:Number = aEmitter.position.x - _currentMic.position.x
					var volume:Number = 1-aDistance/maxDistance
					var currentPanDistance:Number = panDistance/maxDistance
					var sndTransform:SoundTransform = new SoundTransform(volume, currentPanDistance)
					var sndChnl:SoundChannel = aEmitter.soundLink.play(0,0,sndTransform)
					return sndChnl
				}
			}
			return null
		}
		
		
		/**
		 * updates a emitters sound channel 
		 * @param aEmitter
		 * @return 
		 * 
		 */		
		public function updateSoundChannel(aEmitter:SoundEmitter):SoundTransform{
			if(ENABLED){
				if(_currentMic){
					var aDistance:Number = Point.distance(_currentMic.position, aEmitter.position)
					var maxDistance:Number = aEmitter.radius + _currentMic.sensitivity
					var panDistance:Number = aEmitter.position.x - _currentMic.position.x
					
					var volume:Number = 1 - aDistance/maxDistance
					
					var currentPanDistance:Number = panDistance/maxDistance
					var sndTransform:SoundTransform = new SoundTransform(volume, currentPanDistance)
					
					return sndTransform
				}
			}
			return null
		}
		
		
		/**
		 * returns the volume from 0 - 100ish of the current output 
		 * @return 
		 * 
		 */		
		public function getCurrentVolume():Number
		{
			var totalVolume:Number = 0
			var bArray:ByteArray = new ByteArray()
			
			SoundMixer.computeSpectrum(bArray, true)
			bArray.position = 0
			
			for(var x:uint; x < 512; x++){
				totalVolume += bArray.readFloat()
			}
			
			return totalVolume
		}
		
		
		/**
		 * returns the current spectrum as a ByteArray 
		 * @return 
		 * 
		 */				
		public function getCurrentSpectrum():ByteArray
		{
			var bArray:ByteArray = new ByteArray()
			SoundMixer.computeSpectrum(bArray, false)
			bArray.position = 0
			return bArray
		}
		
		
		
		/**
		 * loads an array of sounds in the format "sounds/aSound.mp3"
		 * you can then play the sound with the full path "sounds/aSound.mp3" or the shortened name "aSound" 
		 * @param aArray
		 * 
		 */		
		public function loadSounds(aArray:Array):void{
			if (ENABLED)
				_soundsArray = aArray;
			else
				_soundsArray = new Array();
			_index = 0
			loadNextItem()
		}
		
		/**
		 * adds a interal or seperately loaded sound to the helper
		 * @param aSound the sound
		 * @param aName the name you want to call it from later
		 * 
		 */	
		public function addSound(aSound:Sound, aName:String):void{
			_soundsDictionary[aSound] = aSound
			_soundsDictionaryByName[aName] = aSound
			_soundsDictionaryByShortName[aName] = aSound
		}
		
		
		private function loadNextItem():void
		{
			if(_soundsArray[_index]){
				var url:String = assetBaseURL + _soundsArray[_index];
				_currentLoadingSound = new Sound(new URLRequest(url))
				_currentLoadingSound.removeEventListener(Event.COMPLETE, soundLoaded)
				_currentLoadingSound.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler)
				_currentLoadingSound.addEventListener(Event.COMPLETE, soundLoaded)
				_currentLoadingSound.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler)
			}else{
				var event:SoundEvent = new SoundEvent(SoundEvent.ALLITEMSLOADED, null, _index, _soundsArray.length)
				this.dispatchEvent(event)	
			}
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void{
			output(e + " Error loading sound: " + _soundsArray[_index] + " Skipping!");
			error(e + " Error loading sound: " + _soundsArray[_index] + " Skipping!");
			_index++;
			loadNextItem();
		}
		
		private function soundLoaded(e:Event):void{
			
			var p1:int = String(_soundsArray[_index]).lastIndexOf("/")
			var p2:int = String(_soundsArray[_index]).lastIndexOf(".mp3")
			var shortenedString:String
			
			if (p1 && p2) {
				shortenedString = String(_soundsArray[_index]).slice(p1+1,p2)
			}
			else if (p2){
				shortenedString = String(_soundsArray[_index]).slice(0,p2)
			}
			else {
				log.warn("Missing .mp3 on sound file: " + _soundsArray[_index])
			}
			
			_soundsDictionary[_currentLoadingSound] = _currentLoadingSound
			_soundsDictionaryByName[_soundsArray[_index]] = _currentLoadingSound
			_soundsDictionaryByShortName[shortenedString] = _currentLoadingSound

			output(shortenedString)

			var event:SoundEvent = new SoundEvent(SoundEvent.ITEMLOADED, _currentLoadingSound, _index, _soundsArray.length)
			this.dispatchEvent(event)
			
			_index++
			loadNextItem()
		}
	}
}