//Marks the right margin of code *******************************************************************
package com.neopets.games.inhouse.Diceroll
{
	
	import away3d.cameras.*;
	import away3d.containers.*;
	import away3d.core.base.Face;
	import away3d.core.base.Mesh;
	import away3d.core.base.Vertex;
	import away3d.core.render.Renderer;
	import away3d.core.utils.Cast;
	import away3d.events.Loader3DEvent;
	import away3d.events.MouseEvent3D;
	import away3d.lights.DirectionalLight3D;
	import away3d.lights.PointLight3D;
	import away3d.loaders.Loader3D;
	import away3d.loaders.LoaderCube;
	import away3d.loaders.Obj;
	import away3d.materials.*;
	import away3d.materials.utils.SimpleShadow;
	import away3d.primitives.*;
	import away3d.primitives.data.CubeMaterialsData;
	import away3d.sprites.Sprite3D;
	
	import caurina.transitions.Tweener;
	
	import com.neopets.games.inhouse.shootergame.utils.Mathematic;
	import com.neopets.util.events.CustomEvent;
	import com.neopets.util.loading.LoadedItem;
	import com.neopets.util.loading.LoadingManager;
	import com.neopets.util.loading.LoadingManagerConstants;
	import com.neopets.util.servers.ServerFinder;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix3D;
	import flash.geom.Orientation3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.sampler.NewObjectSample;
	import flash.text.engine.RenderingMode;
	import flash.utils.Timer;
	
	import jiglib.physics.PhysicsSystem;
	import jiglib.physics.RigidBody;
	import jiglib.physics.constraint.JConstraint;
	import jiglib.physics.constraint.JConstraintPoint;
	import jiglib.physics.constraint.JConstraintWorldPoint;
	import jiglib.plugin.away3d.Away3DPhysics;
	import jiglib.plugin.away3d.Away3dMesh;
	import jiglib.plugin.away3dlite.Away3DLitePhysics;
	
	
	
	/**
	 * public class MyFirstModel extends Sprite
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class DiceRollTray_hub extends Sprite
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
		public const CHANGE_VIEW:String = "changeView";
		public const RESET_VIEW:String = "resetView";
		public const LANDED:String = "landed";
		//--------------------------------------------------------------------------
		//Private properties
		//--------------------------------------------------------------------------	
		//COSTANTS
		protected const MAX_SPEED:Number = 200;
		protected const MIN_SPEED:Number = 150;
		protected var Y_SPEED:Number = 30;
		protected const PICKUP_HEIGHT:Number = 0;

		protected var DICE_DIM:Number = 40;
		protected var TRAY_WIDTH:Number = 600;
		protected var TRAY_DEPTH:Number = 380;
		protected var TRAY_HEIGHT:Number =250;
		protected var DICE_START_Y:Number = 100;
		
		protected var CAMERA_Z:Number = -2;
		protected var CAMERA_Y:Number = 1050;
		
		//EMBEDDED PNG
		/**
		 * The following are embedded assets. 
		 */
		/*[Embed(source="assets/anim_die_sides_wood.png")]
		private var diceTexture1:Class;
		[Embed(source="assets/anim_die_sides_bronze.png")]
		private var diceTexture2:Class;
		[Embed(source="assets/anim_die_sides_silv.png")]
		private var diceTexture3:Class;
		[Embed(source="assets/anim_die_sides_gold.png")]
		private var diceTexture4:Class;
		[Embed(source="assets/anim_die_sides_crown.png")]
		private var diceTexture5:Class;
		[Embed(source="assets/anim_die_sides_question.png")]
		private var diceTexture6:Class;
		
		[Embed(source="assets/tablecloth_large.jpg")]
		private var tableCloth:Class;
		
		[Embed("assets/shadow.png")] 
		private var pngShadow:Class;*/
		
		//TEXTURE BITMAPS
		protected var _images:Array = ["anim_die_sides_wood.png", "anim_die_sides_bronze.png","anim_die_sides_silv.png", "anim_die_sides_gold.png", "anim_die_sides_question.png", "anim_die_sides_crown.png", "tablecloth_large.jpg" , "shadow.png" ] 
		protected var _baseURL:String = "";
		//3D ENGINE
		protected var scene:Scene3D;
		protected var camera:TargetCamera3D;
		protected var hcamera:TargetCamera3D;
		protected var view:View3D;
		//objects
		protected var cube:Cube;
		protected var pngPlane:Plane;	
		protected var realCube:Cube;
		
		//MATERIALS
		//material objects
		protected var diceBitmaps:Array;
		protected var textureBitmaps:Array;
		protected var diceMaterials:Vector.<CustomBitmapMaterial>;
		protected var clearmaterial:ColorMaterial
		protected var shadowmaterial:BitmapMaterial;
	
		//table cloth
		protected var tableclothmaterial:CustomBitmapMaterial;
		protected var colormaterial:ColorMaterial//ShadingColorMaterial;
		protected var colormaterial2:ColorMaterial
		protected var colormaterial4:ColorMaterial
		protected var colormaterial3:ColorMaterial///ShadingColorMaterial;
		//winning color from PHP
		protected var _winningMaterial:int;
		//index of the face that is showing up
		protected var _winningFaceIndex:int = 0;
		
		//PHYSICS
		protected var physics:SpecialAway3DPhysics;
		//physics objects
		protected var dice:PhysicsDice;
		protected var ground:RigidBody;
		protected var dragConstraint:JConstraintWorldPoint;
		protected var top:RigidBody;
		protected var bottom:RigidBody;
		protected var left:RigidBody;
		protected var right:RigidBody;
		
		//LAUNCH
		protected var _prevX:Number =-60;
		protected var _prevZ:Number = -60;
		protected var _matrixArray:Vector.<Matrix3D>;
		protected var _origPosition:Matrix3D;
		protected var _count:int = 0;
		protected var _forc:Vector3D;
		protected var _deltaForc:Vector3D;
		
		//FLAGS
		protected var _gotGhostResult:Boolean = false;
		protected var _gotResult:Boolean = false;
		protected var _launched:Boolean = false;
		protected var _applied:Boolean = false;
		protected var _enterDice:Boolean = true;
		protected var _cubeCreated:Boolean = false;
		protected var _startRealCube:Boolean = false;
		protected var _matSwitched:Boolean = false;
		protected var _diceListenersRemoved:Boolean = true;
		protected var _drag:Boolean = false;
		protected var _out:Boolean = false;
		
		protected var _rolled:Boolean = false;
		
		protected var _stage:Stage;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Creates a new public class MyFirstModel extends Sprite instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function DiceRollTray_hub()
		{
			super();
			_matrixArray = new Vector.<Matrix3D>();
			diceMaterials = new Vector.<CustomBitmapMaterial>();
			diceBitmaps = new Array();
			textureBitmaps = new Array();
			//init();
		}
		
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		/**
		 * Global initialise function
		 */
		public function init(bitmaps:Array, winningFace:int, stg:Stage=null, rolled:Boolean=false):void
		{
			
			if (stg){
				_stage = stg;
			} else{
				_stage = this.stage;
			}
			
			//passed by PHP (here the index starts from 0 )
			_winningMaterial = winningFace-1;
			_rolled = rolled;
			
			//DEBUG::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, restartGame);
			//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
			
			if (bitmaps){
				parseBitmaps(bitmaps)
				initMaterials();
			} else {
				build();
			}
			
			
		}

		
		protected function build ():void {
			initEngine();
			initPhysics();
			initObjects();
			showScene();
			if (!_rolled){
				initListeners();
			} else {
				showResults();
			}
		}
		
		public function cleanup():void {
			//DEBUG:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
			if (stage.hasEventListener(KeyboardEvent.KEY_DOWN)){
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, restartGame);
			}
			//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
			//remove listeners
			if (hasEventListener(Event.ENTER_FRAME)){
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			_stage.removeEventListener(Event.RESIZE, onResize);
			if (!_diceListenersRemoved){
				removeDiceListeners();
			}
			//reset flags
			_gotGhostResult = false;
			_gotResult = false;
			_launched = false;
			_applied = false;
			_enterDice = true;
			_cubeCreated = false;
			_startRealCube = false;
			_matSwitched = false;
			_diceListenersRemoved = true;
			_drag = false;
			_out = false;
			//remove ghost dice positions
			for (var j:int =_matrixArray.length-1; j>=0; j--){
				_matrixArray.pop();
			}	
			//remove objects 
			for (var i:int = scene.children.length-1; i>=0; i--){
				scene.removeChild(scene.children[i]);
			}
			//remove physics
			PhysicsSystem.getInstance().removeAllBodies()
			PhysicsSystem.getInstance().removeAllConstraints();
			_count=0;
			removeChild(view);
		}
		
		
		

		public function restart ():void {
			cleanup();
			//init
			init(null, _winningMaterial+1);
			//
			dispatchEvent(new Event (RESET_VIEW));
		}
		
		//DEBUG:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		protected function restartGame(e:KeyboardEvent):void {
			restart();
		}
		//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		//--------------------------------------------------------------------------
		// Protected Methods
		//--------------------------------------------------------------------------	
		//--------------------------------------------------------------------------
		// Private Methods
		//-------------------------------------------------------------------------
		
		/**
		 * Initialise the engine
		 */
		protected function initEngine():void
		{
			//scene
			scene = new Scene3D();
			
			camera = new TargetCamera3D ();
			camera.z = CAMERA_Z//500;
			camera.y = CAMERA_Y;

			//view
			view = new View3D();
			view.x=_stage.stageWidth/2;  
			view.y=_stage.stageHeight/2; 
			view.scene = scene;
			
			addChild(view);
			
		}
		
		protected function initPhysics ():void {
			// Physics System
			physics = new SpecialAway3DPhysics(view, 7);//new Away3DPhysics(view, 7);
		}
		
		protected function parseBitmaps(loaded:Array):void {
			var loaded:Array = LoadingManager.instance.loadedItems;
			for (var i:int=0; i< 6; i++){
				diceBitmaps.push(Bitmap (LoadedItem(loaded[0][i]).objItem).bitmapData);
			}
			for (i=6; i<loaded[0].length-1; i++){
				textureBitmaps.push(Bitmap(LoadedItem(loaded[0][i]).objItem).bitmapData);
			}
		}
		
		/**
		 * Initialise the materials
		 */
		protected function initMaterials():void
		{
			//DEBUG
			clearmaterial = new ColorMaterial(0xFFFFFF, {alpha:0});
			//TABLEBOTTOM SIDES MATERIAL
			colormaterial2 = new ColorMaterial(0xB8CBB0);
			colormaterial = new ColorMaterial(0x9AAA94);
			colormaterial3 = new ColorMaterial(0x8EA087);
			colormaterial4 = new ColorMaterial(0xA3BB99);
			
			//DICE FACES MATERIALS
			//IDX 1 WOOD
			diceMaterials.push (new CustomBitmapMaterial (diceBitmaps[0],"", {smooth:true}));
			
			//IDX 2 BRONZE
			diceMaterials.push (new CustomBitmapMaterial (diceBitmaps[1], "",{smooth:true}));
			
			//IDX 3 SILVER
			diceMaterials.push (new CustomBitmapMaterial (diceBitmaps[2], "",{smooth:true}));
			
			//IDX 4 GOLD
			diceMaterials.push (new CustomBitmapMaterial (diceBitmaps[3],"", {smooth:true}));
			
			//IDX 5 BONUS
			diceMaterials.push (new CustomBitmapMaterial (diceBitmaps[4], "",{smooth:true}));
			
			//IDX 6 DOUBLE
			diceMaterials.push (new CustomBitmapMaterial (diceBitmaps[5],"", {smooth:true}));
			
			//TABLEBOTTOM MATERIAL
			tableclothmaterial = new CustomBitmapMaterial (textureBitmaps[0] ,"", {smooth:true});
			//dice shadow
			shadowmaterial = new BitmapMaterial(textureBitmaps[1]);
			
			
			
			build();
		}
		
		protected function createBorder(w:Number, d:Number, ze:Number, ye:Number, mat:Material, rotateY:Boolean = false):RigidBody {
			var border:RigidBody = physics.createCube({width:w, height:1, depth:d, segmentsW:2, segmentsH:2});
			border.rotationX = 90;
			if (rotateY){
				border.rotationY = 90;
				border.x = ze;
			} else {
				border.z = ze;
			}
			Away3dMesh(border.skin).mesh.pushback = true
			border.y = ye/2;
			border.movable = false;
			Away3dMesh(border.skin).mesh.material = mat;
			return border;
			
		}
		
		protected function makeCube():Cube {
			var c:Cube = new Cube({width:DICE_DIM, height:DICE_DIM, depth:DICE_DIM});
			//c.useHandCursor = true;
			c.faces[0].material = diceMaterials[0];//new ColorMaterial (0xffff00);
			c.faces[1].material = diceMaterials[0];//new ColorMaterial (0xffcc00);
			c.faces[2].material = diceMaterials[1];//new ColorMaterial (0x33cc99);
			c.faces[3].material = diceMaterials[1];//new ColorMaterial (0x336699);
			c.faces[4].material = diceMaterials[2]; //new ColorMaterial (0xffffff);
			c.faces[5].material = diceMaterials[2];//new ColorMaterial (0xffcc99);
			c.faces[6].material = diceMaterials[3];//new ColorMaterial (0xffff00);
			c.faces[7].material = diceMaterials[3];//new ColorMaterial (0xffcc00);
			c.faces[8].material = diceMaterials[4];//new ColorMaterial (0x33cc99);
			c.faces[9].material = diceMaterials[4];//new ColorMaterial (0x336699);
			c.faces[10].material = diceMaterials[5]; //new ColorMaterial (0xffffff);
			c.faces[11].material = diceMaterials[5];//new ColorMaterial (0xffcc99);
			c.ownCanvas = true;
			return c;
		}
		
		/**
		 * Initialise the scene objects
		 */
		protected function initObjects():void
		{
			// Table bottom
			ground = physics.createGround({width:TRAY_WIDTH, height:TRAY_DEPTH, material:tableclothmaterial});
			Away3dMesh(ground.skin).mesh.pushback = true
			Away3dMesh(ground.skin).mesh.bothsides = true;
			//tablecloth
			//borders
			top = createBorder(TRAY_WIDTH, TRAY_HEIGHT, - TRAY_DEPTH/2, TRAY_HEIGHT, colormaterial4);
			bottom = createBorder(TRAY_WIDTH, TRAY_HEIGHT, TRAY_DEPTH/2, TRAY_HEIGHT, colormaterial);
			left = createBorder(TRAY_DEPTH, TRAY_HEIGHT, - TRAY_WIDTH/2, TRAY_HEIGHT,  colormaterial3, true);
			right = createBorder(TRAY_DEPTH, TRAY_HEIGHT, TRAY_WIDTH/2, TRAY_HEIGHT,  colormaterial2, true);
			physics.step();
			//Dice
			//mesh dice
			cube = makeCube ();
			scene.addChild(cube);
			//hcamera
			hcamera = new TargetCamera3D ();
			hcamera.target = cube;
			hcamera.z = 2//200;
			hcamera.y = 400;
			//physic dice
			dice = new PhysicsDice (new Away3dMesh(cube),DICE_DIM);
			dice.moveTo(new Vector3D(0, DICE_START_Y, 0));
			dice.mass = 3;
			dice.movable = true;
			dice.sideLengths = new Vector3D(DICE_DIM,DICE_DIM, DICE_DIM);
			
			//cube.filters = [new GlowFilter(0)];
			//cube.ownCanvas = true;
			
			//debug :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
			//launchPoint = new Cube({width:5, height:5, depth:5, material:redFlat});
			///scene.addChild(launchPoint);
			//cube.faces.forEach(getWinningFace);
			trace ("cube orientation start", dice.currentState.getOrientationCols());
			trace ("------------------------------------------");
			//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
			
			physics.addBody(ground);
			physics.addBody(top);
			physics.addBody(bottom);
			physics.addBody(left);
			physics.addBody(right);
			physics.addBody(dice);
		}
		
		protected function showResults():void {
			var X:Number = Mathematic.randRange(-50, 50);
			var Z:Number = Mathematic.randRange(-50, 50);
			var Y:Number = 0;
			var rY:Number = Mathematic.randRange(0, 180);
			cube.position = new Vector3D (X, Y, Z);
			cube.rotationY = rY;
			Away3dMesh(dice.skin).mesh.faces.forEach(getWinningFace);
			switchMaterials(cube);
			view.camera = hcamera
			hcamera.target = cube;
			dispatchEvent(new Event (CHANGE_VIEW));
			dispatchEvent(new Event(LANDED));
			onResize();
			view.render();
		}
		
		/**
		 * Initialise the listeners
		 */
		protected function initListeners():void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			_stage.addEventListener(Event.RESIZE, onResize);
			
			addDiceListeners();
			
			onResize();
		}
		
		protected function addDiceListeners():void {
			//dice listeners
			cube.addOnMouseDown(dragdice);
			scene.addOnMouseUp(undragdice);
			cube.addOnMouseUp(undragdice);
			cube.useHandCursor = true;
			scene.addOnMouseMove(onMouseMove);
			cube.addOnMouseMove(onMouseMove);
			_stage.addEventListener(MouseEvent.MOUSE_UP, stageundrag);
			_diceListenersRemoved = false;
		}
		
		
		protected function removeDiceListeners():void {
			cube.removeOnMouseDown(dragdice);
			scene.removeOnMouseUp(undragdice);
			cube.removeOnMouseUp(undragdice);
			cube.useHandCursor = true;
			scene.removeOnMouseMove(onMouseMove);
			cube.removeOnMouseMove(onMouseMove);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, stageundrag);
			_diceListenersRemoved = true;
		}
		
		
		
		protected function showScene():void {
			//setup camera
			hcamera.target = Plane(Away3dMesh(ground.skin).mesh);
			view.camera = camera;
		}
		
		
		protected function getWinningFace (item:Face, index:int, vector:Vector.<Face>):void {
			if (index/2 == Math.floor(index/2)){
				//determine what index is the winning face
				var rotatedNormal:Vector3D = cube.transform.deltaTransformVector(item.normal);
				if (rotatedNormal.y < - 0.7 && rotatedNormal.y > - 1.1){
					_winningFaceIndex = index;
				}
				//trace ("face", index, "normal:", item.normal);//, "material:", CustomBitmapMaterial(item.material).name);
				//trace ("rotated normal:", rotatedNormal);
				//trace ("WINNIN FACE INDEX", _winningFaceIndex);
				
			}
		}
		
		
		protected function switchMaterials (obj:Cube):void{
			//material that is on the top face
			var winningFaceMaterial:CustomBitmapMaterial = obj.faces[_winningFaceIndex].material as CustomBitmapMaterial;
			//index of the material that is on the top face
			var wFMI:int = getMaterialIndex(winningFaceMaterial);
			trace ("winning material", _winningMaterial);
			trace ("winning face material index", wFMI);
			//distance between the winning material and the material current on face
			var dI:int = _winningMaterial - wFMI;
			trace ("distance from the winning bitmap", dI);
			//rearrange all materials
			for (var i:int = 0; i<diceMaterials.length; i++){
				var newId:int = i+dI;
				if (newId >= diceBitmaps.length){
					newId = newId - diceBitmaps.length;
				} else if (newId < 0){
					newId = diceBitmaps.length + newId;
				}
				trace ("Switched material ", i, "new id", newId);
				if ( diceBitmaps[newId] != null){
					diceMaterials[i].bitmap = diceBitmaps[newId];
				} else {
					trace ("bitmap doesn't exist");
				}
			}
		}
		
		protected function getMaterialIndex (material:CustomBitmapMaterial):int {
			for (var i:int=0; i<diceMaterials.length; i++){
				if (diceMaterials[i] == material){
					return i;
				}
			}
			return null;
		}
		
		
		protected function launch (X:Number, Z:Number):void {
			
			removeDiceListeners();
			
			_origPosition = cube.transform;
			var dirX:Number = 1;
			var dirZ:Number = 1;
			var cubeFaceNormal:Vector3D =  Vector3D(cube.faceVOs[0].face.normal)//.add(cube.position);
			var orig:Vector3D = cubeFaceNormal.add(new Vector3D (dice.x, dice.y, dice.z));//new Vector3D (Math.floor(dice.x-50),Math.floor( dice.y),Math.floor( dice.z-50));
			
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
			if (speedX+speedZ < MIN_SPEED){
				newspeeds = modifySpeed(MIN_SPEED, speedX, speedZ);
			} else if (speedX+speedZ > MAX_SPEED){
				newspeeds = modifySpeed(MAX_SPEED, speedX, speedZ);
			} else {
				newspeeds.x = speedX;
				newspeeds.y = speedZ;
			}
			
			_forc = new Vector3D(newspeeds.x*dirX, Y_SPEED, newspeeds.y*dirZ);
			_deltaForc = orig.add (_forc);
			trace ("delta forc", _forc, _deltaForc);
			//TIMER SYSTEM
			var t:Timer = new Timer (0.2);
			t.addEventListener(TimerEvent.TIMER, createRoll);
			t.start();
			
		}
		
		protected function modifySpeed(targetSpeed:Number, speedX:Number, speedZ:Number):Point {
			var r:Number ;
			if (speedX != 0 && speedZ != 0){
				r = speedX/speedZ;
			} else {
				r = 1;
			}
			speedZ = targetSpeed/(r+1);
			speedX = targetSpeed - speedZ;
			trace ("NEW SPEEDS: ", speedX, speedZ);
			return new Point (speedX, speedZ);
		}
		
		
		protected function checkBounds(body:AbstractPrimitive):Boolean {
			if (body.x < left.x+DICE_DIM/2){ 
				return true;
			};
			if (body.x > right.x-DICE_DIM/2){ 
				return true;
			};
			if (body.z < top.z+DICE_DIM/2){ 
				return true;
			};
			if (body.z > bottom.z-DICE_DIM/2){ 
				return true;
			};
			return false;
		}
		
		protected function makeDiceShadow ():void {
			// PNG SHADOW
			pngPlane = new Plane({material:shadowmaterial, height:55, width:55, y:-2, bothsides:true});
			pngPlane.ownCanvas = true;;
			pngPlane.filters = [new BlurFilter(64, 64)];
			scene.addChild(pngPlane);
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
		protected function dragdice (e:MouseEvent3D):void {
			
			if (!_drag){
				_drag=true;
				dragConstraint = new JConstraintWorldPoint  (dice, new Vector3D (0, DICE_DIM/2+10, 0), new Vector3D(e.sceneX,PICKUP_HEIGHT, e.sceneZ));		
			}
		}
		
		protected function stageundrag (e:MouseEvent):void {
			undragdice();
		}
		
		protected function undragdice (e:MouseEvent3D=null):void {
			if (_drag){
				_drag=false;
				dragConstraint.disableConstraint();
				if (e){
					launch(e.sceneX, e.sceneZ);
				} else {
					launch(mouseX, -mouseY);
				}
			}
		}
		
		protected function onMouseMove(e:MouseEvent3D):void {
			if (_drag){
				dragConstraint.worldPosition = new Vector3D (e.sceneX, PICKUP_HEIGHT, e.sceneZ);
				_prevX = e.sceneX;
				_prevZ = e.sceneZ;
			}
		}
		
		
		protected function createRoll (e:TimerEvent):void {
			//physics.ghostStep();
			physics.step();
			if (!_applied){
				dice.applyBodyWorldImpulse(_forc, _deltaForc);	
				_applied = true;
			}
			_matrixArray.push(cube.transform);
			//if (_matrixArray.length>5){
			_startRealCube = true;
			//	trace ("start real cube");
			//}
			if (!dice.getVelChanged()){
			//if (checkDiceVelocity()){
				Away3dMesh(dice.skin).mesh.faces.forEach(getWinningFace);
				//trace ("ghost cube orientation end", dice.currentState.getOrientationCols());
				//trace ("=======================================================================");
				_gotGhostResult = true;
				//view.render();
				//RESULT!!!!!!!: LA FACCIA IN ALTO E' QUELLA CON NORMALE TRASFORMATA = (0, -1, 0);
			}
			
			if (!dice.getVelChanged()){
				//trace ("cube position:", cube.position);
				cube.transform = _origPosition;
				Timer(e.target).stop();
			}
		}
		
		
		protected function checkDiceVelocity ():Boolean{
			if (dice.currentState.linVelocity.x < 0.1 && dice.currentState.linVelocity.y < 0.1 && dice.currentState.linVelocity.z < 0.1){
				return true;
			}
			return false;
		}
		/**
		 * Navigation and render loop
		 */
		protected function onEnterFrame( e:Event ):void
		{
			if (!_out){
			
			if (_drag){
				physics.engine.integrate(0.3);
			}
			
			
			
			if (_enterDice){
				physics.engine.integrate(0.3);
				if (!dice.getVelChanged()){
					//trace ("readyToRoll");
					_enterDice = false;
				}
			}
			
			if (_startRealCube){
				
				if (!_cubeCreated){
					realCube = makeCube();
					makeDiceShadow();
					scene.addChild(realCube);
					scene.removeChild(cube);
					realCube.transform = _origPosition;
					_cubeCreated = true;
				}
				
				if (_count<_matrixArray.length){
					realCube.transform = _matrixArray[_count];
					pngPlane.rotationY = realCube.rotationY;
					pngPlane.x = realCube.x;
					pngPlane.z = realCube.z;
					_count++;
					if (checkBounds(realCube)){
						trace ("OUT");
						_out = true;
						physics.engine.removeAllControllers();
						restart();
						return;
					}
					if ( _gotGhostResult){
						view.camera = hcamera
						hcamera.target = realCube;
						if (!_matSwitched){
							switchMaterials (realCube);
							_matSwitched = true;
							dispatchEvent(new Event (CHANGE_VIEW));
							
						}
					} 
				} else {
					_startRealCube = false;
					//trace ("done", _matrixArray.length);
					dispatchEvent(new Event (LANDED));
				}
			}
			
			view.render();
			
			} else {
				removeEventListener( Event.ENTER_FRAME, onEnterFrame);
				//restart();
			}
			
		}
		
		
		/**
		 * _stage listener for resize events
		 */
		protected function onResize(event:Event = null):void
		{
			view.x = _stage.stageWidth / 2;
			view.y = _stage.stageHeight / 2;
			
		}
		//--------------------------------------------------------------------------
		// Getters/Setters
		//--------------------------------------------------------------------------
	}
}