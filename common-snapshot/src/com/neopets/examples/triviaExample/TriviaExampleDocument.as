

/* AS3
	Copyright 2008
*/
package com.neopets.examples.triviaExample
{
	import com.neopets.projects.trivia.shell.TriviaEngineShell;
	
	import flash.display.MovieClip;
	
	
	/**
	 *	This needs to contain information about the Class and what it is used for
	 *	Please use ASDocs if you can for your notes
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern TriviaEngine
	 * 
	 *	@author Clive Henrick
	 *	@since  5.07.2009
	 */
	 
	public class TriviaExampleDocument extends MovieClip 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		public var TriviaApp:TriviaEngineShell;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function TriviaExampleDocument():void
		{
			TriviaApp.externalInit();	
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
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
