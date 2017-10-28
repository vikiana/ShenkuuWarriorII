//Marks the right margin of code *******************************************************************
package com.neopets.games.inhouse.Diceroll
{
	import away3d.cameras.TargetCamera3D;
	import away3d.cameras.lenses.PerspectiveLens;
	
	import caurina.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.Timer;
	
	import jiglib.plugin.away3d.Away3dMesh;

	/**
	 * public class DiceRollTrayAnimation extends DiceRollTray
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	[SWF(width="500", height="600", frameRate="32", backgroundColor="0x000000", scale="exactfit" ,align="t", salign="tl")]
	public class DiceRollTrayAnimation extends DiceRollTray_hub
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
		public const FADE_OUT:String = "fade out";
		//--------------------------------------------------------------------------
		//Private properties
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		[Embed (source="assets/footer.swf", symbol="diceTexture1")]
		private var diceTexture1:Class;
		[Embed (source="assets/footer.swf", symbol="diceTexture2")]
		private var diceTexture2:Class;
		[Embed (source="assets/footer.swf", symbol="diceTexture3")]
		private var diceTexture3:Class;
		[Embed (source="assets/footer.swf", symbol="diceTexture4")]
		private var diceTexture4:Class;
		[Embed (source="assets/footer.swf", symbol="diceTexture5")]
		private var diceTexture5:Class;
		[Embed (source="assets/footer.swf", symbol="diceTexture6")]
		private var diceTexture6:Class;
		
		[Embed (source="assets/footer.swf", symbol="tableCloth")]
		private var tableCloth:Class;
		
		[Embed (source="assets/footer.swf", symbol="pngShadow")]
		private var pngShadow:Class;
		
		
		private var move:Boolean = false;
		
		private var LAUNCH_X:Number = -30;
		private var LAUNCH_Z:Number = -35;
		private var ORIG_X:Number = -100;
		private var ORIG_Z:Number = -100;

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Creates a new public class DiceRollTrayAnimation extends DiceRollTray instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function DiceRollTrayAnimation()
		{
			super();
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		/**
		 * Description
		 * @param  value  of type <code>CustomClass</code> 
		 */
		override public function init(bitmaps:Array, winningFace:int, stg:Stage=null, rolled:Boolean=false):void
		{
			CAMERA_Y = 440;
			CAMERA_Z = -750;
			DICE_START_Y = 180;
			TRAY_HEIGHT = 50;
			Y_SPEED = 0;
			
			//stage
			if (stg){
				_stage = stg;
			} else{
				_stage = this.stage;
			}
			
			//passed by PHP (here the index starts from 0 )
			_winningMaterial = winningFace-1;
			_rolled = rolled;
			

			var bArray:Array = [diceTexture1, diceTexture2,diceTexture3, diceTexture4, diceTexture5, diceTexture6, tableCloth, pngShadow];
			parseBitmaps(bArray)
			initMaterials();
			
			
		}
		public function resetDice():void {
			scene.removeChild(cube);
			view.render();
			cube = makeCube ();
			cube.alpha = 0;
			scene.addChild(cube);
			physics.removeBody(dice);
			dice = new PhysicsDice (new Away3dMesh(cube),DICE_DIM);
			dice.mass = 3;
			dice.movable = true;
			dice.sideLengths = new Vector3D(DICE_DIM,DICE_DIM, DICE_DIM);
			physics.addBody(dice);
			dice.moveTo(new Vector3D(ORIG_X, DICE_START_Y, ORIG_Z));
			physics.engine.integrate(0.3);
		}
		
		public function relaunch():void {
			//cube.transform = _origPosition
			move=true;
			dice.applyBodyWorldImpulse(_forc, _deltaForc);
			//launch(LAUNCH_X, LAUNCH_Z);
		}
		//--------------------------------------------------------------------------
		// Protected Methods
		//--------------------------------------------------------------------------
		override protected function parseBitmaps(loaded:Array):void {
			var bmc:Class;
			var bm:Bitmap;
			var bmd:BitmapData;
			for (var i:int=0; i< 6; i++){
				bmc = loaded[i];
				bm = new bmc();
				bmd = Bitmap(bm).bitmapData;
				trace("bitmap data", bmd);
				diceBitmaps.push(bmd);
				//diceBitmaps.push(Bitmap (LoadedItem(loaded[0][i]).objItem).bitmapData);
			}
			for (i=6; i<loaded.length; i++){
				//textureBitmaps.push(Bitmap(LoadedItem(loaded[0][i]).objItem).bitmapData);
				bmc = loaded[i];
				bm = new bmc ();
				bmd =  Bitmap(bm).bitmapData;
				textureBitmaps.push(bmd);
			}
		}
		
		
		
		override protected function build ():void {
			initEngine();
			
			initPhysics();
			
			initObjects();
			dice.moveTo(new Vector3D(ORIG_X, DICE_START_Y, ORIG_Z));
			cube.alpha = 0;
			physics.engine.integrate(0.3);
			
			showScene();
		
			_stage.addEventListener(Event.RESIZE, onResize);
			onResize();
			/*if (!_rolled){
				initListeners();
			} else {
				showResults();
			}*/
			_prevX = 0;
			_prevZ = 0;
			camera.focus = 90;
			
			//addEventListener(Event.ENTER_FRAME, onEnterFrame);
			view.render();
			Tweener.addTween(cube, {alpha:1, time:2, transition:"easeoutquint"})
			startLaunchTimer();
		}
		
		
	
		
		private function startLaunchTimer():void {
			var t:Timer = new Timer (1000, 2);
			t.addEventListener(TimerEvent.TIMER_COMPLETE, launchDice);
			t.start();
		}
		
		private function launchDice (e:TimerEvent):void {
			Timer (e.target).removeEventListener(TimerEvent.TIMER_COMPLETE, launchDice);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			move=true;
			launch(LAUNCH_X, LAUNCH_Z);
		}
		
		private function relaunchDice (e:TimerEvent):void {
			Timer (e.target).removeEventListener(TimerEvent.TIMER_COMPLETE, relaunchDice);
			Tweener.addTween(cube, {alpha:0, time:2, transition:"easeoutquint", onComplete:fadeIn});
			//dispatchEvent(new Event (FADE_OUT));
		}
		
		private function fadeIn ():void {
			resetDice();
			Tweener.addTween(cube, {alpha:1, time:2, transition:"easeoutquint", onComplete:relaunch})
		}
			
		override protected function launch (X:Number, Z:Number):void {
			
			_origPosition = cube.transform;
			var dirX:Number = 1;
			var dirZ:Number = 1;
			var cubeFaceNormal:Vector3D =  new Vector3D (0,0,0);//Vector3D(cube.faceVOs[0].face.normal)//.add(cube.position);
			var orig:Vector3D = cubeFaceNormal.add(new Vector3D (dice.x, dice.y, dice.z));//new Vector3D (Math.floor(dice.x-50),Math.floor( dice.y),Math.floor( dice.z-50));
			trace ("ORIG: ", orig);
			trace ("PREV COORDS: ", _prevX, _prevZ);
			//extablish direction of launch
			if (_prevX > X){
				dirX = -1;
			}
			if (_prevZ > Z){
				dirZ = -1;
			}
			
			
			var speedX:Number = Math.abs(X-_prevX);
			var speedZ:Number = Math.abs (Z-_prevZ);
			trace ("X dir: ", dirX, "speedX: ", speedX);
			trace ("Z dir: ", dirZ ,"speedZ: ", speedZ);
			var newspeeds:Point = new Point (0,0);
			//speed limiterss
			/*if (speedX+speedZ < MIN_SPEED){
				newspeeds = modifySpeed(MIN_SPEED, speedX, speedZ);
			} else if (speedX+speedZ > MAX_SPEED){
				newspeeds = modifySpeed(MAX_SPEED, speedX, speedZ);
			} else {*/
				newspeeds.x = speedX;
				newspeeds.y = speedZ;
			//}
			
			_forc = new Vector3D(newspeeds.x*dirX, Y_SPEED, newspeeds.y*dirZ);
			_deltaForc = orig.add (_forc);
			trace ("delta forc", _forc, _deltaForc);
			//TIMER SYSTEM
			//var t:Timer = new Timer (0.2);
			//t.addEventListener(TimerEvent.TIMER, createRoll);
			//t.start();	
			dice.applyBodyWorldImpulse(_forc, _deltaForc);
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
		override protected function onEnterFrame( e:Event ):void
		{
			if (move ){
				physics.engine.integrate(0.3);
				if (!dice.getVelChanged()){
					move = false;
					var t:Timer = new Timer (1000, 3);
					t.addEventListener(TimerEvent.TIMER_COMPLETE, relaunchDice);
					t.start();
					trace ("end");
				}
			}
			view.render();
		}
		//--------------------------------------------------------------------------
		// Getters/Setters
		//--------------------------------------------------------------------------
	}
}