//Marks the right margin of code *******************************************************************
package com.neopets.games.marketing.destination.sega
{
	import com.neopets.projects.destination.destinationV3.AbsView;
	import com.neopets.projects.destination.destinationV3.Parameters;
	import com.neopets.users.vivianab.LibraryLoader;
	import com.neopets.util.flashvars.FlashVarManager;
	import com.neopets.util.servers.NeopetsServerFinder;
	
	import flash.events.Event;
	
	
	/**
	 * public class GuardiansView extends AbsView
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class GuardiansView extends AbsView
	{
		//--------------------------------------------------------------------------
		// Costants
		//--------------------------------------------------------------------------	
		private const NEOCONTENT_ID:String = "1734";
		private const LIB_PATH:String = "sponsors/soniccolors/sega_assets.swf";
		
		//EVENTS
		public static var LIB_LOADED:String = "library_loaded";
		//--------------------------------------------------------------------------
		//Public properties
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		//--------------------------------------------------------------------------
		//Private properties
		//--------------------------------------------------------------------------	
		protected var mServers:NeopetsServerFinder;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Creates a new public class GuardiansView extends AbsView instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function GuardiansView()
		{
			super();
			Parameters.assetPath = LIB_PATH;
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		/**
		 * Description
		 * @param  value  of type <code>CustomClass</code> 
		 */
		public function setUp ():void {
			//createGradientBkg();
			createLoadingSign();
			//
			FlashVarManager.instance.initVars(root);
			// figure out our servers
			mServers = new NeopetsServerFinder(this);
			Parameters.baseURL = mServers.scriptServer;
			Parameters.imageURL = mServers.imageServer;
			//initialize with custom control class.
			initialize();
		}
		//--------------------------------------------------------------------------
		// Protected Methods
		//--------------------------------------------------------------------------	
		/**
		 *	This is called after inital prameters are set (view, control, user name and project ID)
		 *	remove spinning arrow or do other things as you please
		 **/
		protected override function  setupReady ():void
		{
			//Load the library
			var libPath:String
			Parameters.onlineMode ? libPath = Parameters.imageURL+"/"+Parameters.assetPath : libPath = Parameters.assetPath;
			trace("path:"+libPath, "online?", Parameters.onlineMode, "image url:", Parameters.imageURL, "asset path:", Parameters.assetPath);
			LibraryLoader.loadLibrary(libPath, onLibLoaded);
		}
		
		protected function onLibLoaded(e:Event):void {
			trace ("Library "+Parameters.assetPath+" is loaded.");
			//removing loader sign
			if (getChildByName("preloader") != null) removeChild(getChildByName("preloader"));
			customSetup();
		};
		
		/**
		 *	override this if there are additional set up to do. Otherwise it calls the control to build the pages
		 **/
		protected function customSetup ():void {
			//trace (this, "customSetup()");
			trace ("Username: ", Parameters.userName);
			dispatchEvent(new Event (LIB_LOADED));
		}
		//--------------------------------------------------------------------------
		// Private Methods
		//--------------------------------------------------------------------------	
		private function createLoadingSign():void{
			var ls:LoadingSign = new LoadingSign ();
			ls.name = "preloader";
			addChild(ls);
			if (stage){
				ls.x = this.stage.width/2 - ls.width/2;
				ls.y = this.stage.height/2 - ls.height/2;
			}
		}
		
		private function initialize ():void {
			init (new GuardiansControl(), NEOCONTENT_ID, true, mServers.isOnline)
		}
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
	}
}