package com.utterlySuperb.chumpManager.view.panels
{
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.competitions.Cup;
   import com.utterlySuperb.text.TextHelper;
   import flash.text.TextField;
   
   public class CupInfo extends Panel
   {
      
      public function CupInfo()
      {
         super();
      }
      
      override protected function init() : void
      {
      }
      
      public function setCompetition(param1:Cup) : void
      {
         var _loc2_:TextField = new TextField();
         TextHelper.doTextField2(_loc2_,Styles.HEADER_FONT,14,16777215);
         _loc2_.htmlText = CopyManager.getCopy(param1.name);
         addChild(_loc2_);
         var _loc3_:TextField = new TextField();
         TextHelper.doTextField2(_loc3_,Styles.MAIN_FONT,12,16777215);
         if(param1.isFinished())
         {
            if(param1.entrants[0].club == Main.currentGame.playerClub)
            {
               _loc3_.htmlText = CopyManager.getCopy("youHaveWonCup");
            }
            else
            {
               _loc3_.htmlText = CopyManager.getCopy("cupWonCopy").replace(CopyManager.CLUB_NAME_REPLACE,param1.entrants[0].club.name).replace("{cupName}",CopyManager.getCopy(param1.name));
            }
         }
         else if(param1.playerIsStillIn())
         {
            _loc3_.htmlText = CopyManager.getCopy("yourNextMatch").replace(CopyManager.WEEKNUM_REPLACE,param1.getNextPlayerRound(Main.currentGame.weekNum) + 1);
         }
         else if(param1.beenKnockedOut(Main.currentGame.playerClub))
         {
            _loc3_.htmlText = CopyManager.getCopy("youHaveBeenKnockedOutCup");
         }
         else
         {
            _loc3_.htmlText = CopyManager.getCopy("youAreNotInCup");
         }
         _loc3_.y = _loc2_.textHeight;
         addChild(_loc3_);
      }
   }
}

