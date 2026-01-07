package com.utterlySuperb.chumpManager.view.modals
{
   import com.utterlySuperb.chumpManager.engine.GameEngine;
   import com.utterlySuperb.chumpManager.engine.TransfersEngine;
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.Game;
   import com.utterlySuperb.chumpManager.model.dataObjects.Message;
   import com.utterlySuperb.chumpManager.model.dataObjects.StaticInfo;
   import com.utterlySuperb.ui.ModalDialogue;
   import flash.events.Event;
   
   public class FeedbackPanel extends ModalDialogue
   {
      
      public static const OUT_OF_FA:String = "outOfFaCup";
      
      public static const OUT_OF_LEAGUE_CUP:String = "outOfLeagueCup";
      
      public static const DOING_BADLY_IN_LEAGUE:String = "doingBadLeague";
      
      public static const FA_WINNER:String = "faCupWinner";
      
      public static const LEAGUE_CUP_WINNER:String = "leagueCupWinner";
      
      public static const CLUBS_RELEGATED:String = "clubsRelegated";
      
      public static const CLUBS_PROMOTED:String = "clubsPromoted";
      
      public static const PREMIERSHIP_WINNER:String = "premiershipWINNER";
      
      private var message:Message;
      
      public function FeedbackPanel(... rest)
      {
         var _loc2_:Game = Main.currentGame;
         var _loc3_:Message = _loc2_.userMessages.shift();
         this.message = _loc3_;
         var _loc4_:String = "";
         var _loc5_:String = "";
         _loc4_ = _loc3_.title;
         _loc5_ = _loc3_.body;
         var _loc6_:Array = [CopyManager.getCopy("ok")];
         if(_loc3_.offer)
         {
            _loc6_.push(CopyManager.getCopy("decline"));
         }
         super(_loc4_,_loc5_,_loc6_);
      }
      
      override protected function makeChoiceHandler(param1:Event) : void
      {
         Main.instance.removeModal(this);
         if(this.message.offer)
         {
            if(buttons.indexOf(param1.target) == 0)
            {
               Main.currentGame.clubCash += this.message.offer.cashOff;
               TransfersEngine.transferPlayer(StaticInfo.getPlayer(this.message.offer.player),this.message.offer.toClub,Main.currentGame.playerClub);
               TransfersEngine.recordTransfer(StaticInfo.getPlayer(this.message.offer.player),Main.currentGame.playerClub,this.message.offer.toClub,this.message.offer.cashOff);
            }
         }
         GameEngine.checkMessages();
      }
   }
}

