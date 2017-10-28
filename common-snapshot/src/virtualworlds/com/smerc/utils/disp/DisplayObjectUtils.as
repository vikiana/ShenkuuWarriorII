/**
* ...
* @author Bo
* @version 0.1
*/

package virtualworlds.com.smerc.utils.disp
{
	import virtualworlds.com.smerc.utils.math.Vector;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	public class DisplayObjectUtils
	{
		/**
		* 
		* @param	a_class:	A Class object of which we will check all the children of a_doc against.
		* @param	a_doc:		A DisplayObjectContainer that we will check its children for being of type a_class.
		* @return				An Array of DisplayObjects that are of type a_class contained by a_doc.
		* 
		* 						Note: This class merely checks children, it does *NOT* check all descendants.
		*/
		public static function getChildrenOfClass(a_class:Class, a_doc:DisplayObjectContainer):Array
		{
			var childrenOfClass:Array = new Array();
			
			var tmpChild:DisplayObject;
			
			var a_doc_numChildren:int = (a_class && a_doc ? a_doc.numChildren : 0);
			for(var i:int = 0; i < a_doc_numChildren; i++)
			{
				tmpChild = a_doc.getChildAt(i);
				if(tmpChild is a_class)
				{
					childrenOfClass.push(tmpChild);
				}
			}
			
			return childrenOfClass;
			
		}//end getChildrenOfClass()
		
		/**
		 * Find and return a display object by instance name.
		 * 
		 * @param	a_name		Instance name of display object to find.
		 * @param	a_doc			Display Object Container to search through.
		 * 
		 * @return The first display object that matches given instance name.
		 * 
		 * @author Brisita
		 */
		static public function getDescendantByName(a_name:String, a_doc:DisplayObjectContainer):DisplayObject
		{	
			
			
			// Get descendants
			var arr:Array = getDescendantsOf(a_doc);
			
			
			// Find Display Object
			var total:int = arr.length;
			while(total--)
			{
				var disObj:DisplayObject = arr[total] as DisplayObject;
				if(disObj)
				{
					// Did we find the display object of interest?
					if(disObj.name == a_name)
					{
						return disObj;
					}
				}
			}
			
			return null;
		}
		
		/**
		* 				Returns all the relatives of a particular DisplayObject.
		* 
		* @param	a_do:	The DisplayObject for which we have been requested to return its descendants.
		* @return	Array:	of all of the Descendants of a particular DisplayObject.
		*/
		public static function getDescendantsOf(a_do:DisplayObject):Array
		{
			var descendantsOfDO:Array = new Array();
			var doc:DisplayObjectContainer = a_do as DisplayObjectContainer;
			
			if(doc)
			{
				var doc_numChildren:int = doc.numChildren;
				for(var i:int = 0; i < doc_numChildren; i++)
				{
					descendantsOfDO = descendantsOfDO.concat(getDescendants(doc.getChildAt(i)));
				}
			}
			
			return descendantsOfDO;
			
		}//end getDescendantsOf()
		
		/**
		 * 
		 * @param	a_do:			The DisplayObject for which we have been requested to return its descendants.
		 * @param	a_useWeakKeys:	<Boolean (default = false)> Instructs the Dictionary object (that is returned) to use "weak" 
		 * 							references on object keys. If the only reference to an object is in the 
		 * 							specified Dictionary object, the key is eligible for garbage collection 
		 * 							and is removed from the table when the object is collected.
		 * 
		 * @return	Dictionary		Of key-DisplayObject pairs, where the key is the "name" property of the DisplayObject.
		 */
		public static function getDescendantsAsDict(a_do:DisplayObject, a_useWeakKeys:Boolean = false):Dictionary
		{
			var dict:Dictionary = new Dictionary(a_useWeakKeys);
			
			var descendantsArr:Array = DisplayObjectUtils.getDescendantsOf(a_do );
			var descendantsArr_length:int = descendantsArr ? descendantsArr.length : 0;
			
			var tmpDO:DisplayObject;
			
			for (var i:int = 0; i < descendantsArr_length; i++)
			{
				tmpDO = descendantsArr[i] as DisplayObject;
				if (tmpDO)
				{
					dict[tmpDO.name] = tmpDO;
				}
			}
			
			return dict;
			
		}//end getDescendantsAsDict()
		
		/**
		* 				The recursive function called originally from getDescendantsOf()
		* 
		* @param	a_do:		The DisplayObject of which we're getting the descendants of.
		* @param	a_depth:	Current depth of this recursive call
		* @return
		*/
		private static function getDescendants(a_do:DisplayObject, a_depth:int = 0):Array
		{
			var doc:DisplayObjectContainer = a_do as DisplayObjectContainer;
			
			var a_descendantArray:Array = new Array();
			
			// If this a_do has any children, add them to the array.
			if(doc)
			{
				for(var i:int = 0; i < doc.numChildren; i++)
				{
					a_descendantArray = a_descendantArray.concat(getDescendants(doc.getChildAt(i), (a_depth + 1)) );
				}
			}
			
			// Finally, add ourselves last.
			a_descendantArray.push(a_do);
			
			return a_descendantArray;
			
		}//end getDescendants()
		
		public static function showAllContents(a_do:DisplayObject):String
		{
			var dumpStr:String = "************************************************\n";
			dumpStr += "DisplayObjectUtils::showAllContents(" + a_do + "): Contents dump, below:\n\n";
			dumpStr += showContents(a_do );
			dumpStr += "************************************************\n";
			dumpStr += "DisplayObjectUtils::showAllContents(" + a_do + "): End of contents dump.\n";
			
			//
			//
			//showContents(a_do);
			//
			//
			
			//
			
			return dumpStr;
			
		}//end showAllContents()
		
		private static function showContents(a_do:DisplayObject, a_tabStr:String = "", a_depthNum:int = 0):String
		{
			var displayStr:String;
			
			var totalDisplayStr:String;
			
			if(a_do)
			{
				var strX:String = (a_do.x.toString());
				var strY:String = (a_do.y.toString());
				var strW:String = (a_do.width.toString());
				var strH:String = (a_do.height.toString());
				var strScaleX:String = (a_do.scaleX.toPrecision(5).toString());
				//var strScaleX:String = (a_do.scaleX.toString());
				var strScaleY:String = (a_do.scaleY.toPrecision(5).toString());
				//var strScaleY:String = (a_do.scaleY.toString());
				
				// Truncate the x, y, width, and height values for displaying.
				var strXtrunc:String = strX.split(/\./g)[0];
				var strYtrunc:String = strY.split(/\./g)[0];
				var strWtrunc:String = strW.split(/\./g)[0];
				var strHtrunc:String = strH.split(/\./g)[0];
				//var strScaleXtrunc:String = strScaleX.split(/\./g)[0];
				var strScaleXtrunc:String = strScaleX;
				//var strScaleYtrunc:String = strScaleY.split(/\./g)[0];
				var strScaleYtrunc:String = strScaleY;
				
				totalDisplayStr = (a_tabStr + a_do.name + "::" + a_do + "(index: " + DisplayObjectUtils.getDisplayObjectIndex(a_do) + ")");
				totalDisplayStr += (" (x:" + strXtrunc + ", y:" + strYtrunc + ", w:" + strWtrunc + ", h:" + strHtrunc 
									+ ", scaleX:" + strScaleXtrunc + ", scaleY:" + strScaleYtrunc + ", depth=" + a_depthNum + ")");
				
				//displayStr = (a_tabStr + a_do.name + "::" + a_do + "(index: " + DisplayObjectUtils.getDisplayObjectIndex(a_do) + ")");
				
				//displayStr += (" (x:" + strXtrunc + ", y:" + strYtrunc + ", w:" + strWtrunc + ", h:" + strHtrunc + ")");
			}
			else
			{
				totalDisplayStr += a_tabStr + "(nameless)" + "::" + a_do;
				//displayStr = (a_tabStr + "(nameless)" + "::" + a_do);
			}
			
			
			if(a_tabStr == "")
			{
				totalDisplayStr += " (Top Level)";
				//displayStr += " (Top Level)";
			}
			
			var doc:DisplayObjectContainer = a_do as DisplayObjectContainer;
			
			if(doc)
			{
				totalDisplayStr += " has " + doc.numChildren + " children:\n";
				//
			}
			else
			{
				totalDisplayStr += " cannot have children.";
				//
			}
			
			if(doc)
			{
				if(doc.numChildren)
				{
					a_tabStr += "|-----";
					
					a_depthNum++;
					
					// If it has any children, display them.
					for(var i:uint = 0; i < doc.numChildren; i++)
					{
						totalDisplayStr +=  DisplayObjectUtils.showContents(doc.getChildAt(i), a_tabStr, a_depthNum);
					}
				}
			}
			
			return totalDisplayStr + "\n";
			
		}//end showContents()
		
		public static function getDisplayObjectIndex(a_do:DisplayObject):int
		{
			var depth:int = -1;
			
			if(a_do && a_do.parent)
			{
				depth = a_do.parent.getChildIndex(a_do);
			}
			return depth;
			
		}//end getDisplayObjectIndex()
		
		/**
		 * This is needed because time lined placed objects cannot be renamed.
		 * 
		 * @param	a_do
		 * @param	a_name
		 */
		public static function setDisplayObjectName(a_do:DisplayObject, a_name:String):void
		{
			if(!a_do || !a_name || !a_name.length)
			{
				throw new ArgumentError("DisplayObjectUtils::setDisplayObjectName(" + a_do + ", " + a_name + "): Bad parameter(s).");
			}
			if(!a_name)
			{
				throw new ArgumentError("DisplayObjectUtils::setDisplayObjectName(" + a_do + ", " + a_name + "): Bad parameter(s).");
			}
			if(!a_name.length)
			{
				throw new ArgumentError("DisplayObjectUtils::setDisplayObjectName(" + a_do + ", " + a_name + "): Bad parameter(s).");
			}
			
			var doParent:DisplayObjectContainer;
			if(a_do)
			{
				var doIndex:int;
				doParent = a_do .parent;
				if(doParent)
				{
					// The object has a parent, so, we must un-parent it, name it, 
					// then re-parent it in its original location.
					doIndex = doParent.getChildIndex(a_do);
					doParent.removeChild(a_do);
				}
				
				//a_do.name = a_name;
				
				/**/
				//
				try
				{
					a_do.name = a_name;
				}
				catch(e:Error)
				{
					
				}
				/**/
				
				if(doParent)
				{
					doParent.addChildAt(a_do, doIndex);
				}
				
				//a_do.name = a_name;
				
			}
		}//end setDisplayObjectName()
		
		/**
		 * This function sets the text of a_textField to a_str, and then shrinks it to fit within a_textField's
		 * original height value, so that the written text doesn't wrap outside of view.
		 * 
		 * @param	a_str:			String to use for the textfield's text value.
		 * @param	a_textField:	The textfield to set the text of within it's DisplayObject Height.
		 * @param	a_textHeight:	(Optional) The maximum height that we wish to *shrink* a_textField.textHeight to.
		 * 							If not given (or NaN passed in), the current a_textField.textHeight is used.
		 */
		public static function setTextFieldWithinHeight(a_str:String, a_textField:TextField, a_textHeight:Number = NaN):void
		{
			if (!a_str)
			{
				a_str = "";
			}
			
			if (!a_textField)
			{
				trace("DisplayObjectUtils::setTextFieldWithinHeight(): Bad parameter(s)! a_str=" + a_str 
						+ ", a_textField=" + a_textField + ", returning.");
				return;
			}
			
			var startingHeight:uint = isNaN(a_textHeight) ? a_textField.height : a_textHeight;
			
			//
			
			var tmpTextFormat:TextFormat;
			var sizeAsNum:Number;
			
			a_textField.text = a_str;
			
			while(a_textField.textHeight > startingHeight)
			{
				// Decrease the size of the text by 1, and try again.
				tmpTextFormat = a_textField.getTextFormat();
				sizeAsNum = new Number(tmpTextFormat.size);
				sizeAsNum--;
				tmpTextFormat.size = (sizeAsNum as Object);
				a_textField.setTextFormat(tmpTextFormat);
				if (sizeAsNum <= 0)
				{
					trace("DisplayObjectUtils::setTextFieldWithinHeight(): Unable to fit text within starting Height(" 
							+ startingHeight + ")!");
					break;
				}
			}
			
		}//end setTextFieldWithinHeight()
		
		public static function setTextFieldWithinWidth(a_str:String, a_textField:TextField):void
		{
			var startingWidth:uint = a_textField.width;
			
			var tmpTextFormat:TextFormat;
			var sizeAsNum:Number;
			
			a_textField.text = a_str;
			
			while(a_textField.textWidth > startingWidth)
			{
				tmpTextFormat = a_textField.getTextFormat();
				sizeAsNum = new Number(tmpTextFormat.size);
				//
				sizeAsNum--;
				//
				tmpTextFormat.size = (sizeAsNum as Object);
				a_textField.setTextFormat(tmpTextFormat);
				if (sizeAsNum <= 0)
				{
					
					break;
				}
			}
			
		}//end setTextFieldWithinWidth()
		
		public static function cloneDO(a_do:DisplayObject):DisplayObject
		{
			var displayObjBmp:Bitmap = Bitmap(a_do);
			var bmpClone:Bitmap = new Bitmap(displayObjBmp.bitmapData.clone());
			var doClone:DisplayObject = bmpClone as DisplayObject;
			//
			//
			
			return doClone;
			
		}//end cloneDO()
		
		/**
		 * Clones a_do by creating a new BitmapData and drawing a_do in that BitmapData.
		 * 
		 * @param	a_do:	DisplayObject to clone.
		 * 
		 * @return	A Bitmap created from the new BitmapData that drew a_do.
		 * 			Essentially, a clone of a DisplayObject at a particular moment.
		 */
		public static function bitmapDrawClone(a_do :DisplayObject):DisplayObject
		{
			var bmpdata:BitmapData = new BitmapData(a_do.width, a_do.height, true, 0x00000000);
			bmpdata.draw(a_do );
			var newBmp:Bitmap = new Bitmap(bmpdata);
			return newBmp;
			
		}//end bitmapDrawClone()
		
		/**
		* duplicateDisplayObject
		* creates a duplicate of the DisplayObject passed.
		* similar to duplicateMovieClip in AVM1
		* @param target the display object to duplicate
		* @param autoAdd if true, adds the duplicate to the display list
		* in which target was located
		* @return a duplicate instance of target
		*/
		static public function duplicateDisplayObject(target:DisplayObject, autoAdd:Boolean = false):DisplayObject
		{
			// create duplicate
			var targetClass:Class = Object(target).constructor;
			var duplicate:DisplayObject = new targetClass();
		 
			// duplicate properties
			duplicate.transform = target.transform;
			duplicate.filters = target.filters;
			duplicate.cacheAsBitmap = target.cacheAsBitmap;
			duplicate.opaqueBackground = target.opaqueBackground;
			if (target.scale9Grid)
			{
				var rect:Rectangle = target.scale9Grid;
				// Flash 9 bug where returned scale9Grid is 20x larger than assigned
				rect.x /= 20, rect.y /= 20, rect.width /= 20, rect.height /= 20;
				duplicate.scale9Grid = rect;
			}
		 
			// add to target parent's display list
			// if autoAdd was provided as true
			if (autoAdd && target.parent)
			{
				target.parent.addChild(duplicate);
			}
			return duplicate;
			
		}//end duplicateDisplayObject()
		
		/**
		 * Creates a clone of an object using a ByteArray to clone an object.
		 * @param	a_sourceObj: Object to clone
		 * 
		 * @return	A clone of a_sourceObj.
		 */
		public static function byteArrayClone(a_sourceObj:Object):*
		{
			var copier:ByteArray = new ByteArray();
			copier.writeObject(a_sourceObj);
			copier.position = 0;
			return(copier.readObject());
			
		}//end byteArrayClone()
		
		public static function scaleUpToFitToBounds(a_img:DisplayObject, a_boundingImg:DisplayObject, a_scope:DisplayObject):void
		{
			a_img.scaleX = a_img.scaleY = 1;
			/**
			if (a_img.scaleX >= 1 || a_img.scaleY >= 1)
			{
				// Already scaled up, exit.
				return;
			}
			/**/
			
			// Step 1: Check if the image is truly scaled, and, if so, goto step 2.
			var trueImgBounds:Rectangle = a_img.getBounds(a_scope);
			var trueBoundingImgBounds:Rectangle = a_boundingImg.getBounds(a_scope);
			
			if (trueImgBounds.width >= a_img.width && trueImgBounds.height >= a_img.height)
			{
				return;
			}
			
			// Else, the true bounds differ from the intended bounds, 
			// therefore, the image is scaled, go onto step 2.
			
			// Step 2: Find the width && height delimeters based on 
			// a_boundingImg and the full scale width && height of a_img.
			var delimitingWidth:Number = a_img.width < trueBoundingImgBounds.width ? a_img.width : trueBoundingImgBounds.width;
			var delimitingHeight:Number = a_img.height < trueBoundingImgBounds.height ? a_img.height : trueBoundingImgBounds.height;
			
			// Step 3: Use the delimiter that yields the smallest increase in scale, and use it to scale up the image.
			var scaleUpByWidth:Number = delimitingWidth / trueImgBounds.width;
			var scaleUpByHeight:Number = delimitingHeight / trueImgBounds.height;
			
			var delimitingScaleUp:Number = scaleUpByWidth < scaleUpByHeight ? scaleUpByWidth : scaleUpByHeight;
			
			a_img.scaleX *= delimitingScaleUp;
			a_img.scaleY *= delimitingScaleUp;
			
		}//end scaleUpToFitToBounds()
		
		public static function radiusOfDO(a_do:DisplayObject):Number
		{
			var halfOfWidth:Number = a_do.width * 0.5;
			var halfOfHeight:Number = a_do.height * 0.5;
			
			return (Math.sqrt((halfOfWidth * halfOfWidth) + (halfOfHeight * halfOfHeight)));
			
		}//end radiusOfDO()
		
		public static function radiusSquaredOfDO(a_do :DisplayObject):Number
		{
			var halfOfWidth:Number = a_do.width * 0.5;
			var halfOfHeight:Number = a_do.height * 0.5;
			
			return ((halfOfWidth * halfOfWidth) + (halfOfHeight * halfOfHeight));
		}//end radiusSquaredOfDO
		
		/**
		 * Determines whether two DisplayObjects are colliding (if a_bBoundCheck), or whether their centers
		 * are within a specific distance of one another.
		 * 
		 * @param	a_do1:				DisplayObject to check if it's within distance of a_do2.
		 * @param	a_do2:				DisplayObject to check if it's within distance of a_do2.
		 * @param	a_bBoundsCheck:		Determines whether the bounds of the two objects are colliding.
		 * 									If true, this value takes priority over a_distance.
		 * 									If false and a_distance is also undefined, a_distance is equal to
		 * 									the sum of the radius of both objects.
		 * @param	a_distance:			If defined, the distance between the centers of the two DisplayObjects
		 * 									that the DisplayObjects must be less than in order to return true.
		 * @return
		 */
		public static function areWithinDistance(a_do1:DisplayObject, a_do2:DisplayObject, 
													a_bBoundsCheck:Boolean = true, a_distance:Number = NaN):Boolean
		{
			//
			
			if (!a_do1 || !a_do2 || !a_do1.stage || !a_do2.stage)
			{
				throw new ArgumentError("DisplayObjectUtils::areWithinDistance(" + a_do1 + ", " 
										+ a_do2 + ", " + a_distance + ", " + a_bBoundsCheck + "): BAD PARAMETERS!");
			}
			
			var scope:DisplayObject = a_do1.stage ? a_do1.stage : a_do2.stage;
			
			// get bounds:
			var bounds1:Rectangle = a_do1.getBounds(scope);
			var bounds2:Rectangle = a_do2.getBounds(scope);
			
			if (a_bBoundsCheck)
			{
				return bounds1.intersects(bounds2);
			}
			
			var distanceToCheckSquared:Number;
			
			if (isNaN(a_distance))
			{
				// a_bBoundsCheck is false and a_distance is undefined.
				// Set a_distance equal to the sum of both DisplayObjects' radii.
				distanceToCheckSquared = DisplayObjectUtils.radiusSquaredOfDO(a_do1) + DisplayObjectUtils.radiusSquaredOfDO(a_do2);
			}
			else
			{
				distanceToCheckSquared = a_distance * a_distance;
			}
			
			// Determine if the centers of the two DisplayObjects are within a_distance from each other.
			var distanceBetweenCentersSquared:Number;
			
			var do1Center:virtualworlds.com.smerc.utils.math.Vector = new virtualworlds.com.smerc.utils.math.Vector(bounds1.x + (bounds1.width / 2), 
																						bounds1.y + (bounds1.height / 2));
			var do2Center:virtualworlds.com.smerc.utils.math.Vector = new virtualworlds.com.smerc.utils.math.Vector(bounds2.x + (bounds2.width / 2), 
																						bounds2.y + (bounds2.height / 2));
			
			distanceBetweenCentersSquared = do1Center.distSquared(do2Center);
			
			return (distanceBetweenCentersSquared <= distanceToCheckSquared);
			
		}//end areWithinDistance()
		
		/**
		 * Scales a DisplayObject so that it is of the specified area.
		 * 
		 * @param	a_dispObj:		<DisplayObject> The object to scale up/down.
		 * @param	a_desiredArea:	<Number> The desired area of the DisplayObject, in pixels.
		 */
		public static function scaleToArea(a_dispObj:DisplayObject, a_desiredArea:Number):void
		{
			if (!a_dispObj || isNaN(a_desiredArea) || a_desiredArea <= 0)
			{
				throw new ArgumentError("DisplayObjectUtils::scaleToArea(): a_dispObj=" + a_dispObj + ", a_desiredArea=" + a_desiredArea);
			}
			
			var aspectRatio:Number = a_dispObj.width / a_dispObj.height;
			a_dispObj.width = Math.sqrt(a_desiredArea * aspectRatio);
			a_dispObj.scaleY = a_dispObj.scaleX;
			
		}//end scaleToArea()
		
		/**
		 * Top-left registers a DisplayObject.
		 * <br /><br /><b>NOTE:</b> This shifts the object's x and y by the amount that it's shifted within itself.
		 * It does NOT shift the contents of this object, since shapes created in CS3 are not acquirable by iterating
		 * through an object's children.
		 * 
		 * @param	a_dispObj:	<DisplayObject> To top-left register.
		 */
		public static function topLeftRegister(a_dispObj:DisplayObject):void
		{
			if (!a_dispObj)
			{
				throw new ArgumentError("DisplayObjectUtils::topLeftRegister(): a_dispObj=null!");
			}
			
			// Get the bounds within itself, that is, its true bounds.
			var selfBounds:Rectangle = a_dispObj.getBounds(a_dispObj);
			var amtToShift:Point = new Point( -selfBounds.x, -selfBounds.y);
			
			// Shift the objects by the amount to shift multiplied by the object's scale, to shift it the correct amount.
			a_dispObj.x += (amtToShift.x * a_dispObj.scaleX);
			a_dispObj.y += (amtToShift.y * a_dispObj.scaleY);
			
		}//end topLeftRegister()
		
		/**
		 * Center-registers a DisplayObject.
		 * <br /><br /><b>NOTE:</b> This shifts the object's x and y by the amount that it's shifted within itself.
		 * It does NOT shift the contents of this object, since shapes created in CS3 are not acquirable by iterating
		 * through an object's children.
		 * 
		 * @param	a_dispObj:	<DisplayObject> To top-left register.
		 */
		public static function centerRegister(a_dispObj:DisplayObject):void
		{
			if (!a_dispObj)
			{
				throw new ArgumentError("DisplayObjectUtils::centerRegister(): a_dispObj=null!");
			}
			
			// Get the bounds within itself, that is, its true bounds.
			var selfBounds:Rectangle = a_dispObj.getBounds(a_dispObj);
			var amtToShift:Point = new Point( -(selfBounds.x + (selfBounds.width * .5)), -(selfBounds.y + (selfBounds.height * .5)));
			
			// Shift the objects by the amount to shift multiplied by the object's scale, to shift it the correct amount.
			a_dispObj.x += (amtToShift.x * a_dispObj.scaleX);
			a_dispObj.y += (amtToShift.y * a_dispObj.scaleY);
			
		}//end centerRegister()
		
		/**
		 * Rotates the matrix of a DisplayObject about a point internal to it.
		 * @param	m:				<Matrix> of the DisplayObject to rotate.
		 * @param	x:				<Number> x-position internal to the DisplayObject.
		 * @param	y:				<Number> y-position internal to the DisplayObject.
		 * @param	angleDegrees:	<Number> Angle to rotate the DisplayObject.
		 */
		public static function rotateAroundInternalPoint(m:Matrix, x:Number, y:Number, angleDegrees:Number):void
		{		
			var p:Point = m.transformPoint(new Point(x, y));
			rotateAroundExternalPoint(m, p.x, p.y, angleDegrees);
			
		}//end rotateAroundInternalPoint()
		
		/**
		 * Rotates the matrix of a DisplayObject about a point external to it.
		 * @param	m:				<Matrix> of the DisplayObject to rotate.
		 * @param	x:				<Number> x-position external to the DisplayObject.
		 * @param	y:				<Number> y-position external to the DisplayObject.
		 * @param	angleDegrees:	<Number> Angle to rotate the DisplayObject.
		 */
		public static function rotateAroundExternalPoint(m:Matrix, x:Number, y:Number, angleDegrees:Number):void
		{
			m.translate(-x, -y);
			m.rotate(angleDegrees*(Math.PI/180));
			m.translate(x, y);
			
		}//end rotateAroundExternalPoint()
		
		/********************************************/
		/** START OF GSKINNER'S COLLISIONDETECTION **/
		/********************************************/
		private static var _clip1Parent:DisplayObjectContainer;
		private static var _clip1OrigLocation:Point;
		private static var _clip1IndexOfParent:int;
		private static var _newClip1Location:Point
		
		private static var _clip2Parent:DisplayObjectContainer;
		private static var _clip2OrigLocation:Point;
		private static var _newClip2Location:Point;
		private static var _clip2IndexOfParent:int;
		
		private static var _bReparented:Boolean = false;
		
		private static var _globalContainer:DisplayObjectContainer;
		
		static public function checkForCollision(p_clip1:DisplayObject, p_clip2:DisplayObject, 
													p_alphaTolerance:Number = 255, 
													p_scope:DisplayObjectContainer = null):Rectangle
		{
			var validStage:Stage;
			
			if(!p_clip1 || !p_clip2)
			{
				//throw new Error("DisplayObjectUtils::checkForCollision(" + p_clip1 + ", " + p_clip2 
									//+ "): Error - DOs are null!!!");
				//
				return null;
			}
			
			if(!p_scope)
			{
				validStage = p_clip1.stage ? p_clip1.stage : p_clip2.stage;
				p_scope = validStage;
			}
			
			/**
			_bReparented = false;
			
			if( a_bReparent && (p_clip1.parent != p_clip2.parent) )
			{
				reparentToStage(p_clip1, p_clip2);
			}
			/**/
			
			// get bounds:
			var bounds1:Rectangle = p_clip1.getBounds(p_scope);
			var bounds2:Rectangle = p_clip2.getBounds(p_scope);
			// rule out anything that we know can't collide:
			if (!bounds1.intersects(bounds2))
			{
				/**
				//
				if(_bReparented)
				{
					DisplayObjectUtils.reparentToOriginals(p_clip1, p_clip2);
				}
				/**/
				//
				return null;
			}
			
			// determine test area boundaries:
			var bounds:Rectangle = bounds1.intersection(bounds2);
			
			// set up the image to use:
			try
			{
				var img:BitmapData = new BitmapData(bounds.width, bounds.height, false);
			}
			catch(error:Error)
			{
				/**
				//
				if(_bReparented)
				{
					DisplayObjectUtils.reparentToOriginals(p_clip1, p_clip2);
				}
				/**/
				//
				return null;
			}
			
			// draw in the first image:
			var p_clip1Pt:Point = p_clip1.localToGlobal(new Point());
			var mat:Matrix = p_clip1.transform.matrix;
			mat.tx = p_clip1Pt.x-bounds.left;
			mat.ty = p_clip1Pt.y-bounds.top;
			img.draw(p_clip1,mat, new ColorTransform(1,1,1,1,255,-255,-255,p_alphaTolerance));
			
			// overlay the second image:
			var p_clip2Pt:Point = p_clip2.localToGlobal(new Point());
			mat = p_clip2.transform.matrix;
			mat.tx = p_clip2Pt.x-bounds.left;
			mat.ty = p_clip2Pt.y-bounds.top;
			img.draw(p_clip2,mat, new ColorTransform(1,1,1,1,255,255,255,p_alphaTolerance),"difference");
			
			// find the intersection:
			var intersection:Rectangle = img.getColorBoundsRect(0xFFFFFFFF,0xFF00FFFF);
			
			// if there is no intersection, return null:
			if (intersection.width == 0)
			{
				/**
				//
				if(_bReparented)
				{
					DisplayObjectUtils.reparentToOriginals(p_clip1, p_clip2);
				}
				/**/
				//
				return null;
			}
			
			// translate the intersection to the appropriate coordinate space:
			intersection.x += bounds.left;
			intersection.y += bounds.top;
			
			/**
			if(_bReparented)
			{
				DisplayObjectUtils.reparentToOriginals(p_clip1, p_clip2);
			}
			/**/
			//
			return intersection;
			
		}//end checkForCollision()
		
		/**/
		/******************************************/
		/** END OF GSKINNER'S COLLISIONDETECTION **/
		/******************************************/
		
	}//end class DisplayObjectUtils
	
}//end package com.smerc.utils.DisplayObject
