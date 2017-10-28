
/* AS3
	Copyright 2008
*/
package  com.neopets.games.inhouse.shenkuuSideScroller.menuExt
{
	import com.neopets.projects.gameEngine.gui.AbsMenu;
	import com.neopets.util.button.NeopetsButton;
	import com.neopets.users.abelee.utils.ViewManager_v3;
	import com.neopets.games.inhouse.shenkuuSideScroller.misc.AssetTool;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	
	/**
	 *	This is a Simple Menu for the Opening Screen
	 *	The Button Click Commands are not handled at this level but at the Insatiation of this Class.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@NP9 Game System
	 * 
	 *	@author Clive Henrick
	 *	@since  7.08.2009
	 */
	 
	public class CustomInstructionScreen extends AbsMenu
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		
		public var returnBtn:NeopetsButton; 		//On Stage
		public var instructionTextField:TextField; //On Stage
		
		
		private var mInstructionBoxes: ViewManager_v3; 
		private var instBox1:MovieClip;
		private var instBox2:MovieClip;
		private var instBox3:MovieClip;
		private var prevButton:MovieClip;
		private var nextButton:MovieClip;
		
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function CustomInstructionScreen():void
		{
			super();
			setupVars();

		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get box1 ():MovieClip
		{
			return instBox1
		}
		public function get box2 ():MovieClip
		{
			return instBox2
		}
		public function get box3 ():MovieClip
		{
			return instBox3
		}
		
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * @Note: Setups Variables
		 */
		 
		private function setupVars():void
		{
			trace (AssetTool.getClass("Boat"))
			trace (AssetTool.getAsset("InstructionsBox1"))
			trace ("from custom instruction", getDefinitionByName ("InstructionsBox1"))
		 	returnBtn.addEventListener(MouseEvent.MOUSE_UP,MouseClicked,false,0,true);
			mID = "GameScene";
			
			instBox1 = AssetTool.getMC("InstructionsBox1")
			instBox2 = AssetTool.getMC("InstructionsBox2")
			instBox3 = AssetTool.getMC("InstructionsBox3")
			prevButton = AssetTool.getMC("LeftArrow")//new LeftArrow ()
			nextButton = AssetTool.getMC("RightArrow")//new RightArrow ()
			
			mInstructionBoxes = new ViewManager_v3 ([instBox1, instBox2, instBox3],[prevButton, nextButton],1);
			addChild (mInstructionBoxes);
			mInstructionBoxes.x = 100;
			mInstructionBoxes.y = 10;
			
			prevButton.buttonMode = true;
			nextButton.buttonMode = true;
			
		}
		 
		
		 
		 
	}
	
}
