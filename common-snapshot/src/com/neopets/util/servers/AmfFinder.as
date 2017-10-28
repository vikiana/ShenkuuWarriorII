/* AS3
	Copyright 2009
*/
package com.neopets.util.servers
{
	import flash.display.DisplayObject;
	import flash.net.Responder;
	
	import com.neopets.util.servers.ServerFinder;
	import com.neopets.util.servers.ServerGroup;
	
	import virtualworlds.net.AmfDelegate;
	
	/**
	 *	This class attaches server finder functionality to an amf delegate.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern none
	 * 
	 *	@author David Cary
	 *	@since  6.11.2010
	 */
	public class AmfFinder extends Object 
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		protected var _servers:ServerFinder;
		protected var _delegate:AmfDelegate;
		public var gatewayPath:String;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function AmfFinder():void {
			gatewayPath = "/amfphp/gateway.php";
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get servers():ServerFinder { return _servers; }
		
		public function get delegate():AmfDelegate { return _delegate; }
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		// Use this function to establish communication with php.
		
		public function setupAMFPHP():void {
			// initial our server finder if this hasn't already been done
			if(_servers == null) _servers = new ServerFinder();
			// create our amf delegate if needed
			if(_delegate == null) _delegate = new AmfDelegate();
			// point the delegate at the target server
			_delegate.gatewayURL = _servers.scriptServer + gatewayPath;
		    _delegate.connect();
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
	}
	
}
