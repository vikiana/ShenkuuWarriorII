package com.neopets.projects.np9.system
{
	// SYSTEM IMPORTS
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.Font;
	
	// CUSTOM IMPORTS
	import com.neopets.projects.np9.system.NP9_Tracer;
	
	/**
	 * A Custom translatable TextField handler class
	 * @author Ollie B. updated by Clive Henrick on 1/21/2009
	 * @since 03/28/08
	 */
	public class NP9_TTextfields
	{
		private var objTracer:NP9_Tracer;
		
		private var bWesternLang:Boolean;
		private var bMultiline:Boolean;
		private var bWordWrap:Boolean;
		
		private var aFonts:Array;
		
		private var objDefaultTextFormat:TextFormat;
		
		/**
		 * @Constructor
		 * @param	p_bTrace	Set to true to enable debugging
		 */
		public function NP9_TTextfields( p_bTrace:Boolean ):void {

			// tracer object
			objTracer = new NP9_Tracer( this, p_bTrace );
			objTracer.out( "Instance created!", true );
			
			// DEFAULTS
			bWesternLang = true;
			bMultiline   = true;
			bWordWrap    = true;

			aFonts = new Array();
			
			objDefaultTextFormat = new TextFormat();
		}
		
		/**
		 * Enables western language support. Affects fonts properties
		 * @param	p_bWesternLang	Set to true if western language used
		 */
		public function init( p_bWesternLang:Boolean ):void {
			
			bWesternLang = p_bWesternLang;
		}
		
		/**
		 * Adds a font to use
		 * @param	p_Font		Font object
		 * @param	p_sID		Unique font ID
		 */
		public function addFont( p_Font:Font, p_sID:String ):void {
			
			if ( aFonts[p_sID] == undefined ) {
				aFonts[p_sID] = p_Font;
			} else {
				objTracer.out( "Font "+p_sID+" already exists!", true );
			}
		}
		
		/**
		 * Sets the default font to use
		 * @param	p_sID	Unique font ID
		 */
		public function setFont( p_sID:String ):void {
			
			if ( aFonts[p_sID] != undefined ) {
				objDefaultTextFormat.font = aFonts[p_sID].fontName;
			}
		}
		
		/**
		 * Sets the html text of a TextField object
		 * @param	p_tfInstance		The TextField instance
		 * @param	p_sHTML			HTML text to enter into the textfield
		 */
		public function setTextField( p_tfInstance:TextField, p_sHTML:String ):void {
			
			p_tfInstance.embedFonts = bWesternLang;
			p_tfInstance.multiline  = bMultiline;
			p_tfInstance.wordWrap   = bWordWrap;
			
			p_tfInstance.htmlText = p_sHTML;
			
			p_tfInstance.setTextFormat( objDefaultTextFormat );
		}
	}
}