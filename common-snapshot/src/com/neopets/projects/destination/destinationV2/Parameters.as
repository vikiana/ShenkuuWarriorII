/**
 *	This is a singleton class to create and store any refereince pointers and data.
 *	Use this to:
 *		-Make reference points
 *		-Create and store properties, parameters that can ba accessed throughout the project's life span
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 **/

	

package com.neopets.projects.destination.destinationV2
{
	
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	
	
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
		private var mTypeID:String;	// Games are 4 all others are 14: Destination is ex."TYPE14"
		private var mItemID:String;	// For desination use neocontendID: ex. "ITEM12345"
		private var mProjectID:String;	// Unquie ID for each proj (mTypeID + mItemID)
		private var mView:Object;	// View class
		private var mControl:Object;	// Control class
		private var mDataObject:Object;	// any custom data you want to have reference to
		
		
		//----------------------------------------
		//	CONSTRUCTOR
		//----------------------------------------
		public function Parameters(pPrivCl : PrivateClass ):void
		{
		}
	
	
		
		//----------------------------------------
		//	GETTERS AND SETTERS
		//----------------------------------------
		
		public static function get instance( ):Parameters
		{
			if( Parameters.mReturnedInstance == null ) 
			{
				Parameters.mReturnedInstance = new Parameters( new PrivateClass( ) );
			}
			else
			{
				//trace( "Instance of VideoPlayerSingleton already exists" );
			}
			return Parameters.mReturnedInstance;
		}

		public function get projectID():String
		{
			return mProjectID;
		}
		
		public function get view():Object
		{
			return mView;
		}
		
		public function get control():Object
		{
			return mControl;
		}
		
		public function get dataObject():Object
		{
			return mDataObject
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		/**
		 *	For any click destination, four parameters below are necessary info other classes may have to 
		 *	access at any given point
		 *	@PARAM		pControl		Object (Control Class) 		Control class you created for the proj
		 *	@PARAM		pView			Object (Control Class) 		View class you created for the proj
		 *	@PARAM		pTypeID			String 						14 for destianation project, 4 for games
		 *	@PARAM		pItemID			String						Set neocontent ID from someone
		 **/
		public function setParameters(pView:Object, pControl:Object, pProjID:int, pItemID:int):void
		{
			mControl = pControl;
			mView = pView;
			mTypeID = "TYPE" + pProjID.toString();
			mItemID = "ITEM" + pItemID.toString();
			mProjectID = mTypeID + mItemID;
		}
		
		/**
		 *	When you want to create any reference pointer
		 *	@PARAM		pDataObj		Object			An object you would have created
		 **/
		public function setDataObject(pDataObj:Object):void
		{
			mDataObject = pDataObj
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