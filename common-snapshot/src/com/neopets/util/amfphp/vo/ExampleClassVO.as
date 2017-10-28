//Marks the right margin of code *******************************************************************
package com.neopets.util.amfphp.vo
{
	import com.neopets.projects.np10.vo.AbstractVO;
	
	/**
	 * This is an example of an AS vo class to be mapped for AMFPHP services.
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2010</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class ExampleClassVO extends AbstractVO
	{

		//--------------------------------------------------------------------------
		//Public properties
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		public var exampleVar:String = "";
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Creates a new public class AbstractVO instance.
		 * 
		 */
		public function ExampleClassVO()
		{
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		/**
		 * Registers this VO as a remote class.
		 * 
		 * @param  remoteClass  String   name of the PHP vo class corresponding to this one. This will include the corresponding PHP package.classname. 
		 */
		public static function register(remoteClass:String):void
		{	
			registerClassAlias(remoteClass, com.neopets.util.amfphp.vo.ExampleClassVO);		
		}
	}
}