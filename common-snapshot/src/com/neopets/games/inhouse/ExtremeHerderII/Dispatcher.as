package com.neopets.games.inhouse.ExtremeHerderII
{
    //===============================================================================
	// IMPORTS
	//===============================================================================
    import flash.events.Event;
    import flash.events.EventDispatcher;
    
    /* import mx.events.PropertyChangeEvent;
    import mx.events.PropertyChangeEventKind; */

    public class Dispatcher
    {
        static protected var __dispatcher:EventDispatcher;

        static public function addEventListener(eventName:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakRef:Boolean = false):void
        {
                if (__dispatcher == null)
                        __dispatcher = new EventDispatcher();

                __dispatcher.addEventListener(eventName, listener, useCapture, priority, useWeakRef);
        }

        static public function removeEventListener(eventName:String, listener:Function, useCapture:Boolean = false):void
        {
                __dispatcher.removeEventListener(eventName, listener, useCapture);
        }
        
        static public function hasEventListener( eventName : String ):Boolean
        {
        	if( __dispatcher.hasEventListener( eventName ) )
        	{
        		return true;
        	}
        	
        	return false;          

        }

        static public function dispatchEvent(event:Event):Boolean
        {
                if (__dispatcher == null)
                        __dispatcher = new EventDispatcher();
                
                return __dispatcher.dispatchEvent(event);
        }

        /* static public function run(eventName:String, data:Object = null):void
        {
                dispatchEvent(new FakeEvent(eventName, data));
        }
        
        static public function dispatchPropertyChange( bubbles:Boolean = false, 
        											   property:Object = null, 
        											   oldValue:Object = null, 
        											   newValue:Object = null, 
        											   source:Object = null):Boolean
        {                
                return dispatchEvent(new PropertyChangeEvent("propertyChange",bubbles,false,PropertyChangeEventKind.UPDATE,property,oldValue,newValue,source));
        } */
    }
}
