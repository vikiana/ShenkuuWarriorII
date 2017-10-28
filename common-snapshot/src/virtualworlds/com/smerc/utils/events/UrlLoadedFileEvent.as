package virtualworlds.com.smerc.utils.events
{
	import flash.events.Event;
	
	
	/**
	* Contains an object that represents a loaded File of text, binary data, or URL-encoded variables.
	* 
	* @author Bo
	*/
	public class UrlLoadedFileEvent extends Event
	{
		private var _fileObj:Object;
		
		/**
		 * Constructor.
		 * 
		 * @param	type:		As Event's.
		 * @param	a_fileObj:	The URL-loaded object.
		 * @param	bubbles:	As Event's.
		 * @param	cancelable:	As Event's.
		 */
		public function UrlLoadedFileEvent(type:String, a_fileObj:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			
			_fileObj = a_fileObj;
			
		}//end UrlLoadedFileEvent() constructor.
		
		/**
		 * getter for acquiring the URL-loaded object.
		 */
		public function get fileObj():Object
		{
			return _fileObj;
		}//end get fileObj()
		
		/**
		 * For proper clean-up.
		 * 
		 * @param	...args
		 */
		public function destroy(...args):void
		{
			_fileObj = null;
		}//end destroy()
		
		override public function clone():Event
		{
			return new UrlLoadedFileEvent(this.type, _fileObj, this.bubbles, this.cancelable);
		}//end clone()
		
	}//end class UrlLoadedFileEvent
	
}//end package src.com.smerc.utils.file.events
