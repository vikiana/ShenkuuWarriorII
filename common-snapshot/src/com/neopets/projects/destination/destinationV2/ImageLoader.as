
/**
 *	sigleton class/design pattern
 *	This loader will laod batch of images in order (the url is given in a form of array and will return in that order)
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  07.01.2009
 */

package com.neopets.projects.destination.destinationV2
{

	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.Loader;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	//import flash.events.ErrorEvent;
	/*
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.system.ApplicationDomain;
	*/
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.util.events.CustomEvent;
	

	public class ImageLoader extends EventDispatcher{

		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		public static const IMAGES_LOADED = "all_images_are_loaded"	
		
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		private static var mReturnedInstance : ImageLoader	//singlton instance
		private var mLoader:Loader;	//loader will load images
		private var mImageArray:Array;	//loaded info (images) will be pushed here
		private var mToLoadArray:Array;	// array of image's urls to be loaded
		private var mLoading:Boolean = false	//true if the loader is loading
		
	
		
		//----------------------------------------
		//	CONSTRUCTOR
		//----------------------------------------
		
		
		public function ImageLoader(pPrivCl : PrivateClass ) 
		{
		}
		
		//----------------------------------------
		//	GETTER AND SETTER
		//----------------------------------------
		
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		
		/**
		 *	singleton instance 
		 **/
		public static function get instance( ):ImageLoader
		{
			if( ImageLoader.mReturnedInstance == null ) 
			{
				ImageLoader.mReturnedInstance = new ImageLoader( new PrivateClass( ) );
				ImageLoader.mReturnedInstance.setupLoader()
			}
			return ImageLoader.mReturnedInstance
		}
			
		/**
		 *	load images in order
		 *	@PARAM		pArray		Array		Array of image urls load
		 **/
		public function startLoading(pArray:Array):void
		{
			if (!mLoading)
			{
				//mLoader = new Loader ()
				mLoading = true
				mImageArray = []
				mToLoadArray = pArray.reverse()
				loadArray()
			}
			trace (mToLoadArray)
		}

			
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		
		/**
		 *	create a one loader to load all the images 
		 **/
		 
		private function setupLoader():void
		{
			if (mLoader == null)
			{
				trace ("image loader is set")
				mLoader = new Loader ()
			}
		}
		
		/**
		 *	load images in order, if all images are loaded, then dispatch the loaded array
		 **/
		private function loadArray():void
		{
			if (mToLoadArray.length > 0)
			{
				trace ("load array....")
				var req:URLRequest = new URLRequest (mToLoadArray.pop());
				mLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded, false, 0, true);
				mLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError, false, 0, true);
				mLoader.load(req)
			}
			else
			{
				trace ("all images are loaded")
				mLoader.unload()
				mLoading = false;
				ImageLoader.mReturnedInstance.dispatchEvent (new CustomEvent ({DATA:mImageArray}, ImageLoader.IMAGES_LOADED))
			}
		}

		
		//----------------------------------------
		//	EVENT LISTENER
		//----------------------------------------
		
		/**
		 *	once image is loaded, move on to the next one
		 **/
		private function onImageLoaded(evt:Event):void
		{
			trace (" one image is loaded")
			mImageArray.push(mLoader.content)
			mLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onImageLoaded);
			mLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			loadArray()
		}
		
		/**
		 *	should error occur, throw an error and move on 
		 **/
		private function onError(evt:IOErrorEvent):void
		{
			trace (" ErrorOccured from image loader class", evt)
			mLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onImageLoaded);
			mLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			loadArray()
		}
		
	}
}

//
class PrivateClass
{
	public function PrivateClass( )
	{
	}

} 
