package com.utterlySuperb.chumpManager.view.screens
{
   import com.utterlySuperb.chumpManager.view.panels.TopTabsBar;
   import com.utterlySuperb.chumpManager.view.panels.universalPanels.StatusPanel;
   import com.utterlySuperb.chumpManager.view.ui.buttons.BigButton;
   import com.utterlySuperb.events.IntEvent;
   import flash.events.Event;
   
   public class ClubScreen extends Screen
   {
      
      private var tabs:TopTabsBar;
      
      private var tacticsButton:BigButton;
      
      private var squadHubButton:BigButton;
      
      private var seasonStatsButton:BigButton;
      
      private var trainingButton:BigButton;
      
      public function ClubScreen()
      {
         super();
         var _loc1_:StatusPanel = new StatusPanel();
         _loc1_.y = Globals.MARGIN_Y;
         addChild(_loc1_);
         this.tabs = new TopTabsBar(TopTabsBar.TAB_SQUAD);
         this.tabs.addEventListener(TopTabsBar.TAB_CLICK,this.tabClickHandler);
         this.tabs.y = _loc1_.y + StatusPanel.HEIGHT + 6;
         addChild(this.tabs);
         var _loc2_:int = this.tabs.y + 40;
         var _loc3_:int = Globals.MARGIN_X;
         this.tacticsButton = new BigButton("Tactics","",320,260);
         this.tacticsButton.x = _loc3_;
         this.tacticsButton.y = _loc2_;
         addMadeButton(this.tacticsButton);
         var _loc4_:int = this.tacticsButton.x + this.tacticsButton.width + 30;
         var _loc5_:int = 220;
         var _loc6_:int = 70;
         this.squadHubButton = new BigButton("Squad Hub","",_loc5_,_loc6_);
         this.squadHubButton.x = _loc4_;
         this.squadHubButton.y = _loc2_;
         addMadeButton(this.squadHubButton);
         this.seasonStatsButton = new BigButton("Season Stats","",_loc5_,_loc6_);
         this.seasonStatsButton.x = _loc4_;
         this.seasonStatsButton.y = this.squadHubButton.y + _loc6_ + 15;
         addMadeButton(this.seasonStatsButton);
         this.trainingButton = new BigButton("Training","",_loc5_,_loc6_);
         this.trainingButton.x = _loc4_;
         this.trainingButton.y = this.seasonStatsButton.y + _loc6_ + 15;
         addMadeButton(this.trainingButton);
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
            case this.squadHubButton:
               Main.instance.showScreen(Screen.TEAM_SCREEN);
               break;
            case this.tacticsButton:
               Main.instance.showScreen(Screen.FORMATION_SCREEN);
               break;
            case this.trainingButton:
               Main.instance.showScreen(Screen.TRAINING_SCREEN);
         }
      }
   }
}
