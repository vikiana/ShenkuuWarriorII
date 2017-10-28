package com.neopets.util.data
{
	import flash.system.ApplicationDomain;
	
	public class EmbedObjectData extends Object
	{
		public var mClass:Class;
		public var mEmdedClass:Class;
		public var mApplicationDomain:ApplicationDomain;
		public var mInstance:*;
		
		public function EmbedObjectData(pClass:Class,pEmdedClass:Class, pApplicationDomain:ApplicationDomain,pInstance:* = null):void
		{
			mClass= pClass;
			mEmdedClass = pEmdedClass;
			mApplicationDomain = pApplicationDomain;
			mInstance = pInstance;
		}

	}
}