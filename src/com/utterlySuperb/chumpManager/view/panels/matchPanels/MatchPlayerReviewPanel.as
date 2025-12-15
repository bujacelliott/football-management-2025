package com.utterlySuperb.chumpManager.view.panels.matchPanels
{
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.MatchDetails;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.MatchPlayerDetails;
   import com.utterlySuperb.chumpManager.view.panels.Panel;
   import com.utterlySuperb.text.TextHelper;
   import flash.text.TextField;
   import flash.text.TextFormatAlign;
   
   public class MatchPlayerReviewPanel extends Panel
   {
      
      private var playerTextField:TextField;
      
      private var matchTextField:TextField;
      
      public function MatchPlayerReviewPanel()
      {
         super();
      }
      
      override protected function init() : void
      {
         makeBox(180,320);
         this.playerTextField = new TextField();
         TextHelper.doTextField2(this.playerTextField,Styles.MAIN_FONT,12,16777215,{"multiline":true});
         addChild(this.playerTextField);
         this.playerTextField.width = 140;
         this.playerTextField.x = this.playerTextField.y = 20;
         this.matchTextField = new TextField();
         TextHelper.doTextField2(this.matchTextField,Styles.MAIN_FONT,14,16777215,{
            "multiline":true,
            "align":TextFormatAlign.CENTER
         });
         addChild(this.matchTextField);
         this.matchTextField.width = 140;
         this.matchTextField.x = this.matchTextField.y = 20;
         this.setMatch(Main.currentGame.matchDetails);
         this.showMatch();
      }
      
      public function setPlayer(param1:MatchPlayerDetails = null) : void
      {
         var _loc2_:* = this.makeTextBig(param1.player.name) + "<br>";
         if(param1.player.isKeeper())
         {
            _loc2_ += CopyManager.getCopy("saves") + this.makeTextBig(param1.saves.toString()) + "<br>";
            _loc2_ += CopyManager.getCopy("goalsConceeded") + this.makeTextBig(param1.goals.toString()) + "<br>";
         }
         else
         {
            _loc2_ += CopyManager.getCopy("goals") + this.makeTextBig(param1.goals.toString()) + "<br>";
            _loc2_ += CopyManager.getCopy("assists") + this.makeTextBig(param1.assists.toString()) + "<br>";
            _loc2_ += CopyManager.getCopy("shots") + this.makeTextBig((param1.shotsOnTarget + param1.shotsOffTarget).toString()) + "<br>";
            _loc2_ += CopyManager.getCopy("shotsOnTarget") + this.makeTextBig(param1.shotsOnTarget.toString()) + "<br>";
         }
         _loc2_ += CopyManager.getCopy("foulsConceeded") + this.makeTextBig(param1.foulsConceeded.toString()) + "<br>";
         _loc2_ += CopyManager.getCopy("foulsWon") + this.makeTextBig(param1.foulsWon.toString()) + "<br>";
         _loc2_ += CopyManager.getCopy("yellowCards") + this.makeTextBig(param1.yellowCards.toString()) + "<br>";
         _loc2_ += CopyManager.getCopy("redCards") + this.makeTextBig(param1.redCards.toString()) + "<br>";
         this.playerTextField.htmlText = _loc2_;
         this.playerTextField.height = this.playerTextField.textHeight + 5;
         this.matchTextField.visible = false;
         this.playerTextField.visible = true;
      }
      
      public function setMatch(param1:MatchDetails) : void
      {
         var _loc2_:* = "";
         if(param1.match.penaltiesScore0 > 0 || param1.match.penaltiesScore1 > 0)
         {
            _loc2_ += this.makeTextBig(CopyManager.getCopy("penalties")) + "<br>" + param1.match.penaltiesScore0.toString() + " - " + param1.match.penaltiesScore1.toString() + "<br>";
         }
         _loc2_ += this.makeTextBig(CopyManager.getCopy("goals")) + "<br>" + param1.team0.getGoals().toString() + " - " + param1.team1.getGoals().toString() + "<br>";
         _loc2_ += this.makeTextBig(CopyManager.getCopy("shots")) + "<br>" + param1.team0.getShots() + " - " + param1.team1.getShots() + "<br>";
         _loc2_ += this.makeTextBig(CopyManager.getCopy("shotsOnTarget")) + "<br>" + param1.team0.getShotsOnTarget() + " - " + param1.team1.getShotsOnTarget() + "<br>";
         _loc2_ += this.makeTextBig(CopyManager.getCopy("possession")) + "<br>" + param1.getTeamPossession(0) + "% - " + param1.getTeamPossession(1) + "%<br>";
         _loc2_ += "<br>";
         _loc2_ += this.makeTextBig(CopyManager.getCopy("matchIncome")) + "<br>" + CopyManager.getCurrency() + TextHelper.prettifyNumber(param1.getMatchIncome()) + "<br>";
         _loc2_ += this.makeTextBig(CopyManager.getCopy("currentBalance")) + "<br>" + CopyManager.getCurrency() + TextHelper.prettifyNumber(Main.currentGame.clubCash) + "<br>";
         this.matchTextField.htmlText = _loc2_;
      }
      
      public function showMatch() : void
      {
         this.matchTextField.visible = true;
         this.playerTextField.visible = false;
      }
      
      private function makeTextBig(param1:String, param2:int = 14) : String
      {
         return "<font face=\'Arial Black\' size=\'" + param2 + "\'>" + param1 + "</font>";
      }
   }
}

