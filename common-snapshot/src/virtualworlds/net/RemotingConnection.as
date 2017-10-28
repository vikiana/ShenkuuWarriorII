//Marks the right margin of code *******************************************************************
package virtualworlds.net
{
	
    import flash.events.AsyncErrorEvent;
    import flash.events.IOErrorEvent;
    import flash.events.NetStatusEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.NetConnection;
    import flash.net.ObjectEncoding;
    
	/**
	 * RemotingConnection for amfphp services.
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>chrisa</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	*/
    public class RemotingConnection extends NetConnection
	{
	
	    public function RemotingConnection( sURL:String )
	    {
            objectEncoding = ObjectEncoding.AMF3;
            
            if (sURL) connect( sURL );
            
            addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            addEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
            addEventListener(AsyncErrorEvent.ASYNC_ERROR , aSyncErrorHandler);            
            addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
        }
        
        		
		//--------------------------------------------------------------------------
		//Methods
		//--------------------------------------------------------------------------	
		// public 
		
        // private
	   
		//--------------------------------------------------------------------------
	    //Events
	    //--------------------------------------------------------------------------	
		public function netStatusHandler( aNetStatusEvent : NetStatusEvent ) : void
        {
			trace ("netStatusEvent: " + aNetStatusEvent);
        }
       
        public function IOErrorHandler( s : String ) : void
        {
			trace ("RemotingConnection.IOErrorHandler: " + s);
        }
        public function aSyncErrorHandler( s : String ) : void
        {
            trace ("RemotingConnection.aSyncErrorHandler: " + s);
        }
        public function securityErrorHandler( s : String ) : void
        {
            trace ("RemotingConnection.securityErrorHandler: " + s);
        }
    }
}