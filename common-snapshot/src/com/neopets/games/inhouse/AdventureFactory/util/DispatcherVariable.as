package com.neopets.games.inhouse.AdventureFactory.util
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	import com.neopets.games.inhouse.AdventureFactory.util.ValueChangeEvent;
	
	/**
	 *	This class lets you set up a variable so it broadcasts an event whenever it changes.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since 3.11.2010
	 */
	 
	public class DispatcherVariable extends EventDispatcher
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE / PROTECTED VARIABLES
		//--------------------------------------
		protected var _classDef:Object;
		protected var _value:Object;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		public function DispatcherVariable(def:Object=null,val:Object=null) {
			_classDef = def;
			_value = val;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get classDef():Object { return _classDef; }
		
		public function get value():Object { return _value; }
		
		public function set value(val:Object) {
			// create change event
			var ev:ValueChangeEvent = new ValueChangeEvent(Event.CHANGE);
			ev.previousValue = _value;
			// change value
			if(_classDef != null) _value = _classDef(val);
			else _value = val;
			ev.newValue = _value;
			// broadcast change event
			dispatchEvent(ev);
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		public function valueOf():Object { return _value; }
	
	}
}