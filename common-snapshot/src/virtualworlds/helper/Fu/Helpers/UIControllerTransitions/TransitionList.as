package virtualworlds.helper.Fu.Helpers.UIControllerTransitions
{
	public class TransitionList
	{
		public function TransitionList()
		{
		}
		
		public static function get AVATAR_MESSAGE():AvatarMessageTransition {
			return new AvatarMessageTransition();
		}
		
		public static function get BASIC():BasicTransition {
			return new BasicTransition();
		}
		
		public static function get BOUNCE_IN_OUT():BounceInBounceOut {
			return new BounceInBounceOut();
		}
		
		public static function get FADE_IN_OUT():FadeInFadeOut {
			return new FadeInFadeOut();
		}
		
		public static function get NO_TRANSITION():NoTransition {
			return new NoTransition();
		}
		
		public static function get NO_TRANSITION_CENTER():NoTransitionCentered {
			return new NoTransitionCentered();
		}
		
		public static function get SLIDE_IN_OUT():SlideInSlideOut {
			return new SlideInSlideOut();
		}
		
		public static function get SLIDE_IN_OUT_RIGHT():SlideInSlideOutR {
			return new SlideInSlideOutR();
		}
	}
}