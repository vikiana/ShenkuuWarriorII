// ---------------------------------------------------------------------------------------
// GAME BIOS
//
//
// ---------------------------------------------------------------------------------------
package com.neopets.projects.np9.system
{
	// SYSTEM IMPORTS
	import flash.display.MovieClip;
	
	/**
	 * <p>The base class for the BIOS object - a movieclip containing common variables used by the Neopets Gaming System</p>
	 * <p>Normally defined in the GameDocument base class - setupVars() method, which extends the NP9_DocumentExtension class</p>
	 * @see com.neopets.projects.np9.gameEngine.NP9_DocumentExtension
	 * @author Ollie B. , Clive Henrick, Koh Peng Chuan
	 * @since 06/10/10
	 */
	public class NP9_BIOS extends MovieClip {

		/**
		 * Default filename of the config file
		 */
		public const configFileName:String = "config";
		/**
		 * Default file extension of the config file
		 */
		public const configFileExtension:String = "xml";

		/**
		 * Debug mode flag
		 */
		public var debug:Boolean;
		/**
		 * Translation flag - True if translation is needed
		 */
		public var translation:Boolean;
		/**
		 * Translation engine debug flag - True if debugging output is needed
		 */
		public var trans_debug:Boolean;
		/**
		 * Dictionary function flag
		 */
		public var dictionary:Boolean;
		/**
		 * Game ID
		 */
		public var game_id:Number;
		/**
		 * Game language
		 */
		public var game_lang:String;
		/**
		 * X coordinate of the black score meter
		 */
		public var meterX:Number;
		/**
		 * Y coordinate of the black score meter
		 */
		public var meterY:Number;
		/**
		 * URL of the server holding scripts - eg. http://www.neopets.com
		 */
		public var script_server:String;
		/**
		 * URL of the server holding swfs - eg. http://images.neopets.com
		 */
		public var game_server:String;
		/**
		 * Set to true if the meter is visible at send score
		 */
		public var metervisible:Boolean;
		/**
		 * Set to true if testing on local without loading anything from the servers
		 */
		public var localTesting:Boolean;
		/**
		 * The path pointing to the config and swf resources used by the game - eg. ./games/g1234/
		 */
		public var localPathway:String;
		/**
		 * Date stamp for game creation
		 */
		public var game_datestamp:String;
		/**
		 * Time stamp for game creation
		 */
		public var game_timestamp:String;
		/**
		 * Game ID string - eg. g1234
		 */
		public var game_infostamp:String;
		/**
		 * Width of the game - Maximum game width for NP site integration without popup = 650px
		 */
		public var iBIOSWidth:int;
		/**
		 * Height of the game - Maximum game height for NP site integration without popup = 600px
		 */
		public var iBIOSHeight:int;
		/**
		 * The full url to the game resource files - offline = localPathway; online = imageserver + localPathway
		 */
		public var finalPathway:String;
		/**
		 * Flag for using the config.xml file
		 */
		public var useConfigFile:Boolean;
		
		/**
		 * Flag for flex embedding
		 */
		public var useFlexEmbed:Boolean;
		
		/**
		 * Config file version control - eg. configFileVersion = 1; (uses "config_v1.xml") or configFileVersion = 0; (uses "config.xml")
		 */
		public var configFileVersion:int = 0;
		
		/**
		 * @Constructor
		 */
		public function NP9_BIOS(){}
	}
}