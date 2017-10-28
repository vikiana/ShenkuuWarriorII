
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

package  com.neopets.games.inhouse.G1156.gui
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import com.neopets.projects.effects.particle.ParticleFormation;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------

	
	
	public class ExtendedParticleFormation extends ParticleFormation
	{

		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		
		public function ExtendedParticleFormation():void{}
		
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		/**
		 *	Create circular sprad movement with downward gravity acting on it
		 *	@PARAM		pArray		Array		Array of praticles
		 *	@PARAM		pHolder		Sprite		Where particles should appear
		 *	@PARAM		pImageName	String		Name of the particle image that should be shown
		 *	@PARAM		px			Number		x position of the particle
		 *	@PARAM		py			Number		y position of the particle
		 *	@PARAM		pRad		Number		Radius force, higher number = bigger circle	 
		 **/
		public static function RockBurst(pArray:Array, pHolder:Sprite, pImageName:String, px:Number, py:Number, pRad:int = 15, pGravX:Number = 0, pGravY:Number = 1,decay:Number = 0.1, delay:Number = 5 ):void
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
				
				pArray[i].init(pHolder, pImageName, new Point (px,py), new Point(xvel, yvel), new Point (xgravity, ygravity), 0.12,decay, delay);
			}
			
		}
		
	}
	
}