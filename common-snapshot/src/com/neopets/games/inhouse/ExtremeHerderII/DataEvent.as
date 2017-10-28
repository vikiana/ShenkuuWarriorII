package com.neopets.games.inhouse.ExtremeHerderII
{
	//===============================================================================
	// IMPORTS
	//===============================================================================
    import flash.events.Event;

    public class DataEvent extends Event
    {
        public var mData   : Object;
        public var mParent : Object;

        public function DataEvent( pType   : String = "", 
        							 pData   :Object = null, 
        							 pParent :Object = null, bubbles : Boolean = true, cancelable : Boolean = false)
        {
                super( pType, bubbles, cancelable );

                this.mData = pData;
        }
    }
}