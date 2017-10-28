package com.neopets.games.marketing.destination.lunchablesAwards
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class VoteNowSign extends MovieClip
	{
		
		public var title_txt:TextField;
		
		private var _curDate:Date; 
		
		public function VoteNowSign()
		{
			super();
			_curDate = new Date ();
			
		} 
		
		public function init(date1:String, date2:String, date3:String):void {
			title_txt.text = "Award\nShow";
			/*processDate (date1, "Vote\nNow");
			processDate (date2, "Visit\nMain Stage");
			processDate (date3, "Award\nShow");*/
		}
		
		
		private function processDate (d:String, newTitle:String):void {
			trace ("processing dates");
			if (_curDate.getFullYear() >= Number (d.slice (7, 11)) && _curDate.getMonth() >= Number (d.slice (0, 2))-1 && _curDate.getDate() > Number (d.slice(3,5))-1){
				title_txt.text = newTitle;
				trace ("passed");
				//date is passed
			} 
		}
		
	}
}