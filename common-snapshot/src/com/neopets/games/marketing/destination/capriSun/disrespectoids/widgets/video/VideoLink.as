/**
 *	This class provides listener and close button behaviour for simple pop ups.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.09.2010
 */

package com.neopets.games.marketing.destination.capriSun.disrespectoids.widgets.video
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.util.BroadcasterClip;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.util.BroadcastEvent;
	import com.neopets.games.marketing.destination.capriSun.disrespectoids.pages.VideoPage;
	import com.neopets.projects.destination.destinationV3.AbsPage;
	
	import com.neopets.util.display.IconLoader
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.general.GeneralFunctions;
	import com.neopets.util.servers.NeopetsAmfManager;
	import com.neopets.util.servers.ServerFinder;
	
	public class VideoLink extends BroadcasterClip
	{
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		public static const VIDEO_REQUESTED:String = "video_requested";
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		protected var _videoData:Object;
		protected var _IDNumber:Number;
		public var comingSoonURL:String = "/sponsors/caprisun/2010/clubhouse/trailers/comingsoon.jpg";
		// extracted information
		protected var _iconURL:String;
		protected var _videoURL:String;
		protected var _videoHeight:Number;
		protected var _videoWidth:Number;
		protected var _neocontentID:int;
		// components
		protected var _iconLoader:IconLoader;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function VideoLink():void {
			super();
			// initialize values
			_videoWidth = 480;
			_videoHeight = 270;
			initID();
			// get components
			iconLoader = getChildByName("icon_mc") as IconLoader;
			// set up broadcaster listeners
			useParentDispatcher(AbsPage);
			// set up mouse listeners
			addEventListener(MouseEvent.CLICK,onClick);
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public function get iconLoader():IconLoader { return _iconLoader; }
		
		public function set iconLoader(ldr:IconLoader) {
			_iconLoader = ldr;
			if(_iconLoader != null) {
				_iconLoader.iconHeight = _iconLoader.height;
				_iconLoader.iconWidth = _iconLoader.width;
			}
		}
		
		public function get iconURL():String { return _iconURL; }
		
		public function set iconURL(url:String) {
			if(_iconURL != url) {
				_iconURL = url;
				if(_iconLoader != null) {
					if(_iconURL != null) _iconLoader.loadFrom(url);
					else _iconLoader.clearIcon();
				}
			}
		}
		
		public function get IDNumber():Number { return _IDNumber; }
		
		public function get neocontentID():int { return _neocontentID; }
		
		override public function set sharedDispatcher(disp:EventDispatcher) {
			// clear listeners
			if(_sharedDispatcher != null) {
				_sharedDispatcher.removeEventListener(VideoPage.VIDEO_RESULT,onVideoData);
			}
			_sharedDispatcher = disp;
			_dispatcherClass = GeneralFunctions.getClassOf(_sharedDispatcher);
			// set up listeners
			if(_sharedDispatcher != null) {
				_sharedDispatcher.addEventListener(VideoPage.VIDEO_RESULT,onVideoData);
			}
		}
		
		public function get videoData():Object { return _videoData; }
		
		public function set videoData(info:Object) {
			if(info != null) {
				// extract properties from data object
				var url:String;
				var ext:String;
				if("thumb_url" in info) {
					// make sure the icon url is valid
					url = String(info.thumb_url);
					ext = GeneralFunctions.getFileExtension(url)
					if(ext != null && ext != "com") iconURL = url;
					else showComingSoon();
				}
				if("video_url" in info) {
					// make sure the video url is an flv
					url = String(info.video_url);
					if(GeneralFunctions.getFileExtension(url) == "flv") _videoURL = url;
					else _videoURL = null;
				}
				if("height" in info) _videoHeight = Number(info.height);
				if("width" in info) _videoWidth = Number(info.width);
				if("neocontent_id" in info) _neocontentID = int(Number(info.neocontent_id));
				// set button mode
				buttonMode = (_videoURL != null);
			} else {
				iconURL = null;
				_videoURL = null;
				buttonMode = false;
			}
		}
		
		public function get videoHeight():Number { return _videoHeight; }
		
		public function get videoWidth():Number { return _videoWidth; }
		
		public function get videoURL():String { return _videoURL; }
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		// Use this function to display the "coming soon" banner for unreleased videos.
		
		public function showComingSoon():void {
			var servers:ServerFinder = NeopetsAmfManager.instance.getServersFor(this);
			iconURL = servers.imageServer + comingSoonURL;
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		// Use this function to try extracting out ID number from our name.
		
		protected function initID():void {
			// extract numeric string from our name
			if(name == null) return;
			var num_list:Array = name.match(/\d+/);
			// use last number in list as our ID number
			if(num_list.length > 0) {
				var last_index:int = num_list.length - 1;
				_IDNumber = Number(num_list[last_index]);
			}
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		// When clicked on, send out video info out.
		
		protected function onClick(ev:Event) {
			if(_videoURL != null) broadcast(VIDEO_REQUESTED,this);
		}
		
		// When video data try to extract data specific to this link.
		
		protected function onVideoData(ev:CustomEvent) {
			// extract data list
			var info:Object = ev.oData;
			var entries:Array = info.videos;
			// use our ID number to find which entry we want
			if(entries.length >= _IDNumber) {
				var index:int = int(_IDNumber) - 1;
				videoData = entries[index];
			} else showComingSoon();
		}

	}
	
}