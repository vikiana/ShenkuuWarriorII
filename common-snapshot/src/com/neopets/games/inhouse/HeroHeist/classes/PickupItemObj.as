
/* AS3
	Copyright 2008
*/
package com.neopets.games.inhouse.HeroHeist.classes
{
	import com.neopets.projects.np9.system.NP9_Evar;
	
	/**
	 *	This class is imported from the flash 6 version of the game.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@NP9 Game System
	 * 
	 *	@author David Cary
	 *	@since  2.18.2010
	 */
	 
	public class PickupItemObj
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		public var pName:String;
		public var pLinkage:String;
		public var pRarity:String;
		public var pPointValue:Number;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function PickupItemObj(name:String,linkage:String,rarity:String,pointValue:Number) {
			this.pName = name;
			this.pLinkage = linkage;
			this.pRarity = rarity;
			this.pPointValue = pointValue;
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function getName():String {
			return this.pName;
		}
		
		public function getLinkageName():String {
			return this.pLinkage;
		}
		
		public function getRarity():String {
			return this.pRarity;
		}
		
		public function getPointValue():Number {
			return this.pPointValue;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		 
	}
	
}