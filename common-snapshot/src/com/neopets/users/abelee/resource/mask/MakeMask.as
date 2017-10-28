

//Generic setup of classes
/***
========================================
DEVELOPER'S NOTE
========================================

@author Abraham Lee
@since  01.23.2009

----------------------------------------

Description 1
Decription Continued

###### NOTE ######

Important instruction

@langversion ActionScript 3.0
@playerversion Flash 9.0
@Pattern MVC 

----------------------------------------

AS3
Copyright 2008

========================================		***/

package com.neopets.users.abelee.resource.mask
{
	/***
	========================================
	CUSTOM IMPORTS
	========================================***/
	
	/***
	========================================
	FLASH IMPORTS
	========================================***/
	import flash.display.Sprite;
	import flash.display.DisplayObject;

	 
	public class MakeMask extends Sprite
	{
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		private var mObjPlace:Object;
		private var mMasked:DisplayObject;
		private var mMask:Sprite
					
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function MakeMask(pPlace:Object, toMask:DisplayObject, width:Number, height:Number):void
		{
			mObjPlace = pPlace;
			mMasked = toMask;
			
			mMask  = new Sprite();
			mMask.graphics.beginFill(0x00);
			mMask.graphics.drawRect(0, 0, width, height)
			mMask.graphics.endFill()
			
			pPlace.addChild (this)
			toMask.mask = mMask
			//addChild(mMask)
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		 
		 //--------------------------------------
		//  PUBLIC INSTANCE METHODS
		//--------------------------------------
		 //--------------------------------------
		//  PRIVATE INSTANCE METHODS
		//--------------------------------------
					
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------

	}
}