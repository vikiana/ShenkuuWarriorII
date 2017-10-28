
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
	 
	public class CardInfoObj
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		public var pFileName:String;
		public var pName:String;
		public var pDescription:String;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function CardInfoObj(fileName:String,name:String,description:String):void {
			this.pFileName = fileName;
			this.pName = name;
			this.pDescription = description;
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
		
		public function getFileName():String {
			return this.pFileName;
		}
		
		public function getDescription():String {
			return this.pDescription;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		 
	}
	
}