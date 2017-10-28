package com.neopets.util.loading
{
	/**
	 *	This is Infomation that is used by the Loading Manager
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 10.0
	 *
	 *	@Clive henrick 
	 *	@since  1.06.10
	 */
	
	public class LoadingManagerConstants
	{
		//--------------------------------------
		//  CONST
		//--------------------------------------
		
		public static const LOADING_COMPLETE:String = "loadingEngine_Complete";
		public static const LOADING_OBJINT:String = "loadingEngine_ObjectINT";
		public static const LOADING_OBJLOADED:String = "loadingEngine_ObjectLoaded";
		public static const LOADING_CLEANED:String = "AllMemoryShouldBeFree";
		public static const LOADING_PROGRESS:String = "loadingEngine_On_Progress";
		
		public static const USE_PARENT:String = "use_parent";
		public static const KEEP_SEPERATE:String = "seperate";
		public static const ADD_CHILD:String = "add_child";
		
		public function LoadingManagerConstants(){}
	}
}