package com.neopets.games.inhouse.wheels {
	
	public class WheelOfMisfortuneClass extends WheelClass {
		
	
		public function WheelOfMisfortuneClass() {
			super();
			setTransID(803);
			setWheelID("4"); //1 = knowledge, 2 = excitement, 3 = mediocrity, 4 = misfortune, 5 = monotony
			setSlots(8);
			setWheel(mcWheelClip);			
			setFlapper(mcFlapper);
			setSoundButton(btnSound);			
			init();			
		}
		
		
		
		public override function positiveReaction() {
			trace("OVERRIDE POSITIVE REACTION");
			character.gotoAndStop(2);
		}
		
		public override function negativeReaction() {
			trace("OVERRIDE NEGATIVE REACTION");
			character.gotoAndStop(3);
		}
		
		public override function neutralReaction() {
			trace("OVERRIDE NEGATIVE REACTION");
			character.gotoAndStop(1);
		}
		
		public override function resetReaction() {
			trace("OVERRIDE RESET REACTION");
			character.gotoAndStop(1);
		}
		
		
		public override function popupPositioner() {		
			setChildIndex(popup, getChildIndex(character)-1);
		}
		
				
		
		
		
	}
	
	
}
