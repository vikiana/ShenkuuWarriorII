package virtualworlds.helper
{
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import virtualworlds.com.smerc.utils.events.ObjectEvent;
	
	/**
	* GameVars is a singleton class meant to be used as storage for data that needs to be globally accessible.
	*   Changes or Creation of data will be made known by an event of type equal to the name of the data being dispatched
	* @author Alex
	* @usage GameVars.instance
	* @example 
	* <pre>	
	* 	var dataName:String = "myDataName";
	* 	var data:Object = {test: true};
	*
	* 	GameVars.instance.addEventListener(dataName, MyDataChanged);
	* 	GameVars.instance.data("myDataName", testData); 
	* 
	* 	private function MyDataChanged(evt:Event):void{
	* 		
	* 	}
	* </pre>
	* 
	*/
	public class GameVars extends EventDispatcher
	{
		
		private var _dictionary:Dictionary = new Dictionary;
		//private var _dispatcher:EventDispatcher = new EventDispatcher;
		private static var _instance:GameVars;
		
		/**
		 * Constructor, use GameVars.instance
		 */
		public function GameVars() 
		{
			if (_instance)
			{
				throw(new Error("GameVars is a singleton ... use GameVars.instance"));
			}
			
		}
		
		/**
		 * Returns Object stored at dataName, returns null if dataName is not specified
		 * @param	dataName String reference to data
		 */
		public function getData(dataName:String):Object
		{
			return _dictionary[dataName];
		}
		
		
		/**
		 * Adds or sets data at dataName.
		 * This dispatches an ObjectEvent where the Event.type == dataName, and the ObjectEvent's _obj is data.
		 * 
		 * @param	dataName String reference to data
		 * @param	data Object 
		 * 
		 * @see com.smerc.utils.events.ObjectEvent
		 */
		public function setData(dataName:String, data:Object):void
		{
			_dictionary[dataName] = data;
			dispatchEvent(new ObjectEvent(dataName, data));
		}
		
		
		/**
		 * Returns singleton instance of the GameVars class
		 */
		static public function get instance():GameVars { 
			if (!_instance)
				_instance = new GameVars;
			return _instance; 
		}
		
	}
	
}