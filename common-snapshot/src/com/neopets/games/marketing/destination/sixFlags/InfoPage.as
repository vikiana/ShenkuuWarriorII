/**
 *	Creates a page with a list of sixflag locations and inforamation on each place
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

	

package com.neopets.games.marketing.destination.sixFlags
{
	
	//----------------------------------------
	//IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.text.TextField;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	//----------------------------------------
	//CUSTOM IMPORTS 
	//----------------------------------------
	import com.neopets.projects.destination.AbstractPage
	import abelee.resource.easyCall.QuickFunctions;
	import com.neopets.util.events.CustomEvent;
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.FilterShortcuts;
	
	
	public class InfoPage extends AbstractPage {
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		public const STATE_CLICKED:String = "state_clicked";	//show popup info for clicked stage
		public const WEB_CLICKED:String = "visit_web_clicked";	//open up appropriate links
		private var mInfoArray:Array	//array of each parks info
		
		
		//----------------------------------------
		//CONSTRUCTOR
		//----------------------------------------
		
		public function InfoPage() {
			super()
			FilterShortcuts.init();	//to use tweener filters
			setupInfoArray()
			setupPage()	//main look and feel of the page
			buttonSetup()	//To accomodate artist's set up of buttons on this page
			popupSetup()	//set pupups to visible = false
			addEventListener(MouseEvent.MOUSE_OVER, handleMouseOver, false, 0, true)
			addEventListener(MouseEvent.MOUSE_OUT, handleMouseOut, false, 0, true)
			addEventListener(STATE_CLICKED, handleStateClick, false, 0, true)
			addEventListener(WEB_CLICKED, handleWebClick, false, 0, true)
		}		
		
		//----------------------------------------
		//GETTERS AND SETTERS
		//----------------------------------------
		
		//----------------------------------------
		//PUBLIC METHODS
		//----------------------------------------
		
		
		
		//----------------------------------------
		//PROTECTED METHODS
		//----------------------------------------
		protected override function setupPage():void
		{
			addImage("InfoBackground", "InfoBackground", 360, 245);
			addImage("InfoList", "InfoList", 60, 5);
			addImage("InfoForeground", "InfoForeground", 140,-145);	
			addImage("InfoPopup", "infoPopup1", 370,10);
			addImage("InfoPopup", "infoPopup2", 370,260);
			placeImageButton("Btn_back", "goBack", 680, 490, 0, "out")
		}
		
		//----------------------------------------
		//PRIVATE METHODS
		//----------------------------------------
		
		//set up state info, last numbers in each array is neo content click IDs
		private function setupInfoArray():void
		{
			var ga:Array = ["ga",
							["Atlanta",
							 "Come to Six Flags Over Georgia where kids have 40 fun things to do.  We have 20 fun-tastic rides just for kids, including the new Thomas Town.",
							 "14242"
							 ]
							];
			
			var il:Array= ["il",
						   ["Chicago",
							"Visit Six Flags Great America, now with four fun-tastic themed areas for kids including Wiggles World and Bugs Bunny National Park. ",
							"14243"
							]
						   ];
			
			var tx:Array= ["tx",
						   ["Arlington",
							"At Six Flags Over Texas treat your kids to over 30 fun-tastic rides just for them like Looney Tunes USA and Mini-Mine Train. ",
							"14244"
							],
						   ["San Antonio",
							"From Bugs Bunny National Park to Hook's Lagoon, treat your kids to over 20 fun-tastic rides just for them at Six Flags Fiesta Texas.",
							"14250"
							]
						   ];
			
			var ny:Array = ["ny",
							["Lake George",
							 "At The Great Escape & Splashwater Kingdom treat your kids to over 30 fun-tastic rides just for them, including the new Wiggles World.",
							 "14245"
							 ]
							];
			var ca:Array = ["ca",
							["Los Angeles",
							 "Six Flags Magic Mountain offers over 25 fun-tastic rides for kids including the new Thomas Town.",
							 "14246"
							 ],
							["Vallejo",
							 "Discover up close encounters with porcupines, anteaters, macaws and more at Six Flags Discovery Kingdom.  Then treat your kids to 20 fun-tastic rides just for them, like Thomas Town and Looney Tunes Seaport.",
							 "14251"
							 ]
							];
			
			var ky:Array = ["ky",
							["Louisville",
							 "From Looney Tunes Movie Town to Hook's Lagoon, Six Flags Kentucky Kingdom offers fun-tastic rides for everyone in your family.",
							 "14247"
							 ]
							];
			
			var ma:Array = ["ma",
							["Springfield",
							 "From Wiggles World to Looney Tunes Movie Town, Six Flags New England offers your kids 35 fun-tastic rides just for them.  ",
							 "14249"
							 ]
							];
			
			var nj:Array = ["nj",
							["Jackson",
							 "Visit Six Flags Great Adventure, now with four fun-tastic themed areas for kids, including Wiggles World and Bugs Bunny National Park. Plus, check out the Wild Safari drive thru, and all-new hands-on Safari adventure.",
							 "14248"
							 ]
							];
			
			var mo:Array = ["mo",
							["St. Louis",
							 "From Bugs Bunny National Park to Hook's Lagoon, treat your kids to over 20 fun-tastic rides just for them at Six Flags St. Louis.",
							 "14252"
							 ]
							]
			var md:Array = ["md",
							["Baltimore/Washington, D.C.",
							 "From Looney Tunes Movie Town to Crocodile Cal's Caribbean Beach, treat your kids to over 25 fun-tastic rides at Six Flags America.",
							 "14253"
							 ]
							]
			
			mInfoArray = [ga, il, tx, ny, ca, ky, ma, nj, mo, md]
		}
				
		//To make sure all the buttons on the wood board is set to mouse out state
		private function buttonSetup():void
		{
			var infoList:MovieClip= getChildByName("InfoList") as MovieClip
			var children:int = infoList.numChildren;
			for (var i:int = 0; i < children; i++)
			{
				var child:MovieClip = infoList.getChildAt(i) as MovieClip;
				if (child != null && child.btnArea != null)
				{
					child.gotoAndStop("out")
					child.btnArea.buttonMode = true
				}
			}
		}
		
		//Setup two popups since there are two parks maximum in each state
		private function popupSetup():void
		{
			var popup:MovieClip = getChildByName("infoPopup1") as MovieClip
			popup.visible = false
			var popup2:MovieClip = getChildByName("infoPopup2") as MovieClip
			popup2.visible = false
		}
		
		//based on number of parks in each state, show the popups (2 max)
		private function showInfo(pStateArray:Array = null):void
		{
			if (pStateArray != null)
			{
				for (var i:int = 1; i < pStateArray.length; i++)
				{
					var city:String = pStateArray[i][0].toUpperCase();
					var description:String = pStateArray[i][1];
					//var linkID:int = int(pStateArray[i][2]);
					var popup:MovieClip = getChildByName("infoPopup"+i) as MovieClip
					popup.cityText.text = city;
					popup.descriptionText.text = description;
					popup.infoVisitWeb.btnArea.buttonMode = true
					popup.visible = true;
					popup.filters = [new BlurFilter(32, 32, 3)];
					Tweener.addTween(popup, {_Blur_blurY:0, _Blur_blurX:0, time:.6})
				}
			}
		}
		
		/**
		 *	Retrieve park information of the given state
		 *	@PARAM		pState		state initial
		 **/
		private function findState(pState:String):Array
		{
			for (var i:String in mInfoArray)
			{
				if (mInfoArray[i][0] == pState)
				{
					return mInfoArray[i];
				}
			}
			return null;
		}
		
		/**
		 *	Retrieve neocontent link ID for each city
		 *	@PARAM		pCity		name of the city
		 **/
		private function findLinkID(pCity:String):int
		{
			for (var i:String in mInfoArray)
			{
				var myState:Array = mInfoArray[i]
				for (var j:int = 1; j < myState.length; j++)
				{
					if (myState[j][0].toUpperCase() == pCity) return int(myState[j][2]);
				}
			}
			return 0
		}
		
		//----------------------------------------
		//EVENT LISTENER
		//----------------------------------------
	
		private function handleMouseOver(evt:MouseEvent):void
		{
			if (evt.target.name == "btnArea")
			{
				var mc:MovieClip = evt.target as MovieClip
				MovieClip(mc.parent).gotoAndStop("over")
			}
		}
		
		private function handleMouseOut(evt:MouseEvent):void
		{
			if (evt.target.name == "btnArea")
			{
				var mc:MovieClip = evt.target as MovieClip
				MovieClip(mc.parent).gotoAndStop("out")
			}
		}
		
		//When state is clicked, show the popup(s) with park information
		private function handleStateClick(evt:CustomEvent):void
		{
			popupSetup();
			showInfo(findState(evt.oData.STATE))
		}
		
		//open up a park page based on user click
		private function handleWebClick(evt:CustomEvent):void
		{
			var btn:MovieClip = MovieClip(evt.oData.DATA)
			var popup:MovieClip = MovieClip(btn.parent)
			var linkID:int =  findLinkID(TextField(popup.getChildByName("cityText")).text)
			if (linkID != 0) {
				var url:String = "http://www.neopets.com/process_click.phtml?item_id="+linkID.toString();
				var requestURL:URLRequest = new URLRequest(url);
				navigateToURL (requestURL, 'blank');
			}
			
		}
	}
}
		