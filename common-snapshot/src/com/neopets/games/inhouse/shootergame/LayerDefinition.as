package com.neopets.games.inhouse.shootergame
{
	
	/**
	 *	This class is a collection of properties a layer might have.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 10.0
	 *	
	 * 
	 *	@author Viviana Baldarelli
	 *	@since  03.19.2009
	 */
	public class LayerDefinition
	{
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		public var posZ:Number;
		public var name:String;
		public var asset:Class;
		//only types
		public var bottomtargets:Array;
		public var toptargets:Array;
		//types and order
		public var bkgs:Array
		//reference to level/stage definitions from each layer
		public var levelDef:LevelDefinition;
		
		public function cleanUp():void {
		posZ = 0;
		name = "";
		asset = null;
		bottomtargets = null;
		toptargets = null;
		bkgs = null;
		levelDef = null;
	}
	}
}