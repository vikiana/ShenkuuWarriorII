//Marks the right margin of code *******************************************************************

package com.neopets.util.template 
{
	// IMPORTS
	import flash.events.Event;
	
	
	/**
	 * Description of the class.
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	*/
	public class TemplateClass
	{
	    //--------------------------------------------------------------------------
	    //Class constants
	    //--------------------------------------------------------------------------	
	    /**
         * Sample static constant.
         * 
         * @default sampleConstant 
        */
        public static const SAMPLE_CONSTANT : String = "sampleConstant";
       
        //--------------------------------------------------------------------------
	    //Private properties
	    //--------------------------------------------------------------------------	
		/**
		 * Getter and setter for the sample variable.
		 * 
		*/		
        public function get sampleVariable ( ) : String { return _sampleVariable; }
        public function set toolbar (value:String ) : void { _sampleVariable=value; }
        private var _sampleVariable : String;
        
		//--------------------------------------------------------------------------
	    //Public properties
	    //--------------------------------------------------------------------------	
		public var sampleVariable2 : String;
		
		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
		/**
		 * Creates a new TemplateClass instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * @param aViewComponent A sample object passed into the constructor.
		 * 
		*/
		public function TemplateClass(aData:Object)
		{
			super();
			
		}

	    //--------------------------------------------------------------------------
	    //Methods
	    //--------------------------------------------------------------------------	
	    
	    //public 
	    /**
		 * A sample public method.
		 */
		public function sampleMethod():String
		{
			return "sample method called";	
		}
				
		// private
		
	    /**
		 * A sample private method.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		*/
	    private function samplePrivateMethod( ) : void
	    {
	    	
		}
	    
	    //--------------------------------------------------------------------------
	    //Events
	    //--------------------------------------------------------------------------	
	    /**
		 * Handles a sample event.
		 * @param The Notification to process.
		 */
		public function onSampleEventHandler(event:Event):void
		{
			
		}
		
	 }
}