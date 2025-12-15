package com.utterlySuperb.chumpManager.view.screens
{
   import com.utterlySuperb.chumpManager.engine.GameEngine;
   import com.utterlySuperb.chumpManager.engine.GameHelper;
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.Game;
   import com.utterlySuperb.chumpManager.view.panels.CupInfo;
   import com.utterlySuperb.chumpManager.view.panels.LeagueTablePanel;
   import com.utterlySuperb.chumpManager.view.panels.SeasonSummaryPanel;
   import com.utterlySuperb.chumpManager.view.ui.buttons.ChumpButton;
   import com.utterlySuperb.chumpManager.view.ui.buttons.MediumButton;
   import flash.events.Event;
   
   public class SeasonEndScreen extends Screen
   {
      
      private var continueButton:ChumpButton;
      
      public function SeasonEndScreen()
      {
         super();
         var _loc1_:LeagueTablePanel = new LeagueTablePanel();
         _loc1_.x = Globals.GAME_WIDTH - LeagueTablePanel.BOX_WIDTH - Globals.MARGIN_X;
         _loc1_.y = 20;
         _loc1_.addEventListener(Event.ADDED_TO_STAGE,this.leaguePanelAdded);
         _loc1_.aHeight = Globals.GAME_HEIGHT - 140 - Main.currentGame.fixtureList.cups.length * 40;
         addChild(_loc1_);
         var _loc2_:SeasonSummaryPanel = new SeasonSummaryPanel();
         _loc2_.x = Globals.MARGIN_X;
         _loc2_.y = _loc1_.y;
         addChild(_loc2_);
         this.continueButton = new MediumButton(CopyManager.getCopy("continue"));
         this.continueButton.x = Globals.MARGIN_X;
         this.continueButton.y = Globals.GAME_HEIGHT - Globals.MARGIN_Y - 50;
         addMadeButton(this.continueButton);
         enabled = true;
      }
      
      private function leaguePanelAdded(param1:Event) : void
      {
         var _loc5_:CupInfo = null;
         param1.target.removeEventListener(Event.ADDED_TO_STAGE,this.leaguePanelAdded);
         var _loc2_:LeagueTablePanel = param1.target as LeagueTablePanel;
         var _loc3_:Game = Main.currentGame;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.fixtureList.cups.length)
         {
            _loc5_ = new CupInfo();
            _loc5_.setCompetition(_loc3_.fixtureList.cups[_loc4_]);
            addChild(_loc5_);
            _loc5_.x = _loc2_.x;
            _loc5_.y = _loc2_.y + _loc2_.boxHeight + 10 + 35 * _loc4_;
            _loc4_++;
         }
      }
      
      override protected function clickButtonHandler(param1:Event) : void
      {
         var _loc2_:int = GameHelper.getPlayerLeaguePosition();
         if(Main.currentGame.leagues[0].entrants.length - _loc2_ > 2)
         {
            GameEngine.processSeasonFinish(Main.currentGame);
            GameEngine.initSeason(Main.currentGame);
         }
         else
         {
            Main.instance.showScreen(Screen.START_SCREEN);
         }
      }
   }
}

