/*
This trivia game is based on the trivia quiz in chapter 10 of AS3 Game Programming University 
by Gary Rosenzweig

*/
package com.neopets.games.inhouse.HideTheFart
{

	// IMPORTS
	import com.neopets.projects.gameEngine.gui.Interface.GameScreen;
	import com.neopets.util.display.DisplayUtils;
	import com.neopets.projects.gameEngine.gui.MenuManager;
	
	import com.neopets.projects.gameEngine.common.GameEngine;
	import com.neopets.util.managers.ScoreManager;
	//
	import com.neopets.games.inhouse.HideTheFart.HideTheFartEngine;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.Timer;

	// Specific Trivia game imports
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.net.URLLoader;// for the xml
	import flash.net.URLRequest;


	// CLASS DEFINITION
	public class HideTheFartGame extends MovieClip
	{

		//-------------------------------------------------------------
		// PROPERTIES
		//-------------------------------------------------------------

		// question data
		private var dataXML:XML;

		// text formats
		private var questionFormat:TextFormat;
		private var answerFormat:TextFormat;
		private var scoreFormat:TextFormat;

		// text fields
		private var messageField:TextField;
		private var questionField:TextField;
		private var scoreField:TextField;
		private var scoreFieldTwo:TextField;
		private var titleField:TextField;

		// sprites and objects
		private var gameSprite:Sprite;// contains everything
		private var questionSprite:Sprite;// single quiz question
		private var answerSprites:Sprite;// text field and 
		private var gameButton:GameButton;// generic button

		// game state variables
		private var questionNum:int;// which number we are currently on
		private var correctAnswer:String;// before they are shuffled, the first answer is the correct one
		private var numQuestionsAsked:int;
		private var numCorrect:int;// score
		private var answers:Array;// we'll put all 4 answers randomly in this array

		private var bonusRound:BonusRound;
		private var startGameBtn:Boolean;
		

		//-------------------------------------------------------------
		// CONSTRUCTOR
		//-------------------------------------------------------------
		public function HideTheFartGame()
		{
			trace("Constructor");
		}


		//-------------------------------------------------------------
		// METHODS
		//-------------------------------------------------------------
	
		private function initGame():void
		{
			trace("----INIT GAME----");
			// create main game sprite
			gameSprite = new Sprite();
			addChild(gameSprite);

			// set text formats for various text fields
			questionFormat = new TextFormat("Arial",20,0x330000,true,false,false,null,null,"left");
			answerFormat = new TextFormat("Arial",18,0x330000,true,false,false,null,null,"left");
			scoreFormat = new TextFormat("Arial",18,0x330000,true,false,false,null,null,"left");

			// Keep track of correct answers - using custom createText method
			//scoreField = createText("",questionFormat,gameSprite,20,440,550);
			scoreFieldTwo = createText("",scoreFormat,gameSprite,15,515,150);

			// Loading message will show until xml is loaded
			messageField = createText("xml file loading...",scoreFormat,gameSprite,0,50,550);

			// set up game state and load questions
			questionNum = 0;
			numQuestionsAsked = 0;
			numCorrect = 0;
			
			xmlImport();// retrieves xml quiz data
			
		}
		
		public function startGame():void
		{
			trace("----Hide the Fart startGame()----");
			initGame();
			
			//Separate start button - temporary fix for multiple errors that happen when calling pressedGameButton()
			showGameButton("Start the Trivia Game!");
			//pressedGameButton(null); 
			
			// Make sure the game always starts with the "MainLevel" frame
			var tGameScreen:GameScreen = MenuManager.instance.getMenuScreen(MenuManager.MENU_GAME_SCR);
			tGameScreen.gotoAndStop("MainLevel");
			
		}

		private function endGame(evt:MouseEvent):void
		{
			trace("---- End game ----");
		}

		// Not used in this game
		internal function endLevelOne():void
		{
			trace("---- endLevelOne() ----");
		}

		// Happens when quit button is clicked
		internal function resetLevelOne():void
		{
			trace("---- resetLevelOne() ----");
			cleanUp(); // removes trivia and/or bonus rounds
		}


        
// -----    TRIVIA GAME METHODS  -----------------------------------------------
		// loads the questions from the xml file
		private function xmlImport()
		{

			//local xml URL when testing
			//var xmlURL:URLRequest = new URLRequest("games/g1264/trivia.xml");

			//Needs to be images.neopets to work remotely
			var xmlURL:URLRequest = new URLRequest("http://images.neopets.com/games/g1264/trivia.xml");
			//var xmlURL:URLRequest = new URLRequest("http://images50.neopets.com/games/g1264/trivia.xml");

			var xmlLoader:URLLoader = new URLLoader(xmlURL);
			xmlLoader.addEventListener(Event.COMPLETE, xmlLoaded);

			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, xmlLoadError);
			
			//Throw error if xml doesn't load
			function xmlLoadError(e:IOErrorEvent)
			{
				trace('There was an error loading the xml file.');
			}

		}


		// After xml questions are loaded
		private function xmlLoaded(event:Event)
		{
			dataXML = XML(event.target.data); // variable that holds xml once it has been loaded
			//trace("GS: "+gameSprite);
			if(gameSprite != null)
			{
				gameSprite.removeChild(messageField); // remove loading message;
			}
		}
		
	   
	// Utility method for creating text fields
	private function createText(text:String, tf:TextFormat, s:Sprite, x,y: Number, width:Number):TextField
	{
		var tField:TextField = new TextField();
		tField.x = x;
		tField.y = y;
		tField.width = width;
		tField.defaultTextFormat = tf;
		tField.selectable = false;
		tField.multiline = true;
		tField.wordWrap = true;
		if (tf.align == "left")
		{
			tField.autoSize = TextFieldAutoSize.LEFT;
		}
		else
		{
			tField.autoSize = TextFieldAutoSize.CENTER;
		}
		tField.text = text;
		s.addChild(tField); // attach to sprite
		return tField;
	}

	// updates the score
	public function showGameScore()
	{
		//scoreField.text = "Questions Correct: " + numCorrect;
		scoreFieldTwo.text = "Score: " + ScoreManager.instance.getValue();
	}

	// Add button to move to next question
	public function showGameButton(buttonLabel:String)
	{
		//trace("GameBTN"+gameButton);
		//trace("GS"+gameSprite);
		gameButton = new GameButton();
		gameButton.btn_txt.text = buttonLabel;
		gameButton.x = 200;
		gameButton.y = 250;
		gameSprite.addChild(gameButton);
		gameButton.addEventListener(MouseEvent.CLICK,pressedGameButton);
		 
		// when clicking the Next Question button
		gameButton.btn_txt.mouseEnabled = false;
		gameButton.buttonMode = true;
	}

	// Next Question button clicks 
	public function pressedGameButton(event:MouseEvent)
	{
		trace("--- pressedGameButton() ---");
		showGameScore(); // should show zero at start of the game
		
			clearPreviousQuestion(); 
			// After 5 question, go to bonus round after button click
			trace("PGB - questionNum: "+questionNum);
			if (questionNum > 5) // 6 questions in xml file(5 in xml array). Hardcoded for testing. 
			{
				trace("TRIVIA GAME OVER");
				// Add bonus round once trivia game is over
				addBonusRound();
			}
			
			// Continue asking questions
			else
			{
				trace("--- askQuestion ---");
				askQuestion();
			}
	}
	
	private function clearPreviousQuestion()
	{
		//trace("CLEAR PREVIOUS QUESTION");
		
		// Remove items after each question - individual if statements necessary to avoid Flash errors
		if (questionSprite != null && this.contains(questionSprite))
		 {
			gameSprite.removeChild(questionSprite); //
		 }
		
		if(gameButton != null && this.contains(gameButton))
		 {
			gameSprite.removeChild(gameButton);
		 }
		 
		if(messageField != null && this.contains(messageField))
		{
			gameSprite.removeChild(messageField);
		}
		
	}
		
		
	// Set up the question on the stage
	private function askQuestion()
	{
		// Question sprite
		questionSprite = new Sprite();
		gameSprite.addChild(questionSprite);

		// Question text field
		var question:String = dataXML.item[questionNum].question;
		questionField = createText(question,questionFormat,questionSprite,50,70,400);

		// The first answer is always the correct answer
		correctAnswer = dataXML.item[questionNum].answers.answer[0];
		answers = shuffleAnswers(dataXML.item[questionNum].answers); // Shuffle the answers for variety

		// put each answer into a new sprite with the square MC from the library
		answerSprites = new Sprite();
		for (var i:int=0; i<answers.length; i++)
		{
			var answer:String = answers[i];
			var answerSprite:Sprite = new Sprite();
			var letter:String = String(1 + i);// Numbers 1-4 that are added to square MC
			var answerField:TextField = createText(answer,answerFormat,answerSprite,0,0,450);
			var circle:Circle = new Circle();// Originally a cirle, but now a square from Library
			circle.letter.text = letter; // now a number
			circle.letter.mouseEnabled = false;
			circle.buttonMode = true;

			answerSprite.x = 100;
			answerSprite.y = 150 + i * 50;
			answerSprite.addChild(circle);
			answerSprite.addEventListener(MouseEvent.CLICK,clickAnswer);
			// make it a button;
			answerSprite.buttonMode = true;
			answerSprites.addChild(answerSprite);
		}
		questionSprite.addChild(answerSprites);
	}

	// take all the answers and shuffle them into an array;
	private function shuffleAnswers(answers:XMLList)
	{
		var shuffledAnswers:Array = new Array();
		while (answers.child("*").length() > 0)
		{
			var r:int = Math.floor(Math.random() * answers.child("*").length());
			shuffledAnswers.push(answers.answer[r]); // add removed item into array
			delete answers.answer[r]; // remove one item
		}
		return shuffledAnswers;
	}

	// Check to see which answer player clicked
	private function clickAnswer(event:MouseEvent)
	{
		trace("--- Click Answer() ---");
	
		// Check if answer is correct
		var selectedAnswer = event.currentTarget.getChildAt(0).text;
		if (selectedAnswer == correctAnswer) // previously stored in askQuestion()
		{
			numCorrect++;
			messageField = createText("Correct!",questionFormat,gameSprite,50,160,550);
			ScoreManager.instance.changeScore(50); // add 50 for each correct question
			trace("CURRENT SCORE: "+ScoreManager.instance.getValue());
		}
		else
		{
			messageField = createText("Wrong! The correct answer was: ",questionFormat,gameSprite,50,160,550);
		}

		finishQuestion();

	}

	// remove all but the correct answer
	private function finishQuestion()
	{
	
		for (var i:int=0; i<4; i++)
		{
			answerSprites.getChildAt(i).removeEventListener(MouseEvent.CLICK,clickAnswer);
			if (answers[i] != correctAnswer)
			{
				answerSprites.getChildAt(i).visible = false;
			}
			else
			{
				answerSprites.getChildAt(i).y = 200; // keep correct answer on stage
			}
		}

		// keep asking questions
		trace("FQ:questionNum: "+questionNum);
		if (questionNum < 5 )  // 6 questions in xml file(5 in xml array). Hardcoded for testing. 
		{
			questionNum++;
			numQuestionsAsked++;
			showGameScore();
			showGameButton("Next Question");
		}
		
		
		//Show Bonus Round button after 6th question
		else
		{
			trace("Go to bonus round");
			questionNum++; // needed for pressedGameButton()
			showGameScore();
			showGameButton("Go to Bonus Round"); // now when bonus round is clicked, remove 
		}
		

	}

	// Clean up the trivia round and/or bonus round
	private function cleanUp()
	{
		trace("--- Clean up() ---");
		// without the multiple if statements, errors will happen after quitting and restarting the 
		// game several times
		
		if(gameSprite != null && this.contains(gameSprite))
		{
		 removeChild(gameSprite);
		 gameSprite = null;
		}
		
		if(questionSprite != null && this.contains(questionSprite))
		{
			questionSprite = null;
		}
		
		if(answerSprites != null && this.contains(answerSprites))
		{
			answerSprites = null;
		}
		
		if(dataXML != null)
		{
			dataXML = null;
		}

		//remove bonus level assets
		
		removeBonusRound();
	}


	// Add a bonus round
	public function addBonusRound()
	{
		trace("BONUS ROUND");
		
		/* 
		  This is a simple timeline option for the demo, 
		  the menu manager can also create a new level
		*/
		var tGameScreen:GameScreen = MenuManager.instance.getMenuScreen(MenuManager.MENU_GAME_SCR);
		tGameScreen.gotoAndStop("BonusLevel");
		
		bonusRound = new BonusRound();
		addChild(bonusRound); // add the new class to the display list
		bonusRound.initBonusRound();
		
		//Remove the score text field since the Bonus Round will have it's own score field
		if(gameSprite != null)
		{
			gameSprite.removeChild(scoreFieldTwo);
		}
		
	}
	
	public function removeBonusRound():void
	{
		trace("--- removeBonusRound ---");
		bonusRound.cleanUpBonusRound();
		if(bonusRound != null && this.contains(bonusRound))
		{
		 removeChild(bonusRound);
		 
		 // remove all of the assets
		 
		}
	}
	
	// Optional randomization of questions
	// ---------------------------------------------------------------------------------------
	/*
	  If you would like to have more variety, you can add more questions to your xml file and then
	  have the function below select a certain number of questions for your game. This way, your have
	  6 main questions from a group of 20 and the game will be different every time.
	  
	  Replace the previous xmlLoaded function with this one:
	 
	  public function xmlLoaded(event:Event)
	  {
	   var tempXML:XML = XML(event.target.data);
	   dataXML = selectQuestions(tempXML, 4);
	   if(gameSprite != null)
		{
				gameSprite.removeChild(messageField); // remove loading message;
		}
	  }
	  
	  
	  Then add this function which will select a random number of questions
	  public function selectQuestions(allXML:XML, numToChoose:int):XML {
			
			// create a new XML object to hold the questions
			var chosenXML:XML = <trivia></trivia>;
			
			// loop until we have enough
			while(chosenXML.child("*").length() < numToChoose) {
				
				// pick a random question and move it over
				var r:int = Math.floor(Math.random()*allXML.child("*").length());
				chosenXML.appendChild(allXML.item[r].copy());
				
				// don't use it again
				delete allXML.item[r];
			}
			
			// ret
			return chosenXML;
		}
	
	
	
	*/
	// -----------------------------------------------------------------------------------------
	
	
	
	} // End of Main class
}

