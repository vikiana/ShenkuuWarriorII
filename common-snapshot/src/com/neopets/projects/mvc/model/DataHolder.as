/* AS3
	Copyright 2008
*/
package com.neopets.projects.mvc.model
{
	
	/**
	 *	This will Hold the Loading Data
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 	@Pattern MVC
	 * 
	 *	@author Clive Henrick
	 *	@since  08.04.08aa
	 */
	public class DataHolder 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var mData:XML;
		protected var mID:String;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function DataHolder(pXML:XML,pID:String = "DataObject"):void
		{	
			mData = pXML;
			mID = pID;
		}
	
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get Data():XML
		{
			return mData;
		}
		
		
		public function get ID():String
		{
			return mID;
		}
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------

		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
