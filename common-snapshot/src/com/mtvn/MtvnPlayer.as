package com.mtvn {

	import flash.display.*;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.geom.Rectangle;
	import flash.system.*;
	
	public class MtvnPlayer extends Sprite {		
		public static var PLAYER_LOADED_AND_READY:String = "mtvn.player.loaded.and.ready";
		public static var VIDEO_STARTED:String = "mtvn.player.video.started";
		public static var VIDEO_STATE_CHANGE:String = "mtvn.player.video.state.change";
		public static var VIDEO_ENDED:String = "mtvn.player.video.ended";
		public static var PLAYHEAD_UPDATE:String = "mtvn.player.playhead.update";
		public static var PLAYLIST_COMPLETE:String = "mtvn.player.playlist.complete";
				
		private var _player:*;
		private var _app:*;		
		private var _playerContainer:DisplayObject;
		private var _isPlayingAd:Boolean = false;
		private var _screenWidth:Number;
		private var _screenHeight:Number;
		private var _playerRec:Rectangle;
		private var _configUrl:String;
		private var _loaderSwfUrl:String;		
		private var _playerLoader:Loader;
		
		public function MtvnPlayer(w:int, h:int, loaderSwfUrl, configFileUrl) {
			_screenWidth = w;
			_screenHeight = h;
			_playerRec = new Rectangle(0, 0, _screenWidth, _screenHeight);
			_configUrl = configFileUrl;
			_loaderSwfUrl = loaderSwfUrl;
			loadPlayer();
		}
		
		public function getPlayer():* {
			return _player;
		}
		
		private function loadPlayer():void {
			_playerLoader = new Loader();
			_playerLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onPlayerSwfLoadComplete, false, 0, true);		
			_playerLoader.x = _playerRec.x;
			_playerLoader.y = _playerRec.y;

			addChild(_playerLoader);
			_playerLoader.load(new URLRequest(_loaderSwfUrl + "?CONFIG_URL=" + escape(_configUrl)), new LoaderContext(true, ApplicationDomain.currentDomain, SecurityDomain.currentDomain));	
		};
		
		public function removeEvents():void {
			trace('removing events');
			_player.removeEventListener("ready", onPlayerReady);
			_player.removeEventListener("playheadUpdate", onPlayheadUpdate);
			_player.removeEventListener("media ended", onMediaEnded);
			_player.removeEventListener("adPackageLoaded", onAdPackageLoaded);
			_player.removeEventListener("stateChange", onStateChange);
			_player.removeEventListener("playlist complete", onPlaylistComplete);
			//_player.removeEventListener("playlist error", onPlaylistError);
			//_player.removeEventListener("metadata", onMediaMetadata);
			_player.removeEventListener("noAd", onNoAd); 
			_playerLoader.unload();
			removeChild(_playerLoader);
			trace(_player);
			_player = null;
			_app = null;		
			_playerContainer = null;
			_isPlayingAd = false;
			_screenWidth = null;
			_screenHeight = null;
			_playerRec = null;
			_configUrl = null;
			_loaderSwfUrl = null;
		}
		private function onPlayerSwfLoadComplete(e:Event):void {
			_playerContainer = (e.target as LoaderInfo).content as DisplayObject;
			_playerContainer.x = _playerRec.x;
			_playerContainer.y = _playerRec.y;
			_playerContainer.addEventListener("applicationComplete", onPlayerApplicationComplete, false, 0, true);
			_playerContainer.addEventListener("applicationComponentsLoaded", onPlayerApplicationComponentsLoaded, false, 0, true);
		};

		private function onPlayerApplicationComplete(e:Event):void {
			e.target.removeEventListener("applicationComplete", onPlayerApplicationComplete);			
			_app = e.target.application as DisplayObject;
			_app.width = _playerRec.width;
			_app.height = _playerRec.height;
		};
		
		private function onPlayerApplicationComponentsLoaded(e:Event):void {
			e.target.removeEventListener("applicationComponentsLoaded", onPlayerApplicationComponentsLoaded);
			_player = e.target.player;
			_player.addEventListener("ready", onPlayerReady, false, 0, true);
			_player.addEventListener("playheadUpdate", onPlayheadUpdate, false, 0, true);
			_player.addEventListener("media ended", onMediaEnded, false, 0, true);
			_player.addEventListener("adPackageLoaded", onAdPackageLoaded, false, 0, true);
			_player.addEventListener("stateChange", onStateChange, false, 0, true);
			_player.addEventListener("playlist complete", onPlaylistComplete, false, 0, true);
			//_player.addEventListener("playlist error", onPlaylistError, false, 0, true);
			//_player.addEventListener("metadata", onMediaMetadata, false, 0, true);
			_player.addEventListener("noAd", onNoAd, false, 0, true);
			dispatchEvent(new Event(PLAYER_LOADED_AND_READY, true));
		}
		
		public function killStream():void {
			_player.pauseVideo();
			_player.removeEventListener("ready", onPlayerReady);
			_player.removeEventListener("playheadUpdate",onPlayheadUpdate);
			_player.removeEventListener("media ended", onMediaEnded);
		}
		
		private function onPlayerReady(e:*):void {
			dispatchEvent(new Event(VIDEO_STARTED, true));
		}
		
		private function onStateChange(e:*):void {
			trace('state change HERE');
			trace(e);
			dispatchEvent(new Event(VIDEO_STATE_CHANGE, true));
		}		
		
		private function onMediaEnded(e:*):void {
			trace('media ended HERE');
			dispatchEvent(new Event(VIDEO_ENDED, true));
		}
		
		private function onPlayheadUpdate(e:*):void {
			dispatchEvent(new Event(PLAYHEAD_UPDATE, true));
		}
		
		private function onPlaylistComplete(e:*):void {
			trace('playlist done HERE');
			dispatchEvent(new Event(PLAYLIST_COMPLETE, true));
		}		

		public function isAd():Boolean {
			return _player.metadata.isAd;
		}

		public function isBumper():Boolean {
			return _player.metadata.isBumper;
		}

		public function pauseVideo():void {
			_player.pause();
		}
		
		public function resumeVideo():void {
			_player.play();
		}
		
		public function getPlayheadTime():Number {
			return _player.playheadTime;
		}
		
		public function getCurrentVideoDuration():Number {
			return _player.metadata.duration;
		}
		
		public function seek(n:Number):void {
			_player.playheadTime = n;
		}
		
		public function getVolume():Number {
			return _player.volume;
		}	

		public function setVolume(level:Number):void {
			_player.volume = level;
		}
		
		 public function mutePlayer():void {
			_player.mute();
		}
		public function unmutePlayer():void {
			_player.unmute();
		} 

		public function maintainAspectRatio(b:Boolean):void {
			_player.maintainAspectRatio = b;
		}
		public function getPlayerState():String {
			return _player.playState;
		}
		public function resize(w:Number, h:Number):void {
			_player.resize(w, h);
			_playerRec.width = w;
			_playerRec.height = h;
			_app.width = _playerRec.width;
			_app.height = _playerRec.height;
		}
		public function playURI(s:String):void {
			_player.playUri(s);
		}		
		
		private function onNoAd(e:*):void {
			 trace("onNoAd");	
		}

		private function onAdPackageLoaded(e:*):void {	
			 trace("onAdPackageLoaded");
		}
		
		private function getCMSIDfromGUID(s:String):String {
			var a:Array = s.split(":");			
			var cmsid:String = a[a.length-1];
			return cmsid;
		}
				
		public function isPlayerMuted():Boolean {
			return _player.isMuted;
		}
		public function nextVideo():void {
			_player.next();
		}
		public function previousVideo():void {
			_player.previous();
		}
		public function playIndex(n:Number):void {
			_player.playIndex(n, 0);
		}
		public function getCurrentPlaylistIndex():int {
			return _player.playlist.index;
		}
		public function getCurrentVideoId():String {
			return getCMSIDfromGUID(_player.metadata.guid);
		}
		public function getCurrentVideoTitle():String {
			return _player.metadata.title;
		}
		public function getCurrentVideoDescription():String {
			return _player.metadata.description;
		}

	}
}