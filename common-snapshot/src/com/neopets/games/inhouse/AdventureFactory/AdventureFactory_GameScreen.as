
/* AS3
	Copyright 2008
*/
package com.neopets.games.inhouse.AdventureFactory
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import com.neopets.projects.gameEngine.gui.Interface.GameScreen;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.games.inhouse.AdventureFactory.util.DispatcherVariable;
	
	/**
	 *	This class is an extension of the basic game screen to allow for dispatcher variables.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@NP9 Game System
	 * 
	 *	@author David Cary
	 *	@since  3.10.2010
	 */
	 
	public class AdventureFactory_GameScreen extends GameScreen
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const GOAL_CHANGED:String = "goal_changed";
		
		//--------------------------------------
		//  VARIABLES
		//--------------------------------------
		// initialization variables
		protected var _tileWidth:Number;
		protected var _tileHeight:Number;
		// option lists
		protected var _levelOptionsXML:XML;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		 
		public function AdventureFactory_GameScreen():void
		{
			super();
			// set initialization variables
			_tileWidth = 31;
			_tileHeight = 31;
			// initialize option lists
			initOptions();
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get levelOptionsXML():XML { return _levelOptionsXML; }
		
		public function get tileHeight():Number { return _tileHeight; }
		
		public function get tileWidth():Number { return _tileWidth; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Use this function to intialize our option lists.
		
		public function initOptions():void {
			// set up miscellaneous item and tool options
			_levelOptionsXML = <options>
					<backgrounds>
						<option image="aztecy1"/>
						<option image="aztecy2"/>
						<option image="dzungla1"/>
						<option image="dzungla2"/>
						<option image="dzungla3"/>
						<option image="dzungla4"/>
						<option image="jaskinia1"/>
						<option image="jaskinia2"/>
					</backgrounds>
					<heroes>
						<option image="MontanaButton"/>
						<option image="SydnieButton"/>
						<option image="MaxButton"/>
						<option image="CatButton"/>
					</heroes>
					<goals>
						<option image="EscapeGoalButton"/>
						<option image="LootGoalButton"/>
						<option image="FightGoalButton"/>
						<option image="FightAndLootGoalButton"/>
					</goals>
					<tools>
						<group id="IDS_TERRAIN_TAB">
							<option image="mcx_skala"/>
							<option image="mcx_sq"/>
						</group>
						<group id="IDS_HAZARDS_TAB">
							<option image="mcx_batsCage"/>
						</group>
						<option class="EraserButton" image="EraserMC"/>
					</tools>
				</options>;
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		 
	}
	
}
