package virtualworlds.com.neopets.games.petpetpark.vo
{
	import virtualworlds.com.neopets.games.petpetpark.screen.ScreenObject;
	import virtualworlds.helper.Fu.Helpers.UIControllerTransitions.BasicTransition;
	
	public class ScreenNotificationVO
	{
		public var screenObject:ScreenObject; 
		public var transition:BasicTransition; 
		public var showOrHideScreen:String; 
		
		public static const SHOWSCREEN:String = "SHOWSCREEN";
		public static const HIDESCREEN:String = "HIDESCREEN";
		
		public function ScreenNotificationVO(p_showOrHideScreen:String, p_screenObject:ScreenObject = null, p_transition:BasicTransition = null)
		{
			showOrHideScreen = p_showOrHideScreen; 
			if(p_screenObject) screenObject = p_screenObject; 
			if(p_transition) transition = p_transition;
		}

	}
}