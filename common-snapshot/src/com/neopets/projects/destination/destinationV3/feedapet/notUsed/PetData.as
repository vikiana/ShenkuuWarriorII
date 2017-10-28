/**
 * To use Rob's version of feedAPet, use: PetData.as, FoodItem.as, loadPet.as, DisplayPet.as
 *	PetData.as: A movieclip in the library (a pet image will be loaded into) should have petdata.as its Class
 *	FoodItem.as: A movieclip in the library (linked with food item) should have FoodItem.as its Class
 *	loadPet.as: Main driving force of the peedAPet.  A document class for the feedAPet swf/fla if you will
 *	DisplayPet.as: in charge of grabbing the url image of the pet and loading/displaying it
 * 
 *@langversion ActionScript 3.0
 *@playerversion Flash 9.0 
 *@author Robert Briggs
 *@since  03.26.2009
 */


package com.neopets.projects.destination.feedapet {
	import flash.net.registerClassAlias;
	[RemoteClass(alias="com.neopets.projects.destination.feedapet.PetData")]
    [Bindable]
    public class PetData{
	public var name:String;
	public var pngurl:String;
	public var swfurl:String;
	public var fed_recently:Boolean;
		/*
		* Contructor
		*/
		public function PetData(fed_recently:Boolean = false, name:String="", pngurl:String="", swfurl:String=""){
			this.name = name;
			this.pngurl = pngurl;
			this.swfurl = swfurl;
			this.fed_recently = fed_recently;
			
		 //http://pets.neopets.com/cp/8jxw4wn2//1.png
		}
		static public function register():void
		{
		
			registerClassAlias("com.neopets.projects.destination.feedapet.PetData", PetData) ;	
		
		}
   }
}