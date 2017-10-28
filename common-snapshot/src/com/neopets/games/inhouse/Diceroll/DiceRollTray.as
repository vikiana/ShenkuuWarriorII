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
	
	import org.osmf.events.TimeEvent;
	
	
	
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
	public class DiceRollTray extends Sprite
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
		public const ROLL_AGAIN:String = "roll_again";
		//--------------------------------------------------------------------------
		//Private properties
		//--------------------------------------------------------------------------	
		private const MAX_SPEED:Number = 75//150;
		private const MIN_SPEED:Number = 75//150;
		private const Y_SPEED:Number = 20;
		private const PICKUP_HEIGHT:Number = 10;
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
		private var _images:Array = ["anim_die_sides_wood.png", "anim_die_sides_bronze.png","anim_die_sides_silv.png", "anim_die_sides_gold.png", "anim_die_sides_question.png", "anim_die_sides_crown.png", "tablecloth_large.jpg" , "shadow.png" ] 
		private var _baseURL:String = "";
		//3D ENGINE
		private var scene:Scene3D;
		private var camera:TargetCamera3D;
		private var hcamera:TargetCamera3D;
		private var view:View3D;
		//objects
		private var cube:Cube;
		private var pngPlane:Plane;	
		private var realCube:Cube;
		
		//MATERIALS
		//material objects
		private var diceBitmaps:Array;
		private var textureBitmaps:Array;
		private var diceMaterials:Vector.<CustomBitmapMaterial>;
		private var clearmaterial:ColorMaterial
		private var shadowmaterial:BitmapMaterial;
	
		//table cloth
		private var tableclothmaterial:CustomBitmapMaterial;
		private var colormaterial:ColorMaterial//ShadingColorMaterial;
		private var colormaterial2:ColorMaterial
		private var colormaterial4:ColorMaterial
		private var colormaterial3:ColorMaterial///ShadingColorMaterial;
		//winning color from PHP
		private var _winningMaterial:int;
		//index of the face that is showing up
		private var _winningFaceIndex:int;
		private var _setWFI:int;
		//PHYSICS
		private var physics:SpecialAway3DPhysics;
		//physics objects
		private var dice:PhysicsDice;
		private var ground:RigidBody;
		private var dragConstraint:JConstraintWorldPoint;
		private var top:RigidBody;
		private var bottom:RigidBody;
		private var left:RigidBody;
		private var right:RigidBody;
		
		//COSTANTS
		private const DICE_DIM:Number = 40;
		private const TRAY_WIDTH:Number = 600;
		private const TRAY_DEPTH:Number = 380;
		private const TRAY_HEIGHT:Number =250;
		
		//LAUNCH
		private var _prevX:Number =0;
		private var _prevZ:Number = 0;
		
		private var _prevRotX:Number;
		private var _prevRotZ:Number;
		
		private var _matrixArray:Vector.<Matrix3D>;
		private var _origPosition:Matrix3D;
		private var _count:int = 0;
		private var _forc:Vector3D;
		private var _deltaForc:Vector3D;
		
		//FLAGS
		private var _gotGhostResult:Boolean = false;
		private var _gotResult:Boolean = false;
		private var _launched:Boolean = false;
		private var _applied:Boolean = false;
		private var _enterDice:Boolean = true;
		private var _cubeCreated:Boolean = false;
		private var _startRealCube:Boolean = false;
		private var _matSwitched:Boolean = false;
		private var _diceListenersRemoved:Boolean = true;
		private var _drag:Boolean = false;
		private var _out:Boolean = false;
		private var _extraspin:Boolean = false;
		private var _rolled:Boolean = false;
		
		private var _stage:Stage;
		
		private var _starDragX:Number;
		private var _starDragZ:Number;
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
		public function DiceRollTray()
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

		
		private function build ():void {
			initEngine();
			initPhysics();
			initObjects();
			showScene();
			if (!_rolled){
				initListeners();
			} else {
				//is this page is pulled up and the dice has been rolled already, show the results
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
			_extraspin = false;
			
			_winningFaceIndex = 0;
			_setWFI =0;

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
		
		
		
		
		//DEBUG:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
		private function restart ():void {
			cleanup();
			//init
			init(null, _winningMaterial+1);
			//
			dispatchEvent(new Event (RESET_VIEW));
		}

		private function restartGame(e:KeyboardEvent):void {
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
		private function initEngine():void
		{
			//scene
			scene = new Scene3D();
			
			camera = new TargetCamera3D ();
			camera.z = -2//500;
			camera.y = 1050;

			//view
			view = new View3D();
			view.x=_stage.stageWidth/2;  
			view.y=_stage.stageHeight/2; 
			view.scene = scene;
			
			addChild(view);
			
		}
		
		private function initPhysics ():void {
			// Physics System
			physics = new SpecialAway3DPhysics(view, 7);//new Away3DPhysics(view, 7);
		}
		
		private function parseBitmaps(loaded:Array):void {
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
		private function initMaterials():void
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
		
		private function createBorder(w:Number, d:Number, ze:Number, ye:Number, mat:Material, rotateY:Boolean = false):RigidBody {
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
		
		private function makeCube():Cube {
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
			return c;
		}
		
		/**
		 * Initialise the scene objects
		 */
		private function initObjects():void
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
			dice.moveTo(new Vector3D(0, 100, 0));
			dice.mass = 3;
			dice.movable = true;
			dice.sideLengths = new Vector3D(DICE_DIM,DICE_DIM, DICE_DIM);
			
			//cube.filters = [new GlowFilter(0)];
			//cube.ownCanvas = true;
			
			//debug :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
			//launchPoint = new Cube({width:5, height:5, depth:5, material:redFlat});
			///scene.addChild(launchPoint);
			//cube.faces.forEach(getWinningFace);
			//trace ("cube orientation start", dice.currentState.getOrientationCols());
			//trace ("------------------------------------------");
			//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
			
			physics.addBody(ground);
			physics.addBody(top);
			physics.addBody(bottom);
			physics.addBody(left);
			physics.addBody(right);
			physics.addBody(dice);
		}
		
		private function showResults():void {
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
		private function initListeners():void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			_stage.addEventListener(Event.RESIZE, onResize);
			
			addDiceListeners();
			
			onResize();
		}
		
		private function addDiceListeners():void {
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
		
		
		private function removeDiceListeners():void {
			cube.removeOnMouseDown(dragdice);
			scene.removeOnMouseUp(undragdice);
			cube.removeOnMouseUp(undragdice);
			cube.useHandCursor = true;
			scene.removeOnMouseMove(onMouseMove);
			cube.removeOnMouseMove(onMouseMove);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, stageundrag);
			_diceListenersRemoved = true;
		}
		
		
		
		private function showScene():void {
			//setup camera
			hcamera.target = Plane(Away3dMesh(ground.skin).mesh);
			view.camera = camera;
		}
		
		
		private function getWinningFace (item:Face, index:int, vector:Vector.<Face>):void {
			if (index/2 == Math.floor(index/2)){
				//determine what index is the winning face
				var rotatedNormal:Vector3D = cube.transform.deltaTransformVector(item.normal);
				if (rotatedNormal.y < - 0.7 && rotatedNormal.y > - 1.1){
					_winningFaceIndex = index;
				}
				//trace ("face", index, "normal:", item.normal);//, "material:", CustomBitmapMaterial(item.material).name);
				//trace ("rotated normal:", rotatedNormal);	
			}
		}
		
		
		private function switchMaterials (obj:Cube):void{
			//material that is on the top face
			var winningFaceMaterial:CustomBitmapMaterial = obj.faces[_winningFaceIndex].material as CustomBitmapMaterial;
			//index of the material that is on the top face
			var wFMI:int = getMaterialIndex(winningFaceMaterial);
			//trace ("winning material", _winningMaterial);
			//trace ("winning face material index", wFMI);
			//distance between the winning material and the material current on face
			var dI:int = _winningMaterial - wFMI;
			//trace ("distance from the winning bitmap", dI);
			//rearrange all materials
			for (var i:int = 0; i<diceMaterials.length; i++){
				var newId:int = i+dI;
				if (newId >= diceBitmaps.length){
					newId = newId - diceBitmaps.length;
				} else if (newId < 0){
					newId = diceBitmaps.length + newId;
				}
				//trace ("Switched material ", i, "new id", newId);
				if ( diceBitmaps[newId] != null){
					diceMaterials[i].bitmap = diceBitmaps[newId];
				} else {
					//trace ("bitmap doesn't exist");
				}
			}
		}
		
		private function getMaterialIndex (material:CustomBitmapMaterial):int {
			for (var i:int=0; i<diceMaterials.length; i++){
				if (diceMaterials[i] == material){
					return i;
				}
			}
			return null;
		}
		
		
		private function launch (X:Number, Z:Number):void {
			
			removeDiceListeners();
			
			_origPosition = cube.transform;
			var dirX:Number = 1;
			var dirZ:Number = 1;
			var cubeFaceNormal:Vector3D =  Vector3D(cube.faceVOs[0].face.normal)//.add(cube.position);
			var orig:Vector3D = cubeFaceNormal.add(new Vector3D (dice.x, dice.y, dice.z));//new Vector3D (Math.floor(dice.x-50),Math.floor( dice.y),Math.floor( dice.z-50));
			
			//trace ("PREV COORDS: ", _prevX, _prevZ);
			//extablish direction of launch
			if (_prevX > X){
				dirX = -1;
			}
			if (_prevZ > Z){
				dirZ = -1;
			}
			
			
			var speedX:Number = Math.abs(X-_prevX);
			var speedZ:Number = Math.abs (Z-_prevZ);
			//trace ("X dir: ", dirX, "speedX: ", speedX);
			//trace ("Z dir: ", dirZ ,"speedZ: ", speedZ);
			var newspeeds:Point = new Point (0,0);
			
			//speed limiters
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
			//trace ("delta forc", _forc, _deltaForc);
			//TIMER SYSTEM
			var t:Timer = new Timer (0.2);
			t.addEventListener(TimerEvent.TIMER, createRoll);
			t.start();
			
		}
		
		private function modifySpeed(targetSpeed:Number, speedX:Number, speedZ:Number):Point {
			var r:Number ;
			if (speedX != 0 && speedZ != 0){
				r = speedX/speedZ;
			} else {
				r = 1;
			}
			speedZ = targetSpeed/(r+1);
			speedX = targetSpeed - speedZ;
			//trace ("NEW SPEEDS: ", speedX, speedZ);
			return new Point (speedX, speedZ);
		}
		
		
		private function checkBounds(body:AbstractPrimitive):Boolean {
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
		
		private function makeDiceShadow ():void {
			// PNG SHADOW
			pngPlane = new Plane({material:shadowmaterial, height:55, width:55, y:-2, bothsides:true});
			pngPlane.ownCanvas = true;;
			pngPlane.filters = [new BlurFilter(64, 64)];
			scene.addChild(pngPlane);
		}
		
		//--------------------------------------------------------------------------
		// Event Handlers
		//--------------------------------------------------------------------------	
		
		private function dragdice (e:MouseEvent3D):void {
			_starDragX = e.sceneX;
			_starDragZ = e.sceneZ;
			if (!_drag){
				_drag=true;
				dragConstraint = new JConstraintWorldPoint  (dice, new Vector3D (0, DICE_DIM/2+10, 0), new Vector3D(e.sceneX,PICKUP_HEIGHT, e.sceneZ));		
			}
		}
		
		private function stageundrag (e:MouseEvent):void {
			undragdice();
		}
		
		private function undragdice (e:MouseEvent3D=null):void {
			var deltaX:Number;
			var deltaZ:Number;
			if (_drag){
					_drag=false;
					dragConstraint.disableConstraint();
					if (e){
						//checks that the player  has moved the mouse around a bit ('shaked')before launching
						deltaX = Math.abs(Math.abs(_starDragX)-Math.abs(e.sceneX))
						deltaZ = Math.abs(Math.abs(_starDragZ)-Math.abs(e.sceneZ))
						//trace("MOUSE MOVE", deltaX, deltaZ);
						if (deltaX < 40 || deltaZ < 40){
							//this adds more rotation if the player didn't 'shake' the dice at all
							_extraspin = true;
						}
						launch(e.sceneX, e.sceneZ);
					} else {
						launch(mouseX, -mouseY);
					}
			}
		}
		
		private function onMouseMove(e:MouseEvent3D):void {
			if (_drag){
				dragConstraint.worldPosition = new Vector3D (e.sceneX, PICKUP_HEIGHT, e.sceneZ);
				_prevX = e.sceneX;
				_prevZ = e.sceneZ;
			}
		}
		
		
		
		//this creates the 'ghost' dice roll and stores the steps in an a rray to be used by the 'real' cube.
		private function createRoll (e:TimerEvent):void {
			//physics.ghostStep();
			physics.step();
			if (!_applied){
				dice.applyBodyWorldImpulse(_forc, _deltaForc);
				if (_extraspin){
					dice.addBodyTorque(new Vector3D (25, 0, 25));
				}	
				_applied = true;
			}
			_matrixArray.push(cube.transform);
			//if (_matrixArray.length>5){
			_startRealCube = true;
			//	trace ("start real cube");
			//}
			
			//when the ghost dice stops, stop the timer and the path generation.
			if (!dice.getVelChanged()){
				//trace ("cube position:", cube.position);
				//Away3dMesh(dice.skin).mesh.faces.forEach(getWinningFace);
				//trace ("ghost cube orientation end", dice.currentState.getOrientationCols());
				//trace ("=======================================================================");
				//_gotGhostResult = true;
				//view.render();
				//RESULT!!!!!!!: LA FACCIA IN ALTO E' QUELLA CON NORMALE TRASFORMATA = (0, -1, 0);
				cube.transform = _origPosition;
				Timer(e.target).stop();
				return;
			}
			//This establishes when the dice is not rolling anymore, so it can decide what face it landed on.
			//At this point, the dice might still have some translational movement.
			//if (!dice.getVelChanged()){
			if (checkDiceRotation()){
				//Gets the winning face
				Away3dMesh(dice.skin).mesh.faces.forEach(getWinningFace);
				//trace ("WINNIN FACE INDEX", _winningFaceIndex);
				//debug statement
				//_winningFaceIndex = 10;
				
				//This checks to see if the face displaying is different from the winning face
				//Sometimes, the dice roll picks up again, resultig in the wrong face being displayed.
				//This handles this error.
				if (_setWFI != _winningFaceIndex && _matSwitched){
					physics.engine.removeAllControllers();
					removeEventListener( Event.ENTER_FRAME, onEnterFrame);
					dispatchEvent(new Event (ROLL_AGAIN));
					return;
				}
				//trace ("ghost cube orientation end", dice.currentState.getOrientationCols());
				//trace ("=======================================================================");
				//triggers the switching of the faces
				_gotGhostResult = true;
				//view.render();
				//RESULT!!!!!!!: LA FACCIA IN ALTO E' QUELLA CON NORMALE TRASFORMATA = (0, -1, 0);
			} 
			//get's the rotation values to compare with next iteration
			_prevRotX = dice.getTransform().decompose()[1].x;
			_prevRotZ = dice.getTransform().decompose()[1].z;
		}
		
		
		private function checkDiceRotation ():Boolean{
			var currRotX:Number = dice.getTransform().decompose()[1].x;
			var currRotZ:Number = dice.getTransform().decompose()[1].z;
			var deltaRX:Number = Math.abs(Math.abs (currRotX) - Math.abs(_prevRotX));
			var deltaRZ:Number = Math.abs(Math.abs (currRotZ) - Math.abs(_prevRotZ));
			//trace ("deltaRX", deltaRX, "deltaRZ", deltaRZ);
			//trace ("DICE ROTATION:", deltaRX, deltaRZ);
			if ( deltaRX < 0.008 && deltaRZ < 0.008 ){
				//trace ("DICE ROTATION:", deltaRX, deltaRZ);
				return true;
			}
			return false;
		}
		
		
		
		/**
		 * Navigation and render loop
		 */
		private function onEnterFrame( e:Event ):void
		{
			if (!_out){
			
			if (_drag){
				physics.engine.integrate(0.3);
			}
			
			
			//dice enters and falls on the ground
			if (_enterDice){
				physics.engine.integrate(0.3);
				if (!dice.getVelChanged()){
					//trace ("readyToRoll");
					_enterDice = false;
				}
			}
			
			//
			if (_startRealCube){
				
				if (!_cubeCreated){
					realCube = makeCube();
					makeDiceShadow();
					scene.addChild(realCube);
					scene.removeChild(cube);
					realCube.transform = _origPosition;
					_cubeCreated = true;
				}
				
				if (_count<_matrixArray.length ){//&& _matrixArray.length>5){
					realCube.transform = _matrixArray[_count];
					pngPlane.rotationY = realCube.rotationY;
					pngPlane.x = realCube.x;
					pngPlane.z = realCube.z;
					_count++;
					if (checkBounds(realCube)){
						//trace ("OUT");
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
							_setWFI = _winningFaceIndex;
							dispatchEvent(new Event (CHANGE_VIEW));
						}
					} 
				} else {
					//movement steps are finished. 
					_startRealCube = false;
					//This check is to avoid the landing event to be fired as soon as the game starts.
					if (_count>0){
						dispatchEvent(new Event (LANDED));
					}
				}
			}
			
			view.render();
			
			} else {
				//NO need to run the loop anymore.
				removeEventListener( Event.ENTER_FRAME, onEnterFrame);
				//restart();
			}
			
		}
		
		
		/**
		 * _stage listener for resize events
		 */
		private function onResize(event:Event = null):void
		{
			view.x = _stage.stageWidth / 2;
			view.y = _stage.stageHeight / 2;
			
		}
		//--------------------------------------------------------------------------
		// Getters/Setters
		//--------------------------------------------------------------------------
	}
}