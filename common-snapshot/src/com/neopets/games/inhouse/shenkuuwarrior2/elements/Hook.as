//Marks the right margin of code *******************************************************************
package com.neopets.games.inhouse.shenkuuwarrior2.elements
{
	import com.neopets.games.inhouse.shenkuuwarrior2.elements.Bullet;
	import com.neopets.util.events.CustomEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	
	
	/**
	 * public class Hook extends Bullet
	 * 
	 * <p><u>REVISIONS</u>:<br>
	 * <table width="500" cellpadding="0">
	 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
	 * <tr><td>06/09/2009</td><td>baldarev</td><td>Class created.</td></tr>
	 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
	 * </table>
	 * </p>
	 */
	public class Hook extends Bullet
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
		private var _pclass:Class;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Creates a new public class Hook extends Bullet instance.
		 * 
		 */
		public function Hook(bullet:MovieClip, container:Sprite, trailerBullet:Class=null, aimline:Boolean=false)
		{
			super(bullet, container, trailerBullet, aimline);
			//this lowers the gravity pull only for the hook
			T *= 10;
		}
		//--------------------------------------------------------------------------
		// Public Methods
		//--------------------------------------------------------------------------	
		override public function pointandshoot(refMc:MovieClip=null):Boolean {
			//clearAimLine();
			if (_aimline){
				_aimline.visible = false;
			}
			//OLD - force was proportional to the distance to the mouse.. This just doesn't work correclty.
			//_vx = (_container.mouseX - _bb.x)*_launchforce;
			//_vy = - Math.abs (_container.mouseY - _bb.y)*_launchforce;
			//NEW
			//var angleRad:Number = Math.atan2(_bb.y-_container.mouseY, _container.mouseX-_bb.x);
			var angleRad:Number = Math.atan2(refMc.y-_container.mouseY, _container.mouseX-refMc.x);
			trace ("hook angle rad:", angleRad, Math.PI);
			if (angleRad > 0 && angleRad < Math.PI){
				_vx = _launchforce * Math.cos (angleRad);
				_vy = _launchforce * Math.sin(angleRad)*-1;
				//trace ("initial velocity", _launchforce, _vx, _vy)
				shoot();
				return true;
			} else {
				return false;
			}
		}
		
		
		
		
	
		//--------------------------------------------------------------------------
		// Protected Methods
		//--------------------------------------------------------------------------	
		override protected function setUp():void {
			super.setUp();
			if (_hasAimline){
				_pclass = Class (getDefinitionByName("power_arrow"));
				_aimline = new _pclass();
				_container.addChild(_aimline);
			}
		}
		

		override protected function aim (X:Number, Y:Number):void {
			if (_hasAimline){
				clearAimLine();
				_aimline.visible = true;
				var tail:Sprite = _pclass(_aimline).tail;
				
				//OLD: magnitude (arrow sizing)
				/*if (tail){
					if ( X > 10 && Y > 10){
						tail.scaleY = X/Y;
					}
				}*/
				
				//position and rotation
				var angler:Number = - Math.atan2( _bb.x -_container.mouseX, _bb.y - _container.mouseY);
				var xoffset:Number = tail.height * Math.sin(angler);
				var yoffset:Number = tail.height * Math.cos(angler);
				_aimline.rotation = angler*180/Math.PI;
				_aimline.x = _bb.x+xoffset;
				_aimline.y = _bb.y-yoffset;
				//trace ("power arrow - ", "Angler:", angler, "Tail.height:", tail.height, "Rotation:", _aimline.rotation,"Offset:", xoffset, yoffset);
				//trace (tail.x, tail.y, tail.visible, tail.scaleY);
			}
		}
		
	
		//--------------------------------------------------------------------------
		// Private Methods
		//--------------------------------------------------------------------------	
		//--------------------------------------------------------------------------
		// Event Handlers
		//--------------------------------------------------------------------------	
		//--------------------------------------------------------------------------
		// Getters/Setters
		//--------------------------------------------------------------------------
	}
}