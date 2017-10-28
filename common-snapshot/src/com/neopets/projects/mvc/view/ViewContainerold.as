/* AS3
	Copyright 2008
*/
package com.neopets.projects.mvc.view
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;

	
	
	/**
	 *	This is a Container for Display Elements This is a Way to Controll Many Different Display Items in 
	 *  a Display Container.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author Clive Henrick
	 *	@since  12.03.08
	 */
	 
	public class ViewContainerold extends Sprite 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var mID:String;
		private var mDisplayObjectList:Array;
		private var mDisplayLayer:uint;
		private var mStartPoint:Point;
		private var mStartVisibility:Boolean;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 * 	@param		pID		String		The ID of the View Container
		 */
		public function ViewContainerold(pID:String = ""):void
		{
			setupVars();
			mID = pID;
		}
		
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------

		public function get ID ():String
		{
			return mID;
		}
		
		public function set ID (pString:String):void
		{
			mID = pString;
		}
		
		public function get displayLayer():uint
		{
			return mDisplayLayer;
		}
		
		public function set displayLayer(pLayer:uint):void
		{
			mDisplayLayer = pLayer;
		}
		
		public function get startPoint():Point
		{
			return mStartPoint;
		}
		
		public function set startPoint(pStartP:Point):void
		{
			mStartPoint = pStartP;
		}
		
		public function get startVisibility():Boolean
		{
			return mStartVisibility;
		}
		
		public function set startVisibility(pFlag:Boolean):void
		{
			mStartVisibility = pFlag;
			
			if (!pFlag) this.visible = false;
		}
		
		public function get displayOrder():Array
		{
			return mDisplayObjectList;
		}
		
		public function get displayObjectList():Array
		{
			return mDisplayObjectList;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 *	@Removes a Reference Object of the mDisplayObjectList
		 * 	@param		pID		String		The ID of the DisplayObject
		 */
		 
		public function removeUIDisplayObject(pID:String):void
		{
			var tLength:uint = mDisplayObjectList.length;
			var tUIObject:Object = {};
			
			for (var t:uint = 0; t < tLength; t++)
			{
				if (mDisplayObjectList[t].hasProperty("ID"))
				{
					if (mDisplayObjectList[t].ID == pID)
					{
						
						if (mDisplayObjectList[t].SWF == null || mDisplayObjectList[t].SWF == undefined)
				 		{
				 			this.removeChild(mDisplayObjectList[t].VIEWCONTAINER);	
				 		} 
				 		else 
				 		{
				 			this.removeChild(mDisplayObjectList[t].SWF);	
				 			
				 		}
				 		
				 		mDisplayObjectList.splice(t,1);
			 		}
				}
			}	
		}
		
		
		/**
		 *	@Returns a Reference Object of the mDisplayObjectList
		 * 	@param		pID		String		The ID of the DisplayObject
		 */
		
		public function getUIObject(pID:String):Object
		{
			var tLength:uint = mDisplayObjectList.length;
			var tUIObject:Object = {};
			
			for (var t:uint = 0; t < tLength; t++)
			{
				if (mDisplayObjectList[t].ID == pID)
				{
					tUIObject =  mDisplayObjectList[t];
					break;
				}
			}
			
			return tUIObject;
		}
		
		/**
		 *	@Returns a Reference (SWF) of the DisplayObject in the DisplayList
		 * 	@param		pID					tring				The ID of the DisplayObject
		 */
		
		public function getUIDisplayObject(pID:String):DisplayObject
		{
			var tLength:uint = mDisplayObjectList.length;
			var tDisplayObj:DisplayObject = new DisplayObject();
			
			for (var t:uint = 0; t < tLength; t++)
			{
				if (mDisplayObjectList[t].ID == pID)
				{
				
					if (mDisplayObjectList[t].SWF == null || mDisplayObjectList[t].SWF == undefined)
			 		{
			 			tDisplayObj = mDisplayObjectList[t].VIEWCONTAINER;	
			 		} 
			 		else 
			 		{
			 			tDisplayObj = mDisplayObjectList[t].SWF;
			 		}
					
					break;
				}
			}
			
			return tDisplayObj;
		}
		
		/**
		 * ReOrders the DisplayList so all Objects are in the Correct DisplayOrder
		 * */
		 
	 	 public function reOrderDisplayList():void
			 {
			 	var tLength:int = mDisplayObjectList.length;
			 	
			 	//Quick Exit for Easy Loops
			 	if (tLength == 1)
			 	{
			 		return;
			 	}
			 	
			 	mDisplayObjectList.sortOn("DLINDEX",Array.NUMERIC);
			 	
			 	//Clear the displayList
			 	while (this.numChildren >0)
			 	{
			 		this.removeChildAt(0);
			 	}
			 	
			 	//Add Back to the Display List
			 	
			 	for (var t:uint = 0; t < tLength; t++)
			 	{
			 		if (mDisplayObjectList[t].SWF == null || mDisplayObjectList[t].SWF == undefined)
			 		{
			 			this.addChild(mDisplayObjectList[t].VIEWCONTAINER);	
			 		} 
			 		else 
			 		{
			 			this.addChild(mDisplayObjectList[t].SWF);	
			 			
			 		}
			 
			 	}
			 	
			 }
		
		/** 
		 * @Note: This Moves One DisplayElement to the Top of the DisplayList
		 * @param		id		String		The Name of the DisplayItem
		 */
		 
		
		public function moveToTopByID(id:String):void
		{
			
			for (var i:uint = 0; i< mDisplayObjectList.length; i++){
				
				if (mDisplayObjectList[i].ID == id)
				{
				
					mDisplayObjectList[i].DLINDEX = this.numChildren +1;
					var tLength:int = mDisplayObjectList.length;
			 	
				 	//Quick Exit for Easy Loops
				 	if (tLength == 1)
				 	{
				 		return;
				 	}
				 	
				 	mDisplayObjectList.sortOn("DLINDEX",Array.NUMERIC);
				 	
				 	//Clear the displayList
				 	while (this.numChildren >0)
				 	{
				 		this.removeChildAt(0);
				 	}
				 	
				 	//Add Back to the Display List
				 	
				 	for (var t:uint = 0; t < tLength; t++)
				 	{
				 		if (mDisplayObjectList[t].SWF == null || mDisplayObjectList[t].SWF == undefined)
				 		{
				 			this.addChild(mDisplayObjectList[t].VIEWCONTAINER);	
				 		} 
				 		else 
				 		{
				 			mDisplayObjectList[t].DLINDEX = t;
				 			this.addChild(mDisplayObjectList[t].SWF);	
				 		}
				 
				 	}
					break;
				}
			}
			
		}
		
		/**
		 *	@Adds an MovieClip to an Item in this View Container
		 *  @param		pMCtoAdd			MovieClip			For adding a MovieClip to the DisplayList
		 *  @param		pOrder				uint				The order of this containers DisplayList
		 * 	@param		id					string				The ID of the DisplayObject to be added
		 * 	@param		pX					Number				The Starting Location X
		 *  @param		pY					Number				The Starting Location Y
		 */
		 
		public function addChildToMC(id:String, pMCtoAdd:MovieClip, pX:Number, pY:Number):void
		{
			
			for (var i:uint = 0; i< mDisplayObjectList.length; i++){
				
				if (mDisplayObjectList[i].ID == id)
				{
					pMCtoAdd.x = pX;
					pMCtoAdd.y = pY;
					mDisplayObjectList[i].SWF.addChild(pMCtoAdd);
				}
			}
			
		}
		
		/**
		 *	@Adds another View Container to this View Container
		 *  @param		pMediatorVC			ViewContainer		For adding a View Container to the DisplayList
		 *  @param		pOrder				uint				The order of this containers DisplayList
		 * 	@param		pID					string				The ID of the DisplayObject
		 * 	@param		pPoint				Point				The Starting Location
		 */
		 
		public function addUIViewContainer(pMediatorVC:ViewContainerold,pOrder:uint,pID:String,pPoint:Point = null,pVisibiltyFlag:Boolean = true):void
		{
			
			var tUI:Object = {VIEWCONTAINER:pMediatorVC,DLINDEX:pOrder,ID:pID};
			mDisplayObjectList.push(tUI);
			
			if (pPoint != null)
			{
				pMediatorVC.x = pPoint.x;
				pMediatorVC.y = pPoint.y;	
			}
			
			if (pVisibiltyFlag == false)
			{
				pMediatorVC.visible = false;	
			}
			
			addChild(pMediatorVC);	
		}
		
		
		/**
		 *	@Adds DisplayObjects to itself
		 *  @param		pDisplayObject		DisplayElement		Any DisplayElement
		 *  @param		pOrder				uint				The order of this containers DisplayList
		 * 	@param		pID					String				The ID of the DisplayObject
		 * 	@param		pPoint				Point				The Starting Location of the Object
		 */
		 
		 
		public function addDisplayObjectUI(pDisplayObject:DisplayObject,pOrder:uint,pID:String,pPoint:Point = null,pVisibiltyFlag:Boolean = true):void
		{
			
			var tUI:Object = {SWF:pDisplayObject,DLINDEX:pOrder,ID:pID,POINT:pPoint};
			mDisplayObjectList.push(tUI);
			
			if (pPoint != null)
			{
				pDisplayObject.x = pPoint.x;
				pDisplayObject.y = pPoint.y;	
			}
			
			if (pVisibiltyFlag == false)
			{
				pDisplayObject.visible = false;	
			}
			
			addChild(pDisplayObject);	
		}
		
		/**
		 *	@Adds DisplayObjects to itself
		 *  @param		pDisplayObject		Object				See the Breakdown below (ITs from the LoadingEngineXML)
		 *  @param		pOrder				uint				The order of this containers DisplayList
		 * 	@param		pID					String				The ID of the DisplayObject
		 * 	@param		pPoint				Point				The Starting Location of the Object
		 */
		 
		  /**
		 * The pLoaderObject Breakdown
		 * @Param		LOADEDCONTENT	Loaded Object(SWF)		The Loaded SWF
		 * @Param		LOADEDNAME		String					The ASSETNAME of the Object in the LoadList
		 * @Param		COUNT			uint					The Index of the Object in the LoadList
		 * @Param		LISTTYPE		String					The Storage Param passed with the Object from the LoadList
		 * @Param		ID				String					The ID of the Loaded Object. If DUPLICATE is used the it will be ID_ + Duplicate Number (Starts at 0)
		 * @Param		LOADCLASS		Object					The loaded SWF constructor Class
		 * @Param		DATA			OBJECT					The passed Object in the LoadList
		 */
		 
		public function addUI(pLoaderObject:Object,pOrder:uint,pID:String,pPoint:Point = null,pVisibiltyFlag:Boolean = true):void
		{
			
			var tUI:Object = {SWF:pLoaderObject.LOADEDCONTENT,DLINDEX:pOrder,ID:pID,POINT:pPoint};
			mDisplayObjectList.push(tUI);
			
			if (pPoint != null)
			{
				pLoaderObject.LOADEDCONTENT.x = pPoint.x;
				pLoaderObject.LOADEDCONTENT.y = pPoint.y;	
			}
			else
			{
				pPoint = new Point(0,0);
			}
			
			if (pVisibiltyFlag == false)
			{
				pLoaderObject.LOADEDCONTENT.visible = false;	
			}
			
			addChild(pLoaderObject.LOADEDCONTENT);	
		}
		
		/**
		 *	@This will remove all UI from the DisplayList and Arrays
		 */
		 
		public function cleanUpAllUI():void
		{
			mDisplayObjectList = [];
			
			while (numChildren) 
			{    
				removeChildAt(0);
			}	
		}
		
		
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 *	@Setup Variables
		 */
		 
		 private function setupVars():void 
		 {
		 	mID = "generic";
		 	mDisplayObjectList = [];
		 	mDisplayLayer = 0;
		 	var tPoint:Point = new Point();
		 	mStartPoint = new Point(0,0);
		 	mStartVisibility = true;
		 }
		 
	}
	
}
