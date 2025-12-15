package com.utterlySuperb.chumpManager.view.screens
{
   import com.utterlySuperb.chumpManager.model.dataObjects.Game;
   import com.utterlySuperb.chumpManager.view.panels.CupInfo;
   import com.utterlySuperb.chumpManager.view.panels.LeagueTablePanel;
   import com.utterlySuperb.chumpManager.view.panels.TopScorersPanel;
   import com.utterlySuperb.chumpManager.view.panels.universalPanels.StatusPanel;
   import flash.events.Event;
   
   public class CompetitionsScreen extends Screen
   {
      
      public function CompetitionsScreen()
      {
         var _loc3_:TopScorersPanel = null;
         super();
         makeBackButton();
         makeHomeButton();
         Main.instance.backOverride = Screen.MANAGERS_SCREEN;
         enabled = true;
         var _loc1_:StatusPanel = new StatusPanel();
         addChild(_loc1_);
         var _loc2_:LeagueTablePanel = new LeagueTablePanel();
         _loc2_.x = Globals.MARGIN_X;
         _loc2_.y = 120;
         _loc2_.addEventListener(Event.ADDED_TO_STAGE,this.leaguePanelAdded);
         _loc2_.aHeight = Globals.GAME_HEIGHT - 140 - Main.currentGame.fixtureList.cups.length * 40;
         addChild(_loc2_);
         _loc3_ = new TopScorersPanel();
         _loc3_.x = Globals.GAME_WIDTH - TopScorersPanel.BOX_WIDTH - Globals.MARGIN_X;
         _loc3_.y = _loc2_.y;
         addChild(_loc3_);
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
            _loc5_.x = Globals.MARGIN_X;
            _loc5_.y = _loc2_.y + _loc2_.boxHeight + 10 + 35 * _loc4_;
            _loc4_++;
         }
      }
      
      override protected function clickButtonHandler(param1:Event) : void
      {
      }
   }
}

