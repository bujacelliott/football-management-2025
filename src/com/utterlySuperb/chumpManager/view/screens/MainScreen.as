package com.utterlySuperb.chumpManager.view.screens
{
   import com.utterlySuperb.chumpManager.engine.GameEngine;
   import com.utterlySuperb.chumpManager.view.panels.ClubFixturesPanel;
   import com.utterlySuperb.chumpManager.view.panels.StandingsPanel;
   import com.utterlySuperb.chumpManager.view.panels.TopTabsBar;
   import com.utterlySuperb.chumpManager.view.panels.TransfersSummaryPanel;
   import com.utterlySuperb.chumpManager.view.panels.universalPanels.StatusPanel;
   import com.utterlySuperb.chumpManager.view.ui.buttons.BigButton;
   import com.utterlySuperb.events.IntEvent;
   import flash.events.Event;
   
   public class MainScreen extends Screen
   {
      
      private var tabs:TopTabsBar;
      
      private var continueButton:BigButton;
      
      private var transfersPanel:TransfersSummaryPanel;
      
      private var fixturesPanel:ClubFixturesPanel;
      
      private var standingsPanel:StandingsPanel;
      
      public function MainScreen()
      {
         super();
         var _loc1_:StatusPanel = new StatusPanel();
         _loc1_.y = Globals.MARGIN_Y;
         addChild(_loc1_);
         this.tabs = new TopTabsBar(TopTabsBar.TAB_CONTROL);
         this.tabs.addEventListener(TopTabsBar.TAB_CLICK,this.tabClickHandler);
         this.tabs.y = _loc1_.y + StatusPanel.HEIGHT + 6;
         addChild(this.tabs);
         var _loc2_:int = Globals.MARGIN_X;
         var _loc3_:int = this.tabs.y + 40;
         var _loc4_:int = 240;
         var _loc5_:int = 20;
         var _loc6_:int = _loc2_ + _loc4_ + _loc5_;
         var _loc7_:int = _loc6_ + _loc4_ + _loc5_;
         this.continueButton = new BigButton("Continue","",_loc4_,70);
         this.continueButton.x = _loc2_;
         this.continueButton.y = _loc3_;
         addMadeButton(this.continueButton);
         this.transfersPanel = new TransfersSummaryPanel(_loc4_,220);
         this.transfersPanel.x = _loc2_;
         this.transfersPanel.y = this.continueButton.y + this.continueButton.height + 20;
         addChild(this.transfersPanel);
         this.fixturesPanel = new ClubFixturesPanel(_loc4_,320);
         this.fixturesPanel.x = _loc6_;
         this.fixturesPanel.y = _loc3_;
         addChild(this.fixturesPanel);
         this.standingsPanel = new StandingsPanel(_loc4_,320,"Standings");
         this.standingsPanel.x = _loc7_;
         this.standingsPanel.y = _loc3_;
         this.standingsPanel.setLeague(Main.currentGame.getMainLeague());
         addChild(this.standingsPanel);
         Main.currentGame.matchDetails = null;
         enabled = true;
      }
      
      private function tabClickHandler(param1:IntEvent) : void
      {
         switch(param1.num)
         {
            case TopTabsBar.TAB_CONTROL:
               Main.instance.showScreen(Screen.MAIN_SCREEN);
               break;
            case TopTabsBar.TAB_SQUAD:
               Main.instance.showScreen(Screen.CLUB_SCREEN);
               break;
            case TopTabsBar.TAB_TRANSFERS:
               Main.instance.showScreen(Screen.TRANSFERS_SCREEN);
               break;
            case TopTabsBar.TAB_ACADEMY:
               Main.instance.showScreen(Screen.ACADEMY_SCREEN);
               break;
            case TopTabsBar.TAB_OFFICE:
               Main.instance.showScreen(Screen.OFFICE_SCREEN);
         }
      }
      
      override protected function clickButtonHandler(param1:Event) : void
      {
         switch(param1.target)
         {
            case this.continueButton:
               GameEngine.nextRound(Main.currentGame);
         }
      }
   }
}
