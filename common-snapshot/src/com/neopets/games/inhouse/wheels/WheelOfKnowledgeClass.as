package com.neopets.games.inhouse.wheels {
	
	public class WheelOfKnowledgeClass extends WheelClass {
		
	
		public function WheelOfKnowledgeClass() {
			super();
			setTransID(800);
			setWheelID("1"); //1 = knowledge, 2 = excitement, 3 = mediocrity, 4 = misfortune, 5 = monotony
			setSlots(16);
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
		
		
		
		
	}
	
	
}
