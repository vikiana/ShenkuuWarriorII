//Marks the right margin of code *******************************************************************
package com.neopets.projects.np10.data.vo
{
	/*import com.neopets.projects.np10.statemachine.states.AssetsLoaded;
	import com.neopets.projects.np10.statemachine.states.ConfigGame;
	import com.neopets.projects.np10.statemachine.states.EncryptionLoaded;
	import com.neopets.projects.np10.statemachine.states.GameEnded;
	import com.neopets.projects.np10.statemachine.states.GamePlaying;
	import com.neopets.projects.np10.statemachine.states.GameSetup;
	import com.neopets.projects.np10.statemachine.states.InitialState;
	import com.neopets.projects.np10.statemachine.states.Preloading;
	import com.neopets.projects.np10.statemachine.states.ScoreResult;
	import com.neopets.projects.np10.statemachine.states.ShellConfigured;
	import com.neopets.projects.np10.statemachine.states.TranslationLoaded;*/
	
	import com.neopets.projects.np10.statemachine.states.AssetsLoaded;
	import com.neopets.projects.np10.statemachine.states.ConfigGame;
	import com.neopets.projects.np10.statemachine.states.GameEnded;
	import com.neopets.projects.np10.statemachine.states.GamePlaying;
	import com.neopets.projects.np10.statemachine.states.GameSetup;
	import com.neopets.projects.np10.statemachine.states.InitialState;
	import com.neopets.projects.np10.statemachine.states.Preloading;
	import com.neopets.projects.np10.statemachine.states.ScoreResult;
	import com.neopets.projects.np10.statemachine.states.ShellConfigured;
	import com.neopets.projects.np10.statemachine.states.TranslationLoaded;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.net.registerClassAlias;

	/**
	 * public class GameStatesVO
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class GameStatesVO
	{
		public static const INITIALSTATE:String = "InitialState";
		public static const TRANSLATIONLOADED:String="TranslationLoaded";
		public static const PRELOADING:String="Preloading";
		public static const GAMESETUP:String="GameSetup";
		public static const CONFIGGAME:String="ConfigGame";
		public static const ASSETSLOADED:String="AssetsLoaded";
		public static const GAMEPLAYING:String="GamePlaying";
		public static const GAMEENDED:String="GameEnded";
		public static const SCORERESULT:String="ScoreResults";
		//optional states
		public static const LOADGAME:String="LoadGame";
		public static const LOADEXTRASTATE:String="LoadAddtlState";
		public static const EXTRASTATE1:String="AddtlState1";
		public static const EXTRASTATE2:String="AddtlState2";
		public static const EXTRASTATE3:String="AddtlState3";
				
		//default
		public var statesFlow:Array = 	[
										INITIALSTATE,  
										TRANSLATIONLOADED, 
										PRELOADING, 
										GAMESETUP, 
										CONFIGGAME, 
										ASSETSLOADED, 
										GAMEPLAYING, 
										GAMEENDED, 
										SCORERESULT
										];
		
		public var defaultStates:Vector.<StateVO>;
		
		public function GameStatesVO ():void {
			/*registerClassAlias(INITIALSTATE, InitialState);
			registerClassAlias(SHELLCONFIGURED, ShellConfigured);
			registerClassAlias(ENCRYPTIONLOADED, EncryptionLoaded);
			registerClassAlias(TRANSLATIONLOADED, TranslationLoaded);
			registerClassAlias(PRELOADING, Preloading);
			registerClassAlias(CONFIGGAME, ConfigGame);
			registerClassAlias(ASSETSLOADED, AssetsLoaded);
			registerClassAlias(SETUPGAME, GameSetup);
			registerClassAlias(GAMEPLAYING, GamePlaying);
			registerClassAlias(GAMEENDED, GameEnded);*/
			defaultStates = new Vector.<StateVO>();
			defaultStates.push (new StateVO (INITIALSTATE, {stateClass:InitialState}));
			defaultStates.push (new StateVO (TRANSLATIONLOADED, {stateClass:TranslationLoaded}));
			defaultStates.push (new StateVO (PRELOADING, {stateClass:Preloading}));
			defaultStates.push (new StateVO (GAMESETUP, {stateClass:GameSetup}));
			defaultStates.push (new StateVO (CONFIGGAME, {stateClass:ConfigGame}));
			defaultStates.push (new StateVO (ASSETSLOADED, {stateClass:AssetsLoaded}));
			defaultStates.push (new StateVO (GAMEPLAYING, {stateClass:GamePlaying}));
			defaultStates.push (new StateVO (GAMEENDED, {stateClass:GameEnded}));
			defaultStates.push (new StateVO (SCORERESULT, {stateClass:ScoreResult}));
		}
		
		
		
		
		//OBSOLETE: keeping an order in the states array is not necesary since I intriduced the new method
		public function insertState (value:String, pos:int):void {
			statesFlow.splice(pos, 0, value);
			trace ("GameStatesVO - state "+value+" added; states Flow =", statesFlow);
		}
		
		
		public static function register(remoteClass:String):void
		{	
			registerClassAlias(remoteClass, com.neopets.projects.np10.data.vo.GameStatesVO);		
		}
			
	}
}