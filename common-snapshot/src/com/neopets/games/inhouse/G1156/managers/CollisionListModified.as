package com.neopets.games.inhouse.G1156.managers
{
	import com.coreyoneil.collision.CDK;
	import com.coreyoneil.collision.CollisionList;
	
	import flash.display.DisplayObject;
	
	public class CollisionListModified extends CDK
	{
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function CollisionListModified(target, ... objs)
		{
			
			addItem(target);
			
			var tCount:int =  objs.length;
			
			for(var i:int = 0; i < tCount; i++)
			{
				if (objs[i] is Array)
				{
					var tArray:Array =  objs[i];
					var tArrayCount:int =tArray.length;	
					
					for (var z:int = 0; z < tArrayCount; z++)
					{
						addItem(tArray[z]);
					}
				}
				else
				{
					addItem(objs[i]);	
				}
				
			}
		}
		
			public function checkCollisions():Array
		{
			clearArrays();
			
			var NUM_OBJS:uint = objectArray.length;
			var item1 = DisplayObject(objectArray[0]), item2:DisplayObject;
			for(var i:uint = 1; i < NUM_OBJS; i++)
			{
				item2 = DisplayObject(objectArray[i]);
					
				if(item1.hitTestObject(item2))
				{
					if((item2.width * item2.height) > (item1.width * item1.height))
					{
						objectCheckArray.push([item1,item2])
					}
					else
					{
						objectCheckArray.push([item2,item1]);
					}
				}
			}
			
			NUM_OBJS = objectCheckArray.length;
			for(i = 0; i < NUM_OBJS; i++)
			{
				findCollisions(DisplayObject(objectCheckArray[i][0]), DisplayObject(objectCheckArray[i][1]));
			}
			
			return objectCollisionArray;
		}
		
		public function swapTarget(target):void
		{
			if(target is DisplayObject)
			{
				objectArray[0] = target;
			}
			else
			{
				throw new Error("Cannot swap target: " + target + " - item must be a Display Object.");
			}
		}
		
		public override function removeItem(obj):void 
		{
			var loc:int = objectArray.indexOf(obj);
			if(loc > 0)
			{
				objectArray.splice(loc, 1);
			}
			else if(loc == 0)
			{
				throw new Error("You cannot remove the target from CollisionList.  Use swapTarget to change the target.");
			}
			else
			{
				throw new Error(obj + " could not be removed - object not found in item list.");
			}
		}
		
	}
}