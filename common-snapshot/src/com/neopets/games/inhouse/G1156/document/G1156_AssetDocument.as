

/* AS3
	Copyright 2009
*/
package com.neopets.games.inhouse.G1156.document
{
	import com.neopets.games.inhouse.G1156.displayObjects.MapSection;
	import com.neopets.games.inhouse.G1156.displayObjects.MapSectionEnd;
	import com.neopets.util.general.GeneralFunctions;
	
	import flash.display.MovieClip;
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	
	/**
	 *	This is the Document Class for the Game Assets
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine G1156
	 * 
	 *	@author Clive Henrick
	 *	@since  10.05.2009
	 */
	 
	public class G1156_AssetDocument extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const WALL_TYPE_1:String = "Wall_Type1";
		public static const WALL_TYPE_2:String = "Wall_Type2";
		public static const WALL_TYPE_5:String = "Wall_Type5";
		public static const WALL_TYPE_6:String = "Wall_Type6";
		public static const WALL_TYPE_7:String = "Wall_Type7";
		public static const WALL_TYPE_8:String = "Wall_Type8";
		public static const WALL_TYPE_9:String = "Wall_Type9";
		public static const WALL_TYPE_10:String = "Wall_Type10";
		public static const WALL_TYPE_11:String = "Wall_Type11";
		public static const WALL_TYPE_END:String = "Wall_Type_Bottom";
		
		public static const WALL_TYPE_1_L2:String = "Wall_Type1_L2";
		public static const WALL_TYPE_2_L2:String = "Wall_Type2_L2";
		public static const WALL_TYPE_3_L2:String = "Wall_Type3_L2";
		public static const WALL_TYPE_4_L2:String = "Wall_Type4_L2";
		public static const WALL_TYPE_5_L2:String = "Wall_Type5_L2";
		public static const WALL_TYPE_END_L2:String = "Wall_Type_Bottom_L2";
		
		public static const WALL_TYPE_1_L3:String = "Wall_Type1_L3";
		public static const WALL_TYPE_2_L3:String = "Wall_Type2_L3";
		public static const WALL_TYPE_3_L3:String = "Wall_Type3_L3";
		public static const WALL_TYPE_4_L3:String = "Wall_Type4_L3";
		public static const WALL_TYPE_5_L3:String = "Wall_Type5_L3";
		public static const WALL_TYPE_END_L3:String = "Wall_Type_Bottom_L3";
	
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var mApplicationDomain:ApplicationDomain;

		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function G1156_AssetDocument():void
		{
			super();
			setupVars();
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
	
		/**
		 * Note: This sets the Application Domain if it is being Emded in Flex
		 * @Param		pApplicationDomain		ApplicationDomain			The Passed in Application Domain
		 */
		 
		public function setApplicationDomain (pApplicationDomain:ApplicationDomain):void
		{
			mApplicationDomain = pApplicationDomain;
		}
		
		public function getApplicationDomain ():ApplicationDomain
		{
			return mApplicationDomain;
		}
		
		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Note Pulls an Item out of the Library
		 * @param			pIndexName			String			The Name of the Item in the Library
		 * @param			pTypeClass			Class				The Class to Map the Item To
		 */
		 
		public function getLibraryObject(pIndexName:String, pTypeClass:Class):Object
		{
			var tReturnObj:Object;
			
			if 	(mApplicationDomain.hasDefinition(pIndexName))
			{
					var returnObjClass:Class = mApplicationDomain.getDefinition(pIndexName) as Class;
					var tReturnObj = new returnObjClass () as pTypeClass;
			}
			
			return tReturnObj;
		}
		
		
		public function returnLoopArray():Array
		{
			
			var tArray:Array = [];

			
			var MapSection1EndClass:Class = mApplicationDomain.getDefinition(G1156_AssetDocument.WALL_TYPE_END) as Class
			var MapSection3Class:Class = mApplicationDomain.getDefinition(G1156_AssetDocument.WALL_TYPE_2) as Class;
			var MapSection4Class:Class = mApplicationDomain.getDefinition(G1156_AssetDocument.WALL_TYPE_6) as Class;
			var MapSection5Class:Class = mApplicationDomain.getDefinition(G1156_AssetDocument.WALL_TYPE_7) as Class;
			var MapSection2Class:Class = mApplicationDomain.getDefinition(G1156_AssetDocument.WALL_TYPE_8) as Class;
			var MapSection6Class:Class = mApplicationDomain.getDefinition(G1156_AssetDocument.WALL_TYPE_9) as Class;
			var MapSection7Class:Class = mApplicationDomain.getDefinition(G1156_AssetDocument.WALL_TYPE_10) as Class;

	
			var MapSection1:MapSection = new MapSection3Class () as MapSection;
			tArray.push(MapSection1);
			MapSection1.mBaseClass = G1156_AssetDocument.WALL_TYPE_2;
			MapSection1.id = G1156_AssetDocument.WALL_TYPE_2;
		
			var MapSection2:MapSection = new MapSection2Class () as MapSection;
			tArray.push(MapSection2);
			MapSection2.mBaseClass= G1156_AssetDocument.WALL_TYPE_8;
			MapSection2.id= G1156_AssetDocument.WALL_TYPE_8;

			var MapSection3:MapSection = new MapSection5Class () as MapSection;
			tArray.push(MapSection3);
			MapSection3.mBaseClass = G1156_AssetDocument.WALL_TYPE_7;
			MapSection3.id = G1156_AssetDocument.WALL_TYPE_7;
			
			var MapSection4:MapSection = new MapSection4Class () as MapSection;
			tArray.push(MapSection4);
			MapSection4.mBaseClass= G1156_AssetDocument.WALL_TYPE_6;
			MapSection4.id= G1156_AssetDocument.WALL_TYPE_6;
			
			var MapSection5:MapSection = new MapSection6Class () as MapSection;
			tArray.push(MapSection5);
			MapSection5.mBaseClass= G1156_AssetDocument.WALL_TYPE_9;
			MapSection5.id = G1156_AssetDocument.WALL_TYPE_9;
		
		
			tArray = GeneralFunctions.shuffleArray(tArray);
		
			var MapSection6:MapSection = new MapSection7Class () as MapSection;
			tArray.splice(0,0,MapSection6);
			MapSection6.mBaseClass= G1156_AssetDocument.WALL_TYPE_10;
			MapSection6.id= G1156_AssetDocument.WALL_TYPE_10;
			
			var tMapSectionEnd:MapSectionEnd = new MapSection1EndClass () as MapSectionEnd;
			tArray.push(tMapSectionEnd);
			tMapSectionEnd.mBaseClass = G1156_AssetDocument.WALL_TYPE_END;
			tMapSectionEnd.id = G1156_AssetDocument.WALL_TYPE_END;
			
			return tArray;	
		}
		
		/** 
		 * @NOTE: LEVEL 2
		 */
		 
		 public function returnMapArrayLevel2():Array
		{
			
			var tArray:Array = [];
			
			var MapSection1EndClass:Class = mApplicationDomain.getDefinition(G1156_AssetDocument.WALL_TYPE_END_L2) as Class
			var MapSection1Class:Class = mApplicationDomain.getDefinition(G1156_AssetDocument.WALL_TYPE_1_L2) as Class;
			var MapSection2Class:Class = mApplicationDomain.getDefinition(G1156_AssetDocument.WALL_TYPE_2_L2) as Class;
			var MapSection3Class:Class = mApplicationDomain.getDefinition(G1156_AssetDocument.WALL_TYPE_3_L2) as Class;
			var MapSection4Class:Class = mApplicationDomain.getDefinition(G1156_AssetDocument.WALL_TYPE_4_L2) as Class;
			var MapSection5Class:Class = mApplicationDomain.getDefinition(G1156_AssetDocument.WALL_TYPE_5_L2) as Class;
			
			var MapSection1:MapSection = new MapSection1Class () as MapSection;
			tArray.push(MapSection1);
			MapSection1.mBaseClass = G1156_AssetDocument.WALL_TYPE_1_L2;
			MapSection1.id = G1156_AssetDocument.WALL_TYPE_1_L2;
		
			var MapSection2:MapSection = new MapSection2Class () as MapSection;
			tArray.push(MapSection2);
			MapSection2.mBaseClass= G1156_AssetDocument.WALL_TYPE_2_L2;
			MapSection2.id= G1156_AssetDocument.WALL_TYPE_2_L2;
			
			var MapSection3:MapSection = new MapSection3Class () as MapSection;
			tArray.push(MapSection3);
			MapSection3.mBaseClass = G1156_AssetDocument.WALL_TYPE_3_L2;
			MapSection3.id = G1156_AssetDocument.WALL_TYPE_3_L2;
			
			var MapSection5:MapSection = new MapSection5Class () as MapSection;
			tArray.push(MapSection5);
			MapSection5.mBaseClass= G1156_AssetDocument.WALL_TYPE_5_L2;
			MapSection5.id= G1156_AssetDocument.WALL_TYPE_5_L2;
	
			
			tArray = GeneralFunctions.shuffleArray(tArray);
			
			var MapSection4:MapSection = new MapSection4Class () as MapSection;
			tArray.splice(0,0,MapSection4);
			MapSection4.mBaseClass= G1156_AssetDocument.WALL_TYPE_4_L2;
			MapSection4.id= G1156_AssetDocument.WALL_TYPE_4_L2;
			
			
			var tMapSectionEnd:MapSectionEnd = new MapSection1EndClass () as MapSectionEnd;
			tArray.push(tMapSectionEnd);
			tMapSectionEnd.mBaseClass = G1156_AssetDocument.WALL_TYPE_END_L2;
			tMapSectionEnd.id = G1156_AssetDocument.WALL_TYPE_END_L2;
			
			return tArray;	
		}
		
		/** 
		 * @NOTE: LEVEL 3
		 */
		 
		 public function returnMapArrayLevel3():Array
		{
			
			var tArray:Array = [];
			
			var MapSection1EndClass:Class = mApplicationDomain.getDefinition(G1156_AssetDocument.WALL_TYPE_END_L3) as Class
			var MapSection1Class:Class = mApplicationDomain.getDefinition(G1156_AssetDocument.WALL_TYPE_1_L3) as Class;
			var MapSection2Class:Class = mApplicationDomain.getDefinition(G1156_AssetDocument.WALL_TYPE_2_L3) as Class;
			var MapSection3Class:Class = mApplicationDomain.getDefinition(G1156_AssetDocument.WALL_TYPE_3_L3) as Class;
			var MapSection4Class:Class = mApplicationDomain.getDefinition(G1156_AssetDocument.WALL_TYPE_4_L3) as Class;
			var MapSection5Class:Class = mApplicationDomain.getDefinition(G1156_AssetDocument.WALL_TYPE_5_L3) as Class;
			
			
			var MapSection1:MapSection = new MapSection1Class () as MapSection;
			tArray.push(MapSection1);
			MapSection1.mBaseClass = G1156_AssetDocument.WALL_TYPE_1_L3;
			MapSection1.id = G1156_AssetDocument.WALL_TYPE_1_L3;
		
			var MapSection2:MapSection = new MapSection2Class () as MapSection;
			tArray.push(MapSection2);
			MapSection2.mBaseClass= G1156_AssetDocument.WALL_TYPE_2_L3;
			MapSection2.id= G1156_AssetDocument.WALL_TYPE_2_L3;
			
			var MapSection3:MapSection = new MapSection3Class () as MapSection;
			tArray.push(MapSection3);
			MapSection3.mBaseClass = G1156_AssetDocument.WALL_TYPE_3_L3;
			MapSection3.id = G1156_AssetDocument.WALL_TYPE_3_L3;
			
			var MapSection4:MapSection = new MapSection4Class () as MapSection;
			tArray.push(MapSection4);
			MapSection4.mBaseClass= G1156_AssetDocument.WALL_TYPE_4_L3;
			MapSection4.id= G1156_AssetDocument.WALL_TYPE_4_L3;
			
		
			tArray = GeneralFunctions.shuffleArray(tArray);
	
			
			var MapSection5:MapSection = new MapSection5Class () as MapSection;
			tArray.splice(0,0,MapSection5);
			MapSection5.mBaseClass= G1156_AssetDocument.WALL_TYPE_5_L3;
			MapSection5.id= G1156_AssetDocument.WALL_TYPE_5_L3;
			
			var tMapSectionEnd:MapSectionEnd = new MapSection1EndClass () as MapSectionEnd;
			tArray.push(tMapSectionEnd);
			tMapSectionEnd.mBaseClass = G1156_AssetDocument.WALL_TYPE_END_L3;
			tMapSectionEnd.id = G1156_AssetDocument.WALL_TYPE_END_L3;
			
			return tArray;	
		}
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		protected function setupVars():void
		{
			mApplicationDomain = ApplicationDomain.currentDomain;	
		}
		
		
	}
	
}
