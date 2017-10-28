package com.neopets.util.misc
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	[Bindable]
	public class NeopetsUtil extends EventDispatcher implements IEventDispatcher
	{
		
		public static function get username ():String {			
			return PlaceHolderUtil.makePlaceHolder("username",20);
		}
		public static function get neopetName ():String {
			return PlaceHolderUtil.makePlaceHolder("neopetName",20);
		}
		public static function get species ():String {
			return PlaceHolderUtil.makePlaceHolder("species",20);
		}	
		
		//
		public static function get virtualItemName ():String {
			return PlaceHolderUtil.makePlaceHolder("name",20);
		}	
		public static function get virtualItemCategory ():String {
			return PlaceHolderUtil.makePlaceHolder("category",20);
		}
		public static function get virtualItemSubcategory ():String {
			return PlaceHolderUtil.makePlaceHolder("Subcategory",20);
		}	
		public static function get virtualItemType ():String {
			return PlaceHolderUtil.makePlaceHolder("type",20);
		}		
		public static function get virtualItemDescription ():String {
			return PlaceHolderUtil.makePlaceHolder("description",200,true);
		}				
		//NOT SURE WHEN THE 'NeopetData' Class dissapeared, but I want to use the rest of this class for now.  samr 12/16/07
		
		/*
		public static function get neopets_arraycollection ():ArrayCollection {
			return new ArrayCollection(
										new Array (
													new NeopetData("All"),
													new NeopetData("Acara"),
													new NeopetData("Aisha"),
													new NeopetData("Blumaroo"),
													new NeopetData("Bori"),
													new NeopetData("Bruce"),
													new NeopetData("Buzz"),
													new NeopetData("Chia"),
													new NeopetData("Chomby"),
													new NeopetData("Cybunny"),
													new NeopetData("Draik"),
													new NeopetData("Elephante"),
													new NeopetData("Eyrie"),
													new NeopetData("Gelert"),
													new NeopetData("Gnorbu"),
													new NeopetData("Grarrl"),
													new NeopetData("Grundo"),
													new NeopetData("Hissi"),
													new NeopetData("Ixi"),
													new NeopetData("Jetsam"),
													new NeopetData("JubJub"),
													new NeopetData("Kacheek"),
													new NeopetData("Kau"),
													new NeopetData("Kiko"),
													new NeopetData("Koi"),
													new NeopetData("Korbat"),
													new NeopetData("Kougra"),
													new NeopetData("Krawk"),									
													new NeopetData("Kyrii"),
													new NeopetData("Lenny"),
													new NeopetData("Lupe"),
													new NeopetData("Lutari"),
													new NeopetData("Meerca"),
													new NeopetData("Moehog"),
													new NeopetData("Mynci"),									
													new NeopetData("Nimmo"),
													new NeopetData("Ogrin"),
													new NeopetData("Peophin"),
													new NeopetData("Poogle"),
													new NeopetData("Pteri"),
													new NeopetData("Quiggle"),
													new NeopetData("Ruki"),									
													new NeopetData("Scorchio"),
													new NeopetData("Shoyru"),
													new NeopetData("Skeith"),
													new NeopetData("Techo"),
													new NeopetData("Tonu"),
													new NeopetData("Tuskaninny"),								
													new NeopetData("Uni"),
													new NeopetData("Usul"),
													new NeopetData("Wocky"),
													new NeopetData("Xweetok"),
													new NeopetData("Yurble"),								
													new NeopetData("Zafara")
												)
									);
		}
	*/


	

	}
}
		 
class PlaceHolderUtil 	{

	//HELPER
	public static function makePlaceHolder (	aSource_str:String = "",
												aTotalSpaces_num:Number = 0,
												aIsLorumIspumFormatted_boolean:Boolean = false) : String 
	{
			//RETURN A STRING OF '[typeWWWW]' with TOTAL characters of total spaces
			return "["+ PlaceHolderUtil.padSpaces(aSource_str,aTotalSpaces_num-2,aIsLorumIspumFormatted_boolean) + "]";
	}
	private static function padSpaces (aSource_str:String = "",aTotalSpaces_num:Number = 0, aIsLorumIspumFormatted_boolean: Boolean = false) : String  
	{
		var return_str : String = aSource_str;
		var loremIpsum_str : String = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Cras commodo consequat ipsum. Nulla blandit magna at dui. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Maecenas eget enim hendrerit dolor egestas porta. Nunc auctor. Vivamus sit amet odio. Aenean tellus turpis, porta non, tempus ut, venenatis cursus, tellus. Nullam sed nibh. Ut in est eu risus vulputate cursus. Fusce arcu metus, interdum eget, vulputate eget, tristique non, ipsum. Nulla vitae risus et nisl euismod consequat. Morbi rhoncus pulvinar magna. Phasellus elementum dapibus elit. Donec diam. Vivamus at urna eget metus fringilla rutrum. Proin mi nulla, euismod quis, egestas in, dapibus a, nisi. Quisque posuere nisi a arcu. Duis orci lorem, blandit eleifend, aliquet at, tempor venenatis, augue. Donec tincidunt nisi laoreet metus. Maecenas cursus pede. Donec ultricies ultricies nunc. Nunc facilisis, est at posuere interdum, massa tellus tempus massa, quis gravida lectus mauris eu turpis. Aenean semper arcu quis arcu. Vestibulum tristique mauris vel dolor. Fusce ultrices justo eu libero. Aenean ante. Nam vel metus. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Nullam venenatis, erat a feugiat semper, risus nisl lacinia sapien, ac eleifend ligula nisl luctus libero. Donec ornare tellus eget purus. Vivamus vehicula eros sit amet erat. Mauris porttitor. Etiam quis est nec urna hendrerit volutpat. Integer vestibulum iaculis magna. Morbi odio quam, vestibulum sit amet, convallis id, egestas placerat, quam. Nulla facilisi. Nam id nulla. Sed tempus sem eget dolor. Curabitur sit amet neque. Aliquam id turpis vel ante scelerisque aliquet. Integer quis elit eget risus lobortis vulputate. Nunc commodo ultricies nisi. Suspendisse potenti. Morbi tempor luctus neque. Vivamus libero mauris, cursus sit amet, imperdiet non, aliquam id, nisl. Ut vel nisi. Pellentesque at velit. Nunc dignissim mollis magna. Vivamus nec lectus id enim faucibus cursus. Maecenas ullamcorper, ligula ut pulvinar scelerisque, velit libero porttitor lorem, quis imperdiet ligula lectus sed dui. Nullam imperdiet, sem at suscipit ultricies, augue augue euismod pede, a euismod libero elit in arcu. Praesent convallis, quam vehicula blandit egestas, metus sapien scelerisque quam, nec aliquet nulla nisl quis dui. Vestibulum ligula metus, varius vitae, varius rutrum, varius sit amet, turpis. Proin massa. Fusce ut nibh pellentesque nisi iaculis accumsan. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Sed pellentesque magna ut quam. Aliquam vel mi in lectus suscipit porttitor. Praesent in erat vitae dui auctor lacinia. In magna lorem, tempor ornare, ultrices a, pretium a, sapien. Phasellus sed mauris. Curabitur cursus molestie justo. Integer ligula quam, consectetuer eget, venenatis at, varius vehicula, velit. Fusce at massa. Etiam eu velit. Aliquam sit amet lorem. Pellentesque tristique felis sed lectus. In rhoncus. Curabitur tempor. Curabitur tincidunt. Vestibulum turpis mauris, adipiscing sit amet, fermentum non, molestie sed, pede. Donec mi. Donec nibh justo, sollicitudin eget, lobortis aliquam, pretium eu, pede. Vestibulum ac augue id urna ornare bibendum. Curabitur dapibus augue id mi. Duis molestie.";
		
		if (aIsLorumIspumFormatted_boolean) {
			return_str += loremIpsum_str.substr(0,aTotalSpaces_num - aSource_str.length);			
		} else {
			for (var i:uint =0; i< aTotalSpaces_num - aSource_str.length ; i++) {
				return_str += "W";				
			}
		}
		return  return_str;
	}
} 


