/**
 *	Preset for particle formation
 *	@NOTE:	This class is not same as class behevior.
 *			It gives initial formation of particles and the behavior itself is governed at particle level.
 *			Currently there is one kind of particle (base) and it can't suppor other kinds:  
 *			That change will be for next revision.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  03.26.2009
 */

package com.neopets.projects.effects.particle
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.Sprite;
	import flash.geom.Point;
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------

	
	
	public class ParticleFormation
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function ParticleFormation():void
		{
			
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		
		
		/**
		 *	Create smoke movement
		 *	@PARAM		pArray		Array		Array of praticles
		 *	@PARAM		pHolder		Sprite		Where particles should appear
		 *	@PARAM		pImageName	String		Name of the particle image that should be shown
		 *	@PARAM		px			Number		x position of the particle
		 *	@PARAM		py			Number		y position of the particle
		 *	@PARAM		pxvel		Number		initial x velocity
		 *	@PARAM		pyvel		Number 		initial y velocity
		 *	@PARAM		pxg			Number		x gravity (force)
		 *	@PARAM		pyg			Number		y gravity (force)
		 *	@PARAM		pFric		Number		friction
		 **/
		public static function smoke(pArray:Array, pHolder:Sprite, pImageName:String, px:Number, py:Number, pxvel:Number = 5, pyvel:Number = 8, pxg:Number = 2, pyg:Number = -2, pfric:Number = .05, pDecay = .03):void
		{
			for (var i:int = 0; i < pArray.length; i++)
			{
				var xvel:Number = (Math.random() - .5) * pxvel
				var yvel:Number = (Math.random()  - 1) * pyvel
				
				var xgravity:Number = Math.random()* pxg
				var ygravity:Number = Math.random()* pyg
				
				pArray[i].init(pHolder, pImageName, new Point (px,py), new Point(xvel, yvel), new Point (xgravity, ygravity), pfric, pDecay, 10);
			}
		}
		
		
		/**
		 *	Create smoke movement
		 *	@PARAM		pArray		Array		Array of praticles
		 *	@PARAM		pHolder		Sprite		Where particles should appear
		 *	@PARAM		pImageName	String		Name of the particle image that should be shown
		 *	@PARAM		px			Number		x position of the particle
		 *	@PARAM		py			Number		y position of the particle
		 *	@PARAM		pxvel		Number		initial x velocity
		 *	@PARAM		pyvel		Number 		initial y velocity
		 *	@PARAM		pxg			Number		x gravity (force)
		 *	@PARAM		pyg			Number		y gravity (force)
		 *	@PARAM		pFric		Number		friction
		 **/
		public static function smoke2(pArray:Array, pHolder:Sprite, pImageName:String, px:Number, py:Number, pxvel:Number = 5, pyvel:Number = 8, pxg:Number = 2, pyg:Number = -2, pfric:Number = .05, pDecay = .03):void
		{
			for (var i:int = 0; i < pArray.length; i++)
			{
				var xvel:Number =  pxvel
				var yvel:Number =  pyvel
				
				var xgravity:Number = pxg
				var ygravity:Number = pyg
				
				pArray[i].init(pHolder, pImageName, new Point (px,py), new Point(xvel, yvel), new Point (xgravity, ygravity), pfric, pDecay, 10);
			}
		}
		
		
		/**
		 *	Create circular sprad movement with downward gravity acting on it
		 *	@PARAM		pArray		Array		Array of praticles
		 *	@PARAM		pHolder		Sprite		Where particles should appear
		 *	@PARAM		pImageName	String		Name of the particle image that should be shown
		 *	@PARAM		px			Number		x position of the particle
		 *	@PARAM		py			Number		y position of the particle
		 *	@PARAM		pRad		Number		Radius force, higher number = bigger circle	 
		 **/
		public static function fireworks(pArray:Array, pHolder:Sprite, pImageName:String, px:Number, py:Number, pRad:int = 15, pGravX:Number = 0, pGravY:Number = 1, decay:Number = 0.01 ):void
		{
			var inc:Number = Math.PI * 2 / pArray.length
			for (var i:int = 0; i < pArray.length; i++)
			{
				var xPos:Number = Math.cos(inc * i) + px
				var yPos:Number = Math.sin(inc * i) + py
				
				var xvel:Number = Math.cos(inc * i) * pRad
				var yvel:Number = Math.sin(inc * i) * pRad
				
				var xgravity:Number = pGravX
				var ygravity:Number = pGravY
				
				pArray[i].init(pHolder, pImageName, new Point (px,py), new Point(xvel, yvel), new Point (xgravity, ygravity), 0.12, decay, 15);
			}
			
		}
		
		/**
		 *	Create slow falling particle
		 *
		 *	@NOTE:		Please note that you should call this funtion every frame or on timer
		 *				for that reason I recommend that you only create 1 ot 2 particle each time
		 *				For px, you should pick a random point everr time i.e. "Math.random() * stagewidth"
		 *
		 *	@PARAM		pArray		Array		Array of praticles
		 *	@PARAM		pHolder		Sprite		Where particles should appear
		 *	@PARAM		pImageName	String		Name of the particle image that should be shown
		 *	@PARAM		px			Number		x position of the particle ***Make it random pts of x width
		 *	@PARAM		py			Number		y position of the particle
		 **/
		public static function snow(pArray:Array, pHolder:Sprite, pImageName:String, px:Number= 0 , py:Number = 0):void
		{
			for (var i:int = 0; i < pArray.length; i++)
			{
				var xPos:Number =  px
				var yPos:Number =  py
				
				var xvel:Number = Math.random() * 1
				var yvel:Number = Math.ceil(Math.random() * 2) + 1
				
				var xgravity:Number = (Math.random() -.5)
				var ygravity:Number = Math.random() + 1
				
				pArray[i].init(pHolder, pImageName, new Point (xPos, yPos), new Point(xvel, yvel), new Point (xgravity, ygravity), 0.03, 0.01, 55);
			}
		}
		
		
		/**
		 *	Create faster falling particle
		 *
		 *	@NOTE:		Please note that you should call this funtion every frame or on timer
		 *				for that reason I recommend that you only create 1 ot 2 particle each time
		 *				For px, you should pick a random point everr time i.e. "Math.random() * stagewidth"
		 *
		 *	@PARAM		pArray		Array		Array of praticles
		 *	@PARAM		pHolder		Sprite		Where particles should appear
		 *	@PARAM		pImageName	String		Name of the particle image that should be shown
		 *	@PARAM		px			Number		x position of the particle ***Make it random pts of x width
		 *	@PARAM		py			Number		y position of the particle
		 **/
		public static function rain(pArray:Array, pHolder:Sprite, pImageName:String, px:Number= 0 , py:Number = 0, pxg:Number = 1, pyg:Number = 0):void
		{
			for (var i:int = 0; i < pArray.length; i++)
			{
				var xPos:Number =  px
				var yPos:Number =  py
				
				var xvel:Number = Math.random() * 1
				var yvel:Number = Math.ceil(Math.random() * 3) + 8
				
				var xgravity:Number = pxg
				var ygravity:Number = pyg
				
				pArray[i].init(pHolder, pImageName, new Point (xPos, yPos), new Point(xvel, yvel), new Point (xgravity, ygravity), 0, 0.01, 30);
			}			
		}
		
		
		/**
		 *	Create genric moving particle(s)
		 *
		 *	@PARAM		pArray		Array		Array of praticles
		 *	@PARAM		pHolder		Sprite		Where particles should appear
		 *	@PARAM		pImageName	String		Name of the particle image that should be shown
		 *	@PARAM		px			Number		x position of the particle ***Make it random pts of x width
		 *	@PARAM		py			Number		y position of the particle
		 *	@PARAM		pxvel		Number		initial x velocity
		 *	@PARAM		pyvel		Number 		initial y velocity
		 *	@PARAM		pxg			Number		x gravity (force)
		 *	@PARAM		pyg			Number		y gravity (force)
		 *	@PARAM		pFric		Number		friction
		 *	@PARAM		decay		Number		rate the particle should decay: lower number = longer life
		 *	@PARAM		delay		Number		mesurement of unit delay before decay starts
		 **/
		public static function stream(pArray:Array, pHolder:Sprite, pImageName:String, px:Number= 0 , py:Number = 0, xvel = 1, yvel:Number = 1, xgrav:Number = 1, ygrav:Number = 0, fric:Number = 0, decay:Number = 0.1, delay:Number = 5):void
		{
			for (var i:int = 0; i < pArray.length; i++)
			{
				pArray[i].init(pHolder, pImageName, new Point (px, py), new Point(xvel, yvel), new Point (xgrav, ygrav), fric, decay, delay);
			}			
		}
		
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
	}
	
}