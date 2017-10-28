//Marks the right margin of code *******************************************************************
package
{
	import com.neopets.games.inhouse.shenkuuwarrior2.levelData.LevelData;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	
	
	/**
	 * public class LevelDataTest extends Sprite
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	[SWF(width="650", height="600", frameRate="32", backgroundColor="0x999999", scale="exactfit" ,align="t", salign="tl")] 
	public class LevelDataTest extends Sprite
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
		 * Creates a new public class LevelDataTest extends Sprite instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function LevelDataTest()
		{
			super();
			putObjOnStage();
			testLevelData();
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		/**
		 * Description
		 * @param  value  of type <code>CustomClass</code> 
		 */
		//--------------------------------------------------------------------------
		// Protected Methods
		//--------------------------------------------------------------------------	
		//--------------------------------------------------------------------------
		// Private Methods
		//--------------------------------------------------------------------------	
		private function putObjOnStage():void {
			//this is to add something to the stage of Flash will not understand stage properties
			var mc:Sprite = new Sprite ();
			var s:Shape = new Shape();
			s.graphics.drawRect(0, 0, 650, 600);
			s.graphics.beginFill (0x000000);
			s.graphics.endFill(); 
			mc.addChild (s);
			addChild (mc);
		}
		
		
		private function testLevelData ():void {
			var xml:XML = <level>
			<background>
			<layer>
			<zone start="0">
			<panel class="sunrise" height="100"/>
			</zone>
			<zone start="100">
			<panel class="sky" height="200"/>
			</zone>
			</layer>
			</background>
			<ground class="dirt"/>
			<platforms>
			<spacing end="1000">
			<range min="20" max="100"/>
			<range min="100" max="300"/>
			</spacing>
			<type class="rock_ledge">
			<zone start="0" weight="1"/>
			</type>
			<type class="icy_ledge">
			<zone start="100" weight="1"/>
			<zone start="500" weight="2"/>
			</type>
			</platforms>
			</level>;
			
			var ldat:LevelData = new LevelData(xml);
			trace("raw data:"+ldat.toXML());
			trace("sample layout:"+ldat.generateLayout(0,1200));
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