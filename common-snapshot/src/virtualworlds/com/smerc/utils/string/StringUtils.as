/**
* ...
* @author Bo
* @version 0.1
*/

package virtualworlds.com.smerc.utils.string
{
	import flash.utils.getQualifiedClassName;
	
	public class StringUtils
	{
		/**
		 * For use with getStringFromDynamicObj()
		 */
		private static var _objQName:String = getQualifiedClassName(new Object());
		
		private static var _arrQName:String = getQualifiedClassName(new Array());
		
		/**
		 * 
		 * 
		 * @param	a_strToStrip:			A string to strip characters from.  This is unmodified.
		 * @param	a_arrOfCharsToStrip:	Array of characters to strip from a_strToStrip. If null,
		 * 									the default array == ["'", "\"", "\\", ";", "/", "<", ">", "[", "]", "\\\\"]
		 * 
		 * @return	A copy of a_strToStrip with the characters within a_arrOfCharsToStrip stripped from it.
		 */
		public static function stripFromString(a_strToStrip:String, a_arrOfCharsToStrip:Array = null):String
		{
			var charToRemove:String;
			var strippedArr:Array;
			var strToStrip:String = new String(a_strToStrip);
			
			if(!a_arrOfCharsToStrip)
			{
				a_arrOfCharsToStrip = ["'", "\"", "\\", ";", "/", "<", ">", "[", "]", "\\\\"];
			}
			
			for(var i:uint = 0; i < a_arrOfCharsToStrip.length; i++)
			{
				charToRemove = a_arrOfCharsToStrip[i];
				strippedArr = strToStrip.split(new RegExp(charToRemove, "gm"));
				strToStrip = strippedArr.join("");
			}
			
			return strToStrip;
			
		}//end stripFromString()
		
		/**
		 * This returns a string representation of a dynamic object, including its internal attributes/objects.
		 * 
		 * @param	a_obj:		A dynamic Object that we're to recursively trace.
		 * 
		 * @return A String representation of the dynamic object.
		 */
		public static function getStrFromDynamic(a_obj:Object):String
		{
			var topLevelDesc:String;
			
			topLevelDesc = "Object is of type=" + getQualifiedClassName(a_obj) + " with contents:\n";
			topLevelDesc += getStringFromDynamicObj(a_obj);
			return topLevelDesc;
			
		}//end getStrFromDynamic()
		
		/**
		 * This returns a string representation of a dynamic object, including its internal attributes/objects.
		 * NOTE: This does *not* display the details of the top-level of this object.
		 * 
		 * @param	a_obj:		A dynamic Object that we're to recursively trace.
		 * @param	a_numTabs:	Starting number of tabs for the tracing of each object/attribute within a_obj.
		 * 
		 * @return A String representation of the dynamic object.
		 */
		public static function getStringFromDynamicObj(a_obj:Object, a_numTabs:int = 0, objName:String = null):String
		{
			var outputStr:String = "";
			
			var tabsStr:String = "";
			
			var valueQName:String;
			
			for (var i:int = 0; i < a_numTabs; i++)
			{
				tabsStr += "\t";
			}
			
			if (!objName)
			{
				objName = "a_obj";
			}
			
			for (var elementName:String in a_obj)
			{
				valueQName = getQualifiedClassName(a_obj[elementName]);
				if (valueQName == _objQName || valueQName == _arrQName)
				{
					outputStr += tabsStr + objName + "[\"" + elementName + "\"]=" + valueQName + ":\n";
					var internalObjName:String = (objName + "[\"" + elementName + "\"]");
					outputStr += getStringFromDynamicObj(a_obj[elementName], 0, internalObjName);
				}
				else if (a_obj[elementName] && a_obj[elementName].toString)
				{
					outputStr += tabsStr + objName + "[\"" + elementName + "\"]=\"" + (a_obj[elementName].toString()) + "\"";
					outputStr += "\n";
				}
				else
				{
					outputStr += tabsStr + objName + "[\"" + elementName + "\"]=" + (a_obj[elementName]);
					outputStr += "\n";
				}
			}
			
			return outputStr;
			
		}//end getStringFromDynamicObj()
		
	}//end class StringUtils
	
}//end package com.smerc.utils.String
