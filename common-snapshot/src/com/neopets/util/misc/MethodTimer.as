package com.neopets.util.misc
{
    import flash.utils.getTimer;
    
    public class MethodTimer
    {
        //disable by default, in case compiled from somewhere else
        //IE: production vs. development
        public static var enabled:Boolean = false;
        
        private var name:String;
        private var start:int;
        private var end:int;
        private var time:int;            
            
        public function MethodTimer( methodName:String )
        {
            if ( enabled ) {
                name = methodName;
                start = getTimer();
            }
        }
        
        public function stop() : int 
        {
            if ( enabled ) {
                end = getTimer();
                time = end - start;
                
                return time;
            } else {
                return 0;
            }
        }
        
        /**
        * Convenience method stops timer and returns formatted output
        */
        public function stopAndPrint() : String
        {
            var str:String = null;
            if ( enabled ) {
                str = name + "...[tm: " + stop() + "ms]";
                trace( str );
            } 
            return str;
        }
    }
}