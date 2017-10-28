package virtualworlds.com.smerc.uicomponents.contentHolders
{
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import org.spicefactory.lib.logging.LogContext;
	import org.spicefactory.lib.logging.Logger;
	
	import virtualworlds.com.smerc.utils.disp.DisplayObjectUtils;
	
	/**
	* This class holds Sprite/MovieClip content, with the option to add it to the ContentHolder.
	* It has bells and whistles such as a fancy toString() and a destroy() for proper clean-up,
	* though the real meat of this class is its buildFrom() function, which acquires a dictionary
	* of descendants, alotting a default place for DisplayObject extraction for the purpose of 
	* constituent construction.
	* 
	* @author Bo
	*/
	public class ContentHolder extends Sprite
	{
		protected static const log:Logger = LogContext.getLogger(ContentHolder);
		/**
		 * The contents used to construct/assign this object.
		 */
		protected var _contents:Sprite;
		
		/**
		 * Same as _contents, but stored as a MovieClip for faster get-time, when a MovieClip is necessary.
		 */
		protected var _contentsMc:MovieClip;
		
		/**
		 * 
		 * @param	a_img:			<Sprite> content to be held/manipulated by this class.
		 * @param	a_bAddContents:	<Boolean @default false> Determines whether a_img is to be a child of this.
		 */
		public function ContentHolder(a_img:Sprite, a_bAddContents:Boolean = false )
		{
			_contents = a_img;
			
			if (!_contents)
			{
				log.warn("ContentHolder::ContentHolder(): _contents=null, returning.");
				return;
			}
			
			if (a_bAddContents)
			{
				this.addChild(a_img);
			}
			
			_contentsMc = _contents as MovieClip;
			
			this.buildFrom(_contents);
			
		}//end ContentHolder() constructor.
		
		public function get contents():Sprite
		{
			return _contents;
			
		}//end get contents()
		
		public function get contentsMC():MovieClip
		{
			return _contentsMc;
			
		}//end get contentsMC()
		
		/**
		 * This finds the descendants from input DisplayObject (_contents), and assigns its
		 * necessary parts to this class's attributes.
		 * 
		 * NOTE: 	Override this function for all subclasses of ContentHolder that have any attributes
		 * 			dependent on the descendants of the _contents.
		 * 
		 * @param	a_img	<Sprite> of which the descendants are found, to be used in assigning/constructing our attributes.
		 * 
		 * @return	<Dictionary> of the DisplayObject descendants of the _contents, 
		 * 			where the key for each DisplayObject is its name.
		 */
		protected function buildFrom(a_img:Sprite):Dictionary
		{
			var descendantsDict:Dictionary = DisplayObjectUtils.getDescendantsAsDict(a_img);
			
			return descendantsDict;
			
		}//end buildFrom()
		
		/**
		 * This class is declared final, since the one thing consistent amongst all subclasses that are to 
		 * modify how they are displayed, is that the QualifiedClassName should be shown, same as what Adobe does
		 * with its core classes.
		 * This function calls this.stringRepresentative() to fill the guts of what's returned, here.
		 * Override get stringRepresentative():String to alter the contents of this function's return value.
		 * 
		 * @return	<String> full representation of this.  By default, always includes the QualifiedClassName of this.
		 * 
		 * @see #stringRepresentative
		 */
		override public final function toString():String
		{
			var myQName:String = getQualifiedClassName(this);
			
			return "[ " + myQName + " (" + this.stringRepresentative + ") ]";
			
		}//end toString()
		
		/**
		 * Override this function to change the details of the toString().
		 */
		protected function get stringRepresentative():String
		{
			var myStringRep:String = "_contents=" + _contents;
			
			return myStringRep;
			
		}//end get stringRepresentative()
		
		/**
		 * Override for proper clean-up.  Best practice is to always call super.destroy() in overrides.
		 * @param	...args
		 */
		public function destroy(...args):void
		{
			if (_contents && _contents.parent == this)
			{
				this.removeChild(_contents);
			}
			
			_contents = null;
			_contentsMc = null;
			
		}//end destroy()
		
	}//end class ContentHolder
	
}//end package com.smerc.uicomponents.holders
