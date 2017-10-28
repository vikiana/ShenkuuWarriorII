/**
 *	sends php requests to retrieve necessary data to play the slot
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

package com.neopets.games.marketing.destination.kidCuisine.pcCollectionQuest
{
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import flash.display.Sprite

	
	public class XMLProcessor extends Sprite
	{
		//----------------------------------------
		//	CONSTANT
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		private var xmlObj:Object;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		
		public function XMLProcessor():void
		{
			xmlObj = new Object ();
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		public function get myObject():Object
		{
			return xmlObj;
		}
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		public function processXML(pXML:XML):void
		{
			var xml:XML = pXML
			switch (xml.localName())
			{
				case "response":
					processResponse(xml);
					break;
					
				case "error":
					processError(xml);
					break;
				
				default:
					trace ("Process some new xml");
					break
			}
		}
		
		public function cleanup():void
		{
			//loader.removeEventListener(
		}
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		private function processResponse(pXML:XML):void
		{
			//trace ("\n  PROCESS RESPONSE")
			//trace (pXML)
			xmlObj.myError = false
			xmlObj.userName = pXML.userdata.username
			handlePostcards (pXML.userdata.postcards.postcard)
			handleInactive (pXML.inactives.inactive)
			handleFinalPrize (pXML.userdata.final_prize)
			
			
		}
		
		//here "error" simply means returned xml is not what was expected, not error in receiving php call
		private function processError (pXML:XML):void
		{
			xmlObj.myError = true
			xmlObj.errorMessage = pXML.errmsg
			xmlObj.userName = "GUEST_USER"
		}
		
		private function handlePostcards(xmlList:XMLList):void
		{
			// postCards means active postcards
			// first boolean mean active or not
			var postcardsArray:Array = new Array ()
			for (var i:String in xmlList)
			{
				postcardsArray.push(
									[
									 true,
									 xmlList[i].@pcid, 
									 xmlList[i].@found, 
									 xmlList[i].@claimed,
									 xmlList[i].@claimhash,
									 xmlList[i].hint,
									 xmlList[i].nick_url,
									 xmlList[i].prize_name,
									 xmlList[i].prize_url
									]
								   )
			}
			xmlObj.postcardsArray = postcardsArray
			//trace ("myXML", xmlObj.postcardsArray.length)
		}
		
		
		//put inactive 
		private function handleInactive(xmlList:XMLList):void
		{
			// first boolean mean active or not
			var inactiveArray:Array = new Array ()
			for (var i:String in xmlList)
			{
				inactiveArray.push(
								   [
									false,
									xmlList[i].@pcid, 
									xmlList[i].@launchdate
									]
								   )
			}
			xmlObj.inactiveArray = inactiveArray
		}

		//process the final prize array
		private function handleFinalPrize(xmlList:XMLList):void
		{
			//trace ("what is this", xmlList.length())
			if (xmlList.length() != 0)
			{
				var FinalPrizeArray:Array = new Array ()
				FinalPrizeArray.push(
									  xmlList.@eligible, 
									  xmlList.@claimed, 
									  xmlList.prize_name, 
									  xmlList.prize_url
									 )
				//trace ("final prize", FinalPrizeArray)
				xmlObj.finalPrizeArray = FinalPrizeArray
				xmlList.@claimed == "0"? xmlObj.finalPrizeOn = true: xmlObj.finalPrizeOn = false
			}
			else 
			{
				xmlObj.finalPrizeArray = null
				xmlObj.finalPrizeOn = false
				
			}
			
		}
		
		//----------------------------------------
		//	EVENT LISTENER
		//----------------------------------------

	}
	
}