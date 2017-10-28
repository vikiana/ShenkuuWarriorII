
/* AS3
	Copyright 2008
*/

package com.neopets.projects.neopetsGameShell.model
{
	
	/**
	 *	This is a Static List of URL Locations used for DATA Area.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern MVC
	 * 
	 *	@author Clive Henrick
	 *	@since  12.04.2008
	 */
	public class ProjectInfo
	{
		
		public static const ERROR_XML:XML = 
	<ITEM>
			<ASSETNAME>noimage.png</ASSETNAME>
			<URL>http://s2.thisnext.com/img/myspace/wish-list/error/</URL>
			<SOUND>false</SOUND>
			<ID>ERROR_IMAGE</ID>
			<DATA></DATA>
	</ITEM>;
	
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function ProjectInfo():void
		{
			trace("ProjectInfo Should Never Be Instantiated");
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		
	}
	
}
