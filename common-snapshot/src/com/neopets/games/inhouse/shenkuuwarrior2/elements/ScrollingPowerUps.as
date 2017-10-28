//Marks the right margin of code *******************************************************************
package com.neopets.games.inhouse.shenkuuwarrior2.elements
{
	import caurina.transitions.Tweener;
	
	import com.neopets.games.inhouse.shenkuuwarrior2.elements.Bullet;
	import com.neopets.games.inhouse.shenkuuwarrior2.elements.PowerUp;
	import com.neopets.games.inhouse.shenkuuwarrior2.gamedata.GameInfo;
	import com.neopets.games.inhouse.shenkuuwarrior2.levelData.GameIntrospectionUtil;
	import com.neopets.games.inhouse.shenkuuwarrior2.levelData.ImagePlacement;
	import com.neopets.games.inhouse.shenkuuwarrior2.levelData.LevelData;
	import com.neopets.games.inhouse.shootergame.utils.Mathematic;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.getClassByAlias;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;

	
	/**
	 * public class ScrollingPowerUps
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class ScrollingPowerUps
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
		private var _levelData:LevelData;
		private var _min:Number = 0;
		private var _max:Number = GameInfo.ENDLESSLEVEL_BG_RANGE;
		/**
		 * var description
		 */
		private var _container:Sprite;
		private var _iArray:Array;
		
		private var _oArray:Vector.<ImagePlacement>;

		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Creates a new public class ScrollingPowerUps instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function ScrollingPowerUps(container:Sprite)
		{
			_container = container;
			_iArray = new Array ();
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------
		public function init (levelData:LevelData):void {
			_levelData = levelData;
			setUp();
		}
		
		
		/**
		 * Description
		 * @param  value  of type <code>CustomClass</code> 
		 */
		public function update (dy:Number):void {
			//move all power ups
			var pu:PowerUp;
			var removePu:PowerUp;
			var puId:int=-1;
			var qcn:String;
			for (var i:int=0; i<_iArray.length; i++){
				pu = PowerUp(_iArray[i]);
				pu.y -= dy;
				pu.update();
				qcn = getQualifiedClassName(pu);
				if ( qcn != "flying_powerup" && puId<0){
					removePu = pu;
					puId = i;
				}
			}
		
	
			//remove first pu to disappear
			if (removePu && puId>=0){
				if (removePu.y > GameInfo.MIN_Y){
					_iArray.splice(puId, 1);
					removeOffScreenElement(removePu);
					//trace ("removing", removePu.name);
				}
			}
			
			if (_iArray.length <= 0){
				_min = _max;
				_max += GameInfo.ENDLESSLEVEL_BG_RANGE;
				_oArray = _levelData.powerups.generateLayout(_min, _max);
				spawn();
			}
		}
		
		private function removeOffScreenElement (element:PowerUp):void {
			if (getQualifiedSuperclassName(element)== "com.neopets.games.inhouse.shenkuuwarrior2.elements::ClusterPowerup"){
				ClusterPowerup(element).cleanUp();
			} else {
				if (element.hasEventListener(GameInfo.GET_POWERUP)){
					element.removeEventListener(GameInfo.GET_POWERUP, powerupEventHandler)
				}
			}
			_container.removeChild(element);
			//trace ("SCOLLING PUS: Array : ", _iArray.length,", childrens:",  _container.numChildren)
		}
		
		public function removePU (pu:PowerUp):void {
			//This is called by the game class when the Warrior catches the powerup (hiding instead of removing). 
			pu.visible = false;
		}
		
		public function reset ():void {
			cleanUp();
			spawn();
		}
		
		
		public function checkCollisions (bullet:Bullet):PowerUp{
			var hitX:Number;
			var timehit:Number;
			var d:Number;
			var pu:PowerUp;
			var bb:Sprite = bullet.displayObject;
			for (var i:int=0; i< _container.numChildren; i++){
				pu = PowerUp(_container.getChildAt(i));
				if (pu.y < GameInfo.STAGE_HEIGHT && pu.y > 0){
					d = pu.y - bb.y;
					timehit = d/bullet.vy;
					if (timehit>0 && timehit<1){
						hitX = bb.x+bullet.vx*timehit;
						if (bb.x < pu.x+pu.width/2 && bb.x > pu.x-pu.width/2){
							//calculate the distance of the hitpoint from the center of the ledge
							//pu.hookX = bb.x - pu.x;
							return pu;
						}
					}
				} 
			}
			return null;
		}
		
		
		public function cleanUp ():void {
			var length:int = _container.numChildren;
			for (var i:int=length-1; i >= 0 ; i--){
				if (getQualifiedSuperclassName(_container.getChildAt(i))== "com.neopets.games.inhouse.shenkuuwarrior2.elements::ClusterPowerup"){
					ClusterPowerup(_container.getChildAt(i)).cleanUp();
				} else {
					if (_container.getChildAt(i).hasEventListener(GameInfo.GET_POWERUP)){
						_container.getChildAt(i).removeEventListener(GameInfo.GET_POWERUP, powerupEventHandler)
					}
				}
				_container.removeChildAt(i);
			}
			length = _iArray.length;
			for (var j:int =length-1; j>=0; j--){
				_iArray.splice(j, 1);
			}
			_iArray = new Array();
		}
		
		public function catchPUs (warrior:MovieClip):void {
			var p:*;
			for (var i:int = 0; i< _iArray.length; i++){
					p = _iArray[i];
					if (p.y > warrior.y){
						if (getQualifiedSuperclassName(p)== "com.neopets.games.inhouse.shenkuuwarrior2.elements::ClusterPowerup"){
							//for each (var mc:MovieClip in p){
							for (var j:int =0; j< p.numChildren; j++){
								PointsPowerup(p.getChildAt(j)).getPowerup();
								Tweener.addTween(p.getChildAt(j), {y:warrior.y, time:1});
								//trace ("tween");
							}
						} else if (p is PointsPowerup){ {
							PointsPowerup(p).getPowerup();
							Tweener.addTween(p, {y:warrior.y, time:1});
						}
					}
				}
			}
		}
		
		//--------------------------------------------------------------------------
		// Protected Methods
		//--------------------------------------------------------------------------
		protected function setUp ():void {
			var max:Number;
			if (_levelData.height){
				 max = _levelData.height;
			} else {
				max = _max;
			}
			//adjust the max not to go all the way to the level top
			max-= (GameInfo.STAGE_HEIGHT*2);
			//generates the layout
			_oArray = _levelData.powerups.generateLayout(_min, max);
			
			//GAME BALANCING 
			GameIntrospectionUtil.gaugePoints(_oArray);
			/////////////////////////////////////////////////////////
			//spawn the powerups
			spawn();
		}
			
	
		
		protected function spawn():void{
			for (var i:int = 0; i<_oArray.length; i++){
				var nextPu:ImagePlacement = ImagePlacement(_oArray[i]);
				var sclass:Class = Class (getDefinitionByName(nextPu.imageClass));
				var pu:Sprite = new sclass ();
				pu.y = nextPu.y;
				//trace ("SPAWNED PUS:", pu, pu.y );
				if (pu is ClusterPowerup){
					pu.x = GameInfo.STAGE_WIDTH/2;
				} else {
					pu.x = Mathematic.randRange(pu.width/2, GameInfo.STAGE_WIDTH-pu.width/2);
				}

				if (pu is PointsPowerup){
					pu.addEventListener(GameInfo.GET_POWERUP, powerupEventHandler, false, 0, true);
				}
				if (getQualifiedSuperclassName(pu)== "com.neopets.games.inhouse.shenkuuwarrior2.elements::ClusterPowerup"){
					ClusterPowerup(pu).addListeners(powerupEventHandler);
				} 
				pu.useHandCursor = true;
				_container.addChild (pu);
				_iArray.push(pu);
			}
		}
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
		protected function powerupEventHandler (e:CustomEvent):void {
			PowerUp(e.target).removeEventListener(GameInfo.GET_POWERUP, powerupEventHandler);
			switch (e.oData.type){
				case "points":
					_container.dispatchEvent(new CustomEvent ({obj:e.target}, GameInfo.ADD_POINTS));
					break;
				case "spawnledge":
					_container.dispatchEvent(new CustomEvent ({obj:e.target}, GameInfo.ENABLE_SPAWN_LEDGES));
					break;
			}
		}
		//--------------------------------------------------------------------------
		// Getters/Setters
		//--------------------------------------------------------------------------
	}
}