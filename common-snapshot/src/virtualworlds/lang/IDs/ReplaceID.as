/**
 * This class holds the complete list of IDs
 * that are replaced.  This is used in
 * conjunction with TranslationManager.
 */

package virtualworlds.lang.IDs
{
	
	/**
	* ...
	* @author Brisita
	*/
	public class ReplaceID
	{
		static public const ITEM_NAME:String = "[ITEM NAME]";
		static public const PETPET_NAME:String = "[PETPET NAME]";
		static public const LOCATION:String = "[LOCATION]";
		static public const NUMBER:String = "[#]";
		static public const USERNAME:String = "[USERNAME]";
		static public const AMOUNT:String = "[AMOUNT]";
		static public const STATUS:String = "[STATUS]";
		static public const MOOD:String = "[MOOD]";
		static public const MEMORY:String = "[MEMORY]";
		static public const CHARM:String = "[CHARM]";
		static public const AGILITY:String = "[AGILITY]";
		static public const PARKPOINTS:String = "[PARKPOINTS]";
		static public const SPECIES:String = "[SPECIES]";
		static public const COLOR:String = "[COLOR]";
		static public const LIKES:String = "[LIKES]";
		static public const DISLIKES:String = "[DISLIKES]";
		static public const NEWSBODY:String = "[NEWSBODY]";
		static public const NEWSTITLE:String = "[NEWSTITLE]";
		static public const HELPTOPIC:String = "[HELPTOPIC]";
		static public const ITEMNAME:String = "[ITEMNAME]";
		static public const ITEMDESC:String = "[ITEMDESC]";
		static public const DATE:String = "[DATE]";
		static public const TRICKDESC:String = "[TRICKDESC]";
		static public const TRICKNAME:String = "[TRICKNAME]";
		static public const NPCDIALOG:String = "[NPCDIALOG]";
		static public const MESSAGE:String = "[MESSAGE]";
		static public const GENDER:String = "[GENDER]";
		static public const SCORE:String = "[SCORE]";
		static public const SPECIESDESC:String = "[SPECIESDESCRIPTION]";
		
		
		public function ReplaceID(){ }
		
		// This is not really needed
		static public function replace(a_src:String, a_replaceID:String, a_str:String):String
		{
			return a_src.replace(a_replaceID, a_str);
		}
		
		/*
		* This will replace text by translating both Strings first.
		* @param a_scr String to be used.
		* @param a_replaceID The replace String.
		* @param a_str The String that will replace.
		* @return String The translated and replaced text.
		
		static public function translateAndReplace(a_src:String, a_replaceID:String, a_str:String):String
		{
			return ReplaceID.replace(AdoptionTextID.getTranslatedFields()[AdoptionTextID.CGNlikes1],ReplaceID.LIKES,LIKES.getTransLike(AdoptionState.ADOPTIONVARS.currentAdoptablePetpet.like1Num)), Fonts.CAFETERIA);
		}*/
		
	}
}