

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
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	 
	public class EasyMask extends Sprite
	{
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		//private var mMasked:DisplayObject;
		//private var mMask:Sprite
					
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function EasyMask(maskLocation:Object, toMask:DisplayObject, px:Number, py:Number, width:Number, height:Number):void
		{
			//mObjPlace = pPlace;
			//mMasked = toMask;			
			
			graphics.beginFill(0x00);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
			x = px;
			y = py;
			
			//pPlace.addChild (this);
			maskLocation.addChild(this)
			toMask.mask = this;
		}
		
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		 
		//--------------------------------------
		//  PUBLIC INSTANCE METHODS
		//--------------------------------------
		public function maskOut():void
		{
			this.visible = false
		}
		
		
		//--------------------------------------
		//  PRIVATE INSTANCE METHODS
		//--------------------------------------
					
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------

	}
}