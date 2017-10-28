package com.neopets.projects.np10.statemachine.interfaces
{
	import com.neopets.projects.np10.util.EncryptedVar;
	import com.neopets.projects.np10.data.vo.GameShellConfigVO;
	import com.neopets.projects.np10.data.vo.PreloaderConfigVO;
	import com.neopets.projects.np10.data.vo.PrizeVO;

	public interface IGameState
	{
		//to better understand, add 'go to ' in front of each one of the following method
		/*function getShellConfig ():void;
		function loadTranslation (gameID:int):void;
		function setupPreloader (config:PreloaderConfigVO):void;
		function setupGame (gameClass:Class):void;
		function loadGameConfig(URL:String):void;
		function loadAssets (assetsUrls:Array):void;
		function startGame ():void;//can be from LOAD ASSETS or from LOAD GAME
		function endGame ():void;
		function sendScore(score:EncryptedVar):void;
		//optional
		function loadGame (URL:String):void;  //VERY RARELY A GAME WILL NEED TO BE LOADED IN INSTEAD OF ACTUALLY INSTANTIATED
		function displayScoreResult (prize:PrizeVO):void;//GAME EVENTS THAT AWARD NEOPOINTS, PRIZES
		function loadExtraState (url1:String, url2:String="", url3:String=""):void;//POSSIBLE ADDITIONAL FEATURES
		function extraState1 (param:Object):void 
		function extraState2 (param:Object):void 
		function extraState3 (param:Object):void*/ 
			
		function enter():void;
		function exit ():void;
	}
}