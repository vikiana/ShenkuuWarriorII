/* AS3
	Copyright 2008
*/

package  com.neopets.examples.vendorShell.document
{
	import com.neopets.examples.vendorShell.gameObjects.HexagonObject;
	import com.neopets.examples.vendorShell.gameObjects.IGameObject;
	import com.neopets.examples.vendorShell.gameObjects.SquareObject;
	import com.neopets.examples.vendorShell.menus.NewGameOverScreen;
	import com.neopets.examples.vendorShell.translation.TranslationInfo;
	import com.neopets.projects.gameEngine.gui.AbsMenu;
	import com.neopets.projects.gameEngine.gui.Interface.GameScreen;
	import com.neopets.projects.gameEngine.gui.Interface.InstructionScreen;
	import com.neopets.projects.gameEngine.gui.Interface.OpeningScreen;
	import com.neopets.projects.gameEngine.gui.MenuManager;
	import com.neopets.projects.np9.system.NP9_Evar;
	import com.neopets.projects.np9.vendorInterface.NP9_VendorGameExtension;
	import com.neopets.util.display.ViewContainer;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.geom.Point;
	
	import virtualworlds.lang.TranslationData;
	import virtualworlds.lang.TranslationManager;

	/**
	 *	This is an Example of the Main Game Code for a Demo.
	 * 	This Version Adds a Custom Menu and Overrides some basic Menu Navigation.
	 *  @NOTE:  It Extends NP9_VendorGame Extension to get Access to The Translation Setup, Menu Setup.
	 *  @NOTE: This Class overrides some functions that most every game will need.
	 * 
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern GameEngine
	 * 
	 *	@author Clive Henrick
	 *	@since  7.7.2009
	 */

	
	public class VendorExampleGame_Extended extends NP9_VendorGameExtension
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		protected var mGameObjectArray:Array;


		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function VendorExampleGame_Extended():void
		{
			super();
			setGameVars();
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		

		 
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * @Note: Updates the Score when the Objects are Clicked
		 * @param		evt.oData.ID				String 		The Name of the Object Clicked
		 * @param		evt.oData.SCORE		Number	The Value of the Object Clicked
		 */
		 
		 protected function 	updateScore (evt:CustomEvent):void
		 {
		 	mScore.changeBy( evt.oData.SCORE);
		 }
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		
		/**
		 * @NOTE: This to reset basic elements for a New Game
		 */
		 
		 protected override  function restartGame():void
		 {
		 	mScore = new NP9_Evar(0);
		 	mMenuManager.menuNavigation(MenuManager.MENU_INTRO_SCR);
		 }
		
		/**
		 * @Note: Starts the Game with all the Code you need to start at this Moment
		 */
		 
		 protected override function startGame():void
		 {
		 	mMenuManager.menuNavigation(MenuManager.MENU_GAME_SCR);
		 }
		
		  /**
		 * @Note: Quit for your Game from the In Game Screen
		 */
		 
		 protected override function quitGame():void
		 {
		 	var tGameOverScreen:NewGameOverScreen = mMenuManager.getMenuScreen(MenuManager.MENU_GAMEOVER_SCR) as NewGameOverScreen;		/* NEW EXTENDED MENU */
		 	tGameOverScreen.setFinalTime((Math.random() * 1000));		/* THIS IS ONLY FOR A TEST OF AN EXTENDED MENU */
		 		
		 }
		 
		  /**
		 * @Note Setups the Menus for the Game. 
		 * @Note: Overrided as the GameOver Menu is non standard and uses ExtendedGameOverScreen instead of the normal class.
		 */
		 
		protected override function setupMenus():void
		{
			var translationManager : TranslationManager = TranslationManager.instance;
			
			var tIntroScreen:OpeningScreen = OpeningScreen(mMenuManager.createMenu("mcOpeningScreen", MenuManager.MENU_INTRO_SCR));
			var tGameScreen:GameScreen = GameScreen(mMenuManager.createMenu("mcGameScreen", MenuManager.MENU_GAME_SCR));
			var tGameOverScreen:NewGameOverScreen = NewGameOverScreen(mMenuManager.createMenu("ExtendedGameOverScreen", MenuManager.MENU_GAMEOVER_SCR));
			var tInstructionScreen:InstructionScreen = InstructionScreen(mMenuManager.createMenu("mcInstructionScreen", MenuManager.MENU_INSTRUCT_SCR,false,null,MenuManager.MENU_INTRO_SCR,new Point(50,25)));	
		
			//Intro Screen
			translationManager.setTextField(tIntroScreen.instructionsButton.label_txt, mTranslationInfo.IDS_BTN_INSTRUCTION);
			translationManager.setTextField(tIntroScreen.startGameButton.label_txt, mTranslationInfo.IDS_BTN_START);
			translationManager.setTextField(tIntroScreen.txtFld_copyright, mTranslationInfo.IDS_COPYRIGHT_TXT);
			translationManager.setTextField(tIntroScreen.txtFld_title, mTranslationInfo.IDS_TITLE_NAME);
			
			//Instruction Screen
			translationManager.setTextField(tInstructionScreen.returnBtn.label_txt, mTranslationInfo.IDS_BTN_BACK);
			translationManager.setTextField(tInstructionScreen.instructionTextField, mTranslationInfo.IDS_INSTRUCTION_TXT);
			
			//In Game Screen
			translationManager.setTextField(tGameScreen.quitGameButton.label_txt, mTranslationInfo.IDS_BTN_QUIT);
			
			//Game Over Screen
			translationManager.setTextField(tGameOverScreen.playAgainBtn.label_txt, mTranslationInfo.IDS_BTN_PLAYAGAIN);
			translationManager.setTextField(tGameOverScreen.reportScoreBtn.label_txt, mTranslationInfo.IDS_BTN_SENDSCORE);
			
			extendMenus();
		}
		
			/**
		 * @Menu Navigation can trigger Events if Needed
		 * @param		evt.oData.MENU		String 		The Name of the Menu you have navigated to
		 */
		  
		 protected override function onMenuNavigationEvent (evt:CustomEvent):void
		 {
		 		
		 	switch (evt.oData.MENU)
		 	{
		 		case MenuManager.MENU_GAMEOVER_SCR:		// FIRST TIME GOING TO THE END SCREEN , NEED TO SEND GAME OVER TO SERVER
		 			mDocumentClass.neopets_GS.sendTag (mDocumentClass.END_GAME_MSG);	
		 			var tGameOverScreen:NewGameOverScreen = mMenuManager.getMenuScreen(MenuManager.MENU_GAMEOVER_SCR) as NewGameOverScreen;
		 			tGameOverScreen.toggleInterfaceButtons(true);
		 		break;
		 	}	
		 }
		 
		 /**
		 * @Note: Send Your Score to Neopets
		 */
		 
		 protected override function reportScore():void
		 {
			mDocumentClass.neopets_GS.sendScore(mScore.show()); 	
		 }
		 
		   /**
		 * @Note: Need to Turn off / On  the Background Track
		 */
		 
		 protected override function toggleMusic():void
		 {
		 		trace("Toggle Music Btn Pressed");
		 }
		 
		 /**
		 * @Note: Need to Turn off / On all the Sounds
		 */
		 
		 protected override function toggleSound():void
		 {
				trace("Toggle Sound Btn Pressed");	
		 }
		 
		/**
		 * @Note: This is all the Startup Vars
		 */
		 
		protected function setGameVars():void
		{	
			mTranslationInfo = new TranslationInfo();
			mGameObjectArray = [];
		}
		
		  /**
		 * @Note: This is going to pull objects out of the externalLibrary
		 * 		> Since the ExternalAssets are loaded into the Parent Application Domain, 
		 * 		> you can just access an item in the library.
		 */
		 
		  protected override function startGameSetup():void 
		  {
		  	var tID:String;
		  	
		  	var tGameScreen:GameScreen = mMenuManager.getMenuScreen(MenuManager.MENU_GAME_SCR) as GameScreen;
		  	var tHexArea:Rectangle = new Rectangle(0,0,300,300);
		  	var tSquareArea:Rectangle = new Rectangle(0,0,600,500);
		  	
		  	var tHexClass:Class = ApplicationDomain.currentDomain.getDefinition("mcHexagon") as Class;
		 	var tSquareClass:Class = ApplicationDomain.currentDomain.getDefinition("mcSquare") as Class;
		 	
		 	for (var tCount:int = 0; tCount < 10; tCount++)
		 	{
		 		if (tCount & 1)
		 		{
		 			tID = "HexObj"+tCount;
		 			var tHexsObject:MovieClip = new tHexClass();
		 			mGameObjectArray.push(tHexsObject);
		 			tHexsObject.init(tID,tHexArea,.6);
		 			tHexsObject.addEventListener(tHexsObject.SEND_SCORE, updateScore, false,0,true);
		 			tGameScreen.addChild(tHexsObject);
		 		}
		 		else
		 		{
			 		tID = "SquareObj"+tCount;
			 		var tSqrGameObj:MovieClip = new tSquareClass();
			 		mGameObjectArray.push(tSqrGameObj);
			 		tSqrGameObj.init(tID,tSquareArea,.5);
			 		tSqrGameObj.addEventListener(tSqrGameObj.SEND_SCORE, updateScore, false,0,true);
			 		tGameScreen.addChild(tSqrGameObj);
		 		}
		 	}
		 	
		 	
		 	gameSetupDone();
		  }
		  
		  /**
		  * @Note: The Game Demo is Done and ready to tell the Shell its Done with Setup
		  * 	> Adds the GameDemo View Contaienr to the GameEngines ViewContainer
		  * 	> Tells the GameEngine it is ready
		  * */
		  
		  protected function gameSetupDone():void
		  {
		  	mDocumentClass.addChildAt(this,mDocumentClass.numChildren);
		   	mMenuManager.menuNavigation(MenuManager.MENU_INTRO_SCR);

		   	var tLanguageStr:String = mDocumentClass.neopets_GS.getFlashParam("sLang") ;
		   
		   	if (tLanguageStr == null)
		   	{
				tLanguageStr = 	mDocumentClass.mcBIOS.game_lang;	
		   	}
		
		   	mMenuManager.getMenuScreen(MenuManager.MENU_INTRO_SCR).mcTransLogo.gotoAndStop(tLanguageStr.toUpperCase());
		  }
		  
		
		 
		
		  
		  
		  
	}
	
}
