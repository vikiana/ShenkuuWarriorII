package com.neopets.games.inhouse.shootergame
{
	import caurina.transitions.Tweener;
	
	import com.neopets.games.inhouse.shootergame.abstract.AbstractLayer;
	import com.neopets.games.inhouse.shootergame.abstract.AbstractTarget;
	import com.neopets.games.inhouse.shootergame.utils.LibraryLoader;
	import com.neopets.games.inhouse.shootergame.utils.Mathematic;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.sound.SoundManagerOld;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix3D;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	
	/**
	*	This is the Container for all levels. It extends AbstractLayer so when the boss arrives, it behaves as such.
	*
	*	@langversion ActionScript 3.0
	*	@playerversion Flash 10.0
	*	
	*	@author Viviana Baldarelli
	* 	@since  05.22.2009
	*/
	public class LayerContainer extends AbstractLayer
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const POINT_VALUE:Number = 1;
		
		//--------------------------------------
		// PUBLIC VARIABLES
		//--------------------------------------
		
		//references
		public var thisRoot:DisplayObject;
		//flags
		public var lcIsCleaned:Boolean;
		
		//--------------------------------------
		// PRIVATE VARIABLES
		//--------------------------------------
		
		//references
		private var _lm:LayersManager;
		private var _led:LevelDefinition;
		private var _soundm:SoundManagerOld;
		//crosshair
		private var _ch:MovieClip;
		//boss
		private var _red:MovieClip;
		private var _boss:MovieClip;
		
		/**
		* 
		* Constructor
		* 
		* @param	sm	SoundManager
		*/
		public function LayerContainer(sm:SoundManagerOld)
		{
			super();
			_soundm = sm;
		}
		
	
		//----------------------------------------------------------------------------------------------------------
		// PUBLIC METHODS
		//----------------------------------------------------------------------------------------------------------
		override public function cleanUp(e:CustomEvent=null):void{
			Tweener.removeTweens(_boss, [x, z]);
			
			removeCommonEventListeners();
			removeEventListeners();
			
			var element:DisplayObject
			for (var i:uint=numChildren-1; i>0; i--){ 
				if (getChildAt(i)){
					element = getChildAt(i);
					
					if (element is AbstractLayer){
						(element as AbstractLayer).cleanUp();					
					}
				    removeChild(element);
				} 
			}
			
			if (_timer){
				stopTimers(null);
			}
			
			_ch  = null;
			_red = null;
			_boss= null;
			
			_lm = null;
			_led = null;
			_soundm = null;
			
			cleanUpCommonElements ();
			
			lcIsCleaned = true;
			trace ("Layer Container is cleaned");
		};
			
			
		/**
		* 
		* Static function. This is the "magic" z-sorting function that handles all children of the layers container and the children of them.
		* 
		* @param		doc			The root or document class.
		* @param		lc			The top DisplayObject where the z-sorting happens. 
		* @param		recurse		Determines if the z-sorting is recursive to the children of lc. Default is true.
		*/
		public function simpleZSort3DChildren( doc:DisplayObjectContainer, lc:DisplayObject, recurse:Boolean = true ):void
		{
    		//transforms from local to world coordinate frame
   	 		var transform:Matrix3D = doc.transform.getRelativeMatrix3D( lc );
 			var numChildren:int = doc.numChildren;
   			//v = ( n * 3 )- (x,y,z) set for each child
    		var vLength:int = numChildren * 3;
 
   	 		var vLocal:Vector.<Number> = new Vector.<Number>( vLength, true );
    		var vWorld:Vector.<Number> = new Vector.<Number>( vLength, true );
 
    		//insertion point for child’s coordinates into state vector
    		var vIndex:int = 0;
 
    		for( var i:int = 0; i <numChildren; i++ )
    		{
 				var child:DisplayObject = doc.getChildAt( i );
        		if( recurse && child is DisplayObjectContainer ) simpleZSort3DChildren( DisplayObjectContainer( child ), lc, true );
 				vLocal[ vIndex ] = child.x;
        		vLocal[ vIndex + 1 ] = child.y;
        		vLocal[ vIndex + 2 ] = child.z;
 
        		vIndex += 3;
    		}	
 			//populates vWorld with children coordinates in world space
 			if (transform){
    			transform.transformVectors( vLocal, vWorld );
    			//bubble sorts children along world z-axis
    			for( i = numChildren - 1; i > 0; i-- ){
 					var hasSwapped:Boolean = false;
 					vIndex = 2;
 					for( var j:int = 0; j < i; j++ ){
 						//z value at that index for each child
            			var z1:Number = vWorld[ vIndex ];
 						
            			vIndex += 3;
 	
           				var z2:Number = vWorld[ vIndex ];
 
            			if( z2> z1 ){
                			//swap
                			doc.swapChildrenAt( j, j + 1 );
 							//swap z values (don’t need to change x and y because they’re not used anymore)
                			vWorld[ vIndex - 3 ] = z2;
                			vWorld[ vIndex ] = z1;
                			//mark as swapped
                			hasSwapped = true;
            			}
        			}
        			//if there was no swap, we don’t need to iterate again
        			if( !hasSwapped ) return;
       			}
 			}
		}
		
		
		//----------------------------------------------------------------------------------------------------------
		// PROTECTED METHODS
		//----------------------------------------------------------------------------------------------------------
		override protected function initialize ():void {
			lcIsCleaned = false;
			_led = ld.levelDef;
			//gun
			var crClass:Class = LibraryLoader.getLibrarySymbol("com.neopets.games.inhouse.shootergame.assets.Crosshair");
			_ch = new crClass ();
			_ch.x = 0;
			_ch.y = 0;
			_ch.z = 30;
			addChild (_ch);
			//listeners
			addEventListener (MouseEvent.MOUSE_OUT, hideCursor);
			addEventListener (MouseEvent.MOUSE_OVER, showCursor);
			addEventListener (MouseEvent.MOUSE_MOVE, updateChPosition, true, 0 ,true);
			addEventListener (MouseEvent.CLICK, shoot, true, 0 ,true);
			
			_sl.addEventListener(SharedListener.CLEAN_UP, cleanUp);
			_sl.addEventListener (SharedListener.GAME_END, getCursor);
			//for when the container behaves like a layer, ie. the boss comes.
			_elementsArray = [];
		}
		
		//----------------------------------------------------------------------------------------------------------
		// PRIVATE METHODS
		//----------------------------------------------------------------------------------------------------------
		
		private function hideCursor (e:MouseEvent):void {
			Mouse.show();
			_ch.visible = false;
		}
		
		private function showCursor (e:MouseEvent):void {
			Mouse.hide();
			_ch.visible = true;
		}
		
		private function getCursor (e:CustomEvent):void {
			if (hasEventListener (MouseEvent.MOUSE_OUT)){
				removeEventListener (MouseEvent.MOUSE_OUT, hideCursor);
			}
			if (hasEventListener (MouseEvent.MOUSE_OVER)){
				removeEventListener (MouseEvent.MOUSE_OVER, showCursor);
			}
			Mouse.show();
			if (_ch){
				_ch.visible = false;
			}
		}
		
		private function removeEventListeners ():void {
			if (hasEventListener (MouseEvent.MOUSE_OUT)){
				removeEventListener (MouseEvent.MOUSE_OUT, hideCursor);
			}
			if (hasEventListener (MouseEvent.MOUSE_OVER)){
				removeEventListener (MouseEvent.MOUSE_OVER, showCursor);
			}
			if (hasEventListener (MouseEvent.MOUSE_MOVE)){
				removeEventListener (MouseEvent.MOUSE_MOVE, updateChPosition);
			}
			if (hasEventListener (MouseEvent.CLICK)){
				removeEventListener (MouseEvent.CLICK, shoot);
			}
			if (_sl.hasEventListener(SharedListener.CLEAN_UP)){
				_sl.removeEventListener(SharedListener.CLEAN_UP, cleanUp);
			}
			if (_sl.hasEventListener (SharedListener.GAME_END)){
				_sl.removeEventListener (SharedListener.GAME_END, getCursor);
			}
		}
		
		
		//--------------------------------------------------------------
		//	EVENT HANDLERS
		//-------------------------------------------------------------
		private function shoot (e:MouseEvent):void {
			if (_ch.visible){
				_sl.sendCustomEvent(SharedListener.PLAY_SOUND, {name:"gunshot", loop:false}, false, true);
				var hitlayer:AbstractLayer;
				for (var i:uint=0; i<numChildren; i++){
					if (getChildAt(i).name == "First"){
						hitlayer = getChildAt(i) as AbstractLayer;
					}
				}
				_sl.sendCustomEvent(SharedListener.COLLIDE1, {X:_ch.x, Y:_ch.y, T:hitlayer}, false, true);
			}
		}
		
		private function updateChPosition (e:MouseEvent):void {
			_ch.x = mouseX;
			_ch.y = mouseY;
		}

		
		//BOSS FUNCTIONS 
		//create boss
			override protected function sendBoss(e:CustomEvent):void {
			var bClass:Class = LibraryLoader.getLibrarySymbol(_led.levelBoss);
			_boss = new bClass();
			_boss.x = ShooterGame.STAGE_WIDTH+_boss.width;
			_boss.y = ShooterGame.STAGE_HEIGHT/2-25;
			_boss.z = 120;
			_boss.init (_sl, POINT_VALUE, this);
			_boss.name = "boss";
			addChild (_boss);
			//
			var rClass:Class = LibraryLoader.getLibrarySymbol("redScreen");
			_red = new rClass ();
			_red.alpha = 0;
			_red.z = -200;
			addChild (_red);
			var destX:Number = 0;
			Tweener.addTween (_boss, {x:destX, time:4, transition:"linear", onComplete:shootBoss});
			//front to back movement
		}
		
		
		//start boss
		private function shootBoss ():void {
			bossMoveX();
			bossAttack();
		}
		
		
		//attack timer
		override public function createTimer (stageNo:Number=0):void {
			//timer for boss attack
			var randomTimeLapse:Number = Mathematic.randRange(6, 10);
			_timer = new Timer (1000, randomTimeLapse);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, bossAttack);
			_timer.start();
		}
		
		
		override protected function stopTimers(e:CustomEvent):void {
			if (_timer){
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, bossAttack);
				_timer = null;
			}
		}
		
		private function bossAttack(e:TimerEvent=null):void {
			stopTimers(null);
			Tweener.addTween (_boss, {z:-180, time:1, transition:"easeInCubic", onUpdate:simpleZSort3DChildren, onUpdateParams:[this, thisRoot], onComplete:goBack});
			_sl.sendCustomEvent(SharedListener.PLAY_SOUND, {name:"attack", loop:false}, false, true);
		}
		
		private function goBack ():void {
			_red.alpha = 0.5;
			Tweener.addTween (_red, {alpha:0, time:1, transition:"easeOutCubic"});
			Tweener.addTween (_boss, {z:120, time:1, transition:"easeOutCubic", onUpdate:simpleZSort3DChildren, onUpdateParams:[this, thisRoot], onComplete:createTimer});
			_sl.sendCustomEvent(SharedListener.LOOSE_LIFE, null, false, true);
		}
		
		//random horizontal movement
		private function bossMoveX ():void {
			var randomPos:Number = Mathematic.randRange(-100, 100);
			var randomTime:Number = Mathematic.randRange(0.3, 1);
			Tweener.addTween(_boss,{x:randomPos, time:randomTime, transition:"linear", onComplete:repeat});
		}
	
		private function repeat ():void {
			 bossMoveX();
		}
		
		
		//if boss is hit
		override protected function destroyTarget (e:CustomEvent):void {
			if (_boss){
				var t:AbstractTarget = e.oData.target;
				for (var i:int = 0; i< _elementsArray.length; i++){
					if (_elementsArray[i].name == t.name){
						if (_elementsArray[i] == _boss.body){
							Tweener.removeTweens(_boss, [x, z]);
							_boss.cleanUpBoss(null);
							_sl.sendCustomEvent(SharedListener.BOSS_DEAD, null, false, true);
			 			}
			 			var deleted:Array = _elementsArray.splice(i, 1);
			 			//stop checking
						i = _elementsArray.length;
			 		}
				}
			}
		}
		
		//--------------------------------------
		// GETTERS/SETTERS
		//--------------------------------------
		public function set lm(value:LayersManager):void{
			_lm = value;
		}
		
		public function get lm():LayersManager{
			return _lm;
		}
		
		public function get ch():MovieClip{
			return _ch;
		}
		
		public function get boss():MovieClip{
			return _boss;
		}
		
		public function get elementsArray():Array{
			return _elementsArray;
		}
	}
}