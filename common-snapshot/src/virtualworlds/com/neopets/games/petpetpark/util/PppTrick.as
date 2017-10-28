package virtualworlds.com.neopets.games.petpetpark.util
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	/**
	 * PppTrick is the visible representation of a trick that is used in the hud, trick challenge, and in trick notifications
	 * @author Smerc
	 */
	public class PppTrick extends MovieClip
	{
		
		private var _id:int;
		private var _itemName:String;
		private var _itemtype_id:int;
		private var _charm_requirement:int;
		private var _agility_requirement:int;
		private var _memory_requirement:int;
		private var _swf_url:String;
		private var _thumb_url:String;
		
		private var _trickMC:MovieClip;
		
		private var _imgLoaded:Boolean;
		private var _point_multiplier:int;
		
		//ResourceManagerProxy should set this
		public static var itemAssetBaseURL:String; 
		
		/**
		 * Tooltip text
		*/
		public function get tooltipText():String{return _tooltipText;}
		public function set tooltipText(value:String):void{_tooltipText = value;}
		private var _tooltipText : String = "";
		
		/**
		 * Does the user own the trick?
		*/
		public function get isOwnedByUser():Boolean{return _isOwnedByUser;}
		public function set isOwnedByUser(value:Boolean):void{_isOwnedByUser = value;}
		private var _isOwnedByUser : Boolean;
		/**
		 * Constructor 
		 * @param	a_obj Object Contains information about the PppTrick
		 */
		public function PppTrick(a_obj:Object) 
		{
			
			
			_id = a_obj.id;
			if(a_obj is PppTrick){
				_itemName = a_obj.itemName;
				_itemtype_id = a_obj.itemtype_id;
			}else{
				_itemName = a_obj.name;
				_itemtype_id = a_obj.type;
			}			
			
			//_charm_requirement = a_obj.charm_requirement;
			//_agility_requirement = a_obj.agility_requirement;
			//_memory_requirement = a_obj.memory_requirement;
			_swf_url = a_obj.swf_url;
			_tooltipText = a_obj.tooltipText;
			_thumb_url = a_obj.thumb_url;
			_point_multiplier = point_multiplier;
			_imgLoaded = false;
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, swfLoaded);
			var urlRequest:URLRequest = new URLRequest(itemAssetBaseURL + _swf_url);
			loader.load(urlRequest);
			
		}
		
		/**
		 * Event Handler thta fires when the swf representing this trick is loaded
		 * @private
		 * @param	evt
		 */
		private function swfLoaded(evt:Event):void 
		{
			
			_trickMC = evt.currentTarget.content as MovieClip;
			addChild(_trickMC);
			_imgLoaded = true;
			
			dispatchEvent(evt);
		}
		
		/**
		 * Trick's int ID
		 */
		public function get id():int { return _id; }
		
		/**
		 * Trick's name
		 */
		public function get itemName():String { return _itemName; }
		
		/**
		 * Trick's int type
		 */
		public function get itemtype_id():int { return _itemtype_id; }
		
		/**
		 * Url of the Trick's swf
		 */
		public function get swf_url():String { return _swf_url; }
		
		/**
		 * Url of the Trick's thumbnail swf (if applicable)
		 */
		public function get thumb_url():String { return _thumb_url; }
		
		/**
		 * Boolean denoting whether the swf has been loaded
		 */
		public function get imgLoaded():Boolean { return _imgLoaded; }

		//public function get charm_requirement():int { return _charm_requirement; }
		//
		//public function get agility_requirement():int { return _agility_requirement; }
		//
		//public function get memory_requirement():int { return _memory_requirement; }
		
		public function get trickMC():MovieClip { return _trickMC; }
		
		/**
		 * Point Modifier to be used in trick challenge
		 */
		public function get point_multiplier():int { return _point_multiplier; }
		
		/**
		 * Clonds the trick and returns a carbon copy 
		 * @return
		 */
		public function clone():PppTrick
		{
			return new PppTrick(this);
		}
		
	}
	
}