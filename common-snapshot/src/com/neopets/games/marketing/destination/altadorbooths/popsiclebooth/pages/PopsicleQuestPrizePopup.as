package com.neopets.games.marketing.destination.altadorbooths.popsiclebooth.pages
{
	import com.neopets.games.marketing.destination.altadorbooths.popsiclebooth.PopsicleQuestText;
	import com.neopets.projects.destination.destinationV3.AbsPageWithBtnState;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.projects.destination.destinationV3.TrackingProxy;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.tracker.NeoTracker;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.Responder;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	public class PopsicleQuestPrizePopup extends AbsPageWithBtnState
	{
		
		private const WEEK1:int = 16201;
		private const WEEK2:int = 16202;
		private const WEEK3:int = 16203;
		private const WEEK4:int = 16204;
		
		
		
		private var _actCopy:Array = new Array ("Do 10 jumping jacks", "Jog in place for 5 minutes", "Do 10 push-ups", "Play outside with your family for 1 hour" );
		
		//buttons
		public var questprizeclose_btn:MovieClip;
		public var claimprize_btn:MovieClip;
		public var activitycomplete_btn:MovieClip;
		public var inventory_btn:MovieClip;
		public var anotherprize_btn:MovieClip;
		
		//text/image
		public var header_txt:TextField;
		public var message_txt:TextField;
		public var anotherprize_mc:MovieClip;
		public var prizeimage_mc:MovieClip;
		public var prizename_text:TextField;
		
		//content 
		public var content1:MovieClip;
		public var content2:MovieClip;
		public var content3:MovieClip;
		public var _maxContent:int = 3;
		
		private var _result:Object;
		private var _buttonActive:Boolean = false;
		private var _currentWeek:Object;
		
		private var _prizecount:int = 0;
		

		public function PopsicleQuestPrizePopup(pName:String=null, pView:Object=null)
		{
			super(pName, pView);
			setVisible(0);
		}
		
		public function setVisible (n:int):void {
			var cName:String;
			for (var i:int =1; i<=_maxContent; i++){
				cName = "content"+i;
				if (i==n){
					getChildByName(cName).visible = true;
				} else {
					getChildByName(cName).visible = false;
				}
			}
		}
		
		public function reset():void {
			for (var i:int =0; i< content2.prizeimage_mc.numChildren; i++){
				if (content2.prizeimage_mc.contains(content2.prizeimage_mc.getChildAt(i))){
					content2.prizeimage_mc.removeChild (content2.prizeimage_mc.getChildAt(i));
				}
			}
			_prizecount = 0;
		}
		
		 public function setResultsObj (msg:Object):void {
			 reset();
			_result = msg;
			_currentWeek = _result.stacksInfo.prizeConditions[_result.stacksInfo.prizeConditions.length-1];
			//timer for activity complete button
			var t:Timer = new Timer (1000, 4);//TESTING change to 60
			t.addEventListener(TimerEvent.TIMER_COMPLETE, activateButton, false, 0, true);
			t.start();
			//set content1: this is the first message the user sees whe he's awarded quest prizes
			var head:String;
			var message:String;
			if (_currentWeek){
			switch(_currentWeek.id){
				case "week1":
					head = PopsicleQuestText.HEADER1;
					message = PopsicleQuestText.MESSAGE1_1;
				break;
				case "week2":
					head = PopsicleQuestText.HEADER2;
					message = PopsicleQuestText.MESSAGE2_1;
				break;
				case "week3":
					head = PopsicleQuestText.HEADER3;
					message = PopsicleQuestText.MESSAGE3_1;
				break;
				case "week4":
					head = PopsicleQuestText.HEADER4;
					message = PopsicleQuestText.MESSAGE4_1;
				break;
			}
			setContent (content1, head, message);
			content1.activitycomplete_btn.gotoAndStop(2);
			setVisible(1);
			}
		 }
		 
		 
		 private function setContent(contentmc:MovieClip, headertxt:String=null, messagetxt:String=null, prizenametxt:String = null):void {
		 	if (headertxt)contentmc.header_txt.text = headertxt;
			if (messagetxt)contentmc.message_txt.text = messagetxt;
			if (prizenametxt) contentmc.prizename_text.text = prizenametxt;
		 }
		 
		 
		 private function activateButton(e:TimerEvent):void 
		 {
			 e.target.removeEventListener(TimerEvent.TIMER_COMPLETE, activateButton);
			 content1.activitycomplete_btn.gotoAndStop(1);
		 }
		 
		 private function getNextPrize ():void {
			 var message:String;
			 switch(_currentWeek.id){
				 case "week1":
					 message = PopsicleQuestText.MESSAGE1_2_NP;
				break;
				 case "week2":
					 switch (_prizecount){
						 case 0:
							 message = PopsicleQuestText.MESSAGE2_2_NP;
							 break;
						 case 1:
							 message = PopsicleQuestText.MESSAGE2_2_PRIZE;
							 break;
					 }
				break;
				 case "week3":
					 switch (_prizecount){
						 case 0:
							 message = PopsicleQuestText.MESSAGE3_2_NP;
							 break;
						 case 1:
							 message = PopsicleQuestText.MESSAGE3_2_PRIZE;
							 break;
						 case 2:
							 message = PopsicleQuestText.MESSAGE3_2_PRIZE2;
							 break;;
					 }
				break;
				 case "week4":
					 switch (_prizecount){
						 case 0:
							 message = PopsicleQuestText.MESSAGE4_2_NP;
							 break;
						 case 1:
							 message = PopsicleQuestText.MESSAGE4_2_PRIZE;
							 break;
						 case 2:
							 message = PopsicleQuestText.MESSAGE4_2_PRIZE2;
							 break;
						 case 3:
							 message = PopsicleQuestText.MESSAGE4_2_PRIZE3;
							 break;
					 }
				break;
			 }
			 setContent (content2, null, message, _currentWeek.prizes[_prizecount].name);
			 
			//load prize image
			 loadPrizeImage (_currentWeek.prizes[_prizecount].url);
		 }
		 
		 private function loadPrizeImage (imageURL:String):void {
			 if (imageURL!=""){
				 var lr:URLRequest =  new URLRequest (imageURL);
				 var ldr:Loader = new Loader();
				 ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, setPrizeImage, false, 0, true);
				 ldr.load(lr);
			 } 
		 }
		 
		 private function setPrizeImage(e:Event):void {
		 	e.target.removeEventListener (Event.COMPLETE, setPrizeImage)
			content2.prizeimage_mc.addChild(e.target.loader.content);
			setVisible (2);
		 }
		 
		 
		 override protected function handleObjClick(e:CustomEvent):void{
			 if (e.oData.DATA.parent != null && e.oData.DATA.name == "btnArea")
			 {
				 var objName:String = e.oData.DATA.parent.name;	//name of the clicked obj
				 var r:Responder = new Responder (onPrizeClaimed, claimStatus);
				 switch (objName){
					case "activitycomplete_btn":
						getNextPrize();
						setVisible(2);
					break;
					case "claimprize_btn":
						Parameters.connection.call ("AltadorAlley2010Service.popClaimStacksPrize", r , _currentWeek.id);
						//trackQuestCompletion(_currentWeek.id);
					break;
					case "anotherprize_btn":
						getNextPrize();
						break;
				 }	 
			}
		 }
		 
		 private function claimStatus (msg:Object):void {
		 	trace (msg);
		 }
		 
		 
		 private function onPrizeClaimed (msg:Object):void {
		 	trace (_currentWeek, ": Prize was awarded already? "+msg);
			//set content of confirmation popup 
			if (_prizecount > 0){
				content3.gotoAndStop(2);
				setContent(content3, null, null, _currentWeek.prizes[_prizecount].name);
				content3.prizeimage_mc.addChild (content2.prizeimage_mc.getChildAt (1));
			} else {
				content3.gotoAndStop(1);
			}
			//set "another prize" message visibility
			if (_prizecount < _currentWeek.prizes.length-1){
				content3.anotherprize_mc.visible = true;
				//up the prize count
				_prizecount++;
			} else {
				content3.anotherprize_mc.visible = false;
			}
			//set confirmation popup visibility
			setVisible (3);
		 } 
		 
		 
		 //done on server
		/*private function trackQuestCompletion (weekid:String):void {
			 var ID:int;
			 var omn:String;
		 	switch (weekid){
				case "week1":
					ID = WEEK1;
					omn = 'AltadorAlley2010 - Week 1 completed'
					break;
				case "week2":
					ID = WEEK2;
					omn = 'AltadorAlley2010 - Week 2 completed'
					break;
				case "week3":
					ID = WEEK3;
					omn = 'AltadorAlley2010 - Week 3 completed'
					break;
				case "week4":
					ID = WEEK4;
					omn = 'AltadorAlley2010 - Week 4 completed'
					break;
			}
			NeoTracker.instance.trackNeoContentID  (ID);
			TrackingProxy.sendADLinkCall(omn);
		 }*/
	}
}