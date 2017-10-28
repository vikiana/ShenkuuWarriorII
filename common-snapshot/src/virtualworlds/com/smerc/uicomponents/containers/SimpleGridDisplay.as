package virtualworlds.com.smerc.uicomponents.containers
{	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import virtualworlds.com.smerc.uicomponents.buttons.Events.ButtonEvent;
	import virtualworlds.com.smerc.uicomponents.buttons.ISmercButton;
	import virtualworlds.com.smerc.uicomponents.buttons.SmercButton;
	
	/**
	* ...
	* @author Bo
	*/
	public class SimpleGridDisplay extends Sprite
	{
		/**
		 * The original MovieClip from which we extracted all our necessary parts.
		 */
		protected var _contentMC:MovieClip;
		
		/**
		 * Our internal list of objects that a portion of which are displayed on the grid.
		 */
		protected var _storedObjs:Array;
		
		/**
		 * The content holders for each DisplayObject are stored in this array.
		 */
		protected var _contentHolders:Array;
		
		protected var _pageUpBtn:ISmercButton;
		protected var _pageDownBtn:ISmercButton;
		
		public function get currentPage():int { return _currentPage; }
		public function set currentPage(value:int):void{ _currentPage = value; }
		
		protected var _currentPage:int;
		
		protected var _bShowingLastPage:Boolean;
		
		protected var _bMorePagesAboveCurrent:Boolean;
		
		private var _bCenerRegisterContents:Boolean = false;
		
		public function SimpleGridDisplay(a_contentMC:MovieClip, a_bAddContents:Boolean = true)
		{
			_contentMC = a_contentMC;
			
			if (!a_contentMC)
			{
				throw new ArgumentError("SimpleGridDisplay::SimpleGridDisplay(): a_contentMC=" + a_contentMC);
			}
			
			_storedObjs = new Array();
			
			_contentHolders = new Array();
			
			_currentPage = 0;
			
			_bShowingLastPage = false;
			_bMorePagesAboveCurrent = false;
			
			this.extractParts(a_bAddContents);
			
			//
			this.pause(true);
			
			this.showPage();
			
		}//end SimpleGridDisplay() constructor.
		
		public function destroy(...args):void
		{
			//
			
			_contentMC = null;
			
			_storedObjs = null;
			
			var tmpContentHolder:DisplayObjectContainer;
			
			for (var i:int = 0; _contentHolders && (i < _contentHolders.length); i++)
			{
				tmpContentHolder = _contentHolders[i] as DisplayObjectContainer;
				if (!tmpContentHolder)
				{
					continue;
				}
				while (tmpContentHolder.numChildren)
				{
					tmpContentHolder.removeChildAt(0);
				}
			}
			
			_contentHolders = null;
			
			if(_pageUpBtn)
			{
				_pageUpBtn.removeEventListener(ButtonEvent.SMERCBUTTON_CLICK_EVT, pageUpClickHandler);
				_pageUpBtn.destroy();
				_pageUpBtn = null;
			}
			
			if(_pageDownBtn)
			{
				_pageDownBtn.removeEventListener(ButtonEvent.SMERCBUTTON_CLICK_EVT, pageDownClickHandler);
				_pageDownBtn.destroy();
				_pageDownBtn = null;
			}
			
			_currentPage = 0;
			
		}//end destroy()
		
		protected function extractParts(a_bAddContents:Boolean):void
		{
			if (a_bAddContents)
			{
				this.addChild(_contentMC);
			}
			
			var contentHolderName:String;
			var tmpContentHolder:DisplayObjectContainer;
			
			for (var i:int = 0; ; i++)
			{
				contentHolderName = ("container" + i + "_mc");
				tmpContentHolder = _contentMC.getChildByName(contentHolderName) as DisplayObjectContainer;
				if(tmpContentHolder)
				{
					_contentHolders.push(tmpContentHolder);
				}
				else
				{
					break;
				}
			}
			
			if (!_contentHolders.length)
			{
				throw new Error("SimpleGridDisplay::extractParts(): _contentHolders.length=0! Must have AT LEAST"
								+ " ONE MovieClip inside of _contentMC named 'containerX_mc', where 'X' is a number"
								+ " starting from 0.");
			}
		
			this.constructButtons();
			
			_pageUpBtn.addEventListener(ButtonEvent.SMERCBUTTON_CLICK_EVT, pageUpClickHandler, false, 0, true);
			_pageDownBtn.addEventListener(ButtonEvent.SMERCBUTTON_CLICK_EVT, pageDownClickHandler, false, 0, true);
			
		}//end extractParts()
		
		protected function constructButtons(...args):void
		{
			_pageUpBtn = new SmercButton(_contentMC.getChildByName("pageUp_mc") as MovieClip, false);
			_pageDownBtn = new SmercButton(_contentMC.getChildByName("pageDown_mc") as MovieClip, false);
			
		}//end constructButtons()
		
		public function set centerRegisterContents(a_bool:Boolean):void
		{
			_bCenerRegisterContents = a_bool;
		}//end set centerRegisterContents()
		public function get centerRegisterContents():Boolean
		{
			return _bCenerRegisterContents;
		}//end get centerRegisterContents()
		
		protected function pageUpClickHandler(a_buttonEvt:ButtonEvent = null):void
		{
			this.pageUp();
			
		}//end pageUpClickHandler()
		
		protected function pageDownClickHandler(a_buttonEvt:ButtonEvent = null):void
		{
			this.pageDown();
			
		}//end pageDownClickHandler()
		
		/**
		 * 
		 * @param	...args
		 * @return	'true' if any objects were actually shown.
		 */
		protected function showPage(...args):Boolean
		{
			var i:int; // loop iterator.
			var tmpContentHolder:DisplayObjectContainer;
			var tmpStoredObj:DisplayObject;
			var tmpIndexToShow:int;
			var bAnObjectWasDisplayed:Boolean = false;
			
			/**
			 * Based on the _currentPage, set the _contentHolders to have the only child that is in
			 * the _storedObjs for its position and page.
			 * 
			 * So, first, remove all the children for each _contentHolders[i],
			 * then, loop throuh each _contentHolder, 
			 * adding the child in _storedObjs[i + _currentPage * _contentHolders.length]
			 */
			
			// Remove all the children from each content holder.
			for (i = 0; i < _contentHolders.length; i++)
			{
				tmpContentHolder = _contentHolders[i] as DisplayObjectContainer;
				while (tmpContentHolder.numChildren)
				{
					tmpContentHolder.removeChildAt(0);
				}
			}
			
			// Add the specific content to each contentHolder.
			for (i = 0; i < _contentHolders.length; i++)
			{
				tmpContentHolder = _contentHolders[i] as DisplayObjectContainer;
				
				tmpIndexToShow = (i + (_currentPage * _contentHolders.length));
				
				if (tmpIndexToShow >= _storedObjs.length)
				{
					// No object to show at this index, so, we're done.
					break;
				}
				
				tmpStoredObj = _storedObjs[tmpIndexToShow] as DisplayObject;
				
				if(tmpStoredObj)
				{
					if (_bCenerRegisterContents)
					{
						var currentScaleX:Number = tmpStoredObj.scaleX;
						var currentScaleY:Number = tmpStoredObj.scaleY;
						tmpStoredObj.scaleX = 1;
						tmpStoredObj.scaleY = 1;
						tmpStoredObj.x = tmpStoredObj.width * -0.5;
						tmpStoredObj.y = tmpStoredObj.height * -0.5;
						tmpStoredObj.scaleX = currentScaleX;
						tmpStoredObj.scaleY = currentScaleY;
					}
					else
					{
						tmpStoredObj.x = tmpStoredObj.y = 0;
					}
					tmpContentHolder.addChild(tmpStoredObj);
					bAnObjectWasDisplayed = true;
				}
			}
			
			// Determine if there are more pages *above* the currently-showing page.
			
			// So, get the last index of the previous page
			var previousPageLastIndex:int = ((_currentPage * _contentHolders.length) - 1);
			
			if (previousPageLastIndex < 0 || previousPageLastIndex >= _storedObjs.length)
			{
				// If there's no stored object at this index, there are no more pages above the current.
				_bMorePagesAboveCurrent = false;
			}
			else
			{
				_bMorePagesAboveCurrent = true;
			}
			
			
			
			var nextPageFirstIndex:int = (_contentHolders.length + (_currentPage * _contentHolders.length));
			
			_bShowingLastPage = (nextPageFirstIndex >= _storedObjs.length) ? true : false;
			_pageUpBtn.pause( !_bMorePagesAboveCurrent);
			_pageDownBtn.pause(_bShowingLastPage );
			
			return bAnObjectWasDisplayed;
			
		}//end showPage()
		
		public function addObj(a_obj:DisplayObject, bShowPage:Boolean = true):DisplayObject
		{
			if (this.hasObj(a_obj))
			{
				
				return null;
			}
			
			_storedObjs.push(a_obj);
			
			if(bShowPage)
				showPage();
			
			return a_obj;
			
		}//end addObj()
		
		/**
		 * Mimics Array::forEach()
		 * 
		 * @param	callback:	<Function> - The function to run on each item in the array. 
		 * 						This function can contain a simple command (for example, a trace() statement) 
		 * 						or a more complex operation, and is invoked with three arguments; the value of 
		 * 						an item, the index of an item, and the Array object:
		 * 						<br/><br/>
		 * 						function callback(item:*, index:int, array:Array):void;
		 * 						<br/><br/>
		 * 
		 * @param	thisObject:	<* @default null >  � An object to use as this for the function.
		 */
		public function forEach(callback:Function, thisObject:* = null):void
		{
			if(_storedObjs)
			{
				_storedObjs.forEach(callback, thisObject);
			}
			
		}//end forEach()
		
		public function pauseContents(a_bool:Boolean):void
		{
			if (a_bool)
			{
				this.forEach(pauseItems);
			}
			else
			{
				this.forEach(unPauseItems);
			}
			
		}//end pauseContents()
		
		private function pauseItems(element:*, index:int, arr:Array):void
		{
			element.pause(true);
		}//end pauseItems()
		
		private function unPauseItems(element:*, index:int, arr:Array):void
		{
			element.pause(false);
		}//end unPauseItems()
		
		public function indexOf(a_obj:DisplayObject):int
		{
			return _storedObjs.indexOf(a_obj);
			
		}//end indexOf()
		
		public function hasObj(a_obj:DisplayObject):Boolean
		{
			return ((this.indexOf(a_obj) < 0) ? false : true);
			
		}//end hasObj()
		
		public function addObjAt(a_obj:DisplayObject, a_index:int):DisplayObject
		{
			if (a_index == _storedObjs.length)
			{
				return this.addObj(a_obj);
			}
			
			if (this.hasObj(a_obj))
			{
				trace("SimpleGridDisplay::addObjAt(" + a_obj + ", " + a_index 
						+ "): WARNING -- object already exists, *not* re-adding it.");
				return null;
			}
			
			if (a_index < 0 || a_index >= _storedObjs.length)
			{
				throw new RangeError("SimpleGridDisplay::addObjAt(): a_index=" + a_index);
			}
			
			_storedObjs.splice(a_index, 0, a_obj);
			
			showPage();
			
			return a_obj;
			
		}//end addObjAt()
		
		public function removeLastObj(...args):void
		{
			if(_storedObjs.length)
			{
				_storedObjs.pop();
				
				// We removed an object, so, if nothing is displayed when we show the page, 
				// and there are more pages above the current, decrement the page number and 
				// show the (preceeding) page.
				while ((!showPage()) && _bMorePagesAboveCurrent)
				{
					_currentPage--;
				}
			}
			
		}//end removeLastObj()
		
		/**
		 * Remove all objects.
		 */
		 public function removeAllObjects():void
		 {
		 	
		 	for (var i:int = 0; _contentHolders && (i < _contentHolders.length); i++)
			{
				var tmpContentHolder : DisplayObjectContainer = _contentHolders[i] as DisplayObjectContainer;
				if (!tmpContentHolder)
				{
					continue;
				}
				while (tmpContentHolder.numChildren)
				{
					tmpContentHolder.removeChildAt(0);
				}
			}
			 _storedObjs = [];
		 }
		 
		public function removeObj(a_obj:DisplayObject):DisplayObject
		{
			var indexOfObj:int = this.indexOf(a_obj);
			if (indexOfObj < 0)
			{
				return null;
			}
			
			return removeObjAt(indexOfObj);
			
		}//end removeObj()
		
		public function removeObjAt(a_index:int):DisplayObject
		{
			var obj:DisplayObject;
			var removedObjArr:Array;
			
			if (a_index < 0 || a_index >= _storedObjs.length)
			{
				throw new RangeError("SimpleGridDisplay::removeObjAt(" + a_index 
										+ "): _storedObjs.length=") + _storedObjs.length;
			}
			
			removedObjArr = _storedObjs.splice(a_index, 1);
			obj = (removedObjArr.pop() as DisplayObject);
			
			// We removed an object, so, if nothing is displayed when we show the page, 
			// and there are more pages above the current, decrement the page number and 
			// show the (preceeding) page.
			while ((!showPage()) && _bMorePagesAboveCurrent)
			{
				_currentPage--;
			}
			
			return obj;
			
		}//end removeObjAt()
		
		public function pageUp(...args):void
		{
			//
			
			if(_bMorePagesAboveCurrent)
			{
				_currentPage--;
				showPage();
			}
			
		}//end pageUp()
		
		public function pageDown(...args):void
		{
			//
			
			if (!_bShowingLastPage)
			{
				_currentPage++;
				showPage();
			}
			
		}//end pageDown()
		
		public function pause(a_bool:Boolean, a_bApplyToContents:Boolean = false):void
		{
			if (_pageUpBtn)
			{
				//
				_pageUpBtn.pause(a_bool);
			}
			if (_pageDownBtn)
			{
				//
				_pageDownBtn.pause(a_bool);
			}
			
			if (a_bApplyToContents)
			{
				this.pauseContents(a_bool);
			}
			
		}//end pause()
		
		
		public function getItems() : Array 
		{ 
			return _storedObjs.slice();
		}
		
		public function get pageUpButton():ISmercButton
		{
			return _pageUpBtn;
			
		}//end get pageUpButton()
		
		public function get pageDownButton():ISmercButton
		{
			return _pageDownBtn;
			
		}//end get pageDownButton()
		
		public function get numberOfItems():int
		{
			return _storedObjs ? _storedObjs.length : 0;
		}//end get numberOfItems()
		
		
		public function get numContentHolders():int
		{
			return _contentHolders ? _contentHolders.length : 0;
		}//end get numContentHolders()
		
	}//end class SimpleGridDisplay
	
}//end package com.smerc.uicomponents.Containers.GridDisplay
