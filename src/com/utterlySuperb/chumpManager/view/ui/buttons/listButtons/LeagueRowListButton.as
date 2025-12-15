package com.utterlySuperb.chumpManager.view.ui.buttons.listButtons
{
   import com.utterlySuperb.chumpManager.model.dataObjects.competitions.CompetitionInfo;
   import com.utterlySuperb.chumpManager.view.ui.buttons.ListButton;
   import com.utterlySuperb.text.TextHelper;
   import flash.text.TextField;
   import flash.text.TextFormatAlign;
   
   public class LeagueRowListButton extends ListButton
   {
      
      private var gamesTF:TextField;
      
      private var winsTF:TextField;
      
      private var drawsTF:TextField;
      
      private var losesTF:TextField;
      
      private var forTF:TextField;
      
      private var againstTF:TextField;
      
      private var goalDifTF:TextField;
      
      private var pointsTF:TextField;
      
      public function LeagueRowListButton()
      {
         super();
         mouseEnabled = false;
      }
      
      private function addTextField(param1:int) : TextField
      {
         var _loc2_:TextField = new TextField();
         TextHelper.doTextField2(_loc2_,Styles.MAIN_FONT,14,16777215,{"align":TextFormatAlign.CENTER});
         _loc2_.x = param1;
         _loc2_.y = 3;
         addChild(_loc2_);
         return _loc2_;
      }
      
      override protected function makeTextField() : void
      {
         tf = this.addTextField(3);
         tf.width = 120;
         var _loc1_:int = 135;
         this.gamesTF = this.addTextField(_loc1_);
         _loc1_ += 26;
         this.winsTF = this.addTextField(_loc1_);
         _loc1_ += 24;
         this.drawsTF = this.addTextField(_loc1_);
         _loc1_ += 24;
         this.losesTF = this.addTextField(_loc1_);
         _loc1_ += 24;
         this.forTF = this.addTextField(_loc1_);
         _loc1_ += 26;
         this.againstTF = this.addTextField(_loc1_);
         _loc1_ += 26;
         this.goalDifTF = this.addTextField(_loc1_);
         _loc1_ += 29;
         this.pointsTF = this.addTextField(_loc1_);
      }
      
      public function setInfo(param1:CompetitionInfo) : void
      {
         tf.htmlText = param1.club.shortName;
         this.gamesTF.htmlText = param1.gamesPlayed.toString();
         this.winsTF.htmlText = param1.wins.toString();
         this.drawsTF.htmlText = param1.draws.toString();
         this.losesTF.htmlText = param1.loses.toString();
         this.forTF.htmlText = param1.goalsScored.toString();
         this.againstTF.htmlText = param1.goalsConceeded.toString();
         this.goalDifTF.htmlText = param1.goalDifference.toString();
         this.pointsTF.htmlText = param1.points.toString();
      }
      
      public function makeLabels() : void
      {
         this.gamesTF.htmlText = "G";
         this.winsTF.htmlText = "W";
         this.winsTF.x -= 3;
         this.drawsTF.htmlText = "D";
         this.losesTF.htmlText = "L";
         this.forTF.htmlText = "F";
         this.againstTF.htmlText = "A";
         this.goalDifTF.htmlText = "GD";
         this.goalDifTF.x -= 5;
         this.pointsTF.htmlText = "P";
         this.gamesTF.textColor = this.winsTF.textColor = this.drawsTF.textColor = this.losesTF.textColor = this.forTF.textColor = this.againstTF.textColor = this.goalDifTF.textColor = this.pointsTF.textColor = 0;
      }
   }
}

