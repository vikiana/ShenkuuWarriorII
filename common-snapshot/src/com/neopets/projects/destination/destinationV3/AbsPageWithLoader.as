
/**
 *	@NOTE: DO NOT USE THIS CLASSS DIRECTLY. 
 *	@NOTE: TO CREATE A "PAGE", PLEASE CREATE A CLASS AND EXTEND EITHER THIS CLASS OR "AbstractPage"
 *
 *	Extension of Abstract Page with MouseOver and MouseOut stage and built in loader system
 *	This assumes all thte art asset for each page is separted and each page has its own unique URL
 *	In this case, by loading separte art asset for separate page will shorten the loading time.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  Nov.2009
 */

	

package com.neopets.projects.destination.destinationV3
{
	
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import flash.filters.GlowFilter;
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.util.loading.LoadingManager;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.util.loading.LoadingManagerConstants;
	
	public class AbsPageWithLoader extends AbsPage {
		
		
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		public const ASSET_LOADED:String = "art_assets_for_this_page_loaded";

		
		//----------------------------------------
		//CONSTRUCTOR
		//----------------------------------------
		public function AbsPageWithLoader(pName:String = null, pView:Object = null):void 
		{
			super(pName)
			LoadingManager.instance.addEventListener(LoadingManagerConstants.LOADING_PROGRESS, onLoadingProgress, false, 0, true)
			addEventListener(MouseEvent.MOUSE_OVER, handleMouseOver, false, 0, true)
			addEventListener(MouseEvent.MOUSE_OUT, handleMouseOut, false, 0, true)
			trace (Parameters.imageURL ,!Parameters.onlineMode);
			//LoadingManager.instance.init (Parameters.imageURL ,!Parameters.onlineMode)
			if (Parameters.onlineMode)
			{
				LoadingManager.instance.init (Parameters.imageURL + "/"+ Parameters.assetPath ,!Parameters.onlineMode)
			}
			else
			{
				LoadingManager.instance.init (Parameters.assetPath ,!Parameters.onlineMode)
			}
			
			LoadingManager.instance.addEventListener(LoadingManagerConstants.LOADING_COMPLETE, onAssetLoaded, false, 0, true);
			
			//addEventListener(ASSET_LOADED, onAssetLoaded, false, 0, true)
		}		
		
		//----------------------------------------
		//GETTERS AND SETTERS
		//----------------------------------------
		
		
		
		//----------------------------------------
		//PUBLIC METHODS 
		//----------------------------------------
		
		
		//Clean up is called when it is the page is removed from the stage by DestinationControl
		public override function cleanup():void 
		{
			if (Parameters.view != null && Parameters.view.hasEventListener(AbsView.OBJ_CLICKED))
			{
				Parameters.view.removeEventListener(AbsView.OBJ_CLICKED, handleObjClick);
			}
			removeEventListener(MouseEvent.MOUSE_OVER, handleMouseOver)
			removeEventListener(MouseEvent.MOUSE_OUT, handleMouseOut)
			removeAllChildren(this)
		}
		
		//----------------------------------------
		//PROTECTED METHODS
		//----------------------------------------
		
		/**
		*
		**/
		protected function loadAsset(pUrl:String, pId:String):void
		{
			trace ("loadAsset called");
			LoadingManager.instance.addItemToLoad(pUrl, pId);
			LoadingManager.instance.startLoadingList();
		}
		
		
		// set the button frame to "out" by defult
		protected override function addImageButton (buttonClass:String, pName:String, px:Number = 0, py:Number = 0, pAngle:Number = 0, pFrame:String = null):void
		{
			var btnState:String = pFrame == null? "out": pFrame; 
			placeImageButton (buttonClass, pName, px, py, pAngle, btnState)
		}
		
		
		// set the button frame to "out" by defult
		protected override function addTextButton (buttonClass:String, pName:String,pText:String, px:Number, py:Number, pAngle:Number = 0, pFrame:String = null):void
		{
			var btnState:String = pFrame == null? "out": pFrame; 
			placeTextButton (buttonClass, pName, pText, px, py, pAngle,btnState)
		}
		
		
		
		 /**
		  *	Default is set to white glow around the display object when MouseOver.
		  *	For different effects, child class should override this function
		  *
		  *	@NOTE: This display Object must have MC within itself named "btnArea" at the top layer
		  * @NOTE: If the display Object has a "over" state (as frame lable) it'll stop at that state
		  **/
		protected function handleMouseOver(evt:MouseEvent):void
		{
			if (evt.target.name == "btnArea")
			{
				var mc:MovieClip = evt.target as MovieClip
				if (!mc.buttonMode) mc.buttonMode = true;
				MovieClip(mc.parent).gotoAndStop("over")
				MovieClip(mc.parent).filters = [new GlowFilter(0xFFFFFF, 1, 16, 16, 2, 3)]
			}
		}
		
		
	
		/**
		 *	Default is set have no filter on the display object when MouseOut.
		 *	For different effects, child class should override this function
		 *
		 *	@NOTE: This display Object must have MC within itself named "btnArea" at the top layer
		 *	@NOTE: If the display Object has a "out" state (as frame lable) it'll stop at that state
		 **/
		protected function handleMouseOut(evt:MouseEvent):void
		{
			if (evt.target.name == "btnArea")
			{
				var mc:MovieClip = evt.target as MovieClip
				MovieClip(mc.parent).gotoAndStop("out")
				MovieClip(mc.parent).filters = null
			}
		}
		
		
		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
		
				
		
		//----------------------------------------
		//EVENT LISTENER
		//----------------------------------------
		
		protected function onAssetLoaded(evt:Event):void
		{
			trace (" onAssetLoaded(), AbsPageWithLoader.as: all assets loaded, please override this if needed")
			LoadingManager.instance.removeEventListener(LoadingManagerConstants.LOADING_PROGRESS, onLoadingProgress)
			setupPage();
			LoadingManager.instance.removeEventListener(LoadingManagerConstants.LOADING_COMPLETE, onAssetLoaded);
			
		}
		
		/**
		 *	@NOTE: override this if your loading bar is progressive
		 **/
		protected function onLoadingProgress(e:CustomEvent):void
		{
			trace ("loading",e.oData.TOTAL_ITEMS, e.oData.TOTAL_LOADED, e.oData.BYTES_LOADED, e.oData.BYTES_TOTAL)
			
		}
		
	}
}
		