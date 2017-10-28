		
/**
 *	Convert slot result XML(received form PHP call via SlotRequestPHP) usable array
 *	For actual documentation of XML responses, please take a look at:
 *
 * 	http://confluence.mtvi.com/display/NEOPETS/Slot+Machines+Web+Service
 *
 *	NOTE: This version works for now, but is not exactly working as I wanted it to.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

package com.neopets.games.inhouse.brucyBSlots
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	
	
	
	public class SlotResultXMLProcessor
	{
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		private var mResultObject:Object	// objects that will contain php result information
		
		//----------------------------------------
		//CONSTRUCTOR 
		//----------------------------------------
		public function SlotResultXMLProcessor():void
		{
			mResultObject = new Object ();
		}
		
		//----------------------------------------
		//GETTERS AND SETTORS
		//----------------------------------------
		
		public function get resultObject():Object 
		{
			return mResultObject;
		}
			
		
		//----------------------------------------
		//PUBLIC METHODS
		//----------------------------------------
		
		////
		// it will take XML (php slot results) and break it down to usable information according to XML type
		//
		//	@PARAM		xml		php slot results
		////
		public function processXML(xml:XML):Object
		{
			trace (xml)
			switch (xml.localName())
			{
				case "slotsStartup":
					processSetup(xml)
					break;
				
				case "slotsSpin":
					processSpin(xml)
					break;
				
				case "slotsError":
					processError(xml)
					break;
			}
			return mResultObject
		}
		
		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
		
		
		//handles when XML returns an error
		private function processError(xml):void
		{
			mResultObject.error = true;
			mResultObject.message = xml.message
		}
		
		//handles when XML is a set up call (called only once as the game starts)
		private function processSetup(xml):void
		{
			mResultObject.error = false;
			mResultObject.message = ""
			mResultObject.setup = true
			mResultObject.userName = xml.username.toString();
			mResultObject.userNP = xml.user_np
			var jackpot:int = xml.hasOwnProperty("jackpot")? int(xml.jackpot): 0;
			mResultObject.jackpot = jackpot
		}
		
		//handles when XML is slot result
		private function processSpin(xml):void
		{
			mResultObject.error = false;
			mResultObject.message = ""
			mResultObject.setup = false;
			mResultObject.userName = xml.username.toString();
			mResultObject.userNP = xml.user_np
			var jackpot:int = xml.hasOwnProperty("jackpot")? int(xml.jackpot): 0;
			mResultObject.jackpot = jackpot
			mResultObject.pointsWon = xml.np_won
			mResultObject.slotResult = slotArray(xml.reels)
			mResultObject.winIndicator = winArray(xml.lines_won)
			mResultObject.pawkeetBonus = xml.pawkeet_bonus == ""? 0: int(xml.pawkeet_bonus);
			mResultObject.treasureBonus = bonusArray(xml.treasure_bonus)
		}
		
		////
		//	takes reels (xml property/node) portion of xml result and turns it into an array
		//	that'll look something like [[1,2,3], [1,2,3], [1,2,3], [1,2,3], [1,2,3]]
		////
		private function slotArray(reelsXML:XMLList):Array
		{
			var xmlList:XMLList = reelsXML.children()
			var myArray:Array = new Array ();
			for (var i:String in xmlList)
			{
				var symbolList:XMLList = xmlList[i].symbol;
				var reelArray = new Array ()
				for (var j:String in symbolList)
				{
					reelArray.push(int(symbolList[j].children()))
				}
				myArray.push(reelArray)
			}
			return myArray
		}
		
		
		////
		//	takes win (xml property/node) portion of xml result and turns it into an array
		//	shows winning line and matching items
		//	ex)	[[1, 3], [6,4]] means line 1 matching item 3, line 6 matching item 4
		////
		private function winArray(linesWonXML:XMLList):Array
		{
			var myArray:Array = new Array ();
			if (linesWonXML.length() > 0)
			{
				var xmlList:XMLList = linesWonXML.children()
				for (var i:String in xmlList)
				{
					myArray.push([xmlList[i].@id, xmlList[i].@match])
				}
			}
			return myArray;
		}
		
		////
		//	takes bonus (xml property/node) portion of xml result and turns it into an array
		////
		private function bonusArray(bonusXML:XMLList):Array
		{
			var myArray:Array = new Array ();
			myArray.push(bonusXML.@type)
			
			switch (bonusXML.@type.toString())
			{
				case "none":
					// do nothing
					myArray.push("")
					break;
					
				case "dubloon":
					myArray.push(bonusXML.message)
					break;
				
				case "np":
					myArray.push(bonusXML.message + ":" + bonusXML.@np)
					break;
			}
			
			return myArray;
		}
		
		
		//----------------------------------------
		//EVENT LISTENERS
		//----------------------------------------
	}
	
}