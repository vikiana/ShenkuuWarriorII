/**
 *	ImageManager manages visual side of the particles
 *	This will draw out particles on the stage
 *
 *	Main idea is that when given the holders (Sprites), it adds two* bitmaps per each holder:
 *	1) main bitmap: to render out particles each frame
 *	2) trail bitmap: to render out trails
 *	*only one bitmap will be added per holder if trail property is off
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  08.16.2009
 */

 
 
 /**
  *		TO DOs
  *
  *		- make a way to make main particle invisible while trails can be shown
  *		- optimization for processing speed
  **/
package com.neopets.users.abelee.effects.particle
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------

	
	
	public class ImageManager
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		private static var mReturnedInstance:ImageManager;	//singleton instance
		private var mInitiated:Boolean = false;
		private var mHolderArray:Array;	// holds MC/Sprite and the filter information for particles
		private var mParticleImages:Object;	// images of particles to be used
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function ImageManager(pPrivCl : PrivateClass):void
		{
			
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		public static function get instance( ):ImageManager
		{
			if( ImageManager.mReturnedInstance == null ) 
			{
				ImageManager.mReturnedInstance = new ImageManager( new PrivateClass( ) );
				ImageManager.instance.init ()	// this can be called outside if needed be
			}
			
			return ImageManager.mReturnedInstance
		}
		
		
		
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		
		/**
		 *	Add sprite where particles will be shown in
		 *
		 *	@NOTE:	When are adding an empty/new sprite, it won't have any width or hiehgt
		 *			Thus sp.width or sp.hieght will only return 0.
		 *			So please be sure to give a solid width and height
		 *
		 *	@NOTE:	more filter = more memory and slow down
		 *
		 *	@PARAM		pHolder			Sprite		Where particle bitmap will be shown in
		 *	@PARAM		pWidth			Number		Width of the folder
		 *	@PARAM		pFilterArray	Array		Array of filters: applied on main particle bitmap
		 *	@PARAM		pTrailOn		Boolean		Set true if you want to see a trail
		 *	@PARAM		pTrailDecay		Number		decay rate: higher number == longerlife
		 *	@PARAM		pTFilterArray	Array		Array of filters: applied on trail bitmap
		 *	@PARAM		pBlendMode		String		blendmode: applied on main particle bitmap
		 *	@PARAM		pTBlendMode		String		blendmode: applied on trail bitmap
		 **/
		public static function addHolder(pHolder:Sprite,pWidth:Number, pHeight:Number, pFilterArray:Array = null, pTrailOn:Boolean = false, pTrailDecay:Number = .9, pTFilterArray:Array = null, pBlendMode:String = null, pTBlendMode:String = null):void
		{
			ImageManager.instance.setupHolder(pHolder,pWidth, pHeight, pFilterArray, pTrailOn, pTrailDecay, pTFilterArray, pBlendMode, pTBlendMode)
		}
		
		/**
		 *	Add an image of a particle
		 *	@PARAM		pSource		DisplayObject		The image of the particle to be used
		 *	@PRRAM		pName		String				Name of the particle image
		 **/
		public static function addParticleImage(pSource:DisplayObject, pName:String):void
		{
			ImageManager.instance.addParticleImage(pSource, pName)
		}
		
		
		/**
		 *	renders all the active aprticles accordingly
		 **/
		public static function showParticles():void
		{
			ImageManager.instance.refreshBitmaps();	// refresh bitmap, account of decay, etc.
			ImageManager.instance.showParticles();	// render each particle
			ImageManager.instance.applyFilters();	// apply filters to each bitmap
			ImageManager.instance.showTrail();	//show trails
			ParticleManager.sortParticles();	//sort active vs inactive particles
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		// initialize 
		private function init():void
		{
			if (!mInitiated)
			{
				trace ("\n//////////\nImage Manager initiated\n//////////\n")
				mInitiated = true;
				mHolderArray = [];
				mParticleImages = new Object ();
			}
		}
		
		
		/**
		 *	Creat a holder where particle will be shown at
		 *	@PARAM		pHolder		DisplayObject		Where (prticle) bitmpats will be placed at
		 *	@PARAM		pTrailOn	Boolean				Set true if you want the particle trail
		 *	@PARAM		pTrailDcay	Number				pick between 0 to 1: higher number = longer trail
		 **/
		private function setupHolder(pHolder:Sprite, pWidth:Number, pHeight:Number, pFilterArray:Array , pTrailOn:Boolean, pTrailDecay:Number, pTFilterArray:Array, pBlendMode:String, pTBlendMode:String)
		{
			var mainBD:BitmapData = new BitmapData (pWidth, pHeight, true, 0x000000); 
			var mainBM:Bitmap = new Bitmap (mainBD);
			mainBM.name = "main";
			
			if (pTrailOn)
			{
				var trailBD:BitmapData = new BitmapData (pWidth, pHeight, true, 0x000000);
				var trailBM:TrailBitmap = new TrailBitmap (trailBD, pTrailDecay);
				trailBM.name = "trail"
				pHolder.addChild(trailBM)
			}
			pHolder.addChild(mainBM);
			mHolderArray.push([pHolder, pFilterArray, pTFilterArray, pBlendMode, pTBlendMode])
		}
		
		/**
		 *	create a bitmap of a source image and hold it in an array.
		 *	@NOTE:	The registration point for the soure image MUST be centered!!!
		 *
		 *	@PARAM		pSouce		DisplayObject		Source image of a particle
		 *	@PARAM		pName		String				Name of this particle image
		 **/
		private function addParticleImage (pSource:DisplayObject, pName:String):void
		{
			var image:DisplayObject = pSource
			var pBD:BitmapData = new BitmapData (image.width, image.height, true, 0x000000);
			var matrix:Matrix = new Matrix (1, 0, 0, 1, image.width/2,image.height/2)
			pBD.draw(image, matrix)			
			
			var pBM:Bitmap = new Bitmap (pBD);
			
			mParticleImages[pName] = pBM
		}
		
		
		/**
		 *	refresh Main particle bitmap
		 *	refresh (or allow decay if trail bitmap is available)
		 **/
		private function refreshBitmaps():void
		{
			for (var i:String in mHolderArray)
			{
				var sp:Sprite = mHolderArray[i][0]
				var mainBM:Bitmap = Bitmap(sp.getChildByName("main"))
				mainBM.bitmapData.fillRect (new Rectangle (0, 0, mainBM.width, mainBM.height),0x0000);
				
				
				if (sp.getChildByName("trail") != null)
				{
					var trailBM:TrailBitmap = TrailBitmap(sp.getChildByName("trail"))
					var alphaS:uint = uint(Number(uint2hex(0xff * trailBM.decay) + "000000"));
					var alphab:BitmapData = new BitmapData(mainBM.width, mainBM.height, true , alphaS);
					var rectstage:Rectangle = new Rectangle (0, 0, mainBM.width, mainBM.height);
					trailBM.bitmapData.copyPixels(trailBM.bitmapData, rectstage, new Point (0, 0),alphab, new Point (0, 0)) 
					alphab.dispose()
				}
			}
		}
		
		/**
		 *	Render particles on main bitmap
		 **/
		private function showParticles():void
		{
			if (ParticleManager.activeParticles.length >= 1)
			{
				for (var i:String in ParticleManager.activeParticles)
				{
					var particle:AbsParticle = ParticleManager.activeParticles[i];
					var sp:Sprite = particle.holder;
					var mainBM:Bitmap = Bitmap(sp.getChildByName("main"));
					var imageName:String = particle.imageName;
					var image:BitmapData = mParticleImages[imageName].bitmapData;
					var rect:Rectangle = new Rectangle (0, 0, image.width, image.height);
					var destPt:Point = new Point (ParticleManager.activeParticles[i].pos.x - image.width/2, particle.pos.y - image.height/2);
					particle.update()
					if (
						particle.pos.x > 0 - image.width && 
						particle.pos.x < mainBM.width +  image.width &&
						particle.pos.y > 0 - image.height && 
						particle.pos.y < mainBM.height + image.height
						)
					{
						var alphaValue:uint = uint(Number(uint2hex(0xff * particle.decay) + "000000"));
						var tempbm:BitmapData = new BitmapData(image.width, image.height,true,alphaValue);
						mainBM.bitmapData.copyPixels (image, rect, destPt, tempbm, new Point (0,0), true);
						tempbm.dispose();
					}
				}
			}
		}
		
		
		/**
		 *	apply given filters to appropriate bitmaps
		 **/
		private function applyFilters():void
		{
			for (var i:String in mHolderArray)
			{
				var sp:Sprite = mHolderArray[i][0];
				var mainBM:Bitmap = Bitmap(sp.getChildByName("main"));
				var rect:Rectangle = new Rectangle (0, 0, mainBM.width, mainBM.height);
				if (mHolderArray[i][1] != null && mHolderArray[i][1].length > 0)
				{
					for (var j:String in mHolderArray[i][1])
					{
						mainBM.bitmapData.applyFilter(mainBM.bitmapData,rect, new Point (0, 0), mHolderArray[i][1][j])
					}
					if (mHolderArray[i][3] != null) mainBM.blendMode = mHolderArray[i][3];
				}
				
				if (sp.getChildByName("trail") != null)
				{
					var trailBM:TrailBitmap = TrailBitmap(sp.getChildByName("trail"))
					if (mHolderArray[i][2] != null && mHolderArray[i][2].length > 0)
					{
						for (var k:String in mHolderArray[i][2])
						{
							trailBM.bitmapData.applyFilter(trailBM.bitmapData,rect, new Point (0, 0), mHolderArray[i][2][k])
						}
					}
					if (mHolderArray[i][4] != null) trailBM.blendMode = mHolderArray[i][4];
				}
				
			}
		}
		
		//show trail bitmap If trail is on
		private function showTrail():void
		{
			for (var i:String in mHolderArray)
			{
				var sp:Sprite = mHolderArray[i][0]
				var mainBM:Bitmap = Bitmap(sp.getChildByName("main"))
				if (sp.getChildByName("trail") != null)
					{
						var trailBM:TrailBitmap = TrailBitmap(sp.getChildByName("trail"))
						var rectOfMain:Rectangle = new Rectangle (0, 0, mainBM.width, mainBM.height)
						trailBM.bitmapData.copyPixels (mainBM.bitmapData, rectOfMain, new Point (0,0), mainBM.bitmapData, new Point (0,0), true)
					}
			}
		}
		
		//	convert number into hex value
		public function uint2hex(dec:uint) : String
		{
			var digits:String = "0123456789ABCDEF";
			var hex:String = '';
		
			while (dec > 0)
			{
				var next:uint = dec & 0xF;
				dec >>= 4;
				hex = digits.charAt(next) + hex;
			}
		
			if (hex.length == 0)
				hex = '00'
			return '0x'+hex;
		}
		
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
	}
	
}

//
class PrivateClass
{
	public function PrivateClass( )
	{
		//trace( "PrivateClass in GlobalGameReference instantiated" );
	}

} 