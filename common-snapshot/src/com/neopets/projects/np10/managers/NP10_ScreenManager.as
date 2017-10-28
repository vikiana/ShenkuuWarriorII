//Marks the right margin of code *******************************************************************
package com.neopets.projects.np10.managers
{
	import com.neopets.projects.np10.NP10_Document;
	import com.neopets.projects.np10.ui.screens.AbstractScreen;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import virtualworlds.lang.TranslationData;

	/**
	 * public class NP10_ScreenManager extends EventDispatcher
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class NP10_ScreenManager extends EventDispatcher
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
		 * var description
		 */
		public static var instance:NP10_ScreenManager = new NP10_ScreenManager(SingletonEnforcer);
		//--------------------------------------------------------------------------
		//Private properties
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		protected var _root:NP10_Document;
		protected var _td:TranslationData;
		
		protected var _screens:Dictionary;
		
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Creates a new public class NP10_ScreenManager extends EventDispatcher instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function NP10_ScreenManager(lock:Class)
		{
			if(lock != SingletonEnforcer)
			{
				throw new Error( "Invalid Singleton access.  Use NP10_ScreenManager.instance." ); 
			}
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		/**
		 * Description
		 * @param  value  of type <code>CustomClass</code> 
		 */
		public function init (p_root:NP10_Document, p_translationData:TranslationData=null):void {
			_root = p_root;
			_td = p_translationData;
			_screens = new Dictionary(true);
		}
		
		
		public function createScreen (screenName:String, className:Class, p_isPopup:Boolean=false):void {
			_screens[screenName] = new className () as AbstractScreen;
			_root.addChild(_screens[screenName].displayObject);
			AbstractScreen(_screens[screenName]).isPopup = p_isPopup;
			AbstractScreen(_screens[screenName]).init();
		}
		
		public function screenTransition (p_toScreen:String, transition:String="none"):void{
			var toScreen:AbstractScreen = getScreen(p_toScreen);
		}
		//--------------------------------------------------------------------------
		// Protected Methods
		//--------------------------------------------------------------------------	
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
		//--------------------------------------------------------------------------
		// Getters/Setters
		//--------------------------------------------------------------------------
		public function getScreen (screenID:String):AbstractScreen{
			return _screens[screenID];
		}
	}
}

internal class SingletonEnforcer {};