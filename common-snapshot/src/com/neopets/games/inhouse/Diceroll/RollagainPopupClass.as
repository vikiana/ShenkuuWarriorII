//Marks the right margin of code *******************************************************************
package com.neopets.games.inhouse.Diceroll
{
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * public class RollagainPopupClass extends GenericScreenClass
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class RollagainPopupClass extends GenericScreenClass
	{
		//--------------------------------------------------------------------------
		// Costants
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		//--------------------------------------------------------------------------
		//Public properties
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		public var btn_rollAgain:SimpleButton; //on stage
		public var txt_btn_rollagain:TextField; //on stage
		
		
		public var txt_error_msg: TextField; //on stage
		public var str_error: String = "";
		//--------------------------------------------------------------------------
		//Private properties
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Creates a new public class RollagainPopupClass extends GenericScreenClass instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function RollagainPopupClass()
		{
			super();
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------
		public function init() {
			btn_rollAgain.addEventListener(MouseEvent.CLICK, mouseClicked,false,0,true);
			tManager.setTextField(txt_btn_rollagain, tData.IDS_BUTTON_ROLLAGAIN);			
			tManager.setTextField(txt_error_msg, tData.IDS_ROLLAGAIN);		
			txt_btn_rollagain.mouseEnabled = false;
		}
		
		
		/**
		 * Description
		 * @param  value  of type <code>CustomClass</code> 
		 */
		public function setErrorMsg(p_str:String=""):void {
			if (p_str.length > 1) {				
				str_error = p_str;
			} else {
				str_error = tData.IDS_ERROR_MSG
			}			
			tManager.setTextField(txt_error_msg, str_error);			
			
		}
		//--------------------------------------------------------------------------
		// Protected Methods
		//--------------------------------------------------------------------------	
		//--------------------------------------------------------------------------
		// Private Methods
		//--------------------------------------------------------------------------	

		//--------------------------------------------------------------------------
		// Event Handlers
		//--------------------------------------------------------------------------	
		/**
		 * Handler for CustomEvent.
		 * 
		 * @param event The <code>CustomEvent</code>
		 * 
		 */
		//--------------------------------------------------------------------------
		// Getters/Setters
		//--------------------------------------------------------------------------
	}
}