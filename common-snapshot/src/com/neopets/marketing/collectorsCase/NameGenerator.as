/* AS3
	Copyright 2008
*/
package com.neopets.marketing.collectorsCase
{
	
	/**
	 *	This class creates random names.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  10.07.2009
	 */
	public class NameGenerator
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _consonants:Array;
		protected var _vowels:Array;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function NameGenerator():void{
			_consonants = ['b','c','d','f','g','h','j','k','l','m','n','p','qu','r','s','t','v','w','x','y','z'];
			_vowels = ['a','e','i','o','u'];
		}		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get randomConsonant():String {
			var index:int = Math.floor(Math.random() * _consonants.length);
			return _consonants[index];
		}
		
		public function get randomVowel():String {
			var index:int = Math.floor(Math.random() * _vowels.length);
			return _vowels[index];
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @This function generates a new name from randomly generated words.
		 */
		
		public function createName():String {
			var id:String = createWord(true);
			var words:int = Math.round(Math.random() * 2);
			for(var i:int = 0;  i < words; i++) id += " " + createWord(true);
			return id;
		}
		
		/**
		 * @This function generates a new paragraph from randomly generated sentence 
		 * @up to a given character limit.
		 */
		
		public function createParagraph(char_limit:int=100):String {
			var para:String = createSentence();
			var sentence:String = " " + createSentence();
			while(para.length + sentence.length < char_limit) {
				para += sentence;
				sentence = " " + createSentence();
			}
			return para;
		}
		
		/**
		 * @This function generates a new sentance from randomly generated words.
		 */
		
		public function createSentence():String {
			var sentence:String = createWord(true);
			var words:int = Math.round(Math.random() * 5) + 1;
			for(var i:int = 0;  i < words; i++) sentence += " " + createWord(false);
			return sentence + ".";
		}
		
		/**
		 * @This function generates a new word from randomly generated letter pairings.
		 * @param		capped			Boolean 		Capitalize this word?
		 */
		
		public function createWord(capped:Boolean):String {
			var word:String = "";
			var pairs:int = Math.round(Math.random() * 3) + 1;
			for(var i:int = 0;  i < pairs; i++) {
				if(Math.random() < 0.5) {
					word += randomConsonant + randomVowel;
				} else {
					word += randomVowel + randomConsonant;
				}
			}
			if(capped) {
				var letter:String = word.charAt(0);
				word = letter.toUpperCase() + word.slice(1);
			}
			return word;
		}

		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}