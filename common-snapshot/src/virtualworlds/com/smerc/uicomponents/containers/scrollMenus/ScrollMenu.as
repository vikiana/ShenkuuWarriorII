package virtualworlds.com.smerc.uicomponents.containers.scrollMenus
{
	import caurina.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import virtualworlds.com.smerc.uicomponents.buttons.Events.ButtonEvent;
	import virtualworlds.com.smerc.uicomponents.buttons.ISmercButton;
	import virtualworlds.com.smerc.uicomponents.buttons.SmercButton;
	import virtualworlds.com.smerc.uicomponents.containers.scrollMenus.errors.MissingScrollImgError;
	import virtualworlds.com.smerc.utils.disp.DisplayObjectUtils;
	
	
	/**
	* This object allows for the visual scrolling of DisplayObjects
	* that have been added to this as menu items.
	* 
	* The file:
	* Components\trunk\uicomponents\LibraryBuilding\assets\ScrollMenuTesting.fla
	* has examples of the MovieClips that can be used to construct ScrollMenus.
	* 
	* @author Bo
	*/
	
	public class ScrollMenu extends Sprite implements IScrollMenu
	{
		/**
		 * A Horizontal Scroll Menu type.
		 */
		static public const HORZ:int = 1;
		
		/**
		 * A Vertical Scroll Menu type.
		 */
		static public const VERT:int = 2;
		
		/**
		 * Our type, horizontal or vertical.
		 */
		protected var _type:int = -1;
		
		/**
		 * Tween-shift the container, or joltingly shift it?
		 */
		protected var _bTweenContainerMovement:Boolean;
		
		/**
		 * The direction to move the target.
		 */
		protected var _direction:Number;
		
		/**
		 * The speed to move the container per ButtonEvent.SMERCBUTTON_HELD_DOWN_EVT
		 */
		protected var _speed:Number;
		
		// Array of DisplayObjects stored in the ScrollMenu
		protected var _item_ar:Array;
		
		/**
		 * Array of Attributes for the DisplayObjects inside _item_ar.
		 * These objects are instances of Objects::{scaleX:Number, scaleY:Number}
		 */
		protected var _attributes_arr:Array;
		
		/**
		 * Up or Left
		 */
		protected var scroll1:String;
		
		/**
		 * Right or Down
		 */
		protected var scroll2:String;
		
		/**
		 * X or Y axis to use for our container and measurements.
		 */
		protected var axis:String;
		
		/**
		 * X or Y, opposite of 'axis' to use for our container and measurements.
		 */
		protected var oppositeAxis:String;
		
		/**
		 * width or height, to use for our container and measurements.
		 */
		protected var measurement:String;
		
		/**
		 * width or height, opposite of 'measurement' to use for our container and measurements.
		 */
		protected var oppositeMeasurement:String;
		
		/**
		 * The mask for the items in the scroll bar.
		 */
		protected var _scrollBarMask:Sprite;
		
		/**
		 * The container for the items.
		 */
		private var _container:MovieClip;
		
		protected var _visibleMC:Sprite;
		
		/**
		 * Masked Background Layer
		 */
		protected var _background:MovieClip;
		protected var _tileClass:Class;
		
		/**
		 * I don't think this is actually used. - Bo
		 */
		protected var itemsPerScroll:Number;
		
		/**
		 * space between all items in the menu.
		 */
		private var _spacing:Number;
		
		/**
		 * The _container's original (x,y) Point.
		 */
		protected var _initialContainerPosition:Point;
		
		/**
		 * The time it takes for the moveContainer tween to move from one position to the next.
		 * The smaller this time, the faster the tweens will occur. This value is in Seconds.
		 */
		protected var _tweenMovementTime:Number = .2;
		
		/**
		 * The DisplayObjectContainer that contains all the parts of a ScrollMenu that we construct this from.
		 */
		protected var _entireMenuContents:MovieClip;
		
		/**
		 * Our up/left scroll button.
		 */
		protected var _scrollButton1:ISmercButton;
		
		/**
		 * Our bottom/right scroll button.
		 */
		protected var _scrollButton2:ISmercButton;
		
		/**
		 * Dispatched from this upon each movement of the container.
		 * 
		 * @eventType com.smerc.uicomponents.Containers.ScrollMenus.ScrollMenu.SCROLL_EVT
		 */
		public static const SCROLL_EVT:String = "ScrollMenuScrollEvent";
		
		
		/**
		 * 
		 * @param	a_mc:						MovieClip that contains all the necessary contents to construct a ScrollMenu.
		 * 										Specifically, there should be a masked empty MovieClip named 'content_mc' 
		 * 										with the same x,y position as its mask named 'scrollBarMask_mc'.
		 * 										It is also necessary that there are two MovieClips contained inside a_mc
		 * 										named ('leftScroll_mc' AND 'rightScroll_mc')
		 * 										OR ('upScroll_mc' AND 'downScroll_mc') -- BOTH of these MovieClips MUST
		 * 										contain all the necessary parts for SmercButtons.
		 * 										Optionally, a_mc may have a child labelled 'background_mc' which would
		 * 										be a container for any BitmapData tiles that one might wish to populate
		 * 										through the setBackgroundTile() function.
		 * <br />The file:
		 * <b>Components\trunk\uicomponents\LibraryBuilding\assets\ScrollMenuTesting.fla</b>
		 * <br />
		 * has examples of the MovieClips that can be used to construct ScrollMenus.
		 * <br />
		 * 
		 * @param	defaultSpacing:				The requested spacing between menu items.
		 * @param	a_bTweenContainerMovement:	Should container movement be tweened or merely shifted by the number of 
		 * 										pixels specified by the attribute 'speed'.
		 * @param	a_bAddContents:				Should the contents (a_mc) be added to this? Set to 'true' only if 
		 * 										a_mc is a new instance, and you're not worried about accidentally shifting
		 * 										a_mc's position by its being added to this new ScrollMenu. 
		 * 										If a_mc is pre-existing and you do not wish it to be re-parented, set this
		 * 										to 'false'.
		 * 
		 * @see flash.display.MovieClip
		 * @see com.smerc.uicomponents.Buttons.SmercButton
		 * @see #setBackgroundTile()
		 * @see #setSpeed()
		 */
		public function ScrollMenu(a_mc:MovieClip, defaultSpacing:Number = 0, 
									a_bTweenContainerMovement:Boolean = true, 
									a_bAddContents:Boolean = true)
		{
			_entireMenuContents = a_mc;
			
			if (!_entireMenuContents)
			{
				throw new Error("ScrollMenu::ScrollMenu(): parameter 'a_mc' is NOT a MovieClip!");
			}
			
			// Get all the pieces of this ScrollMenu from our _entireMenuContents
			extractParts(a_bAddContents);
			
			spacing = defaultSpacing;
			
			_speed = 1;
			
			_item_ar = new Array();
			
			_attributes_arr = new Array();
			
			itemsPerScroll = 1;
			
			//pause(false);
			
			_initialContainerPosition = new Point(this.container.x, this.container.y);
			
			_bTweenContainerMovement = a_bTweenContainerMovement;
			
		}//end ScrollMenu() constructor
		
		/**
		 * Acquire the guts of the ScrollMenu.  It's what we're made of!
		 */
		public function get entireMenuContents():MovieClip
		{
			return _entireMenuContents;
		}//end get entireMenuContents()
		
		/**
		 * gets/sets the reference to the mask of _container.
		 */
		protected function set scrollBarMask(a_do :DisplayObject):void
		{
			_scrollBarMask = a_do as Sprite;
		}//end set scrollBarMask()
		protected function get scrollBarMask():DisplayObject
		{
			return _scrollBarMask;
		}//end get scrollBarMask()
		
		/**
		 * get/set the reference to the masked _container to which all menu item objects are added/removed.
		 */
		protected function set container(a_container:MovieClip):void
		{
			_container = a_container;
		}//end set container()
		protected function get container():MovieClip
		{
			return _container;
		}//end get container()
		
		/**
		 * This extracts the necessary parts.  In this case, a TextField with name 'bubbleText_txt".
		 * Note: the TextField has its multiline property set to 'true' and its type set to TextFieldType.DYNAMIC.
		 * 
		 * @return	An Array representation of the descendants of _contentMC
		 */
		protected function extractParts(a_bAddContents:Boolean):Array
		{
			if (a_bAddContents)
			{
				this.addChild(_entireMenuContents);
			}
			
			var contentMcDescendants:Array = DisplayObjectUtils.getDescendantsOf(_entireMenuContents);
			
			var tmpDispObj:DisplayObject;
			var leftScrollImg:MovieClip;
			var rightScrollImg:MovieClip;
			var upScrollImg:MovieClip;
			var downScrollImg:MovieClip;
			var scrollButton1Img:MovieClip;
			var scrollButton2Img:MovieClip;
			
			for (var i:int = 0; i < contentMcDescendants.length; i++)
			{
				tmpDispObj = contentMcDescendants[i] as DisplayObject;
				
				if (!tmpDispObj)
				{
					continue;
				}
				
				switch(tmpDispObj.name)
				{
					case "scrollBarMask_mc":
						_scrollBarMask = tmpDispObj as Sprite;
						break;
					case "container_mc":
						container = tmpDispObj as MovieClip;
						break;
					case "background_mc":
						_background = tmpDispObj as MovieClip;
						break;
					case "leftScroll_mc":
						leftScrollImg = tmpDispObj as MovieClip;
						break;
					case "upScroll_mc":
						upScrollImg = tmpDispObj as MovieClip;
						break;
					case "rightScroll_mc":
						rightScrollImg = tmpDispObj as MovieClip;
						break;
					case "downScroll_mc":
						downScrollImg = tmpDispObj as MovieClip;
						break;
					case "visible_mc":
						_visibleMC = tmpDispObj as Sprite;
						break;
					default:
						break;
				}
			}
			
			if(leftScrollImg && rightScrollImg)
			{
				setType(ScrollMenu.HORZ);
				scrollButton1Img = leftScrollImg;
				scrollButton2Img = rightScrollImg;
			}
			else if(upScrollImg && downScrollImg)
			{
				setType(ScrollMenu.VERT);
				scrollButton1Img = upScrollImg;
				scrollButton2Img = downScrollImg;
			}
			else if(!leftScrollImg)
			{
				throw new MissingScrollImgError();
			}
			
			if (_visibleMC)
			{
				buildContainerAndMaskFrom(_visibleMC);
			}
			
			_scrollButton1 = new SmercButton(scrollButton1Img, false);
			_scrollButton2 = new SmercButton(scrollButton2Img, false);
			_scrollButton1.setDispatchesHeldDownEvents(true);
			_scrollButton2.setDispatchesHeldDownEvents(true);
			
			// Finally, so that future generations can learn from these descendants.
			return contentMcDescendants;
			
		}//end extractParts()
		
		protected function buildContainerAndMaskFrom(a_img:Sprite):void
		{
			if (!a_img)
			{
				throw new ArgumentError("ScrollMenu::buildContainerAndMaskFrom(): a_img=null!");
			}
			
			var visibleBounds:Rectangle = a_img.getBounds(a_img);
			
			container = new MovieClip();
			container.x = a_img.x + visibleBounds.x;
			container.y = a_img.y + visibleBounds.y;
			a_img.parent.addChild(container);
			_scrollBarMask = new Sprite();
			_scrollBarMask.graphics.beginFill(0x00ff00, .5);
			_scrollBarMask.graphics.drawRect(visibleBounds.x, visibleBounds.y, visibleBounds.width, visibleBounds.height);
			_scrollBarMask.graphics.endFill();
			_scrollBarMask.x = a_img.x;
			_scrollBarMask.y = a_img.y;
			a_img.parent.addChild(_scrollBarMask);
			a_img.alpha = 0;
			container.mask = _scrollBarMask;
			
		}//end buildContainerAndMaskFrom()
		
		/**
		 * In case you wish to specify a different interval between
		 * the scroll menu button's dispatching of their held-down
		 * event.  Increasing this number over 33 would slow down the rate
		 * at which the container moves at its speed.  Speeding it up would
		 * smooth and increase the speed.
		 */
		public function set buttonsHeldDownInterval(a_int:int):void
		{
			_scrollButton1.setDispatchesHeldDownEvents(true, a_int);
			_scrollButton2.setDispatchesHeldDownEvents(true, a_int);
			
		}//end set buttonsHeldDownInterval()
		
		/**
		 * Destroy this object.
		 * @param	...args
		 */
		public function destroy(...args):void
		{
			// Clear the menu, destroying every destructable item.
			this.clearMenu(true);
			
			if(_item_ar)
			{
				for(var i:uint = 0; i < _item_ar.length; i++)
				{
					if(_item_ar[i])
					{
						try
						{
							_item_ar[i].destroy();
						}
						catch (e:Error)
						{
							trace(this.name + "::ScrollMenu::destroy(): _item_ar[i]=" + _item_ar[i] + " generated the"
									+ " following error upon calling 'destroy()' on it: " + e);
						}
					}
				}
				_item_ar = null;
			}
			if(_attributes_arr)
			{
				_attributes_arr = null;
			}
			
			_type = -1;
			
			spacing = 0;
			
			_speed = 1;
			
			itemsPerScroll = 1;
			
			if(_scrollButton1)
			{
				_scrollButton1.destroy();
				_scrollButton1 = null;
			}
			if(_scrollButton2)
			{
				_scrollButton2.destroy();
				_scrollButton2 = null;
			}
			
		}//end destroy()
		
		/**
		 * if _background exists (extracted from the construction parameter a_mc), it is 
		 * tiled with newly-created instances of a_imgClass.
		 * 
		 * @param	a_imgClass:	A Class object for a BitmapData class (or a subclass thereof).
		 * 
		 * @see #ScrollMenu()
		 */
		public function setBackgroundTile(a_imgClass:Class):void
		{
			if(!_background)
			{
				return;
			}
			
			_tileClass = a_imgClass;
			// Get height and width of a_do
			var bmpData:BitmapData = new _tileClass(0,0);
			var bmp:Bitmap;
			
			// Calculate how many times to tile
			// Assuming mask is larger else just do once
			var timesToTileX:Number = _scrollBarMask.width / bmpData.width;
			var timesToTileY:Number = _scrollBarMask.height / bmpData.height;
			
			// Loop to tile images
			var i:int = 0;
			while(i < timesToTileX)
			{
				// Create bitmap, no need to adjust to be top left registered
				// container is not center registered
				bmp = new Bitmap(bmpData);
				bmp.smoothing = true;
				
				// Adjust for tiling on the X Axis
				bmp.x += i * bmp.width;
				
				i++;
				
				// Add to the background
				_background.addChild(bmp);
			}
		}
		
		/**
		 * get/set the spacing between objects.  This does *not* alter the space between
		 * objects that have already been added.  Set this spacing BEFORE adding menu items.
		 */
		public function set spacing(newSpacing:Number):void
		{
			_spacing = newSpacing;
			
		}//end setSpacing
		public function get spacing():Number
		{
			return _spacing;
		}//end get spacing()
		
		/**
		 * Set the speed for the tweening of the container (if it's tweened).
		 * @default .2 (Seconds)
		 */
		public function set movementTweenTime(a_time:Number):void
		{
			if(a_time <= 0)
			{
				throw new ArgumentError(this.name + ".set movementTweenTime(" + a_time + "): a_time must be >= 0 !");
			}
			
			_tweenMovementTime = a_time;
			
		}//end set movementTweenTime()

		/**
		* Called from extractParts() after the type has been determined, 
		* <b>based on the name of the MovieClips that become the buttons.</b>
		* This should only be called once.
		* Here is where scroll1, scroll2, axis, oppositeAxis, measurement, and oppositeMeasurement
		* are set.
		* 
		* @param	a_type:	int defined as either ScrollMenu.HORZ or ScrollMenu.VERT.
		* 
		* @see #scroll1
		* @see #scroll2
		* @see #axis
		* @see #oppositeAxis
		* @see #measurement
		* @see #oppositeMeasurement
		*/
		protected function setType(a_type:int):void
		{
			//set the names of the scroll buttons, according to orientation.
			switch(a_type)
			{
				case HORZ:
					scroll1 = "leftScroll_mc";
					scroll2 = "rightScroll_mc";
					axis = "x";
					oppositeAxis = "y";
					measurement = "width";
					oppositeMeasurement = "height";
					break;
				case VERT:
					scroll1 = "upScroll_mc";
					scroll2 = "downScroll_mc";
					axis = "y";
					oppositeAxis = "x";
					measurement = "height";
					oppositeMeasurement = "width";
					break;
				default:
					throw new ArgumentError(this.name + ".setType(" + a_type + "): " + a_type + " is *NOT* a valid ScrollMenu type!!");
					break;
			}
			
			_type = a_type;
			
		}//end setType()

		/**
		* @param	a_number - The number in pixels to move the container when scrolling.
		*/
		public function setSpeed(a_number:Number):void
		{
			_speed = a_number;
			
		}//end setSpeed()
		
		/**
		*
		* @param	a_obj - DisplayObject to add to the masked _container..
		* 
		* @return The DisplayObject that was added added.
		*/
		public function addItemToMenu(a_obj:DisplayObject):DisplayObject
		{
			//
		
			// Add a given item to the menu
			// Create Item in Container
			var container:MovieClip = container;
			
			var item_do:DisplayObject = a_obj;
		
			
			
			// Save the object's initial attributes.
			var dispObjOrigAttribs:Object = {scaleX:item_do.scaleX, scaleY:item_do.scaleY};
			
			//the amount to scale our object by, should we need to.
			var scaleBy:Number = 1;
			
			//scale the item, should it be too large.
			if	(item_do[oppositeMeasurement] > this._scrollBarMask[oppositeMeasurement])
			{
				//scale down.
				scaleBy = 1/(item_do[oppositeMeasurement] / this._scrollBarMask[oppositeMeasurement]);
				item_do.scaleX *= scaleBy;
				item_do.scaleY *= scaleBy;
			}
			
			//to represent the rectange of the last object before this one.
			var scaledRectOfLastObj:Rectangle;
			
			//add the item to the container.
			item_do = container.addChild(item_do);
			
			//get the last item added and the end of the container
			var lastItem_do:DisplayObject;
			
			//the axis value of the conainer's end before adding the new object.
			var containerEndBeforeAdding:Number;
			
			//the resultant axis value for the new item.
			var newItemAxis:Number;
			
			if(_item_ar.length)
			{
				//There's at least one item already in the menu, use its end to determine where to put the new item.
				
				lastItem_do = _item_ar[_item_ar.length - 1];
				
				//get the rectangle of the last object in the coordinate system of the container, since that's where it is.
				scaledRectOfLastObj = lastItem_do.getBounds(container);
				
				if(_type == ScrollMenu.HORZ)
				{
					//we're using x for axis and width for measurement.
					containerEndBeforeAdding = scaledRectOfLastObj.right;
				}
				else
				{
					//we're using y for axis and height for measurement.
					containerEndBeforeAdding = scaledRectOfLastObj.bottom;
				}
				
				//the newly added item will be shifted to the end of the container plus the included spacing.
				newItemAxis = containerEndBeforeAdding + this.spacing;
			}
			else
			{
				//There are no items currently in the menu...this is the first, so, put it at the beginning.
				
				containerEndBeforeAdding = 0;
				
				//disregard spacing if there are no other items in the container.
				newItemAxis = containerEndBeforeAdding;
			}
			
			//Place the item at the first available location, (after spacing, if there are currently any objects in the menu).
			item_do[axis] = newItemAxis;
			
			//Find the center of the Mask, for determining where to place the new DisplayObject for centering,
			//then shift back up by 1/2 half of the item's oppositeMeasurement, to result with the top-left corner's oppositeAxis.
			item_do[oppositeAxis] = (this._scrollBarMask[oppositeMeasurement]/2) - (item_do[oppositeMeasurement]/2);
			
			// Adjust added item according to its registration point...shift the object to treat it as if it had a top-left registration.
			var rect:Rectangle = item_do.getBounds(item_do);
			if(rect.x != 0)
			{
				item_do.x += (rect.x * -1) * item_do.scaleX;
			}
			
			if(rect.y != 0)
			{
				item_do.y += (rect.y * -1) * item_do.scaleY;
			}
			
			// Save Item to manipulate later
			_item_ar.push(item_do );
			
			// And also save the item's original attributes for the item's removal, later.
			_attributes_arr.push(dispObjOrigAttribs);
			
			return item_do;
			
		}//end addItemToMenu()
		
		/**
		 * same as addItemToMenu, except you can specify the index you wish to add it.
		 * 
		 * @param	a_do:		The DisplayObject to add.
		 * @param	a_index:	Index where you wish the item to be added.
		 * 
		 * @return				The added DisplayObject.
		 * 
		 * @throws #RangeError if a_index is < 0 or a_index is > numberOfItems.
		 * 
		 * @see #addItemToMenu()
		 * @see #numberOfItems
		 */
		public function addItemAt(a_do:DisplayObject, a_index:int):DisplayObject
		{
			//
			
			if(a_index < 0 || a_index > _item_ar.length)
			{
				throw new RangeError(this.name + ".addItemAt(): a_index=" + a_index);
			}
			
			// Trying to add to the end of the container...this is a regular addition.
			if(a_index == _item_ar.length)
			{
				return this.addItemToMenu(a_do);
			}
			
			// Create Item in Container
			var container:MovieClip = this.container;
			
			var item_do:DisplayObject = a_do;
			
			// Save the object's initial attributes.
			var dispObjOrigAttribs:Object = {scaleX:item_do.scaleX, scaleY:item_do.scaleY};
			
			//the amount to scale our object by, should we need to.
			var scaleBy:Number = 1;
			
			//scale the item, should it be too large.
			if	(item_do[oppositeMeasurement] > this._scrollBarMask[oppositeMeasurement])
			{
				//scale down.
				scaleBy = 1/(item_do[oppositeMeasurement] / this._scrollBarMask[oppositeMeasurement]);
				item_do.scaleX *= scaleBy;
				item_do.scaleY *= scaleBy;
			}
			
			//add the item to the container.
			item_do = container.addChild(item_do);
			
			
			// Save the [axis] value of the current item at a_index.
			var prevItem:DisplayObject = _item_ar[a_index] as DisplayObject;
			var oldItemAxis:Number = prevItem.getRect(container)[axis];
			
			//now items with index >= a_index over to the right by the width of the scaled-down item_do.
			var iLength:int = int(this._item_ar.length);
			for(var i:int = a_index; i < iLength; i++)
			{
				DisplayObject(this._item_ar[i])[axis] += item_do.width + this.spacing;
			}
			
			// Adjust the axis of the item.
			item_do[axis] = oldItemAxis;
			
			// Adjust the opposite axis of the item so that it's placed at the top-left corner of its position.
			item_do[oppositeAxis] = (this._scrollBarMask[oppositeMeasurement]/2) - (item_do[oppositeMeasurement]/2);
			
			// Adjust added item according to its registration point...shift the object to treat it as if it had a top-left registration.
			var rect:Rectangle = item_do.getRect(item_do);
			if(rect.x != 0)
			{
				item_do.x += (rect.x * -1) * item_do.scaleX;
			}
			
			if(rect.y != 0)
			{
				item_do.y += (rect.y * -1) * item_do.scaleY;
			}
			
			// Add new item to the specified index.
			_item_ar.splice(a_index, 0, item_do);
			
			// And also save the item's original attributes (at the specified index) for the item's removal, later.
			_attributes_arr.splice(a_index, 0, dispObjOrigAttribs);
			
			return item_do;
			
		}//end addItemAt()
		
		/**
		 * 
		 * @param	a_index:	int index of the MenuItem to retreive.
		 * 
		 * @return	The DisplayObject MenuItem at the specified index.
		 */
		public function getMenuItemAt(a_index:uint):DisplayObject
		{
			var DO:DisplayObject;
			if(a_index < _item_ar.length)
			{
				DO = _item_ar[a_index] as DisplayObject;
			}
			
			return DO;
			
		}//end getMenuItemAt()
		
		/**
		 * 
		 */
		 public function getItems():Array
		 {
		 	return _item_ar;
		 	
		 }
		 
		/**
		 * 
		 * @param	a_do:					The DisplayObject MenuItem to remove from this ScrollMenu.
		 * @param	a_bDestroyItemsRemoved:	Calls 'destroy()' on the MenuItem if 'true'. @default false.
		 * @return							int index where the MenuItem resided before removal, -1 if
		 * 									unsuccessful.
		 */
		public function removeMenuItem(a_do:DisplayObject, a_bDestroyItemsRemoved:Boolean = false):int
		{
			var indexOfItemToRemove:int = _item_ar ? _item_ar.indexOf(a_do) : -1;
			
			//Item is not in our ScrollMenu
			if(indexOfItemToRemove >= 0)
			{
				removeMenuItemAt(indexOfItemToRemove, a_bDestroyItemsRemoved);
			}
			
			return indexOfItemToRemove;
			
		}//end removeMenuItem()
		
		/**
		 * 
		 * @param	a_do:	The DisplayObject MenuItem to acquire the index of.
		 * @return			int index of a_do in this ScrollMenu, -1 if it doesn't exist
		 * 					in this ScrollMenu.
		 */
		public function indexOfMenuItem(a_do:DisplayObject):int
		{
			return _item_ar ? _item_ar.indexOf(a_do) : -1;
		}//end indexOfMenuItem()
		
		/**
		 * 
		 * @param	a_do:	The DisplayObject MenuItem to check if it has been added to this
		 * 					ScrollMenu.
		 * 
		 * @return			Boolean 'true' if a_do exists in this ScrollMenu.
		 */
		public function hasMenuItem(a_do:DisplayObject):Boolean
		{
			return ( (_item_ar.indexOf(a_do) >= 0) ? true : false );
			
		}//end hasMenuItem()
		
		/**
		 * gets the number of items currently in this ScrollMenu.
		 */
		public function get numberOfItems():int
		{
			return _item_ar.length;
		}//end get numberOfItems()
		
		/**
		 * Remove all the items from the menu, with the option to call 'destroy()' on each one.
		 * 
		 * @param	a_bDestroyItemsRemoved:	Boolean to determine if 'destroy()' should be called on the
		 * 									MenuItems that are removed from this ScrollMenu after their
		 * 									removal.
		 */
		public function clearMenu(a_bDestroyItemsRemoved:Boolean = false):void
		{
			var container:MovieClip = container;
			
			var itemArrCopy:Array = _item_ar ? _item_ar.slice() : new Array();
			
			// Remove every item that we have in the _item_ar (use a copy in case _item_ar is corrupted
			// when we remove items).
			for (var i:int = (itemArrCopy.length - 1); i >= 0; i--)
			{
				// Remove from the end, first, since that's easier.
				this.removeMenuItem(itemArrCopy[i], a_bDestroyItemsRemoved);
			}
			
			// One last clean-up for our arrays.
			if(_item_ar)
			{
				// Just to ensure that the array is emptied.
				_item_ar.splice(0);
			}
			
			if(_attributes_arr)
			{
				// And remove the objects' initial attributes.
				_attributes_arr.splice(0);
			}
			
			if(container && _initialContainerPosition)
			{
				//Move the container back to the top-left corner of the mask for new item addition.
				container.x = _initialContainerPosition.x;
				container.y = _initialContainerPosition.y;
			}
			
			return;
			
		}//end clearMenu()
		
		/**
		 * Removes a DisplayObject MenuItem at the specified index.
		 * 
		 * @param	a_index:				int index of the requested MenuItem to remove.
		 * @param	a_bDestroyItemsRemoved:	Calls 'destroy()' on the removed MenuItems if 'true'. @default false
		 */
		public function removeMenuItemAt(a_index:Number, a_bDestroyItemsRemoved:Boolean = false):void
		{
			if (a_index < 0 || a_index >= _item_ar.length)
			{
				throw new RangeError("ScrollMenu::removeMenuItemAt(): a_index=" + a_index);
			}
			
			//remove the reference to the item at this index.
			//The VM cleans up the memory for us.
			var arrayOfItemRemoved:Array = _item_ar.splice(a_index, 1); // Cut it out of the array
			
			var itemToRemove_do:DisplayObject = arrayOfItemRemoved.pop() as DisplayObject;
			
			// Get the object's original attributes
			var itemImgAttribs:Object = _attributes_arr.splice(a_index, 1).pop();
			
			var itemMeasurement:Number = itemToRemove_do[measurement];
			var amtToShiftRemainingObjs:Number = itemMeasurement + this.spacing;
			
			//remove the DisplayObject from the DisplayList (so it won't be drawn any longer)
			var container:MovieClip = this.container;
			
			//remove the child if it hasn't been re-parented
			if(container.contains(itemToRemove_do))
			{
				container.removeChild(itemToRemove_do);
				if(a_bDestroyItemsRemoved)
				{
					var destructable:Object = itemToRemove_do as Object;
					try
					{
						if (destructable && null != destructable.destroy)
						{
							destructable.destroy();
						}
					}
					catch (e:Error)
					{
						trace(this.name + "::ScrollMenu::removeMenuItemAt(): destructable=" + destructable + " generated the"
									+ " following error upon calling 'destroy()' on it: " + e);
					}
				}
			}
			
			//now shift all the remaining items over.
			var iLength:int = int(_item_ar.length);
			for(var i:int = a_index; i < iLength; i++)
			{
				DisplayObject(_item_ar[i])[axis] -= amtToShiftRemainingObjs;
			}
			
			// Restore the object to it's original attributes
			itemToRemove_do.scaleX = itemImgAttribs.scaleX;
			itemToRemove_do.scaleY = itemImgAttribs.scaleY;
			
		}//end removeMenuItemAt()
		
		/**
		 * Removes the MenuItem from this ScrollMenu whose index is (numberOfItems - 1).
		 * 
		 * @param	a_bDestroyItemRemoved:	calls 'destroy()' on the MenuItem after removal if true. @default false.
		 */
		public function removeLastMenuItem(a_bDestroyItemRemoved:Boolean = false):void
		{
			var indexToRemove:int = _item_ar ? _item_ar.length - 1 : -1;
			
			if (indexToRemove < 0)
			{
				// No items to remove!
				return;
			}
			
			//remove the reference to the item at this index.
			//The VM cleans up the memory for us.
			var arrayOfItemRemoved:Array = _item_ar.splice(indexToRemove, 1); // Cut it out of the array
			
			var itemToRemove_do:DisplayObject = arrayOfItemRemoved.pop() as DisplayObject;
			
			// Get the object's original attributes
			var itemImgAttribs:Object = _attributes_arr.splice(indexToRemove, 1).pop();
			
			//remove the child if it hasn't been re-parented
			if(container.contains(itemToRemove_do))
			{
				container.removeChild(itemToRemove_do);
				if(a_bDestroyItemRemoved)
				{
					var destructable:Object = itemToRemove_do as Object;
					try
					{
						if (destructable && null != destructable.destroy)
						{
							destructable.destroy();
						}
					}
					catch (e:Error)
					{
						trace(this.name + "::ScrollMenu::removeMenuItemAt(): destructable=" + destructable + " generated the"
									+ " following error upon calling 'destroy()' on it: " + e);
					}
				}
			}
			
			// Restore the object to it's original attributes
			itemToRemove_do.scaleX = itemImgAttribs.scaleX;
			itemToRemove_do.scaleY = itemImgAttribs.scaleY;
			
		}//end removeLastMenuItem()
		
		/**
		 * Pause the ScrollMenu, along with its buttons.
		 * 
		 * @param	a_bool:	'true' to pause this ScrollMenu, 'false' to un-pause.
		 */
		public function pause(a_bool:Boolean):void
		{
			if (!_scrollButton1 || !_scrollButton2)
			{
				throw new Error(this.name + "::ScrollMenu::pause(" + a_bool 
								+ "): _scrollButton1=" + _scrollButton1 + ", _scrollButton2=" + _scrollButton2 
								+ " -- NEITHER CAN BE NULL!");
			}
			
			_scrollButton1.pause(a_bool);
			_scrollButton2.pause(a_bool);
			
			if(!a_bool)
			{
				//scroll1 is the left/up button, and scroll2 the down/right button
				_scrollButton1.addEventListener(ButtonEvent.SMERCBUTTON_HELD_DOWN_EVT, onScroll1Press);
				_scrollButton2.addEventListener(ButtonEvent.SMERCBUTTON_HELD_DOWN_EVT, onScroll2Press);
			}
			
			// Pause clickable items
			/**
			var iLength:int = int(_item_ar.length);
			for(var i:Number = 0; i < iLength; i++)
			{
				_item_ar[i].pause(a_bool);
			}
			/**/
		}//end pause()
		
		protected function get axisBorderSpacing():Number
		{
			return _spacing;
		}//end get axisBorderSpacing()
		
		/**
		 * This moves the container within the mask of the ScrollBar. This is
		 * what gives the ScrollMenu the appearance of objects scrolling.
		 * 
		 * @param	a_event:	An optional event - not used. @default null.
		 */
		protected function moveContainer(a_event:Event = null):void
		{
			/** 
			 * There are three possible conditions of the mask-container that must be solved for.  
			 * They are as follows:
			 *	The are 3 Mask-Container Relationships:
			 *	1: The Container has a width/height less than or equal to the mask width/height.
			 *	2: The Container is larger than the mask, and its x/y point is less than the mask's x/y point.
			 *	3: The Container is larger than the mask, and its x/y point is greater than the mask's x/y point.
			 */
			
			var container_mc:MovieClip = this.container;
			
			var spaceOutsideContents:Number = this.axisBorderSpacing;
			
			// Calculate the new x/y point for the container to shift to.
			var newContainerAxis:Number = this.container[axis] + (_direction * _speed);
			
			//Delimiters for the shifting.
			var minContainerAxis:Number;
			const maxContainerAxis:Number = _scrollBarMask[axis]; //we can never see left/above the first item.
			
			//Satisfy Mask-Container Relationship #1: Mask is bigger than the container.
			if(_scrollBarMask[measurement] >= (this.container[measurement] + spaceOutsideContents) )
			{
				minContainerAxis = _scrollBarMask[axis]; //we can't shift the container left of the mask if it's smaller.
				if(this.container[axis] != _scrollBarMask[axis])
				{
					//All the items should be visible
					newContainerAxis = _scrollBarMask[axis];
				}
				else
				{
					//All the items *are* visible, nothing to do here.
					return;
				}
			}
			else
			{
				//Satisfy Mask-Container Relationship #2 & #3:
				var containerLeeway:Number = (this.container[measurement] + spaceOutsideContents) 
												- _scrollBarMask[measurement];
				
				minContainerAxis = _scrollBarMask[axis] - containerLeeway; //maximum amount we can shift left/up.
			}
			
			//shift only within bounds of the delimiters:
			if(_direction == 1)
			{
				//Scrolling left/up
				newContainerAxis = Math.min(maxContainerAxis, newContainerAxis);
			}
			else
			{
				//Scrolling right/down
				newContainerAxis = Math.max(minContainerAxis, newContainerAxis);
			}
			
			if(_bTweenContainerMovement)
			{
				//remove any current tweens on the container, should the user have quickly clicked again during a tween.
				Tweener.removeTweens(this.container);
				
				//Shift the proper axis of the container.
				if(_type == ScrollMenu.HORZ)
				{
					Tweener.addTween(this.container, {x:newContainerAxis, time:_tweenMovementTime, transition:"linear"});
					if(_background)
					{
						Tweener.addTween(_background, {x:newContainerAxis, time:_tweenMovementTime, transition:"linear"});
					}
				}
				else
				{
					Tweener.addTween(this.container, {y:newContainerAxis, time:_tweenMovementTime, transition:"linear"});
					if(_background)
					{
						Tweener.addTween(_background, {y:newContainerAxis, time:_tweenMovementTime, transition:"linear"});
					}
				}
			}
			else
			{
				// Shift the container, joltingly
				this.container[axis] = newContainerAxis;
				if(_background)
				{
					_background[axis] = newContainerAxis;
				}
			}
			
			adjustBackgroundTiling();
			
			// Dispatch an event noting that we've been scrolled.
			this.dispatchEvent(new Event(ScrollMenu.SCROLL_EVT));
			
		}//end moveContainer()
		
		private function adjustBackgroundTiling():void
		{
			if(!_background)
			{
				return;
			}
			
			// Test against scroll mask and background position
			var diff:Number = _scrollBarMask[axis] - _background[axis];
			if(diff)
			{
				// Are there background children?
				if(_background.numChildren)
				{
					// Is the difference we moved call for a new tile?
					if((_background.width - diff) < _scrollBarMask.width)
					{
						// Get a child at 0 in background to get width and height
						var disObj:DisplayObject = _background.getChildAt(0);
						if(disObj && null != _tileClass)
						{
							// Add another tile
							var bmpData:BitmapData = new _tileClass(0,0);
							var bmp:Bitmap = new Bitmap(bmpData);						
							bmp.smoothing = true;
							
							// Adjust for tiling on the X Axis
							bmp.x += _background.numChildren * bmp.width;
							
							_background.addChild(bmp);
						}
					}
				}
				
			}
			
		}//end adjustBackgroundTiling()
		
		/**
		 * Called automatically when the scrollButton1 dispatches the held down event.
		 * 
		 * @param	a_buttonEvt
		 */
		public function onScroll1Press(...args):void
		{
			_direction = 1;
			
			this.moveContainer(null);
			
		}//end onScroll1Press()
		
		/**
		 * Called automatically when the scrollButton2 dispatches the held down event.
		 * 
		 * @param	a_buttonEvt
		 */
		public function onScroll2Press(...args):void
		{
			_direction = -1;
			
			this.moveContainer(null);
			
		}//end onScroll2Press()
		
		public function get scrollButton1():ISmercButton
		{
			return _scrollButton1;
			
		}//end get scrollButton1()
		
		public function get scrollButton2():ISmercButton
		{
			return _scrollButton2;
			
		}//end get scrollButton2()
		
		/**
		 * Setter to change the movement of the container from instantaneous shifting to tweening.
		 */
		public function set tweenContainerMovement(a_bool:Boolean):void
		{
			_bTweenContainerMovement = a_bool;
		}//end tweenContainerMovement()
		
	}//end class ScrollMenu
	
}//end package GuiObjects