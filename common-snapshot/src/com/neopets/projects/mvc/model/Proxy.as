/* AS3
	Copyright 2008
*/

package com.neopets.projects.mvc.model
{
	import com.neopets.projects.neopetsGameShell.events.SharedListener;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.loading.XMLLoader;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	
	
	/**
	 *	This will Hold all Code that has to deal with a Data Player
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 	@Pattern MVC
	 * 
	 *	@author Clive Henrick
	 *	@since  12.04.08
	 */
	 
	public class Proxy extends EventDispatcher implements IProxy
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public const LOAD_XML_LIST:String = "loadtheXML";
		
		public const PROXY_READY:String = "ProxyIsReady";
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var mSiteData:DataHolder;
		protected var mSharedListener:SharedListener;
		protected var mID:String;
		protected var mXMLLoader:XMLLoader;
		
		protected var mNumberofFiles:uint;
		protected var mSiteDataArray:Array;
		protected var mCurrentCountofLoadedFiles:uint;
		protected var mDataToLoadArray:Array;
		
		protected var mBackUpArray:Array;
		protected var mCount:uint = 0;
		
		protected var mLoaderArray:Array;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function Proxy (pSharedListener:ISharedListener,pID:String = "ProxyLoader",target:IEventDispatcher=null)
		{
			super(target);
			mID = pID;
			mSharedListener = pSharedListener as SharedListener;
			
			setupVars();
			
		}
		
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get ID():String
		{
			return mID;
		}
		
		public function get loadedDataArray():Array
		{
			return mSiteDataArray;
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		 /**
		 *	@LoadData
		 * 	@param		pURLARRAY[0][0]		String		URL of the Data File
		 * 	@param		pURLARRAY[0][1]		String		The Name of The Data for Reference
		 */
		 public function loadData(pURLARRAY:Array):void
		 {
		 	mNumberofFiles = pURLARRAY.length;
		 	mDataToLoadArray = pURLARRAY;
		 	 
		 	for (var z:uint = 0; z < mNumberofFiles; z++)
		 	{
		 		var tXMLLoader:XMLLoader = new XMLLoader(pURLARRAY[z][0],pURLARRAY[z][1]);
		 		tXMLLoader.addEventListener(tXMLLoader.XML_DONE, XMLLoaded,false,0,true);
		 		tXMLLoader.addEventListener(tXMLLoader.XML_LOAD_ERROR, XMLLoadedError,false,0,true);
		 		mLoaderArray.push(tXMLLoader);
		 	}
		 }	
		 
		 
		 /**
		 *	@This looks for an XML File and returns it
		 * 	@param		pName		String		The Proxys ID for the RequestedInfo
		 */
		 
		 public function getXML(pName:String):XML 
		 {
		 	var tXML:XML = new XML();
		 	
			for (var t:uint = 0; t < mNumberofFiles; t++)
			{
				if (pName == mSiteDataArray[t].ID)
				{
					tXML = mSiteDataArray[t].Data;
				}
			}
			return tXML;
		 	
		 }
		 
		 private function getIndex(pName:String):uint 
		 {
		 	
		 	var tIndex:uint;
		 	
			for (var t:uint = 0; t < mNumberofFiles; t++)
			{
				if (pName == mSiteDataArray[t].ID)
				{
					tIndex = t;
					break;
				}
			}
			
			return t;
		 	
		 }	
		 
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 *	@This looks at Proxy Requests and Returns Data form the DataObject
		 * 	@param		evt.oData.ID		String		Object IDs requesting the DataObject
		 *  @param		evt.oData.PROXYID	String		The Proxys ID for the RequestedInfo
		 *  @param		evt.oData.ITEM		String		The Object Being Requested
		 * 	@param		evt.oData.LEFLAG	Boolean		false = Send Back as false as it means it is Not a LoadingList
		 */
		 
		 protected function onGetObject(evt:CustomEvent):void 
		 {
		 	if(mSiteDataArray[0])
		 	{
			 	if(mSiteDataArray[0].ID == "ErrorXML")
			 	{
			 		mSharedListener.dispatchEvent(new CustomEvent({ID:ID, ERROR:true},BaseSharedListener.PROXY_LOADERROR));
			 	}
			 }
			if (evt.oData.PROXYID == mID)
		 	{
				for (var t:uint = 0; t < mNumberofFiles; t++)
				{
					/* DEBUGGING */
					if (t == mSiteDataArray.length)
					{
						trace("Problem in Proxy " + mID + " mSiteDataArray is out of Bounds at " + t + " For Request " + evt.oData.ITEM);
						break;
					}
					if (evt.oData.ITEM == mSiteDataArray[t].ID)
					{
						mSharedListener.dispatchEvent(new CustomEvent({ID:evt.oData.ID,ITEM:evt.oData.ITEM,XML:mSiteDataArray[t].Data,LEFLAG:evt.oData.LEFLAG,XMLURL:mDataToLoadArray[0][0]},BaseSharedListener.PROXY_SENDOBJ));
						break;
					}
				}
				
				evt.stopImmediatePropagation();
		 	}
		 }
		 
		 /**
		 *	@onError handles when a XMLLoader has an Error	
		**/
		
		protected function XMLLoadedError(evt:Event):void 
		{
			trace("XML PROXY ( " + mID + " ) LOAD ERROR. XML will be empty for Error Control");
			
			var tDataObject:DataHolder = new DataHolder(new XML(), "ErrorXML");
			mSiteDataArray.push(tDataObject);
			mCurrentCountofLoadedFiles++;
			
			if (mNumberofFiles == mCurrentCountofLoadedFiles)
			{
				this.dispatchEvent(new Event(PROXY_READY));
				
				/* CLEAR LISTENERS */
				mLoaderArray = [];
				
			}
		}
		
		public function reorderByAtribute(pName:String, pAttribute:String, pOptions:Object = null, pCopy:Boolean=false):XML
		{
			
			//store in array to sort on
			var xmlArray:Array	= new Array();
			var item:XML;
			var tXML:XML = getXML(pName);
			var returnXML:XML;
			
			for each(item in tXML.children())
			{
				var object:Object = {
					data	: item, 
					order	: item.attribute(pAttribute)
				};
				xmlArray.push(object);
			}
		
			//sort using the power of Array.sortOn()
			xmlArray.sortOn("order", pOptions);
		
			//create a new XMLList with sorted XML
			var sortedXmlList:XMLList = new XMLList();
			var xmlObject:Object;
			for each(xmlObject in xmlArray )
			{
				sortedXmlList += xmlObject.data;
			}
			
			if(pCopy)
			{
				//don't modify original
				returnXML = tXML.copy().setChildren(sortedXmlList);
			}
			else
			{
				//original modified
				returnXML = tXML.setChildren(sortedXmlList);
				
			}
			
			return returnXML;

		}
		
			
		/**
		 *	@When the XML is Ready. Create a Data Object
		 * 	@param		evt.oData.XML		XML			The XML for the DataObject
		 * 	@param		evt.oData.ID		String		The ID of the XMLLoader
		*/
		
		protected function XMLLoaded(evt:CustomEvent):void 
		{
			var tDataObject:DataHolder = new DataHolder(evt.oData.XML, evt.oData.ID);
	
			mSiteDataArray.push(tDataObject);
			
			mCurrentCountofLoadedFiles++;
			
			if (mNumberofFiles == mCurrentCountofLoadedFiles)
			{
				mBackUpArray = mSiteDataArray;
			
				this.dispatchEvent(new Event(PROXY_READY));
			}
				
		}
		 
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 *	@Setup Variables
		 */
		 
		 protected function setupVars():void 
		 {
		 	mSharedListener.addEventListener(mSharedListener.PROXY_GETOBJ,onGetObject,false,0,true);
		 	mNumberofFiles = 0;
		 	mCurrentCountofLoadedFiles = 0;
		 	mSiteDataArray = [];
		 	mDataToLoadArray = [];
		 	mLoaderArray = [];
		 }
		 
		
	}
	
}
