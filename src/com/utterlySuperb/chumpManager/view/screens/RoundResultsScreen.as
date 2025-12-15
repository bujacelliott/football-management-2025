package com.utterlySuperb.chumpManager.view.screens
{
   import com.greensock.TweenLite;
   import com.utterlySuperb.chumpManager.engine.GameEngine;
   import com.utterlySuperb.chumpManager.engine.SavesManager;
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.view.modals.PleaseWaitModal;
   import com.utterlySuperb.chumpManager.view.panels.RoundResultsPanel;
   import com.utterlySuperb.chumpManager.view.panels.universalPanels.StatusPanel;
   import com.utterlySuperb.chumpManager.view.ui.buttons.ChumpButton;
   import com.utterlySuperb.chumpManager.view.ui.buttons.MediumButton;
   import com.utterlySuperb.ui.ModalDialogue;
   import flash.events.Event;
   
   public class RoundResultsScreen extends Screen
   {
      
      private var pleaseWaitModal:ModalDialogue;
      
      public function RoundResultsScreen()
      {
         super();
         this.pleaseWaitModal = new PleaseWaitModal("",CopyManager.getCopy("playingRoundMatches"),[]);
         Main.instance.addModal(this.pleaseWaitModal);
         addEventListener(Event.ENTER_FRAME,this.playMatchesHandler);
      }
      
      private function playMatchesHandler(param1:Event) : void
      {
         if(!GameEngine.playAMatch(Main.currentGame))
         {
            removeEventListener(Event.ENTER_FRAME,this.playMatchesHandler);
            TweenLite.delayedCall(2,this.finishedWorkOut);
         }
      }
      
      private function finishedWorkOut() : void
      {
         Main.instance.removeModal(this.pleaseWaitModal);
         this.pleaseWaitModal = null;
         this.finishedMatches();
      }
      
      private function finishedMatches() : void
      {
         var _loc1_:StatusPanel = new StatusPanel();
         addChild(_loc1_);
         GameEngine.playRoundMatches(Main.currentGame);
         var _loc2_:RoundResultsPanel = new RoundResultsPanel();
         _loc2_.x = Globals.MARGIN_X;
         _loc2_.y = Globals.belowStatus;
         addChild(_loc2_);
         var _loc3_:ChumpButton = new MediumButton(CopyManager.getCopy("continue"));
         _loc3_.x = Globals.MARGIN_X;
         _loc3_.y = Globals.GAME_HEIGHT - (Globals.MARGIN_Y + 50);
         addMadeButton(_loc3_);
         enabled = true;
         GameEngine.advanceRound(Main.currentGame);
         Main.currentGame.matchDetails = null;
         SavesManager.saveGame();
      }
      
      override protected function clickButtonHandler(param1:Event) : void
      {
         Main.currentGame.matchDetails = null;
         Main.instance.showScreen(Screen.MAIN_SCREEN);
         GameEngine.doRoundUpdates();
      }
   }
}

