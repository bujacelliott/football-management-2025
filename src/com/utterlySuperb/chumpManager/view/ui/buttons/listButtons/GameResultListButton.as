package com.utterlySuperb.chumpManager.view.ui.buttons.listButtons
{
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.Match;
   import com.utterlySuperb.chumpManager.view.ui.buttons.ListButton;
   import com.utterlySuperb.text.TextHelper;
   import flash.text.TextField;
   import flash.text.TextFormatAlign;
   
   public class GameResultListButton extends ListButton
   {
      
      public function GameResultListButton()
      {
         super();
         mouseEnabled = false;
      }
      
      override protected function makeTextField() : void
      {
         tf = new TextField();
         addChild(tf);
         TextHelper.doTextField2(tf,Styles.LIST_FONT,18,Styles.BUTTON_FONT_COLOR,{"align":TextFormatAlign.LEFT});
      }
      
      private function setScores(param1:String, param2:String) : void
      {
         setText("-");
         var _loc3_:TextField = new TextField();
         TextHelper.doTextField2(_loc3_,Styles.MAIN_FONT,18,16777215);
         _loc3_.htmlText = param1;
         _loc3_.x = bWidth / 2 - _loc3_.textWidth - 10;
         addChild(_loc3_);
         var _loc4_:TextField = new TextField();
         TextHelper.doTextField2(_loc4_,Styles.MAIN_FONT,18,16777215);
         _loc4_.htmlText = param2;
         _loc4_.x = bWidth / 2 + 10;
         addChild(_loc4_);
      }
      
      public function setMatch(param1:Match) : void
      {
         var _loc2_:int = 0;
         var _loc5_:TextField = null;
         var _loc6_:TextField = null;
         var _loc7_:String = null;
         _loc2_ = 20;
         if(param1.extraTimePlayed)
         {
            this.setScores(param1.club0.club.name + " " + (param1.club0Score + param1.club0ETScore),param1.club1Score + param1.club1ETScore + " " + param1.club1.club.name);
            _loc5_ = new TextField();
            TextHelper.doTextField2(_loc5_,Styles.MAIN_FONT,10,16777215);
            _loc5_.htmlText = CopyManager.getCopy("afterExtraTime");
            _loc5_.y = 20;
            _loc5_.x = (bWidth - _loc5_.textWidth) / 2;
            addChild(_loc5_);
            _loc2_ += 15;
            if(param1.penaltiesScore0 > 0 || param1.penaltiesScore1 > 0)
            {
               _loc6_ = new TextField();
               TextHelper.doTextField2(_loc6_,Styles.MAIN_FONT,12,16777215);
               _loc7_ = param1.penaltiesScore0 + "-" + param1.penaltiesScore1;
               _loc6_.htmlText = CopyManager.getCopy("XwinPenalties").replace(CopyManager.CLUB_NAME_REPLACE,param1.getWinner().club.name).replace("{penaltiesScore}",_loc7_);
               _loc6_.y = _loc2_;
               _loc6_.x = (bWidth - _loc6_.textWidth) / 2;
               addChild(_loc6_);
               _loc2_ += 15;
            }
         }
         else
         {
            this.setScores(param1.club0.club.name + " " + param1.club0Score,param1.club1Score + " " + param1.club1.club.name);
         }
         tf.y = 2;
         var _loc3_:TextField = new TextField();
         TextHelper.doTextField2(_loc3_,Styles.MAIN_FONT,10,16777215,{"multiline":true});
         _loc3_.htmlText = param1.club0Scorers;
         _loc3_.width = bWidth / 2 - 30;
         _loc3_.x = bWidth / 2 - 30 - _loc3_.textWidth;
         addChild(_loc3_);
         var _loc4_:TextField = new TextField();
         TextHelper.doTextField2(_loc4_,Styles.MAIN_FONT,10,16777215,{"multiline":true});
         _loc4_.htmlText = param1.club1Scorers;
         _loc4_.width = bWidth / 2 - 30;
         _loc4_.x = bWidth / 2 + 30;
         addChild(_loc4_);
         _loc3_.y = _loc4_.y = _loc2_;
         bHeight = Math.max(30,_loc2_ + Math.max(_loc3_.textHeight,_loc4_.textHeight) + 5);
         if(param1.club0.club == Main.currentGame.playerClub || param1.club1.club == Main.currentGame.playerClub)
         {
            setBGCol(Styles.PLAYER_CLUB_COLOR);
         }
      }
   }
}

