//Marks the right margin of code *******************************************************************
package com.neopets.games.inhouse.Diceroll
{
	import com.neopets.users.vivianab.LibraryLoader;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.sampler.NewObjectSample;
	
	
	/**
	 * public class Blumaroll_rollingpage extends MovieClip
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class Blumaroll_rollingpage extends GenericScreenClass
	{
		//--------------------------------------------------------------------------
		// Costants
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		//--------------------------------------------------------------------------
		//Public properties
		//--------------------------------------------------------------------------	
		/**
		 * The following are embedded assets. To add them to the Flash project, just add the corresponding symbol (from assets/rollingPage.fla) in the library 
		 * and give it the linkage name described by the Class variable. Then comment out the embeds.
		 */
		/*[Embed(source="assets/rollingPage.swf", symbol="Table_mc")]
		private var Table_mc:Class;
		[Embed(source="assets/rollingPage.swf", symbol="BoardMask_mc")]
		private var BoardMask_mc:Class;
		[Embed(source="assets/rollingPage.swf", symbol="Floor_mc")]
		private var Floor_mc:Class;*/
		
		
		
		//ROLLING TABLE
		private var _floor:Sprite;
		private var _table:Sprite;
		private var _mask:Sprite;
		private var _board:DiceRollTray
		
		private var _rollagainPopup:MovieClip;
		
		private var _winningFace:int;
		//CALL BACK FUNCTION for dice landed
		private var _callBack:Function;
	
		//--------------------------------------------------------------------------
		//Private properties
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Creates a new public class Blumaroll_rollingpage extends MovieClip instance.
		 * This page holds the DiceRollTray, that contains the 3D scene and physics.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function Blumaroll_rollingpage()
		{
			super();
			
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		/**
		 * Initializes the page, builds the table and the rolling tray.
		 * 
		 * @param  stg  of type <code>Stage</code>    Stage reference
		 * @param  callback   of type <code>Function</code>    Callback function to call when the dice is landed.
		 * @param  winningFace   of type <code>int</code>   Index of the winning face. 
		 * 
		 *  <span class="hide">1 - wood; 2 - bronze; 3 - silver; 4 - gold; 5 - Bonus; 6 - Double</span>
		 */
		public function init(bitmaps:Array, stg:Stage, callback:Function, winningFace:int, rolled:Boolean =false):void {
			/*_floor = new Floor_mc ();
			_table = new Table_mc();
			_mask = new BoardMask_mc();*/
			_floor = LibraryLoader.createElement("Floor_mc", 0, 0);
			_table =  LibraryLoader.createElement("Table_mc", 0, 0);
			_mask = LibraryLoader.createElement("BoardMask_mc", 0, 0);
			_board = new DiceRollTray ();
			_board.addEventListener(_board.CHANGE_VIEW, changeView, false, 0, true);
			_board.addEventListener(_board.RESET_VIEW, resetView);
			_board.addEventListener(_board.LANDED,diceLanded);
			_board.addEventListener(_board.ROLL_AGAIN, rollAgain);
			
			_callBack = callback;
			
			stg.addEventListener(BUTTON_PRESSED,onButtonPressed,false,0,true);
			
			
			addChild(_floor);
			addChild(_board);
			addChild(_mask);
			_board.mask = _mask;
			addChild(_table);
			
			
			_winningFace = winningFace;
			_board.init (bitmaps, _winningFace, stg, rolled);
		}
		
		
		public function cleanup():void {
			_board.mask = null;
			_callBack = null;
			_board.cleanup();
			for (var i:int = numChildren; i>=0; i--){
				removeChildAt(i);
			}
			if (_board.hasEventListener(_board.CHANGE_VIEW)){
				_board.removeEventListener(_board.CHANGE_VIEW, changeView);
			}
			if (_board.hasEventListener(_board.RESET_VIEW)){
				_board.removeEventListener(_board.RESET_VIEW, resetView);
			}
			if (_board.hasEventListener(_board.LANDED)){
				_board.removeEventListener(_board.LANDED, changeView);
			}
			if (stage.hasEventListener(BUTTON_PRESSED)){
				stage.removeEventListener(BUTTON_PRESSED,onButtonPressed);
			}
			
			if (_board.hasEventListener(_board.ROLL_AGAIN)){
				_board.removeEventListener(_board.ROLL_AGAIN, rollAgain);
			}
		}
		/**
		 * This resets the page for play again.
		 * 
		 */
		public function playAgain(winningFace:int, stg:Stage):void{
			_board.cleanup();
			resetView();
			_board.init (null, winningFace, stg);
		}
		//--------------------------------------------------------------------------
		// Protected Methods
		//--------------------------------------------------------------------------
		/**
		 * Repositions the display objects to show the landing view.
		 * 
		 * @param  e  of type <code>Event</code>    
		 */
		private function changeView (e:Event):void {
			_board.removeEventListener(_board.CHANGE_VIEW, changeView);
			swapChildren(_table, _board);
			_board.mask = null;
			_board.x -= 350;
			_board.y -= 350;
			_board.scaleX = _board.scaleY = 1.9;
		}
		
		
		/**
		 * Restore the initial dispaly objects position.
		 * 
		 * @param  e  of type <code>Event</code>    
		 */
		private function resetView (e:Event=null):void {
			_board.removeEventListener(_board.RESET_VIEW, resetView);
			if (getChildIndex(_table) <getChildIndex(_board)){
				swapChildren(_table, _board);
				_board.mask = _mask
				_board.x += 350;
				_board.y += 350;
				_board.scaleX = _board.scaleY = 1;
			}		
		}
		
		
		private function rollAgain(e:Event):void {
			if (!_rollagainPopup){
				_rollagainPopup = LibraryLoader.createElement("mcRollagainPopup",0, 0);			
				_rollagainPopup.setTrans(tManager, tData);
				addChild(_rollagainPopup);
				_rollagainPopup.init();
			} else {
				addChild(_rollagainPopup);
			}
		}
		
		
		/**
		 * Calls a parent's function when the dice lands
		 * 
		 * @param  e  of type <code>Event</code>    
		 */
		private function diceLanded (e:Event):void {
			_board.removeEventListener(_board.LANDED,diceLanded);
			_callBack ();
		}
		//--------------------------------------------------------------------------
		// Private Methods
		//--------------------------------------------------------------------------	
		//--------------------------------------------------------------------------
		// Event Handlers
		//--------------------------------------------------------------------------	
		/**
		 * Handler for CustomEvent.
		 * 
		 * @param event The <code>CustomEvent</code>
		 * 
		 */
		private function onButtonPressed(evt:CustomEvent):void {
			switch (evt.oData.TARGETID)
			{
				case "btn_rollAgain":  
					if (_rollagainPopup){
						if (contains(_rollagainPopup)){
							removeChild(_rollagainPopup)
							resetView();
							_board.cleanup();
							_board.init(null, _winningFace);
						}
					}
					break;
			}
		}
		//--------------------------------------------------------------------------
		// Getters/Setters
		//--------------------------------------------------------------------------
	}
}