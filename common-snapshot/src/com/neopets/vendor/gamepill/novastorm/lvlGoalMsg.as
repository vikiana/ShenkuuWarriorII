package com.neopets.vendor.gamepill.novastorm
{
	import virtualworlds.lang.TranslationManager;
	import virtualworlds.lang.TranslationData;

	import flash.ui.Mouse;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.events.*;

	/*
	   *  levelGoal class
	   *  levelGoal display
	   * 
	   *  @langversion ActionScript 3.0
	   *  @playerversion Flash 9.0
	   * 
	   *  @author Christopher Emirzian
	   *  @since  11.11.2009
	   */

	public class lvlGoalMsg extends msgDisplay {
		//public var translation=new TranslationInfo();

		public var levelData:level=new level();// level data

		public function lvlGoalMsg() {
			super();

			msgText.y=250;
			msgText.text.height=205;
			okBtn.y=480;


			TranslationManager.instance.setTextField(this.msgHeader.text, "<p align='center'>"+mTranslationData.IDS_LEVELGOAL_Goal+"</p>")
			
			//this.msgHeader.text.htmlText="<p align='center'>"+mTranslationData.IDS_LEVELGOAL_Goal+"</p>";
			//this.okBtn.text.htmlText="<p align='center'>"+mTranslationData.IDS_BTN_OK+"</p>";
		}

		public override function okBtnPressed(event:MouseEvent) {
			this.container.startLevel();
		}

		public function show(levelNum:int) {
			showAnim();

			var levelDesc:String=levelData.data[levelNum].desc;

			if (levelData.data[levelNum].goal==levelData.levelGoalDestroy) 
			{
				/*
				trace (mTranslationData.IDS_LEVELGOAL_Destroy)
				trace (levelData.data[levelNum].goalVal)
				trace (mTranslationData.IDS_LEVELGOAL_Enemies)
				trace ()
				*/
				TranslationManager.instance.setTextField(this.msgText.text, "<p align='center'><font size='12'>"+mTranslationData.IDS_LEVELGOAL_Destroy+" "+levelData.data[levelNum].goalVal+" "+mTranslationData.IDS_LEVELGOAL_Enemies+"!\n\n"+levelDesc+"</font></p>")
				//this.msgText.text.htmlText="<p align='center'><font size='12'>"+mTranslationData.IDS_LEVELGOAL_Destroy+" "+levelData.data[levelNum].goalVal+" "+mTranslationData.IDS_LEVELGOAL_Enemies+"!\n\n"+levelDesc+"</font></p>";
			}
			if (levelData.data[levelNum].goal==levelData.levelGoalSurvive) 
			{
				var levelTime:int=(levelData.data[levelNum].goalVal/this.container.frameRate);
				var timeText:String;

				if (levelTime>=60) {
					timeText="1:"+(levelTime-60);
				} else {
					timeText="0:"+levelTime;

				}
				TranslationManager.instance.setTextField(this.msgText.text, "<p align='center'><font size='12'>"+mTranslationData.IDS_LEVELGOAL_SurviveFor+" "+timeText+"!\n\n"+levelDesc+"</p>")
				//this.msgText.text.htmlText="<p align='center'><font size='12'>"+mTranslationData.IDS_LEVELGOAL_SurviveFor+" "+timeText+"!\n\n"+levelDesc+"</p>";
			}
			if (levelData.data[levelNum].goal==levelData.levelGoalProtect) 
			{
				TranslationManager.instance.setTextField(this.msgText.text, "<p align='center'><font size='12'>"+mTranslationData.IDS_LEVELGOAL_Protect+"!\n\n"+levelDesc+"</font></p>")
				//this.msgText.text.htmlText="<p align='center'><font size='12'>"+mTranslationData.IDS_LEVELGOAL_Protect+"!\n\n"+levelDesc+"</font></p>";
			}
			if (levelData.data[levelNum].goal==levelData.levelGoalBoss) 
			{
				TranslationManager.instance.setTextField(this.msgText.text, "<p align='center'><font size='12'>"+mTranslationData.IDS_LEVELGOAL_Boss+"!\n\n"+levelDesc+"</font></p>")
				//this.msgText.text.htmlText="<p align='center'><font size='12'>"+mTranslationData.IDS_LEVELGOAL_Boss+"!\n\n"+levelDesc+"</font></p>";
			}
		}
	}
}