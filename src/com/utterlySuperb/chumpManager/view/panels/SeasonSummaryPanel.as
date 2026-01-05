package com.utterlySuperb.chumpManager.view.panels
{
   import com.utterlySuperb.chumpManager.engine.GameHelper;
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.Game;
   import com.utterlySuperb.chumpManager.model.dataObjects.competitions.CompetitionInfo;
   import com.utterlySuperb.chumpManager.view.modals.SubmitScoreModal;
   import com.utterlySuperb.chumpManager.view.ui.buttons.ChumpButton;
   import com.utterlySuperb.chumpManager.view.ui.buttons.MediumButton;
   import com.utterlySuperb.events.IntEvent;
   import com.utterlySuperb.text.TextHelper;
   import com.utterlySuperb.ui.ModalDialogue;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class SeasonSummaryPanel extends Panel
   {
      
      public static const BOX_WIDTH:int = 320;
      
      private var submitButton:ChumpButton;
      
      private var totalScore:int;
      
      public function SeasonSummaryPanel()
      {
         var _loc6_:CompetitionInfo = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Number = NaN;
         super();
         var _loc1_:TextField = new TextField();
         TextHelper.doTextField2(_loc1_,Styles.HEADER_FONT,22,16777215,{"multiline":true});
         _loc1_.width = BOX_WIDTH - 40;
         var _loc2_:Game = Main.currentGame;
         var _loc3_:int = GameHelper.getPlayerLeaguePosition();
         var _loc4_:int = GameHelper.getMeritPayment();
         var _loc5_:* = CopyManager.getCopy("seasonEnd").replace("{finishPosition}",TextHelper.addHtmlFont(_loc3_.toString(),Styles.HEADER_FONT,"18")).replace("{meritPayment}",TextHelper.addHtmlFont(CopyManager.getCurrency() + TextHelper.prettifyNumber(_loc4_),Styles.HEADER_FONT,"18"));
         var _loc11_:Boolean = _loc2_.getMainLeague().entrants.length - _loc3_ <= 2;
         if(!_loc11_)
         {
            if(_loc3_ < 5)
            {
               _loc5_ += "<br><br>" + CopyManager.getCopy("eligleForEuro").replace("{cupName}",CopyManager.getCopy("europeanCup"));
            }
         }
         _loc6_ = _loc2_.getMainLeague().getCompetitionInfo(_loc2_.playerClub);
         _loc7_ = (_loc2_.getMainLeague().entrants.length - _loc6_.currentPosition) * 10000;
         _loc8_ = _loc6_.goalsScored * 50;
         _loc9_ = _loc6_.goalDifference * 200;
         _loc10_ = _loc6_.club.scoreMultiplier;
         this.totalScore = (_loc7_ + _loc8_ + _loc9_) * _loc10_;
         _loc5_ += "<br><br>" + CopyManager.getCopy("postionScore") + TextHelper.addHtmlFont(_loc7_.toString(),Styles.HEADER_FONT,"18");
         _loc5_ = _loc5_ + ("<br>" + CopyManager.getCopy("goalScore") + TextHelper.addHtmlFont(_loc8_.toString(),Styles.HEADER_FONT,"18"));
         _loc5_ = _loc5_ + ("<br>" + CopyManager.getCopy("goalDifScore") + TextHelper.addHtmlFont(_loc9_.toString(),Styles.HEADER_FONT,"18"));
         _loc5_ = _loc5_ + ("<br>" + CopyManager.getCopy("seasonClubBonus") + TextHelper.addHtmlFont(_loc10_.toFixed(1),Styles.HEADER_FONT,"18"));
         _loc5_ = _loc5_ + ("<br><br>" + TextHelper.addHtmlFont(CopyManager.getCopy("totalScore") + TextHelper.prettifyNumber(this.totalScore),Styles.HEADER_FONT,"20"));
         if(_loc11_)
         {
            _loc5_ += "<br><br>" + "Your team has been relegated.";
         }
         if(_loc2_.seasonNum == 0)
         {
            this.submitButton = new MediumButton(CopyManager.getCopy("submitScore"));
         }
         _loc1_.htmlText = _loc5_;
         _loc1_.x = _loc1_.y = 20;
         makeBox(BOX_WIDTH,_loc1_.textHeight + 50,0,0);
         if(this.submitButton)
         {
            this.submitButton.y = boxHeight + 20;
            addButton(this.submitButton);
         }
         addChild(_loc1_);
         enable();
      }
      
      override protected function clickButtonHandler(param1:Event) : void
      {
         var _loc2_:SubmitScoreModal = new SubmitScoreModal();
         _loc2_.addEventListener(ModalDialogue.MAKE_CHOICE,this.makeModalChoiceHandler);
         Main.instance.addModal(_loc2_);
      }
      
      private function makeModalChoiceHandler(param1:IntEvent) : void
      {
         var _loc2_:SubmitScoreModal = param1.target as SubmitScoreModal;
         _loc2_.removeEventListener(ModalDialogue.MAKE_CHOICE,this.makeModalChoiceHandler);
         Main.instance.removeModal(_loc2_);
         if(param1.num == 0)
         {
            this.submitButton.visible = false;
            HighScoreHandler.handleScoreEvent(this.totalScore,_loc2_.inputField.text);
         }
      }
      
      override protected function cleanUp() : void
      {
         removeAllButtons();
      }
   }
}

