package com.neopets.projects.np9.system
{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.net.navigateToURL;
	import flash.net.Responder;
	import com.neopets.util.display.ListPane;
	import com.neopets.util.display.BoundedIconRow;
	//import com.neopets.util.string.StringUtils;
	import virtualworlds.net.AmfDelegate;
	
	/**
	 *	This class is used by the scoring meter to show prize awards in the game window.
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *	@Pattern ?
	 * 
	 *	@author David Cary
	 *	@since  6.16.2009
	 */
	public class NP9_Prize_Pop_Up extends MovieClip 
	{
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const MESSAGE_RECEIVED:String = "message_received";
		public static const MESSAGE_FAULT:String = "message_fault";
		public static const ICON_SIZE:Number = 80;
		
		//--------------------------------------
		//  PROTECTED VARIABLES
		//--------------------------------------
		protected var centerPoint:Point;
		protected var _contentPane:ListPane;
		protected var contentWidth:Number;
		protected var _language:String;
		protected var backgroundURL:String;
		protected var backgroundLoader:Loader;
		protected var backgroundIndex:int;
		protected var fontFace:String;
		protected var delegate:AmfDelegate;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function NP9_Prize_Pop_Up():void{
			// initializae variables
			_language = "en";
			centerPoint = new Point();
			backgroundIndex = 1;
			contentWidth = 200; // default value
			fontFace = "Verdana";
			// set up communication with php
			delegate = new AmfDelegate();
			delegate.gatewayURL = "http://dev.neopets.com/amfphp/gateway.php";
		    delegate.connect();
			// initialize listeners
			addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			super();
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		public function get contentPane():ListPane { return _contentPane; }
		
		public function set contentPane(pane:ListPane):void {
			if(_contentPane == null) _contentPane = pane;
		}
		
		public function get language():String { return _language; }
		
		public function set language(str:String):void { _language = str; }
		
		public function get background():String { return backgroundURL; }
		
		public function set background(path:String):void {
			// clear the previous background
			if(backgroundLoader != null) {
				removeChild(backgroundLoader);
				backgroundLoader = null;
			}
			// set up the new loader
			if(path != null && path.length > 0) { 
				backgroundLoader = new Loader();
				backgroundLoader.load(new URLRequest(path));
				addChild(backgroundLoader);
				setChildIndex(backgroundLoader,backgroundIndex);
			}
			backgroundURL = path;
		}
		
		public function get gatewayURL():String { return gatewayURL; }
		
		public function set gatewayURL(url:String):void {
			delegate = new AmfDelegate();
			delegate.gatewayURL = url;
		    delegate.connect();
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * Use this function to add text to our content pane.
		 * @param		str			This is the text to be added.
		 * @param		index		This is where in the list the item should be placed.
		 */
		public function addLinks(links:Array,index:int=-1):void {
			if(links == null) return;
			// addition fails if there's nowhere to add it
			if(_contentPane == null) return;
			// create a shell for the links
			var shell:MovieClip = new MovieClip();
			// fill the shell with link buttons
			var info:Array;
			var clip:MovieClip;
			var txt:TextField;
			for(var i:int = 0; i < links.length; i++) {
				info = links[i];
				if(info.length > 0) {
					// add the text to the shell
					txt = createTextField(info[0]);
					txt.width = txt.textWidth + 16;
					txt.htmlText = "<u>" + txt.htmlText + "</u>"; // add underlining
					txt.x = txt.width / -2; // center text in clip
					// create a shell for the text
					clip = new MovieClip();
					clip.addChild(txt);
					// add the link info to the clip
					if(info.length > 1) {
						clip.clickURL = info[1];
						// check if the link specifies a window
						if(info.length > 2) clip.clickWindow = info[2];
						// set up click behaviour
						txt.mouseEnabled = false; // make sure clip catches clicks instead of the textfield
						clip.useHandCursor = true;
						clip.addEventListener(MouseEvent.CLICK,onLinkClicked);
					} else clip.clickURL = null;
					// add this movieclip to the shell
					shell.addChild(clip);
				}
			}
			// update the shell once all links have been added
			var spacing:Number = contentWidth / (shell.numChildren + 1);
			var px:Number = spacing;
			for(i = 0; i < shell.numChildren; i++) {
				clip = shell.getChildAt(i) as MovieClip;
				clip.x = px;
				px += spacing;
			}
			// add the movieclip and it's links to our content pane
			_contentPane.addItemAt(shell,index);
		}
		
		/**
		 * Use this function to add text to our content pane.
		 * @param		str				This is the text to be added.
		 * @param		index			This is where in the list the item should be placed.
		 */
		public function addText(str:String="",index:int=-1):void
		{
			// addition fails if there's nowhere to add it
			if(_contentPane == null) return;
			// create the textfield
			var txt:TextField = createTextField(str);
			// add the textfield to our content pane
			_contentPane.addItemAt(txt,index);
		}
		
		/**
		 * Use this function to add text to our content pane.
		 * @param		str			This is the text to be added.
		 * @param		index		This is where in the list the item should be placed.
		 */
		public function addTextRow(list:Array,index:int=-1):void {
			if(list == null) return;
			// addition fails if there's nowhere to add it
			if(_contentPane == null) return;
			// create a shell for the links
			var shell:MovieClip = new MovieClip();
			// fill the shell with text entries
			var str:String;
			var txt:TextField;
			for(var i:int = 0; i < list.length; i++) {
				str = list[i];
				if(str.length > 0) {
					txt = createTextField(list[i]);
					txt.width = txt.textWidth + 8;
					shell.addChild(txt);
				}
			}
			// update the shell once all links have been added
			var spacing:Number = contentWidth / (shell.numChildren + 1);
			var px:Number = spacing;
			for(i = 0; i < shell.numChildren; i++) {
				txt = shell.getChildAt(i) as TextField;
				txt.x = px - (txt.width / 2);
				px += spacing;
			}
			// add the movieclip and it's links to our content pane
			_contentPane.addItemAt(shell,index);
		}
		
		/**
		 * Use this function to add a row of icons to our content pane
		 * @param		urls			This is an array of icon urls.
		 * @param		index		This is where in the list the item should be placed.
		 */
		public function loadIcons(urls:Array,index:int=-1):void
		{
			if(urls == null) return;
			// create the new icon row
			var row:BoundedIconRow = new BoundedIconRow();
			// add a bounding area to the row
			var clip:MovieClip = new MovieClip();
			clip.graphics.beginFill(0x000000,0.01);
			clip.graphics.drawRect(0,0,contentWidth,ICON_SIZE);
			clip.graphics.endFill();
			row.addChild(clip);
			row.setBoundingObj(clip);
			// load images into the icon row
			var backing:MovieClip;
			var offset:Number = ICON_SIZE / -2;
			for(var i:int = 0; i < urls.length; i++) {
				backing = new MovieClip();
				backing.graphics.beginFill(0xFFFFFF,1);
				backing.graphics.drawRect(offset,offset,ICON_SIZE,ICON_SIZE);
				backing.graphics.endFill();
				row.loadIconFrom(urls[i],backing);
			}
			// add the row to our content pane
			_contentPane.addItemAt(row,index);
		}
		
		/**
		 * Use this function to ask php for a given prize message.
		 * @param		game_id		 		This is the game's id number in Games Master.
		 * @param		score			 		This is the player's current score.
		 * @param		msg_id			 		This is the message code we got back from sending the score.
		 */
		public function loadMessage(game_id:int,score:Number,msg_id:int,plays:int):void {
			var responder : Responder = new Responder(onAMFResult, onAMFFault);
		    delegate.callRemoteMethod("ScoreMessagingService.loadMessageData",responder,game_id,score,msg_id,plays);
		}
		
		/**
		 * Use this function to load a translated image into our content pane.
		 * @param		path					This is the url of the target image.
		 * @param		top_gap			This is used to set the spacing above the item.
		 * @param		bottom_gap		This is used to set the spacing below the item.
		 * @param		index				This is where in the list the item should be placed.
		 */
		public function loadTranslatedImage(path:String,index:int=-1,top_gap:Number=2,bottom_gap:Number=2):void
		{
			if(path != null && path.length > 0) {
				var ldr:Loader = new Loader();
				_contentPane.addItemAt(ldr,index,top_gap,bottom_gap);
				ldr.contentLoaderInfo.addEventListener(Event.COMPLETE,onTranslatedImageLoaded);
				ldr.load(new URLRequest(path));
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		/**
		 * This function is called when the pop up is added to the stage.
		 */
		public function onAddedToStage(ev:Event):void
		{
			if(ev.target == this) {
				// set up our center point
				centerPoint.x = width / 2;
				centerPoint.y = height / 2;
				// search our contents for a list pane
				var child:DisplayObject;
				for(var i:int = 0; i < numChildren; i++) {
					child = getChildAt(i);
					if(child is ListPane) {
						_contentPane = child as ListPane;
						_contentPane.padding = 8;
						_contentPane.alignment = ListPane.CENTER_ALIGN;
						_contentPane.addEventListener(ListPane.LIST_UPDATED,onContentUpdated);
						contentWidth = _contentPane.width - _contentPane.padding;
						break;
					}
				}
				// check for a modified background index
				if("bg_mc" in this) {
					child = this["bg_mc"] as DisplayObject;
					backgroundIndex = getChildIndex(child) + 1;
				}
				// remove listener
				removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			}
		}
		
		/**
		 * This function is called when the pop up is added to the stage.
		 */
		public function onContentUpdated(ev:Event):void
		{
			// center the content pane
			var bb:Rectangle = _contentPane.getBounds(this);
			var cx:Number = (bb.left + bb.right) / 2;
			var cy:Number = (bb.top + bb.bottom) / 2;
			_contentPane.x += centerPoint.x - cx;
			_contentPane.y += centerPoint.y - cy;
		}
		
		/**
		 * Use this function to make sure a translated image is set to the right language.
		 */
		public function onTranslatedImageLoaded(ev:Event):void {
			var info:LoaderInfo = ev.target as LoaderInfo;
			var clip:MovieClip = info.content as MovieClip;
			if("language" in clip) clip.language = _language;
		}
		
		/**
		 * This function is called whenever the user clicks on one of our dynamically created links.
		 */
		public function onLinkClicked(ev:MouseEvent):void {
			if(ev.target is MovieClip) {
				var clip:MovieClip = ev.target as MovieClip;
				if("clickURL" in clip) {
					var window:String;
					if("clickWindow" in clip) window = clip.clickWindow;
					else window = "_blank";
					navigateToURL(new URLRequest(clip.clickURL),window);
				}
			}
		}
		
		/**
		 * Amf success.
		*/
		public function onAMFResult(msg:Object):void
		{
			trace("success: event: " + msg);
			if(msg == null) return;
			dispatchEvent(new Event(MESSAGE_RECEIVED));
			// set the background
			if("background" in msg) background = msg["background"];
			// check if the message wants to change our existing text
			if("statusMsg" in msg) {
				var str:String = msg["statusMsg"];
				if(str != null && str.length > 0) {
					var itm:DisplayObject = _contentPane.getItemAt(-2);
					if(itm != null && itm is TextField) {
						var txt:TextField = itm as TextField;
						txt.htmlText = str;
					}
				}
			}
			// Since we're adding the rest of the content on top of the original text, let's add things
			// from the bottom up.  Otherwise we'd need to track the insertion index.
			// add in the buttons
			if("buttons" in msg) addLinks(msg["buttons"],0);
			// get our prize images
			var img_rows:Array;
			if("prizeIcons" in msg) img_rows = msg["prizeIcons"];
			else img_rows = new Array();
			// get our prize text
			var txt_list:Array;
			if("textFields" in msg) txt_list = msg["textFields"];
			else txt_list = new Array();
			// interweave the contents of both lists
			for(var i:int = Math.max(img_rows.length,txt_list.length) - 1; i >= 0; i--) {
				// start with an image row
				if(i < img_rows.length) loadIcons(img_rows[i],0);
				// put text on top of the images
				if(i < txt_list.length) addText(txt_list[i],0);
			}
			// add the logo
			if("backgroundLogo" in msg) loadTranslatedImage(msg["backgroundLogo"],0,-50);
		}
		
		/**
		 * Amf fault.
		*/
		public function onAMFFault(msg:Object):void
		{
			trace("fault: event: " + msg);
			dispatchEvent(new Event(MESSAGE_FAULT));
		}
		
		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------
		
		/**
		 * This function creates a new textfield and readies it for addition to our content pane.
		 * @param		str		This is the text we want assigned to the textfield.
		 */
		protected function createTextField(str:String=""):TextField {
			var txt:TextField = new TextField();
			txt.textColor = 0xFFFFFF; // used as default text color for higher visibility
			txt.selectable = false;
			txt.wordWrap = true;
			txt.multiline = true;
			txt.width = contentWidth;
			// add font tags if needed
			var font_open:int = str.indexOf("<font");
			if(font_open < 0) {
				str = "<font color='#FFFFFF' face='" + fontFace + "' size='12'>" + str + "</font>";
			} else {
				// if the font face has not been declared, set it now
				var font_close:int = str.indexOf(">",font_open);
				var face_open:int = str.indexOf("face='",font_open);
				if(face_open < 0 || face_open > font_close) {
					str = str.replace("<font","<font face='" + fontFace + "'");
				} else {
					// if the font face has been set, overwrite it
					/*var face_break:int = face_open + 6;
					var face_close:int = str.indexOf("'",face_break);
					str = str.substring(0,face_break) + fontFace + str.substring(face_close);*/
				}
			}
			// add alignment tags if needed.
			if(str.indexOf("</p>") < 0) {
				str = "<p align='center'>" + str + "</p>";
			}
			// set the text
			txt.htmlText = str;
			txt.height = txt.textHeight + 8;
			return txt;
		}
		
	}
	
}