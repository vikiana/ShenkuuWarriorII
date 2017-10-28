//Marks the right margin of code *******************************************************************
package com.neopets.users.vivianab
{
	import caurina.transitions.Tweener;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	
	import virtualworlds.lang.TranslationManager;
	
	/**
	 * This is a utility to control the clicking in a game and avoid game-breaking or autoclickers cheating.
	 * Please Note: for this specific version to work, a "slowDownMessage" symbol has to be in the Library. Otherwise, override the getSlowDownMessage() function.
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class ClickerControl
	{
		//--------------------------------------------------------------------------
		// Costants
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		//--------------------------------------------------------------------------
		//Public properties
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		//--------------------------------------------------------------------------
		//Private properties
		//--------------------------------------------------------------------------	
		/**
		 * var description
		 */
		private var _timeLapse:Number =0;
		private var _message:String = "Slow Down!"
		private var _messageCoords:Point;
		private var _container:DisplayObjectContainer;
		
		//clicker timer
		private  var _clickerTimer:Timer;
		private var _clickEnabled:Boolean = true;
		private var _init = false;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Creates a new public class ClickerControl instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function ClickerControl()
		{
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		/**
		 * Initialize the ClickerControl
		 * 
		 * @param  tLapse  of type <code>Number</code> The time that has to pass between a click and the other
		 * @param  message  of type <code>String</code> The mesage that will appear when the player is clicking too fast
		 * @param  coords  of type <code>Number</code> The position of the message
		 * @param  container of type <code>DisplayObjectContainer</code> The container for the message
		 */
		
		public function init(tLapse:Number, message:String, coords:Point, container:DisplayObjectContainer):void {
			_timeLapse = tLapse;
			_message=message;
			_messageCoords=coords;
			_container = container;
			
			_init = true;
		}
		
		public function start ():void {
			if (_init){
				startClickerTimer();
			} else {
				trace (this, "WARNING: can't start clicker blocker. Call 'init' first.");
			}
		}
		
		
		public function getSlowDownMessage():void {
			var sdmClass:Class = Class (getDefinitionByName("slowDownMessage"));
			var sdm:MovieClip = new sdmClass();
			setTextField (sdm, _message);
			sdm.alpha = 0;
			sdm.x = _messageCoords.x; 
			sdm.y = _messageCoords.y; 
			_container.addChild(sdm);
			Tweener.addTween(sdm, {alpha:100, time:1, transition:"easeoutquint", onComplete:removeSdm, onCompleteParams:[sdm]});
		}

		
		public function clearClickerTimer():void {
			resetClickerTimer();
			
			_timeLapse = 0;
			_message="";
			_messageCoords=null;
			_container = null;
		}
		
		public  function resetClickerTimer (e:TimerEvent=null):void {
			if (_clickerTimer){
				_clickerTimer.stop();
				if (_clickerTimer.hasEventListener(TimerEvent.TIMER_COMPLETE)){
					_clickerTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, resetClickerTimer);
				}
				_clickerTimer = null;
			}
			_clickEnabled = true;

		}
		
		//--------------------------------------------------------------------------
		// Protected Methods
		//--------------------------------------------------------------------------
		protected function startClickerTimer ():void {
			_clickEnabled = false;
			_clickerTimer = new Timer (100, _timeLapse );
			_clickerTimer.addEventListener(TimerEvent.TIMER_COMPLETE, resetClickerTimer, false, 0, true);
			_clickerTimer.start();
		}
		
		/**
		 * Override this function for use on non-Neopets games
		 * 
		 * @param message The <code>String</code>
		 * 
		 */
		protected function setTextField (m_mc:MovieClip, message:String):void {
			TranslationManager.instance.setTextField(m_mc.label_txt, _message);//TranslationManager.instance.translationData.IDS_SLOW_DOWN_MESSAGE
		}
		
		protected function removeSdm (message_mc):void {
			_container.removeChild(message_mc);
		}
		//--------------------------------------------------------------------------
		// Private Methods
		//--------------------------------------------------------------------------	
		//--------------------------------------------------------------------------
		// Event Handlers
		//--------------------------------------------------------------------------	
		/**
		 * Handler for CustomEvent.
		 * 
		 * @param event The <code>CustomEvent</code>
		 * 
		 */
		//--------------------------------------------------------------------------
		// Getters/Setters
		//--------------------------------------------------------------------------
		public function get clickEnabled():Boolean {return _clickEnabled};
		
		
		
	}
}