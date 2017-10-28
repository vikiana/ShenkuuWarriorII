//Marks the right margin of code *******************************************************************
package com.neopets.games.inhouse.shenkuuwarrior2.effects
{
	import caurina.transitions.Tweener;
	
	import com.neopets.games.inhouse.shenkuuwarrior2.gamedata.GameInfo;
	import com.neopets.games.inhouse.shootergame.utils.Mathematic;
	import com.neopets.projects.effects.particle.ImageManager;
	import com.neopets.projects.effects.particle.ParticleFormation;
	import com.neopets.projects.effects.particle.ParticleManager;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.utils.getDefinitionByName;
	
	
	/**
	 * public class BonusPickupFX extends Sprite
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class BonusPickupFX 
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
		private var _cArray:Array = new Array();
		
		private var _active:Boolean = false;
		
		private var _count:int = 0;
		
		private var _container:DisplayObjectContainer;
		
		private var _frequency:int = 0;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Creates a new public class BonusPickupFX extends Sprite instance.
		 * 
		 * <span class="hide">Any hidden comments go here.</span>
		 *
		 * 
		 */
		public function BonusPickupFX()
		{
			super();
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		/**
		 * Description
		 * @param  value  of type <code>CustomClass</code> 
		 */
		public function init(particleClasses:Array, container:DisplayObjectContainer, freq:int=1):void {
			for (var i:int =0; i < particleClasses.length; i++){
				_cArray.push(Class (getDefinitionByName(String(particleClasses[i]))));
			}
			_frequency = freq;
			_container = container;
			/*var ps:Sprite;
			var pClass:Class;
			for (var i:int =0; i < particleClasses.length; i++){
				ps = new Sprite ();
				addChild(ps);
				var holderFilters:Array = [new GlowFilter (0xffff00)]//, new BlurFilter (8, 8, 3)]
				ImageManager.addHolder(ps, GameInfo.STAGE_WIDTH, GameInfo.STAGE_HEIGHT, holderFilters, false);
				ImageManager.skipFilter = false;
				pClass = Class (getDefinitionByName(String(particleClasses[i])));
				ImageManager.addParticleImage(DisplayObject(new pClass()), String("particle"+i));
				sArray.push(ps);
			}*/
			_active = true;
		}
		
		public function update (X:Number, Y:Number, vy:Number):void {
			for (var i:int =0; i<_container.numChildren; i++){
				_container.getChildAt(i).y -= vy;
			}
			if (_count >= _frequency){
				var s:Sprite = new _cArray[0]();
				s.x = X;
				s.y = Y;
				s.rotation = Mathematic.randRange(0, 45);
				_container.addChild(s);
				Tweener.addTween(s, {alpha:0.3, scaleX:0.3, scaleY:0.3, time:1, onComplete:remove, onCompleteParams:[s]});
				_count = 0;
			} else {
				_count++;
			}
		}
		//--------------------------------------------------------------------------
		// Protected Methods
		//--------------------------------------------------------------------------	
		protected function remove (obj:DisplayObject):void {
			if (_container.contains(obj)){
				_container.removeChild(obj);
			}
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
		public function get active ():Boolean { return _active;};
		public function set active (value:Boolean):void {_active = value;};
		
		
	}
}