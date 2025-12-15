package com.utterlySuperb.chumpManager.view.panels.matchPanels
{
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.MatchDetails;
   import com.utterlySuperb.chumpManager.view.panels.Panel;
   import com.utterlySuperb.text.TextHelper;
   import flash.text.TextField;
   import flash.text.TextFormatAlign;
   
   public class MatchScorePanel extends Panel
   {
      
      private var team0Score:TextField;
      
      private var team1Score:TextField;
      
      private var team0Scorers:TextField;
      
      private var team1Scorers:TextField;
      
      private var tWidth:int;
      
      public function MatchScorePanel()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.tWidth = Globals.GAME_WIDTH - Globals.MARGIN_X * 2;
         makeBox(this.tWidth,100,0,0,16777215,16777180);
         makeBox(this.tWidth,60,0,0);
         this.team0Score = new TextField();
         TextHelper.doTextField2(this.team0Score,Styles.HEADER_FONT,30,16777215);
         addChild(this.team0Score);
         this.team0Score.y = 5;
         this.team1Score = new TextField();
         TextHelper.doTextField2(this.team1Score,Styles.HEADER_FONT,30,16777215);
         addChild(this.team1Score);
         this.team1Score.y = 5;
         var _loc1_:TextField = new TextField();
         TextHelper.doTextField2(_loc1_,Styles.HEADER_FONT,32,16777215);
         addChild(_loc1_);
         _loc1_.htmlText = "-";
         _loc1_.x = this.tWidth / 2 - _loc1_.textWidth / 2;
         _loc1_.y = 5;
         this.team0Scorers = new TextField();
         TextHelper.doTextField2(this.team0Scorers,Styles.MAIN_FONT,12,0,{
            "multiline":true,
            "wordWrap":true,
            "align":TextFormatAlign.RIGHT
         });
         this.team0Scorers.y = 65;
         this.team0Scorers.width = this.tWidth / 2 - 50;
         this.team0Scorers.x = this.tWidth / 2 - this.team0Scorers.width - 50;
         addChild(this.team0Scorers);
         this.team1Scorers = new TextField();
         TextHelper.doTextField2(this.team1Scorers,Styles.MAIN_FONT,12,0,{
            "multiline":true,
            "wordWrap":true
         });
         this.team1Scorers.y = 65;
         this.team1Scorers.width = this.tWidth / 2 - 50;
         this.team1Scorers.x = this.tWidth / 2 + 50;
         addChild(this.team1Scorers);
         this.update(null);
      }
      
      override protected function update(param1:Object = null) : void
      {
         var _loc2_:MatchDetails = Main.currentGame.matchDetails;
         this.team0Score.htmlText = _loc2_.match.club0.club.shortName + " " + _loc2_.match.club0Score;
         TextHelper.fitTextField(this.team0Score);
         this.team0Score.x = this.tWidth / 2 - this.team0Score.textWidth - 15;
         this.team1Score.htmlText = _loc2_.match.club1Score + " " + _loc2_.match.club1.club.shortName;
         TextHelper.fitTextField(this.team1Score);
         this.team1Score.x = this.tWidth / 2 + 15;
         this.team0Scorers.htmlText = _loc2_.team0.getScorers();
         this.team1Scorers.htmlText = _loc2_.team1.getScorers();
      }
   }
}

