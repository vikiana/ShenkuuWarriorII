/**
 *	LM: level methods
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  aug.2009
 */

package com.neopets.games.inhouse.shenkuuSideScroller.levelInfo
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import com.neopets.games.inhouse.shenkuuSideScroller.dataObj.GameData;
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------

	
	
	public class LM
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------

		
		public static var mHelperGroupPair:Array = [
													["Helper_Score", "SCORE"],	//0 
													["Helper_Heal", "HEAL"] ,	//1
													["Helper_Double", "DOUBLE"],//2
													["Helper_Invincible", "INVINCIBLE"],//3
													["Helper_Kill", "KILL"],	//4
													["Helper_Morph", "MORPH"],	//5
													["Helper_SpeedDown", "SPEED_DOWN"]//6
													//["Helper_SpeedUp", "SPEED_UP"],//7
													
													]

		
		public static var speed:Number = -GameData.movingSpeed
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function LM():void
		{			
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		
		/**
		 *	creates enemies/helpers in line formation, vertical, horizontal or diagonal
		 *	@PARAM		pArray		Array 			contains array of enemies and items for a level
		 *	@PARAM		dist		Number			Position it's should appear in
		 *	@PARAM		quantity	int				number of Characters to show this formation
		 *	@PARAM		type		String			Type of the Character
		 *	@PARAM		mc			String			class name of the movie clip image for this Character
		 *	@PARAM		px			Number			starting x position
		 *	@PARAM		py			Number			Starting y position
		 *	@PARAM		pbx			Number			x buffer distance for next Character
		 *	@PARAM		pby			Number			y buffer distance for next Character
		 *	@PARAM		pvx			Number			x velocity of the Character
		 *	@PARAM		pvy			Number			y velocity of the Character
		 *	@PARAM		behavior	String			behavior of this Character
		 **/
		public static function lineCreator( dist:Number, pArray:Array, quantity:int, type:String, mc:String, px:Number, py:Number, pbx:Number, pby:Number, pvx:Number, pvy, behavior:String):void
		{
			for (var i:int = 0; i < quantity; i++)
			{
				pArray.push([dist, type, mc, px + pbx * i, py + pby * i, pvx, pvy, 0, 0, behavior])
			}
		}
		
		
		
		/**
		 *	creates helpers in line formation, vertical, horizontal or diagonal.
		 *	It randomly selects the helper from the given array
		 *	@PARAM		pArray		Array 			contains array of enemies and items for a level
		 *	@PARAM		dist		Number			Position it's should appear in
		 *	@PARAM		quantity	int				number of Characters to show this formation
		 *	@PARAM		type		String			Type of the Character
		 *	@PARAM		pairArray	Array			array of possible helpers to be selected
		 *	@PARAM		px			Number			starting x position
		 *	@PARAM		py			Number			Starting y position
		 *	@PARAM		pbx			Number			x buffer distance for next Character
		 *	@PARAM		pby			Number			y buffer distance for next Character
		 *	@PARAM		pvx			Number			x velocity of the Character
		 *	@PARAM		pvy			Number			y velocity of the Character
		 **/
		public static function lineCreatorR( dist:Number, pArray:Array, quantity:int, type:String, pairArray:Array, px:Number, py:Number, pbx:Number, pby:Number, pvx:Number, pvy:Number):void
		{
			for (var i:int = 0; i < quantity; i++)
			{
				var pair:Array = mHelperGroupPair[pairArray[Math.floor(Math.random()* pairArray.length)]]
				pArray.push([dist, type, pair[0], px + pbx * i, py + pby * i, pvx, pvy, 0, 0, pair[1]])
			}
		}
		
		
		
		/**
		 *	Randomly places enemies/objects interms of y position.
		 *	@PARAM		pArray		Array 			contains array of enemies and items for a level
		 *	@PARAM		dist		Number			Position it's should appear in
		 *	@PARAM		quantity	int				number of Characters to show this formation
		 *	@PARAM		type		String			Type of the Character
		 *	@PARAM		px			Number			starting x position
		 *	@PARAM		py			Number			Starting y position
		 *	@PARAM		pbx			Number			x buffer distance for next Character
		 *	@PARAM		pvx			Number			x velocity of the Character
		 *	@PARAM		pvy			Number			y velocity of the Character
		 *	@PARAM		behavior	String			behavior of this Character
		 **/
		public static function custCreator(dist:Number, pArray:Array, quantity:int, type:String, mc:String,  px:Number, py:int, pbx:Number, pvx:Number, pvy:Number, behavior:String):void
		{
			var yPos:Number;
			for (var i:int = 0; i < quantity; i++)
			{
				switch (py)
				{
					case 1:
						yPos = randomY();
						break;
					
					case 2:
						yPos = GameData.player.px;
						break;
				}
				pArray.push([dist, type, mc, px + pbx * i, yPos , pvx, pvy, 0, 0, behavior])
			}
		}
		
		
		/**
		 *	Randomly places helpers interms of y position.
		 *	@PARAM		pArray		Array 			contains array of enemies and items for a level
		 *	@PARAM		dist		Number			Position it's should appear in
		 *	@PARAM		quantity	int				number of Characters to show this formation
		 *	@PARAM		type		String			Type of the Character
		 *	@PARAM		px			Number			starting x position
		 *	@PARAM		py			Number			Starting y position
		 *	@PARAM		pbx			Number			x buffer distance for next Character
		 *	@PARAM		pvx			Number			x velocity of the Character
		 *	@PARAM		pvy			Number			y velocity of the Character
		 *	@PARAM		pairArray	Array			array of possible helpers to be selected
		 **/
		public static function custCreatorR(dist:Number, pArray:Array, quantity:int, type:String,pairArray:Array,  px:Number, py:int, pbx:Number, pvx:Number, pvy:Number):void
		{
			var yPos:Number;
			for (var i:int = 0; i < quantity; i++)
			{
				switch (py)
				{
					case 1:
						yPos = randomY();
						break;
					
					case 2:
						yPos = GameData.player.px;
						break;
				}
				var pair:Array = mHelperGroupPair[pairArray[Math.floor(Math.random()* pairArray.length)]]
				pArray.push([dist, type, pair[0], px + pbx * i, yPos , pvx, pvy, 0, 0, pair[1]])
			}
		}
		
		
		
		/**
		 *	creates a circle formation with given characters
		 *	All other PARAMs are same as above ones.
		 *	@PARAM		rad			Number			radius of the circle
		 **/
		public static function circCreator( dist:Number, pArray:Array, quantity:int, type:String, mc:String, px:Number, py:Number, rad:Number, pvx:Number, pvy:Number, behavior:String):void
		{
			var inc:Number = Math.PI * 2 / quantity
			for (var i:int = 0; i < quantity; i++)
			{
				var xpos:Number = Math.cos(inc * i) * rad + px
				var ypos:Number = Math.sin(inc * i) * rad + py
				pArray.push([dist, type, mc, xpos, ypos, pvx, pvy, 0, 0, behavior])
			}
		}
		
		
		/**
		 *	can create partial circle formation with given characters
		 *	All other PARAMs are same as above ones.
		 *	@PARAM		rad			Number			radius of the circle
		 *	@PARAM		max			Number			max number of characters per cirlc
		 *	@PARAM		startAng	Number			angle at where first character should show up in
		 **/
		public static function circCreator2( dist:Number, pArray:Array, quantity:int, max:int, startAng:Number, type:String, mc:String, px:Number, py:Number, rad:Number, pvx:Number, pvy:Number, behavior:String):void
		{
			var inc:Number = Math.PI * 2 / max
			for (var i:int = 0; i < quantity; i++)
			{
				var xpos:Number = Math.cos(inc * i + startAng) * rad + px
				var ypos:Number = Math.sin(inc * i + startAng) * rad + py
				pArray.push([dist, type, mc, xpos, ypos, pvx, pvy, 0, 0, behavior])
			}
		}
		
		
		/**
		 *	creates a circle formation with given characters, used for helpers
		 *	All other PARAMs are same as above ones.
		 *	@PARAM		rad			Number			radius of the circle
		 **/
		public static function circCreatorR( dist:Number, pArray:Array, quantity:int,type:String, pairArray:Array, px:Number, py:Number, rad:Number, pvx:Number, pvy:Number):void
		{
			var inc:Number = Math.PI * 2 / quantity
			for (var i:int = 0; i < quantity; i++)
			{
				var pair:Array = mHelperGroupPair[pairArray[Math.floor(Math.random()* pairArray.length)]]
				var xpos:Number = Math.cos(inc * i) * rad + px
				var ypos:Number = Math.sin(inc * i) * rad + py
				pArray.push([dist,type, pair[0], xpos, ypos, pvx, pvy, 0, 0, pair[1]])
			}
		}
		
		
		/**
		 *	creats sign or cosign wave looking formation
		 **/
		public static function curvCreator(dist:Number, pArray:Array, quantity:int, perCircle:int, stAngle:Number, type:String, mc:String, px:Number, py:Number, rad:Number, pbx:Number, pvx:Number, pvy:Number, behavior:String):void
		{
			var inc:Number = Math.PI * 2 / perCircle
			for (var i:int = 0; i < quantity; i++)
			{
				var xpos:Number = px + ( pbx * i)
				var ypos:Number = Math.sin(inc * i + stAngle) * rad + py
				pArray.push([dist, type, mc, xpos, ypos, pvx, pvy, 0, 0, behavior])
			}
		}
		
		/**
		 *	creats sign or cosign wave looking formation, for randomly picked helpers
		 **/
		public static function curvCreatorR(dist:Number, pArray:Array, quantity:int, perCircle:int, stAngle:Number, type:String, pairArray:Array, px:Number, py:Number, rad:Number, pbx:Number, pvx:Number, pvy:Number):void
		{
			var inc:Number = Math.PI * 2 / perCircle
			for (var i:int = 0; i < quantity; i++)
			{
				var xpos:Number = px + ( pbx * i)
				var ypos:Number = Math.sin(inc * i + stAngle) * rad + py
				var pair:Array = mHelperGroupPair[pairArray[Math.floor(Math.random()* pairArray.length)]]
				pArray.push([dist,type, pair[0], xpos, ypos, pvx, pvy, 0, 0, pair[1]])
			}
		}
		
		
		/**
		 *	can create partial circle formation with given characters
		 *	All other PARAMs are same as above ones.
		 *	@PARAM		rad			Number			radius of the circle
		 *	@PARAM		max			Number			max number of characters per cirlc
		 *	@PARAM		startAng	Number			angle at where first character should show up in
		 **/
		public static function archCreator(dist:Number, pArray:Array, quantity:int, perCircle:int, stAngle:Number, type:String, mc:String, px:Number, py:Number, rad:Number, pvx:Number, pvy:Number, behavior:String):void
		{
			var inc:Number = Math.PI * 2 / perCircle
			for (var i:int = 0; i < quantity; i++)
			{
				var xpos:Number = Math.cos(inc * i + stAngle) * rad + px
				var ypos:Number = Math.sin(inc * i + stAngle) * rad + py
				pArray.push([dist,type, mc, xpos, ypos, pvx, pvy, 0, 0, behavior])
			}
		}
		
		/**
		 *	randomly pick y poisiton given stage with with buffer of 50px from top and bottom
		 **/
		public static function randomY():Number
		{
			return Math.random() * (GameData.stageWidth -100) + 50
		}
		
		//----------------------------------------
		//	public METHODS
		//----------------------------------------
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
	}
	
}