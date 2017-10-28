//Marks the right margin of code *******************************************************************
package com.neopets.games.marketing.destination.CapriSun2011.pages
{
	import com.neopets.projects.destination.destinationV3.Parameters;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.net.Responder;

	/**
	 * public class CommunityChallengeBlueprint
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class CommunityChallengeBlueprint
	{
		//--------------------------------------------------------------------------
		// Variables
		//--------------------------------------------------------------------------	
		private var _prizesPending:Array;
		private var _prizes:int;
		
		
		//flags
		private var _hasItem:Boolean = false;
		private var _firstTime:Boolean;
		//--------------------------------------------------------------------------
		// Methods
		//--------------------------------------------------------------------------	
		//O. CHECK SHARED OBJ FOR FIRST TIME
		public function init():void{
			//check shared obj: is first time, open the instructions popup and
			_firstTime = true;
			//otherwise
			_firstTime = false;
			getStatus();
		}
		
		
		//1. GET THE PLAYER STATUS
		protected function getStatus ():void {
		  var responder:Responder = new Responder (getStatusSuccess, getStatusFail);
		  Parameters.connection.call ("CapriSun2011Service.getStatus", responder);
		}
		
		//2. INTERPRET PLAYER STATUS
		protected function getStatusSuccess (msg:Object):void {
			if (msg.logged_in){
				if (msg.join_status){
					//display message instead of 'join' button
					if (msg.prizes_pending[0]){
						_prizesPending = msg.prizes_pending;
						_prizes = _prizesPending.length;
						getPrizesPending ();
					}
				} else {
					//display 'JOIN CHALLENGE' button
				}
			} else {
				//display the "Login popup"
			}
		}
		
		//3. GET PENDING PRIZE 
		protected function getPrizesPending ():void {
			var responder:Responder = new Responder (getPrizeinfoSuccess, getPrizeinfoFail);
			Parameters.connection.call ("CapriSun2011Service.prizeInfo", responder, _prizesPending[_prizes-1]);
			_prizes--;
		}
		
		protected function getPrizeinfoSuccess (msg:Object):void {
			///call the popup. It will display the number of points won, the congratulation message and the "Claim" button
			var pointsToDisplay:Number = msg.points;
			if (msg.item){
				//display the item in the popup as well. 
				//BRUCE HAS TO PASS THE IMAGE URL AS WELL SO YOU CAN LOAD IT IN (itemUrl and itemName a String)
				//loadImage (msg.itemUrl)
				_hasItem = true;
			}	
		}
		
		
		
		//4. CLAIM BUTTON LISTENER HANDLE
		protected override function handleObjClick(e:CustomEvent):void
		{
			if (e.oData.DATA.parent == null)
			{
				return;
			}
			
			trace (e.oData.DATA.parent.name, e.oData.DATA.parent)
			
			if (e.oData.DATA.parent != null && e.oData.DATA.name == "btnArea")
			{
				var objName:String = e.oData.DATA.parent.name;	//name of the clicked obj
				
				// Return to community challenge page from the popup
				switch (objName)
				{	
					//these are the button instance names in the Prizes Popup page.
					//the popup will have to extend AbsPageWithBtnState
					case "claimPrizeCC":
						claimPrize();
					break;
					case "seeNextPrize":
						getPrizesPending();
					break;
					case "closeThisWindow":
						//close the popup
					break;
					case "instructionsClose":
						if (_firstTime){
							getStatus();
							_firstTime = false;
						}
						//close the popup
					break;
					case "joinChallenge":
						//call the joinChallenge service IMPLEMENT
					break;
					case "openInstrictions":
						//open the instructions popup
					break;
				}
			}
		}
		
		//5. CLAIM THE PRIZE
		protected function claimPrize():void {
			var responder:Responder = new Responder (claimPrizeSuccess, claimPrizeFail);
			Parameters.connection.call ("CapriSun2011Service.claimPrize", responder, _weekNo);
		}
		
		protected function claimPrizeSuccess (msg:Object):void {
			if (msg.result){
				//display in the popup (or show a new popup) the claimed prize message ("the points have been aded to yuor account")
				if (_hasItem){
					//display in the popup also the claimed item message ("the item has been aded to yuor inventory")
				}
				if (_prizes>=0){
					//display the "see next prize" button in the popup
				} else {
					//diplay the "close this window" button in the popup
				}
			} else {
				//the prize can't be claimed: ASK BRUCE WAHT (msg.result == false) MEANS
			}
		}
		
		//6. NOW YOU CAN DISPLAY THE ARM POSITIONED ACCORDING TO THE WEEK CHALLENGE RESULT. 
		//Check with bruce if the current week is the first element of the array , or the last one
		protected function displayArm (_prizesPending[0]):void {
			
		}
		
		
		
		//THE FOLLOWING FUNCTIONS GET CALLED IF THE SERVICE IS DOWN. 
		//THEORETICALLY THEY SHOULD CALL A POPUP THAT SAYS 'TRY AGAIN' OR "SERVICE IS DOWN TRY AGAIN LATER"
		private function getStatusFail (msg:Object):void {
			trace("Errror: getStatus fault: " + msg.toString());
		}
		private function getPrizeinfoFail (msg:Object):void {
			trace("Errror: getPrizeinfoFail fault: " + msg.toString());
		}
		private function claimPrizeFail (msg:Object):void {
			trace("Errror: claimPrizeFail fault: " + msg.toString());
		}
		
	}
}