/**
 *	This class handles links to other pages in the same destination.
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author David Cary
 *	@since  04.14.2010
 */

package com.neopets.games.marketing.destination.despicableMe.widgets.nav
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import com.neopets.games.marketing.destination.despicableMe.util.BroadcasterClip;
	import com.neopets.games.marketing.destination.despicableMe.DestinationView;
	import com.neopets.projects.destination.destinationV3.AbsPage;
	
	import virtualworlds.lang.TranslationManager;
	
	public class PageLink extends BroadcasterClip
	{
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		public var targetPage:String;
		public var ADLinkID:String;
		public var neoContentID:int;
		
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function PageLink():void {
			super();
			// set up broadcasts
			useParentDispatcher(AbsPage);
			// set up mouse behaviour
			addEventListener(MouseEvent.CLICK,onClick);
			buttonMode = true;
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		
		public function setTranslation(txt:TextField,id:String) {
			if(txt != null) {
				// load translated text
				var translator:TranslationManager = TranslationManager.instance;
				if(translator.translationData != null) {
					txt.htmlText = translator.getTranslationOf(id);
				} else txt.text = id;
			}
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
		
		// Relay click through shared dispatcher.
		
		protected function onClick(ev:MouseEvent) {
			trace("PageLink.as onClick()");
			broadcast(DestinationView.LOAD_PAGE_REQUEST,targetPage);
			if(ADLinkID != null) broadcast(DestinationView.ADLINK_REQUEST,ADLinkID);
			if(neoContentID > 0) broadcast(DestinationView.NEOCONTENT_TRACKING_REQUEST,neoContentID);
		
		}

	}
	
}