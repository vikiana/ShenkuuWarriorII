//Marks the right margin of code *******************************************************************
package virtualworlds.com.neopets.games.petpetpark.vo
{
	/**
	 * Generic message data. Used to display errors and other messages
	 * using the <code>GenericPopup</code> class.
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>02/05/2008</td><td>chrisa</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	*/
	public class MessageVO
	{

		/**
		 * The header string to display.
		 */
		 public var header : String;

		/**
		 * The body string to display.
		 */
		 public var body : String;

		/**
		 * Whether or not to show the close button.
		 */
		 public var showClose : Boolean;

		/**
		 * Whether or not to show the accept button.
		 */
		 public var showAccept : Boolean;

		/**
		 * Whether or not to show the cancel button.
		 */
		 public var showCancel : Boolean;

		/**
		 * The string to display for the accept button.
		 */
		 public var acceptLabel : String;

		/**
		 * The string to display for the cancel button.
		 */
		 public var cancelLabel : String;

		/**
		 * Event handler that is called when the accept button is pressed.
		 */
		 public var acceptFunction : Function;

		/**
		 * Event handler that is called when the cancel button is pressed.
		 */
		 public var cancelFunction : Function;

	}

}