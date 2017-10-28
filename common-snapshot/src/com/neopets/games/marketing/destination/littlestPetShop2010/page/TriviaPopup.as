/* AS3
Copyright 2009
*/

package com.neopets.games.marketing.destination.littlestPetShop2010.page
{

	/**
	 *	@NOTE:	This is sort handed quickie version of trivia system and unique as well 
	 *			so I don't really recommend to look at this for general trivia system
	 *			For this project, because the amfphp call is combined with trivia and banner quest, 
	 *			by the time main page is called, the questions and answers are already retrieved.  
	 *			So this only displays teh questions and anwers
	 *	@NOTE:  Also on my project radial button was throwing error so made custom button and functionality
	 *			
	 **/

	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import flash.events.MouseEvent;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.video.VideoManager;
	import com.neopets.util.tracker.NeoTracker;
	import com.neopets.projects.destination.destinationV3.Parameters



	public class TriviaPopup extends PageDesitnationBase2 {
		
		//----------------------------------------
		//VARIABLES
		//----------------------------------------
		
		
		protected var trivia:MovieClip;  //movie clip in teh library.  Already has necessary text fields
		protected var submitBtn:MovieClip;	//submit button in trivia movie clip
		protected var answer:MovieClip;	//selected answer movie clip

		//--------------------------------------
		//  constructor
		//--------------------------------------

		/**
		 *	set up the popup page
		 **/
		public function TriviaPopup():void 
		{
			setupPage();
		}
		
		//--------------------------------------
		//  getter
		//--------------------------------------
		
		/**
		 *	cheap quick way to know which answer was selected at the time of submission
		 * 	each answer box is named (answer1, answer2, etc.) so I am jsut retrieving the number portion
		 *	of the answer box name
		 **/
		public function get answerNumber ():int
		{
			var txt:String = answer.name
			return int(txt.substr(6, 1))
		}
		
		
		//--------------------------------------
		//  public method
		//--------------------------------------
		
		
		/**
		 *	show the question and answers in the trivia movie clip
		 **/
		public function setQuestions(pQuestion:String, pAnswers:Array):void
		{
			trivia.triviaQuestion_txt.text = pQuestion;
			showAnswerOption(pAnswers);
			
		}
		
		
		//--------------------------------------
		// protected private
		//--------------------------------------


		/**
		 *	compose trivia display objects
		 **/
		override protected function setupPage():void 
		{
			addImage("MC_triviaPopup", "triviaPannel", 0, 0);
			placeTextButton("MC_navButton", "submitBtn", "Submit", 280, 420, 0, "out");
			placeTextButton("MC_navButton", "hintBtn", "Hint", 460, 420, 0, "out");
			trivia = MovieClip(getChildByName("triviaPannel"));
			submitBtn = MovieClip(getChildByName("submitBtn"));
			submitBtn.visible= false;
		}
		
		
		/**
		 *	Show answer movie clips with appropriate texts.  and hide rest of the anser MCs if there is 
		 *	no answer for it. i.e. if pAnswers array has only 3 answers, 
		 *	show the first 3 answer MCs with correct text and hide the forth answer mc
		 *
		 *	@PARAM		pAanswers		Array		contains array of answers
		 **/
		protected function showAnswerOption(pAnswers:Array):void
		{
			for (var i:int = 0 ; i < 4; i++)
			{
				trivia["answer" + i].visible = false;
			}
			
			for (var j:int = 0 ; j< pAnswers.length ; j++)
			{
				trivia["answer" + j].visible = true;
				trivia["answer" + j].label_txt.text = pAnswers[j].answer;
				trivia["answer" + j].addEventListener(MouseEvent.MOUSE_DOWN, answerSelected, false, 0, true)
				trivia["answer" + j].addEventListener(MouseEvent.MOUSE_OVER, answerOver, false, 0, true)
			}
			
		}
		
		
		/**
		 *	set all answer movie clips as "unselected" radial button state
		 **/
		protected function resetAnswer():void
		{
			for (var i:int = 0 ; i < 4; i++)
			{
				trivia["answer" + i].gotoAndStop("off");
			}
		}


		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 *	set the answer movie clip as "over" radial button state
		 **/
		protected function answerOver(evt:MouseEvent):void
		{
			resetAnswer()
			evt.currentTarget.gotoAndStop("on");
			if (answer != null)
			{
				answer.gotoAndStop("selected")
			}
		}
		
		/**
		 *	set the answer movie clip as "selected" radial button state
		 **/
		protected function answerSelected(evt:MouseEvent):void
		{
			resetAnswer()
			evt.currentTarget.gotoAndStop("selected");
			answer = MovieClip(evt.currentTarget);
			submitBtn.visible= true;
			
		}



		/**
		 *	tasks that needs to be carried out based on user clicks
		 **/
		override protected function handleObjClick(e:CustomEvent):void {
			switch (e.oData.DATA.parent.name) {
				case "closeBtn_mc" :
					trace("close");
					cleanup();
					this.parent.removeChild(this)
					break;
					
				case "submitBtn":
					// at this submit level, it only hides the answers and submit button
					// the actual amfphp calls for submitting answer happens in mainpage.as level
					for (var i:int = 0 ; i < 4; i++)
					{
						trivia["answer" + i].visible = false;
					}
					submitBtn.visible= false;
					break;
				
				case "hintBtn":
					NeoTracker.processClickURL(15682)
					break;
			}
		}
	}
}