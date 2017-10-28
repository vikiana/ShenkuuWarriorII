//Marks the right margin of code *******************************************************************
package com.neopets.games.inhouse.shenkuuwarrior2.elements
{
	import com.neopets.games.inhouse.shenkuuwarrior2.elements.Bullet;
	import com.neopets.games.inhouse.shenkuuwarrior2.elements.Ledge;
	import com.neopets.games.inhouse.shenkuuwarrior2.gamedata.GameInfo;
	import com.neopets.games.inhouse.shenkuuwarrior2.gamedata.Parameters;
	import com.neopets.games.inhouse.shenkuuwarrior2.levelData.ImagePlacement;
	import com.neopets.games.inhouse.shenkuuwarrior2.levelData.LevelData;
	import com.neopets.games.inhouse.shootergame.utils.Mathematic;
	import com.neopets.users.vivianab.MathUtilities;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	
	/**
	 * public class Ledges
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class ScrollingLedges
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
		private var _levelData:LevelData;
		private var _levelNo:int =0;
		
		private var _min:Number = 0;
		private var _max:Number = GameInfo.ENDLESSLEVEL_BG_RANGE;
		private var _count:int = 0;
		
		//total amount of scrolling that occurred
		private var _dy:Number = 0;
		
		private var _container:Sprite;
		private var _iArray:Array;
		private var _gap:Number = 0;
		private var _focusLdg:Sprite;

		private var _oArray:Vector.<ImagePlacement>;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Creates a new public class Ledges instance.
		 *
		 */
		public function ScrollingLedges(container:Sprite)
		{
			_container = container;
			_iArray = new Array ();
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------
		public function init (levelData:LevelData, levelNo:int):void {
			_levelData = levelData;
			_levelNo = levelNo;
			setUp();
		}
		
		//this is to update ledges that have a behaviour independently from the scrolling
		public function updateLedges ():void {
			var ldg:Ledge;
			for (var i:int=0; i<_iArray.length; i++){
				ldg = Ledge(_iArray[i]);
				ldg.update();
			}
		}
		/**
		 * Main scrolling ledges engine. Called from the Game update class.
		 * 
		 * @param  dy  Amount to be scrolled (vert only) 
		 */
		public function update (dy:Number):void {
			_dy += dy;
			//move all ldgs
			var ldg:Ledge;
			for (var i:int=0; i<_iArray.length; i++){
				ldg = Ledge(_iArray[i]);
				ldg.y -= dy;
				ldg.proxy.synch();
			}
			
			//remove first ldg to disappear://ADDED  800 TO SHOW SOME LEDGES WHEN THE WARRIOR FALLS
			if (_iArray[0]){
				if (_iArray[0].y > GameInfo.MIN_Y+800){
					ldg = Ledge(_iArray[0]);
					if (ldg.hasEventListener (GameInfo.LEDGE_EVENT)){
						ldg.removeEventListener(GameInfo.LEDGE_EVENT, handleLedgeEvent);
					}
					_container.removeChild(ldg);
					_iArray.shift();
					//trace ("LEDGES", _iArray, "num chuildren", _container.numChildren);
				}
			} 
			
			
			//spawn new batch of ledges 
			if (_focusLdg.y-dy >= 0){
				//trace("making batch", _focusLdg);
				makeBatch();
				
			}
		}
		
		///old simplified Viv system
		/*public function checkCollisions (bullet:Bullet):Ledge{
			var hitX:Number;
			var timehit:Number;
			var d:Number;
			var ldg:Ledge;
			var bb:Sprite = bullet.displayObject;
			for (var i:int=0; i< _container.numChildren; i++){
				if (_container.getChildAt(i) is Ledge){
					ldg = Ledge(_container.getChildAt(i));
					if (ldg.y < GameInfo.STAGE_HEIGHT && ldg.y > 0){
						d = ldg.y - bb.y;
						timehit = d/bullet.vy;
						if (timehit>0 && timehit<1){
							hitX = bb.x+bullet.vx*timehit;
								//calculate the distance of the hitpoint from the center of the ledge
								ldg.hookX = bb.x - ldg.x;
								return ldg;
							}
						}
					}
				} 
			}
			return null;
		}*/
		//TODO - WORK IN PROGRESS
		public function spawnExtraLedge ():void {
			var ldgclass:Class = Class (getDefinitionByName("ledge_sky_balloons"));
			var ldg:MovieClip = new ldgclass();
			ldg.addEventListener(GameInfo.LEDGE_EVENT, handleLedgeEvent, false, 0, true)
			ldg.cacheAsBitmap = true;
			//this positions the ledge about 50 px from the top edge, an optimal position for emergency grappling
			ldg.y = 100;
			//random x pos
			ldg.x = Mathematic.randRange(ldg.width/2, GameInfo.STAGE_WIDTH-ldg.width/2);
			//ledge orientation
			if (ldg.x > GameInfo.STAGE_WIDTH/2){
				ldg.scaleX = -1;
			}
			//
			_container.addChild (ldg);
			_count ++;
			//trace ("new ledge", nextLdg.y, _count, ldg.y);
			_iArray.push(ldg);
			_focusLdg = ldg;
		}
		
		
		public function reset ():void {
			cleanUp();
			setUp();
		}
		
		public function cleanUp ():void {
			var length:int = _container.numChildren;
			for (var i:int=length-1; i >= 0 ; i--){
				if (_container.getChildAt(i) is Ledge){
					var ldg:Ledge = Ledge(_container.getChildAt(i));
					if (ldg.hasEventListener (GameInfo.LEDGE_EVENT)){
						ldg.removeEventListener(GameInfo.LEDGE_EVENT, handleLedgeEvent);
					}
				}
				_container.removeChildAt(i);
			}
			length = _iArray.length;
			for (var j:int =length-1; j>=0; j--){
				_iArray.splice(j, 1);
			}
			_gap = 0;
			_count = 0;
			_dy = 0;
			_min= 0;
			_max =  GameInfo.ENDLESSLEVEL_BG_RANGE;
			_focusLdg = null;
		}
		//--------------------------------------------------------------------------
		// Protected Methods
		//--------------------------------------------------------------------------	
		protected function setUp ():void {
			//this is to catch mouse clicks
			var sp:Sprite = makeCoverSprite();
			_container.addChild (sp);
			var max:Number;
			if (_levelData.height){
				max = _levelData.height;
			} else {
				//edless level
				max = _max
			}
			
			//adjust the max not to go all the way to the level top
			max-= GameInfo.STAGE_HEIGHT;
			
			//generates the layout
			_oArray = _levelData.platforms.generateLayout(_min, max);
			//creates the first 10 ledges
			makeBatch();
		}
		
		public function makeCoverSprite ():Sprite{
			var sp:Sprite = new Sprite();
			var s:Shape = new Shape();
			s.graphics.beginFill (0x000000);
			s.graphics.drawRect (0, 0, GameInfo.STAGE_WIDTH, GameInfo.STAGE_HEIGHT);
			s.graphics.endFill(); 
			s.alpha = 0;
			sp.addChild(s);
			return sp;
		}
		
		protected function makeBatch ():void {
			var ldg:Sprite
			for (var i:int = 0; i<=10; i++){
				ldg = nextLedge();
				if (ldg){
					_iArray.push(ldg);
					_focusLdg = ldg;
				} else {
					return;
				}
			}
		}
		
		protected function nextLedge ():Sprite {
			//ENDLESS LEVEL
			if (!_levelData.height){
				if (_count >= _oArray.length){
					_min = _max;
					_max += GameInfo.ENDLESSLEVEL_BG_RANGE;
					_oArray = _levelData.platforms.generateLayout(_min, _max);
					_count = 0;
				}
			} else {
				if (_count >= _oArray.length){
					//trace ("NO MORE LEDGES");
					return null;
				}
			}
			
			var nextLdg:ImagePlacement = ImagePlacement(_oArray[_count]);
			var ldgclass:Class = Class (getDefinitionByName(nextLdg.imageClass));
			var ldg:Sprite = new ldgclass();
			ldg.addEventListener(GameInfo.LEDGE_EVENT, handleLedgeEvent, false, 0, true)
			ldg.cacheAsBitmap = true;
			ldg.useHandCursor = true;
			//this positions the first batch in the game screen and adjust all positions 
			//based on how much scroll has occured up until this time.
			ldg.y = nextLdg.y+GameInfo.STAGE_HEIGHT-100-_dy;
			//debug
			//trace ("ldg", _count, ": y = ", ldg.y);
			///
			//viv: reducing the X span of the ledges to allow the warrior to gain more momentum on level 1
			var gap:Number = (_levelNo == 0)? GameInfo.LEDGE_XGAP_REDUCTION : 0;
			ldg.x = Mathematic.randRange(ldg.width/2+gap, GameInfo.STAGE_WIDTH-ldg.width/2-gap);
			//ledge orientation
			if (ldg.x > GameInfo.STAGE_WIDTH/2){
				ldg.scaleX = -1;
			}
			_container.addChild (ldg);
			_count ++;
			//trace ("new ledge", nextLdg.y, _count, ldg.y);
			return ldg;
		}
		
		//--------------------------------------------------------------------------
		// Private Methods
		//--------------------------------------------------------------------------	
		//--------------------------------------------------------------------------
		// Event Handlers
		//--------------------------------------------------------------------------
		//passes the ledge event (break, dissolve. etc) to the main game class
		private function handleLedgeEvent (e:CustomEvent):void {
			Ledge(e.target).removeEventListener(GameInfo.LEDGE_EVENT, handleLedgeEvent);
			switch (e.oData.etype){
				case "break":
					_container.dispatchEvent(new CustomEvent ({obj:Ledge(e.target)},GameInfo.LEDGE_BREAK));
				break;
			}
		}
		//--------------------------------------------------------------------------
		// Getters/Setters
		//--------------------------------------------------------------------------
	}
}