//Marks the right margin of code *******************************************************************
package com.neopets.games.inhouse.shenkuuwarrior2.elements
{
	import com.neopets.games.inhouse.shenkuuwarrior2.gamedata.GameInfo;
	import com.neopets.games.inhouse.shenkuuwarrior2.levelData.BackgroundData;
	import com.neopets.games.inhouse.shenkuuwarrior2.levelData.ImagePlacement;
	import com.neopets.games.inhouse.shenkuuwarrior2.levelData.LevelData;
	import com.neopets.vendor.gamepill.novastorm.obj.bg;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * public class ScrollingBkg
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class ScrollingBkg
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
		//level height span
		private var _min:Number = 0;
		private var _max:Number = 0;
		
		//"source" bkgs
		private var _source:Vector.<Vector.<ImagePlacement>>;
		//"working" bkgs
		private var _layers:Vector.<Vector.<Sprite>>;
		//parallax speed multipliers
		private var _multipliers:Vector.<Number>;
		private var _mbf:Number = 16;//default is 8
		//counts
		private var _counts:Vector.<int>;
		//focus bkgs
		private var _focusBkgs:Vector.<Sprite>;
		private var _lastBkg:Sprite;
		//containers: storing the display objects in a vector so debugging is not a nightmare!
		private var _containers:Vector.<Sprite>;
		private var _container:Sprite;
		//flags
		private var _endingLevelFlag:Boolean = false;
		
		

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Creates a new public class ScrollingBkg instance.
		 * 
		 */
		public function ScrollingBkg (container:Sprite)
		{
			_container = container;
			
			//arrays
			_layers = new Vector.<Vector.<Sprite>>;
			_focusBkgs = new Vector.<Sprite>();
			_counts = new Vector.<int>();
			_containers = new Vector.<Sprite> ();
			_multipliers = new Vector.<Number>;
			
			//_mHeight = 0;	
			
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------
		public function init (levelData:LevelData, levelNo:int):void {
			//this var is used to generate the endless level 'batches'
			_levelData = levelData;
			_levelNo = levelNo;
			
			setUp();
		}
	
		/**
		 * Main scrolling bkgs engine. Called from the Game update class.
		 * 
		 * @param  dy  Amount to be scrolled (vert only) 
		 */
		public function update (dy:Number):void {
			
			//move all bkgs. Here's where the magic happens :)
			var bg:Sprite;
			var m:Number;
			for (var i:int=0; i<_layers.length; i++){
				for (var j:int=0; j<_layers[i].length; j++){
					bg = Sprite(_layers[i][j]);
					m = _multipliers[i];
					bg.y -= dy/m;
					//trace ("LAYER ID:", i, " - bg id:", j, " - m:", m, " - y:", bg.y);
					//this condition is to individuate the top bkg on the last level
					if (i == 0 && j == _layers[i].length-1 && _counts[i] >= _source[i].length && _levelData.height){
						//trace ("last bkg",  _layers[i][j].y) ;
						if (_layers[i][j].y > - GameInfo.STAGE_HEIGHT+300 && ! _endingLevelFlag){
							_endingLevelFlag = true;
							//trace ("last bkg", _layers[i][j], _layers[i][j].y);
							_lastBkg = bg;
							_container.dispatchEvent(new Event (GameInfo.LEVEL_ENDING));
						}
					}
				}
			}
			
			//remove first bkgs to disappear //ADDED 800 SO I HAVE SPACE TO SCROLL DOWN WHEN THE WARRIOR FALL
			for (i=0; i<_layers.length; i++){
				if (_layers[i][0].y >GameInfo.MIN_Y+800){
					//_container.numChildren-1-i
					if (_containers[i].contains(_layers[i][0])){
						Sprite(_containers[i]).removeChild(_layers[i][0]);
						Vector.<Sprite>(_layers[i]).shift();
					}
					
				}
				//spawn new bgks
				if (_focusBkgs[i].y >= 0){
					//debug
					//if (i==2){trace ("BG PASSED Y=0");}
					//
					//if (_counts[i] < _source[i].length){
						bg = nextBg(i);
						if (bg){
							bg.y = _focusBkgs[i].y - _source[i][_counts[i]-1].height;
							//debug
							//if (i == 0){ trace ("bg", _counts[i]-1, ": y = ", bg.y);}
							_layers[i].push(bg);
							_focusBkgs[i] = bg;
							//trace ("spawn new"+bg.name);
						}
					//}
				}
			}
		}
		
		public function reset ():void {
			cleanUp();
			setUp();
		}
		
		public function cleanUp ():void {
			var l:int;
			var l2:int;
			
			l = _containers.length;
			for (var j:int=l-1; j >= 0; j--){
				l2 = Sprite(_containers[j]).numChildren;
				for (var i:int = l2-1; i >= 0 ; i--){
					_containers[j].removeChildAt(i);
				}
				_container.removeChildAt(j);
				_containers.splice(j, 1);
			}
			
			l = _layers.length;
			for (j = l-1; j>=0; j--){
				l2 = _layers[j].length;
				for (i = l2-1; i>=0; i--){
					_layers[j].splice(i, 1);
				}
				_layers.splice(j, 1);
			}
			
			l = _counts.length
			for (j = l-1; j>=0; j--){
				_counts.splice(j, 1);
			} 
			
			l = _focusBkgs.length
			for (j = l-1; j>=0; j--){
				_focusBkgs.splice(j, 1);
			}
			//VARS
			//_mHeight = 0;
			_min = 0;
			_max = 0;
			
			_endingLevelFlag = false;
		}
		//--------------------------------------------------------------------------
		// Protected Methods
		//--------------------------------------------------------------------------	

		protected function setUp():void{
			
			//creates the first batch of bkg layers (for endless level, the ONLY one for finite levels)
			var bkg:BackgroundData = _levelData.background;
			bkg.bgLayerCount = 1;
			
			//max height of the level
			//var max:Number;
			if (_levelData.height){
				_max = _levelData.height;
			} else {
				//edless level: gets generated in batches. This is the height of a "batch". This calculation is based on the height od the back layer panel and the "standard" relation between front and back set in the fisrt layer.
				//trace ("back layer panel height", bkg.getBackLayerPanelHeight());
				_max = bkg.getBackLayerPanelHeight() * _mbf;
			}
			

			var cont:Sprite;
			_source = bkg.generateLayout(_min, _max);
			for each (var v:Vector.<ImagePlacement> in _source){
				_layers.push (new Vector.<Sprite>());
				cont = new Sprite ();
				_container.addChild(cont);
				_containers.unshift(cont);
				_counts.push (0);
			}	
			//gets the parallax multipliers to use for the scrolling speed
			_multipliers = bkg.getMultipliers(_max);
			//trace ("MULTIPLIERS", _multipliers, "MAX", _max);
			
			
			//this sets the standard for relationship between back layer and front layer, to use in the endless level:NA-HA
			//if (_levelNo == 0){
			//	_mbf = _multipliers[_multipliers.length-1];
			//}
			
			
			//creates the first set of bkgs
			var nbg:Sprite; v
			//for every layer
			for (var j:int =0; j < _source.length; j++){
				//for 4 times	
				var t:int = Math.floor(4/_multipliers[j]);
				for (var i:int=0; i<= t; i++){
					nbg = nextBg( j);
					if (nbg){
						if (i!=0){
							nbg.y = _layers[j][i-1].y - _source[j][i].height;//nbg.height;
						} else {
							nbg.y = GameInfo.STAGE_HEIGHT - _source[j][i].height;
						}
						//debug
						//if (j == 0){ trace ("bg", i, ": y = ", nbg.y);}
						///
						_layers[j].push(nbg);
						_focusBkgs[j] = nbg;
					}
				
				}
			}
		}
		
		protected function nextBg(idx:int):Sprite {
			var last:int = _counts.length-1;
			var layer:Vector.<ImagePlacement>  = _source[idx];
			if (!_levelData.height){
				//ENDLESS LEVEL: keeps on generating batches of bkg layers
				if (_counts[last]>= _source[last].length){
					_min = _max;
					_max += _max;//GameInfo.ENDLESSLEVEL_BG_RANGE;
					var newSource:Vector.<Vector.<ImagePlacement>> = _levelData.background.generateLayout(_min, _max);
					for (var i:int =0; i<_source.length; i++){
						_source[i] = _source[i].concat(newSource[i]);
						//for (var j:int=0; j<newSource[i].length; j++){
							//var ip:ImagePlacement = newSource[i][j];
							//_source[i] = _source[i].concat(ip);
						//}
					}
				}
			} else {
				//trace ("layer ", idx, "length", layer.length, "counts: ", _counts[idx] );
				//NORMAL LEVELS
				if (_counts[idx] >= layer.length){
					//trace ("NO MORE BKGS ON THIS LAYER:", idx);
					return null;
				}
			}
			layer  = _source[idx];
			var nextBg:ImagePlacement = ImagePlacement(layer[_counts[idx]]);
			var bgclass:Class = Class (getDefinitionByName(nextBg.imageClass));
			//trace ("creating a "+bgclass);
			var bg:Sprite = new bgclass();
			
			bg.cacheAsBitmap = true;
			
			//_mHeight += bg.height;
			//bgclass(bg).label_txt.text = _mHeight;	
			
			Sprite(_containers[idx]).addChild (bg);
			_counts[idx]++;
			return bg
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
		//--------------------------------------------------------------------------
		// Getters/Setters
		//--------------------------------------------------------------------------
		public function get lastBkg ():Sprite {
			return _lastBkg;
		}
	}
}