
/* AS3
	Copyright 2008
*/
package com.neopets.util.tranistion
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import caurina.transitions.Tweener;

	/**
	 *	This is a Class to Make a Transition between two different DisplayObjects
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern None
	 * 
	 *	@author Clive Henrick
	 *	@since  12.29.2008
	 */
	public class TransitionObject extends EventDispatcher 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const FADE_DOWN:String = "FadeTheObject";
		public static const FADE_UP:String = "FadeUpTheObject";
		public static const XFADE:String = "XFadeTheObjects";
		public static const MOVEMENT:String = "MoveTransition";
		 
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
	
		public function TransitionObject(target:IEventDispatcher=null){}
		

		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/** 
		 * This is for 2 Objects for a Transition
		 * @param		pDisplayObject1				Object								The Holder for the First Item
		 * @param		pDisplayObject1.ITEM		displaycontainer					The First Item
		 * @param		pDisplayObject1.TIME		time								The First Item transition time
		 * @param		pDisplayObject1.FUNCTION	Class				optional		a function to be called by the item when complete
		 * @param		pDisplayObject1.PARMATERS	array				optional		paramters to be passed to the function
		 * @param		pDisplayObject1.STARTLOC	point				optional		Start Location
		 * @param		pDisplayObject1.ENDLOC		point				optional		End Location
		 * @param		pDisplayObject2				Object								The Holder for the Second Item
		 * @param		pDisplayObject2.ITEM		displaycontainer					The First Item
		 * @param		pDisplayObject2.TIME		time								The First Item transition time
		 * @param		pDisplayObject2.FUNCTION	Class				optional		a function to be called by the item when complete
		 * @param		pDisplayObject2.PARMATERS	array				optional		paramters to be passed to the function
		 * @param		pDisplayObject2.STARTLOC	point				optional		Start Location
		 * @param		pDisplayObject2.ENDLOC		point				optional		End Location
		 * */
		
		public static function startTransition(pType:String,pDisplayObject1:Object,pDisplayObject2:Object = null):void
		{
			switch (pType)
			{
				case XFADE:
					pDisplayObject1.ITEM.alpha = 0;
					
					Tweener.addTween(
						pDisplayObject1.ITEM,
						{
							time: pDisplayObject1.TIME,
							alpha:1,
							onComplete:pDisplayObject1.FUNCTION,
							onCompleteParams:pDisplayObject1.PARAMTERS
						}
					);
					
					if (pDisplayObject2 != null)
					{
						pDisplayObject2.ITEM.alpha = 1;
					
						Tweener.addTween(
							pDisplayObject2.ITEM,
							{
								time: pDisplayObject2.TIME,
								alpha:0,
								onComplete:pDisplayObject2.FUNCTION,
								onCompleteParams:pDisplayObject2.PARAMTERS
							}
						);	
					}
				break;
				case FADE_DOWN:
					
					Tweener.addTween(
						pDisplayObject1.ITEM,
						{
							time: pDisplayObject1.TIME,
							alpha:0,
							onComplete:pDisplayObject1.FUNCTION,
							onCompleteParams:pDisplayObject1.PARAMTERS
						}
					);
					
				break;
				case FADE_UP:
					pDisplayObject1.ITEM.alpha = 0;
					Tweener.addTween(
						pDisplayObject1.ITEM,
						{
							time: pDisplayObject1.TIME,
							alpha:1,
							onComplete:pDisplayObject1.FUNCTION,
							onCompleteParams:pDisplayObject1.PARAMTERS
						}
					);
					
				break;
				case MOVEMENT:
					pDisplayObject1.ITEM.x = pDisplayObject1.STARTLOC.x;
					pDisplayObject1.ITEM.y = pDisplayObject1.STARTLOC.y;
					
					Tweener.addTween(
						pDisplayObject1.ITEM,
						{
							transition:"easeNone",
							time: pDisplayObject1.TIME,
							x:pDisplayObject1.ENDLOC.x,
							y:pDisplayObject1.ENDLOC.y,
							onComplete:pDisplayObject1.FUNCTION,
							onCompleteParams:pDisplayObject1.PARAMTERS
						}
					);
					
					if (pDisplayObject2 != null)
					{
						pDisplayObject2.ITEM.x = pDisplayObject2.STARTLOC.x;
						pDisplayObject2.ITEM.y = pDisplayObject2.STARTLOC.y;
					
						Tweener.addTween(
							pDisplayObject2.ITEM,
							{
								transition:"easeNone",
								time: pDisplayObject2.TIME,
								x:pDisplayObject2.ENDLOC.x,
								y:pDisplayObject2.ENDLOC.y,
								onComplete:pDisplayObject2.FUNCTION,
								onCompleteParams:pDisplayObject2.PARAMTERS
							}
						);	
					}
				break;
			}	
		}
		
	}
	
}
