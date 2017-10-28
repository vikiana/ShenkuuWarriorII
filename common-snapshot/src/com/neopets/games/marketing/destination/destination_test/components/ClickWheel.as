/**
 *	Littlest Pet Shop Destination Part: Click wheel
 *	Click wheel items will simply spin around based on what is clicked
 *	All this does is when the wheel (carousel) cart is clicked, 
 *	it turns the carousel and sorts the depth of the items for visual consistancy
 * 
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  01.2010
 */

package com.neopets.games.marketing.destination.destination_test.components
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------

	
	
	public class ClickWheel extends MovieClip
	
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		public var snowCart:MovieClip; //on the stage
		public var farmCart:MovieClip; //on the stage
		public var jungleCart:MovieClip; //on the stage
		
		protected var wheelCenter:Point = new Point (460, 270); //certer pivot point
		protected var cartArray:Array; //array of carts
		protected var depthArray:Array; //array to keep track of depth
		protected var timeInc:Number = 0; //total amount for turning wheels
		protected var incAmnt:Number = 0; //how much to move per frame
		protected var setAngle:Number = 0; //the angle it should be set to..

		
		protected var xFactor:Number = 180; //carousel cos x distance
		protected var yFactor:Number = 30;	// carousel sin y distance
		
		protected var bMoving:Boolean = false;	// if carousel is moving
		protected var targetCart:MovieClip; //clicked cart that's suppose to be shown in the middle
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function ClickWheel(): void
		{
			setup();
			setupCircle();
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		
		//----------------------------------------
		//	PROTECTED & PRIVATE METHODS
		//----------------------------------------
		
		/**
		 *	@NOTE: run initial setup
		 **/
		protected function setup():void
		{
			snowCart.stop();
			farmCart.stop();
			jungleCart.stop();
			cartArray = [snowCart, jungleCart, farmCart];
			depthArray = [snowCart, jungleCart, farmCart];
			snowCart.addEventListener(MouseEvent.MOUSE_DOWN, onCartClicked);
			farmCart.addEventListener(MouseEvent.MOUSE_DOWN, onCartClicked);
			jungleCart.addEventListener(MouseEvent.MOUSE_DOWN, onCartClicked);
			
			snowCart.buttonMode = true;
			farmCart.buttonMode = true;
			jungleCart.buttonMode = true;
			
			addEventListener(Event.ENTER_FRAME, turnWheel)
			
			targetCart = snowCart;
		}
		
		/**
		 *	@NOTE: arrange 3 carts in circle formation
		 **/
		protected function setupCircle():void
		{
			var inc:Number = Math.PI * 2 /cartArray.length;
			for (var i:Number = 0; i < cartArray.length; i ++)
			{
				var cart:MovieClip = cartArray[i];
				cart.x = Math.cos(inc * i - Math.PI/2) * xFactor + wheelCenter.x;
				cart.y = Math.sin(inc * i - Math.PI/2) * yFactor + wheelCenter.y;
			}
		}
		
		/**
		 *	@NOTE this is just set the filter on the carts
		 **/
		public function setFilter(pMC:MovieClip, pFilters:Array):void
		{
			pMC.filters = pFilters;
		}
		
		/**
		 * @NOTE: This is not necessary but for consistancy sake....
		 **/
		public function removeFilter(pMC:MovieClip):void
		{
			pMC.filters = null
		}
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		/**
		 *	@NOTE: 	There should have been better way to handle this but 
		 *			due to time constraint I went for quick fix...
		 *			Basically whatever cart gets clicked, the angle and the position is calculated from 
		 *			the carousel center point.  It decides how much needs to be moved (interms of angle) 
		 *			Then based on its position the carousel is moved to right or left in increments.
		 *			When the clicked obj is moved desired amount (or when it's near enough)
		 *			the carousel is stopped and locked in desired position.
		 **/
		protected function onCartClicked(evt:MouseEvent):void
		{
			var travelRad:Number;  //radiant angle it the clicked object need to travel to be at the center
			var travelAng:Number; //converted travel radiant angle to degrees
			var factor:Number; // basically decides if carousel should should move right or left (-1 or 1)
			
			//when clicked item is not already at the cener
			if (!bMoving && targetCart != MovieClip(evt.currentTarget)) 
			{
				bMoving = true
				targetCart = MovieClip(evt.currentTarget);
				var rad = Math.atan2((targetCart.y- wheelCenter.y)* xFactor, (targetCart.x - wheelCenter.x)* yFactor);
				var ang = rad * 180 /Math.PI;
				
				//cut into 4 coordinates
				if (targetCart.x < wheelCenter.x && targetCart.y < wheelCenter.y)
				{
					travelRad = rad + Math.PI/2;
					travelAng = travelRad * 180 /Math.PI; 
					factor = 1;
				}
				else if (targetCart.x < wheelCenter.x  && targetCart.y > wheelCenter.y)
				{
					travelRad = Math.PI - rad + Math.PI/2
					travelAng = travelRad * 180 /Math.PI;
					factor = 1;
				}
				
				else if (targetCart.x >= wheelCenter.x  && targetCart.y <= wheelCenter.y)
				{
					travelRad = Math.PI/2 + rad;
					travelAng = travelRad * 180 /Math.PI; 
					factor = -1;
				}
				else if (targetCart.x > wheelCenter.x  && targetCart.y > wheelCenter.y)
				{
					travelRad = Math.PI/2 + rad;
					travelAng = travelRad * 180 /Math.PI; 
					factor = -1;
				}
				incAmnt = .1 * factor
				setAngle = timeInc + travelRad * factor;

			}
			// account for when center piece is clicked, by marketing request, act as though the item one from left is clicked (just make it turn to right
			else if (!bMoving && targetCart == MovieClip(evt.currentTarget))
			{
				bMoving = true
				var rad2 = Math.atan2((targetCart.y- wheelCenter.y)* xFactor, (targetCart.x - wheelCenter.x)* yFactor);
				var ang2 = rad2 * 180 /Math.PI;
				if (Math.round(90 + ang2) == 0)
				{
					// super quick fix heck switch statement
					switch (targetCart)
					{
						case snowCart:
							targetCart = farmCart
							break;
						case farmCart:
							targetCart = jungleCart
							break;
						case jungleCart:
							targetCart = snowCart
							break;
					}
				}
				var rad3 = Math.atan2((targetCart.y- wheelCenter.y)* xFactor, (targetCart.x - wheelCenter.x)* yFactor);
				travelRad = Math.PI - rad3 + Math.PI/2
				travelAng = travelRad * 180 /Math.PI;

				incAmnt = .1 
				setAngle = timeInc + travelRad ;
				
			}
			
		}
		
		
		/**
		 *	@NOTE:	Turning the wheel is constantly running on the ground.
		 *			If the selected obj's current angle is same as the angle it needs to be (at the center)
		 *			Then the no turning will happen.  Otherwise, the carousel will turn right or to left
		 *			by designated increment amount
		 **/
		protected function turnWheel(evt:Event):void
		{
			timeInc += incAmnt;
			var inc:Number = Math.PI * 2 /cartArray.length;
			if (Math.abs((Math.abs(setAngle) - Math.abs(timeInc))) < .12)
			{
				timeInc = setAngle;
				bMoving = false;
			}
			for (var i:Number = 0; i < cartArray.length; i ++)
			{
				var cart:MovieClip = cartArray[i];
				cart.x = Math.cos(inc * i - Math.PI/2 + timeInc) * xFactor + wheelCenter.x;
				cart.y = Math.sin(inc * i - Math.PI/2 + timeInc) * yFactor + wheelCenter.y;
				var numericValue:Number =  ((wheelCenter.y - cart.y + yFactor)/(yFactor * 2));
				cart.scaleX = cart.scaleY = numericValue * .6 + .4;
				if (cart.clueText != null) cart.clueText.alpha = numericValue;
				sortDepth()
			}
		}
		
		
		/**
		 *	@NOTE:	As the carousel turns it short the dept of the displayed carts
		 *			It basiecally gets an array of carts in the order of depth it should be in
		 *			Then it resets the depth of each item in the array
		 **/
		protected function sortDepth():void
		{
			var tempArray:Array = sortArray ([], depthArray);
			depthArray = tempArray;
			for (var i:int = 0 ; i < tempArray.length ; i++)
			{
				var item:MovieClip = tempArray[i];
				setChildIndex(item, i);
			}
		}
		
		/**
		 *	@NOTE:	Recursive function.  
		 *			It takes an target array and the item needs to be place in.  
		 *			Item is taken from the source array and  placed in the target array.
		 *			Based on it's criteria (in this case, item's order is decided based on its y position) 
		 *			the item takes its placement in the target array accordingly
		 *
		 *	@PARAM		targetArray 	Array		array that item needs to be place in
		 *	@PARAM		sourceArray		Array		array that contains items to be sorted
		 **/
		protected function sortArray(targetArray:Array, sourceArray:Array):Array
		{
			if (sourceArray.length <= 0)
			{
				return targetArray;
			}
			else
			{
				var tempArray:Array = placeItemInArray(targetArray, sourceArray.pop());
				return sortArray (tempArray, sourceArray);
			}
			
		}
		
		
		/**
		 *	@NOTE:	It takes item and the array.  The item is placed in the given array.
		 *			The placement is determined based on its y position.  For carousel to work
		 *			The item with lowest y position should be place at the top level 
		 *			(or at the end of the array)
		 *
		 *	@PARAM		targetArray 	Array		array that item needs to be place in
		 *	@PARAM		item			MovieClip	Cart MC in the carousel
		 **/
		protected function placeItemInArray (targetArray:Array, item:MovieClip):Array
		{
			if (targetArray.length <= 0)
			{
				targetArray.push(item);
				return targetArray;
			}
			else
			{
				var tempArray = [];
				while (targetArray.length > 0)
				{
					var compareItem:MovieClip = targetArray.shift();
					if (compareItem.y < item.y)
					{
						tempArray.push(item);
						tempArray.push(compareItem);
						if (targetArray.length > 0) tempArray = tempArray.concat(targetArray);
						break;
					}
					else
					{
						tempArray.push(compareItem);
						if (targetArray.length <= 0) 
						{
							tempArray.push(item);
							break;
						}
					}
				}
				return tempArray;
			}
		}
	}
	
}