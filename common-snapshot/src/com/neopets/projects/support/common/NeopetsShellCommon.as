
/* AS3
	Copyright 2008
*/
package com.neopets.projects.support.common
{
	import com.neopets.projects.support.shell.NeopetsShell;
	
	import flash.events.EventDispatcher;
	
	
	/**
	 *	This is a mix of functions used by the Neopets Shell
	 *	Please use ASDocs if you can for your notes
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author Clive Henrick (Based off Ollie B. NP9_Gaming_System)
	 *	@since  2.06.2009
	 */
	 
	public class NeopetsShellCommon extends EventDispatcher 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PROTECTED / PRIVATE VARIABLES
		//--------------------------------------
		
		protected var mShell:NeopetsShell;
		protected var mScoreURL:String;
		
		protected var objTranslator:NP9_Translator;
		protected var objEncryption:NP9_Score_Encryption;
		protected var objNeoStatus:NP9_Neostatus;
		protected var objScoringMeter:NP9_Scoring_Meter;
		
		public var _SOUND:NP9_Sound_Control;
		
		
		protected var scoreLoader:URLLoader;
		protected var aScoreMeterVars:Object;
		protected var bScoringMeterClick:Boolean;
		
		protected var bTRACE:Boolean;
		
		protected var mcMeter:MovieClip;
		
		protected var nShowScore:Number;
		protected var nShowNP:Number;

		protected var extraSendScoreVars : Array;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		

		public function NeopetsShellCommon():void{
			setupVars();
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		
		
		
		/**
		 * @Note: This is an example
		 * @param		pCMD			String 		This is an Example of a Passed parameter
		 * @param		pBuyHowMuch		uint 		This is an Example of a Passed parameter
		 */
		 
		public function init(pShell:NeopetsShell, pBuyHowMuch:uint = null)
		{
			
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		private function setupVars():void
		{
			
		}
	}
	
}
