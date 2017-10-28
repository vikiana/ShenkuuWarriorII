package virtualworlds.com.neopets.games.util
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import org.spicefactory.lib.logging.LogEvent;
	import org.spicefactory.lib.logging.LogLevel;
	import org.spicefactory.lib.logging.Logger;
	import org.spicefactory.lib.logging.impl.AbstractAppender;

	public class HttpErrorLoggerAppender extends AbstractAppender
	{
		private var _urlVars:URLVariables;
		private var _urlRequest:URLRequest;
		private var _urlLoader:URLLoader;
		private var _needsLineFeed:Boolean;
		
		public function HttpErrorLoggerAppender(errorLoggerURL:String)
		{
			super();
			_needsLineFeed = false;
			threshold = LogLevel.ERROR;
			
			// Setup URL request
			_urlVars = new URLVariables();
		
			// Required vars
			_urlVars.message = "";
			
			// Optional
			_urlVars.desc = "";
			_urlVars.errorStack = "";
			_urlVars.userid = "";
						
			_urlRequest = new URLRequest();
			_urlRequest.url = errorLoggerURL;
			_urlRequest.method = URLRequestMethod.POST;
			_urlRequest.data = _urlVars;

			
			_urlLoader = new URLLoader();
		}
		
		public function setUserId(userId:String):void 
		{
			// Set user id that is passed to Http Logger
			// This is called after user logs in
			_urlVars.userid = userId;
		}

		/**
		 * Invoked whenever a <code>Logger</code> instance registered with this
		 * <code>Appender</code> fires a <code>LogEvent</code>.
		 * 
		 * @param event the LogEvent to handle
		 */
		protected override function handleLogEvent(event:LogEvent) : void {
			if (isBelowThreshold(event.level))
				return;
			var loggerName:String = Logger(event.target).name;
			var logMessage:String;
			
			if (event.error == null) {
				logMessage = loggerName + " - " + event.message;
				_needsLineFeed = true;
			} else {
				var lf:String = (_needsLineFeed) ? "\n" : "";
				logMessage = lf + "  *** " + event.level + " *** " + loggerName + " ***\n" 
					+ event.message + "\n";
				if (event.error != null) {
					var stackTrace:String = event.error.getStack;
					if (stackTrace != null && stackTrace.length > 0) {
						logMessage += stackTrace + "\n";
					}
				}
				_needsLineFeed = false;
			}
			_urlVars.message = logMessage;
			
			//if (Globals.errorLoggingOn) // turn off for dev
				_urlLoader.load(_urlRequest);
			
			// Throw error so we know to fix this
			throw(new Error(logMessage));
		}

	}
}