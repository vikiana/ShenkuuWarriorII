// ---------------------------------------------------------------------------------------
// Game Translation Class
//
// Author: Ollie B.
// Last Update: 03/28/08
//
// ---------------------------------------------------------------------------------------
package com.neopets.projects.np9.system
{
	// SYSTEM IMPORTS
	import flash.text.TextField;
	import flash.text.Font;
	
	import flash.events.Event;
	import flash.events.SecurityErrorEvent;
	
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;

	import flash.utils.unescapeMultiByte;
	
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	
	// CUSTOM IMPORTS
	import com.neopets.projects.np9.system.NP9_Tracer;
	import com.neopets.projects.np9.system.NP9_TTextfields;
	
	/**
	 * The Neopets game text Translator class
	 * @author Ollie B.
	 * @since 03/28/08
	 */
	public class NP9_Translator {
		
		private var objTracer:NP9_Tracer;
		
		private var sServer:String;
		private var sURL:String;
		private var sLang:String;
		private var nTypeID:Number;
		private var nItemID:Number;
		
		private var objTTextfields:NP9_TTextfields;
		
		private var bIsWesternLang:Boolean;
		private var aWesternLangs:Array;
		private var aTransData:Array;
		
		private var loader:URLLoader;
		
		private var bComplete:Boolean;
		
		/**
		 * @Constructor
		 * @param	p_bTrace		Set this to true to enable debugging
		 */
		public function NP9_Translator( p_bTrace:Boolean ) {
			
			// tracer object
			objTracer = new NP9_Tracer( this, p_bTrace );
			objTracer.out( "Instance created!", true );
			
			// set default values
			sServer = "htpp://www.neoepets.com/";
			sLang   = "EN";
			nTypeID = 4;
			nItemID = 0;
			
			// getTranslationXML URL
			var sSlash:String = String.fromCharCode(47);
			sURL = "transcontent" + sSlash + "gettranslationxml.phtml";
			
			objTTextfields = new NP9_TTextfields( p_bTrace );
			
			bIsWesternLang = false;
			aWesternLangs = ["EN","PT","DE","FR","IT","ES","NL"];
			aTransData = new Array();
			
			loader = new URLLoader();

			bComplete = false;
		}
		
		/**
		 * Initializes the translation data retrieval
		 * @param	p_sServer			Server to connect to
		 * @param	p_nGameID		The game ID
		 * @param	p_sLang			Language to load
		 */
		public function init( p_sServer:String, p_nGameID:Number, p_sLang:String ):void {
			
			sServer = p_sServer;
			nItemID = p_nGameID;
			sLang   = p_sLang;
			
			// is selected language a western language
			for ( var i:Number=0; i<aWesternLangs.length; i++ ) {
				if ( aWesternLangs[i].toUpperCase() == sLang.toUpperCase() ) {
					bIsWesternLang = true;
					break;
				}
			}
			
			// initialize ttextfield object
			objTTextfields.init( bIsWesternLang );
			objTracer.out( "lang="+sLang+", embed fonts="+bIsWesternLang, false );
		}
		
		/**
		 * Sets the type ID
		 * @param	p_nTypeID
		 */
		public function setTypeID( p_nTypeID:Number ):void {
			
			nTypeID = p_nTypeID;
		}
		
		/**
		 * Checks for western language
		 * @return	True if it's a western language
		 */
		public function isWesternLang():Boolean {
			return ( bIsWesternLang );
		}
		
		/**
		 * Calls the translation XML script
		 */
		public function callTranslation():void {
			
			var t_sVars:String = "?lang=" + sLang + "&type_id=" + nTypeID + "&item_id=" + nItemID;
		    t_sVars += "&r=" + String( int(Math.random() * 10000) );
		    
			var request:URLRequest = new URLRequest();
			request.url = sServer + sURL + t_sVars;
			request.method = URLRequestMethod.POST;
			loader.addEventListener(Event.COMPLETE, completeHandler, false, 0, true);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);
			loader.load( request );
			
			objTracer.out( "Calling Translation Script...", false );
			objTracer.out( "...URL: "+sServer+sURL, false );
			objTracer.out( "...Parameters: "+t_sVars, false );
		}
		
		/**
		 * Security handler for translation XML script call
		 * @param	event
		 */
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			
			objTracer.out( "securityErrorHandler: "+event.text, true );
        }
		
		/**
		 * Translation XML script retrieval successful, proceed to parse xml
		 * @param	event
		 */
		private function completeHandler(event:Event):void {
			
			//race("**"+this+": "+"Data received");
			
			var sXML:XMLDocument = new XMLDocument(event.target.data);
			
			var xData1:XMLNode = sXML.childNodes[2];
			var xData2:XMLNode = xData1.childNodes[1];
			var xData3:XMLNode = xData2.childNodes[3];
			var xNodes:Array   = xData3.childNodes;
			
			var xN1:XMLNode;
			var xN2:XMLNode;
			for ( var node:Number = 0; node<xNodes.length; node++ ) {
			
				xN1 = xNodes[node];
				if ( xN1.nodeName == "trans-unit" ) {
					
					xN2 = xN1.childNodes[1];
					aTransData[ xN1.attributes["resname"] ] = unescapeMultiByte( String(xN2.firstChild) );
				}
			}
			
			bComplete = true;
		}
		
		/**
		 * @return	True if translation is complete
		 */
		public function translationComplete():Boolean {
			return ( bComplete );
		}
		
		/**
		 * Adds a font to be used
		 * @param	p_Font		Font object
		 * @param	p_sID		Unique ID for the font
		 */
		public function addFont( p_Font:Font, p_sID:String ):void {
			objTTextfields.addFont( p_Font, p_sID );	
		}
		
		/**
		 * Sets the default font to be used
		 * @param	p_sID	Unique ID of the font
		 */
		public function setFont( p_sID:String ):void {
			objTTextfields.setFont( p_sID );	
		}
		
		/**
		 * Sets the value of a TextField object
		 * @param	p_tfInstance		TextField object
		 * @param	p_sHTML			The HTML stirng to to used
		 */
		public function setTextField( p_tfInstance:TextField, p_sHTML:String ):void {
			objTTextfields.setTextField( p_tfInstance, p_sHTML );
		}
		
		/**
		 * Retrieves a translated text from the loaded translation XML
		 * @param	p_sID	Unique ID of the text string
		 * @return				Value of the text
		 */
		public function getTranslation( p_sID:String ):String {
			return ( aTransData[ p_sID ] );
		}
	}
}
