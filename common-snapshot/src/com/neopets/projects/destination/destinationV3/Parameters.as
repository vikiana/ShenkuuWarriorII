/**
 *	This is a singleton class to create and store any reference pointers and data.
 *	Use this to:
 *		-Make reference points
 *		-Create and store properties, parameters that can be accessed throughout the project's life span
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  Nov.2009
 **/

	

package com.neopets.projects.destination.destinationV3
{
	
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import flash.net.NetConnection;
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.videoPlayerComponent.VideoPlayerShell
	
	public class Parameters {
		
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		
		private static var mReturnedInstance : Parameters;
		private var mProjectID	:String;		// Unquie ID for each proj (mTypeID + mItemID)
		private var mView		:Object;		// View class
		private var mControl	:Object;		// Control class
		private var mUserName	:String;		// User name
		private var mLoggedIn	:Boolean;		// When user name is not retrieved but only the loggged in status
		private var mDataObject	:Object;		// any other custom data
		private var mConnection :NetConnection;	// connection for amfphp calls
		private var mGroupMode	:Boolean;		// set false if you wane uinque html for each page
		private var mOnlineMode	:Boolean;		// set true if it goes online
		private var mBaseURL	:String;		// dev. vs live
		private var mImageURL	:String;		// image50 vs image
		private var mAssetPath	:String;		// Path to art asset, may or may not be used
		
		
		//----------------------------------------
		//	CONSTRUCTOR
		//----------------------------------------
		public function Parameters(pPrivCl : PrivateClass ):void{}
		
		
		//----------------------------------------
		//	GETTERS AND SETTERS
		//----------------------------------------
		
		public static function get instance( ):Parameters
		{
			if( Parameters.mReturnedInstance == null ) 
			{
				Parameters.mReturnedInstance = new Parameters( new PrivateClass( ) );
			}
			return Parameters.mReturnedInstance;
		}

		public static function get projectID():String {return Parameters.instance.mProjectID;}
		public static function get view():Object {return Parameters.instance.mView;}		
		public static function get control():Object {return Parameters.instance.mControl;}		
		public static function get dataObject():Object {return Parameters.instance.mDataObject;}
		public static function get userName():String {return Parameters.instance.mUserName;}
		public static function get loggedIn():Boolean {return Parameters.instance.mLoggedIn;}
		public static function get connection():NetConnection {return Parameters.instance.mConnection;}
		public static function get groupMode():Boolean {return Parameters.instance.mGroupMode;}
		public static function get onlineMode():Boolean {return Parameters.instance.mOnlineMode;}
		public static function get baseURL():String {return Parameters.instance.mBaseURL;}
		public static function get imageURL():String {return Parameters.instance.mImageURL;}
		public static function get assetPath():String {return Parameters.instance.mAssetPath;}
		
		public static function set view(pView:Object):void {Parameters.instance.mView = pView;}
		public static function set control(pControl:Object):void{Parameters.instance.mControl = pControl;}
		public static function set userName(pName:String):void {Parameters.instance.mUserName = pName;}
		public static function set loggedIn(value:Boolean):void {Parameters.instance.mLoggedIn = value;}
		public static function set projectID (pType:String):void {Parameters.instance.mProjectID = "TYPE14"+"ITEM"+pType}
		public static function set connection (pNet:NetConnection):void {Parameters.instance.mConnection = pNet;}
		public static function set groupMode (pValue:Boolean):void {Parameters.instance.mGroupMode = pValue;}
		public static function set onlineMode (pValue:Boolean):void {Parameters.instance.mOnlineMode = pValue;}
		public static function set baseURL(pValue:String):void {Parameters.instance.mBaseURL = pValue;}
		public static function set imageURL(pValue:String):void {Parameters.instance.mImageURL = pValue;}
		public static function set assetPath(pValue:String):void {Parameters.instance.mAssetPath = pValue;}
	
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		/**
		 *	For any destination projects, following parameters are necessary:
		 *	access at any given point
		 *	@PARAM		pControl		Object		Control class you created for the proj
		 *	@PARAM		pView			Object 		View class you created for the proj
		 *	@PARAM		pTypeID			String 		14 misc. projects, 4 for games
		 *	@PARAM		pItemID			String		Set neocontent ID
		 *	@PARAM		pName			String		user name, retrieved via amfphp or flashvar
		 **/
		public static function setParameters(pView:Object, pControl:Object, pName:String, pItemID:int, pProjID:int = 14):void
		{
			Parameters.instance.mControl = pControl;
			Parameters.instance.mView = pView;
			Parameters.instance.mProjectID = "TYPE" + pProjID.toString() + "ITEM" + pItemID.toString();
			Parameters.instance.mUserName = pName;
		}
		
		/**
		 *	When you want to create any reference pointer
		 *	@PARAM		pDataObj		Object			An object you would have created
		 **/
		public static function setDataObject(pDataObj:Object):void
		{
			Parameters.instance.mDataObject = pDataObj;
		}
		
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		

		
		//----------------------------------------
		//	EVENT LISTENER
		//----------------------------------------		
	}
}


//
class PrivateClass
{
	public function PrivateClass( )
	{
		//trace( "PrivateClass in GlobalGameReference instantiated" );
	}

} 