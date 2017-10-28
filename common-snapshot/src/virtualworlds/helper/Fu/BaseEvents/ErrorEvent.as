//Marks the right margin of code *******************************************************************
package virtualworlds.helper.Fu.BaseEvents
{
	import flash.events.Event;
	
	/**
	 * Event dispatched due to an error. 
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>03/30/2009</td><td>chrisa</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	*/
	public class ErrorEvent extends Event
	{
		
		 /**
		 * The header string to display (error message).
		 * 
		*/	
		public var header : String;
		
		 /**
		 * The body string to display (error message).
		 * 
		*/	
		public var body : String;
		
		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
		/**
		 * Creates a new ErrorEvent instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * @param type The type of Event.
		 * @param bubbles Indicates whether an event is a bubbling event..
		 * @param cancelable Indicates whether the behavior associated with the event can be prevented.
		 * @param headerString The header to display.
		 * @param bodyString The message to display.
		 * 
		*/
		public function ErrorEvent(type:String, headerString:String, bodyString:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type,bubbles, cancelable);
			header = headerString;
			body = bodyString;
		}
		
	}
}