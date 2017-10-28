package virtualworlds.com.neopets.games.petpetpark.util
{
	import flash.utils.getQualifiedClassName;
	
	import virtualworlds.com.smerc.utils.string.StringUtils;
	
	/**
	* An object used to extend and quickly deserialize an object 
	* returned from the SmartFoxServer for the PetPetPark application.
	* 
	* @author Bo
	*/
	public class PppObject
	{
		/**
		 * Our storage Object for all the attributes of this instance.
		 */
		protected var _attribs:Object;
		
		/**
		 * An array of attribute names for this instance.
		 */
		protected var _attributeNames:Array;
		
		/**
		 * Constructs a new instance of the _attribs and _attributeNames.
		 */
		public function PppObject()
		{
			_attribs = new Object();
			
			_attributeNames = new Array();
			
		}//end PppObject()
		
		/**
		 * 
		 * @param	a_attribName:	<String> Attribute-name to add.
		 */
		protected final function addAttributeName(a_attribName:String):void
		{
			if (undefined == _attribs[a_attribName])
			{
				_attribs[a_attribName] = new Object();
			}
			
			_attributeNames.push(a_attribName);
			
		}//end addAttributeName()
		
		/**
		 * Returns the value with the specified attribute name.
		 * 
		 * @param	a_attribName:	<String> Attribute-name.
		 * @return	<Object> Instance value of the specified attribute.
		 */
		public final function getAttribute(a_attribName:String):Object
		{
			return _attribs[a_attribName];
			
		}//end getAttribute()
		
		/**
		 * Sets the value for a specified attribute.
		 * 
		 * @param	a_attribName:	<String> Attribute name.
		 * @param	a_val:			<Object> value to store for this Attribute.
		 */
		public function setAttribute(a_attribName:String, a_val:Object):void
		{
			_attribs[a_attribName] = a_val;
			
		}//end setAttribute()
		
		/**
		 * Deserializes an object from the SmartFoxServer, storing our attributes along the way.
		 * This function must be called with a serialized object of this type in order for this 
		 * instance's attributes to be set.
		 * 
		 * @param	a_serializedObj:	<Object> A serialized object passed to us 
		 * 								from a SmartFoxServer's response.
		 */
		public function deserializeFrom(a_serializedObj:Object):void
		{
			for (var i:int = 0; i < _attributeNames.length; i++)
			{
				var myAttrib:String = _attributeNames[i] as String;
				
				if (undefined == a_serializedObj[myAttrib])
				{
					continue;
				}
				
				_attribs[myAttrib] = new int(a_serializedObj[myAttrib]);
			}
			
		}//end deserializeFrom()
		
		/**
		 * 
		 * @return	<String> representation of this instance, including 
		 * 			all of its attributes and attributes' values.
		 */
		public function toString():String
		{
			var attributeStr:String = StringUtils.getStrFromDynamic(_attribs);
			var myQName:String = getQualifiedClassName(this);
			
			var attributeList:String = "";
			var attribName:String;
			
			for (var i:int = 0; i < _attributeNames.length; i++)
			{
				attribName = _attributeNames[i] as String;
				if (!attribName)
				{
					continue;
				}
				
				attributeList += " " + attribName + "=" + _attribs[attribName];
			}
			
			return "[ " + myQName + attributeList + " ]";
			
		}//end toString()
		
	}//end class PppObject
	
}//end package com.smerc.ppa.core.objects
