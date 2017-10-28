package virtualworlds.com.smerc.uicomponents.containers.scrollMenus
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import virtualworlds.com.smerc.uicomponents.buttons.Events.ButtonEvent;
	import virtualworlds.com.smerc.uicomponents.buttons.ISmercButton;

	
	/**
	* ...
	* @author Bo
	*/
	public class SeperatorScrollMenu extends Sprite implements IScrollMenu
	{
		protected var _spacerClass:Class;
		
		protected var _scrollMenu:ScrollMenu;
		
		public function SeperatorScrollMenu(a_mc:MovieClip, a_spacerClass:Class, defaultSpacing:Number = 0, 
											a_bTweenContainerMovement:Boolean = true, 
											a_bAddContents:Boolean = true)
		{
			_scrollMenu = new ScrollMenu(a_mc, defaultSpacing, a_bTweenContainerMovement, a_bAddContents);
			
			_spacerClass = a_spacerClass;
			
			if (a_bAddContents)
			{
				this.addChild(_scrollMenu);
			}
			
		}//end SeperatorScrollMenu()
		
		/**
		 * Acquire the guts of the ScrollMenu.  It's what we're made of!
		 */
		public function get entireMenuContents():MovieClip
		{
			return _scrollMenu.entireMenuContents;
		}//end get entireMenuContents()
		
		public function addItemToMenu(a_obj:DisplayObject):DisplayObject
		{
			
			
			var lastItemIsSpacer:Boolean = Boolean(_scrollMenu.numberOfItems && ((_scrollMenu.getMenuItemAt(_scrollMenu.numberOfItems - 1)) is _spacerClass));
			
			if (!lastItemIsSpacer && _scrollMenu.numberOfItems)
			{
				_scrollMenu.addItemToMenu(new _spacerClass());
			}
			
			return _scrollMenu.addItemToMenu(a_obj);
			
		}//end addItemToMenu()
		
		public function addItemAt(a_do:DisplayObject, a_index:int):DisplayObject
		{
			
			
			var preIndex:int = a_index - 1;
			
			var itemBeforeIndexToAdd:DisplayObject;
			
			if ( (preIndex >= 0) && (preIndex < _scrollMenu.numberOfItems) )
			{
				itemBeforeIndexToAdd = _scrollMenu.getMenuItemAt(preIndex);
				if ( !(itemBeforeIndexToAdd is _spacerClass) )
				{
					// The item before where we're trying to add is NOT a spacer, so, add a spacer.
					_scrollMenu.addItemAt(new _spacerClass(), a_index);
					
					// And add our item after where it was intended to go.
					a_index++;
				}
			}
			
			var itemToReturn:DisplayObject = _scrollMenu.addItemAt(a_do , a_index);
			
			// Check if the item at the postIndex is a spacer, if not, add it.
			var postIndex:int = a_index + 1;
			var itemAtPostIndex:DisplayObject;
			if(postIndex >= 0 && postIndex < _scrollMenu.numberOfItems)
			{
				itemAtPostIndex = _scrollMenu.getMenuItemAt(postIndex);
				if (!(itemAtPostIndex is _spacerClass))
				{
					_scrollMenu.addItemAt(new _spacerClass(), postIndex);
				}
			}
			
			return itemToReturn;
			
		}//end addItemAt()
		
		public function removeMenuItem(a_do :DisplayObject, a_bDestroyItemsRemoved:Boolean = false):int
		{
			
			
			var indexOfRemoved:int = _scrollMenu.removeMenuItem(a_do , a_bDestroyItemsRemoved);
			
			addSpacersBetweenNonSpacers();
			
			return indexOfRemoved;
			
		}//end removeMenuItem()
		
		public function removeMenuItemAt(a_index:Number, a_bDestroyItemsRemoved:Boolean = false):void
		{
			
			
			_scrollMenu.removeMenuItemAt(a_index, a_bDestroyItemsRemoved);
			
			addSpacersBetweenNonSpacers();
			
		}//end removeMenuItemAt()
		
		protected function addSpacersBetweenNonSpacers(...args):void
		{
			var firstImg:DisplayObject;
			var secondImg:DisplayObject;
			
			var recurse:Boolean = false;
			
			for (var i:int = 0; ((i + 1) < _scrollMenu.numberOfItems); i++)
			{
				firstImg = _scrollMenu.getMenuItemAt(i);
				secondImg = _scrollMenu.getMenuItemAt(i + 1);
				
				if (!(firstImg is _spacerClass) && !(secondImg is _spacerClass))
				{
					recurse = true;
					_scrollMenu.addItemAt(new _spacerClass(), (i + 1));
					break;
				}
				if ((firstImg is _spacerClass) && (secondImg is _spacerClass))
				{
					recurse = true;
					_scrollMenu.removeMenuItemAt(i);
					break;
				}
			}
			
			if (recurse)
			{
				this.addSpacersBetweenNonSpacers();
			}
			
		}//end addSpacersBetweenNonSpacers()
		
		public function set buttonsHeldDownInterval(a_int:int):void
		{
			_scrollMenu.buttonsHeldDownInterval = a_int;
		}
		
		public function destroy(...args):void
		{
			_scrollMenu.destroy();
			_spacerClass = null;
		}
		
		public function set spacing(newSpacing:Number):void
		{
			_scrollMenu.spacing = newSpacing;
		}
		
		public function get spacing():Number
		{
			return _scrollMenu.spacing;
		}
		
		public function set movementTweenTime(a_time:Number):void
		{
			_scrollMenu.movementTweenTime = a_time;
		}
		
		public function setSpeed(a_number:Number):void
		{
			_scrollMenu.setSpeed(a_number);
		}
		
		public function getMenuItemAt(a_index:uint):DisplayObject
		{
			return _scrollMenu.getMenuItemAt(a_index);
		}
		
		public function indexOfMenuItem(a_do :DisplayObject):int
		{
			return _scrollMenu.indexOfMenuItem(a_do );
		}
		
		public function hasMenuItem(a_do :DisplayObject):Boolean
		{
			return _scrollMenu.hasMenuItem(a_do );
		}
		
		public function get numberOfItems():int
		{
			return _scrollMenu.numberOfItems;
		}
		
		public function clearMenu(a_bDestroyItemsRemoved:Boolean = false):void
		{
			_scrollMenu.clearMenu(a_bDestroyItemsRemoved);
		}
		
		public function removeLastMenuItem(a_bDestroyItemRemoved:Boolean = false):void
		{
			_scrollMenu.removeLastMenuItem(a_bDestroyItemRemoved);
		}
		
		public function pause(a_bool:Boolean):void
		{
			_scrollMenu.pause(a_bool);
		}
		
		public function onScroll1Press(...args):void
		{
			var a_buttonEvt:ButtonEvent = ((args && args.length) ? args[0] as ButtonEvent : null);
			_scrollMenu.onScroll1Press(a_buttonEvt);
		}
		
		public function onScroll2Press(...args):void
		{
			var a_buttonEvt:ButtonEvent = ((args && args.length) ? args[0] as ButtonEvent : null);
			_scrollMenu.onScroll2Press(a_buttonEvt);
		}
		
		public function get scrollButton1():ISmercButton
		{
			return _scrollMenu.scrollButton1;
		}
		
		public function get scrollButton2():ISmercButton
		{
			return _scrollMenu.scrollButton2;
		}
		
		public function set tweenContainerMovement(a_bool:Boolean):void
		{
			_scrollMenu.tweenContainerMovement = a_bool;
		}
		
	}//end class SeperatorScrollMenu
	
}//end package com.smerc.uicomponents.Containers.ScrollMenus
