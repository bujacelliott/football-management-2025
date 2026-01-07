package com.utterlySuperb.chumpManager.view.screens.transfers
{
   import com.utterlySuperb.chumpManager.view.panels.BGPanel;
   import com.utterlySuperb.chumpManager.view.panels.TopTabsBar;
   import com.utterlySuperb.chumpManager.view.panels.universalPanels.StatusPanel;
   import com.utterlySuperb.chumpManager.view.screens.Screen;
   import com.utterlySuperb.chumpManager.view.ui.buttons.BigButton;
   import com.utterlySuperb.events.IntEvent;
   import com.utterlySuperb.text.TextHelper;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class TransfersScreen extends Screen
   {
      
      private var tabs:TopTabsBar;
      
      private var playerSearchBtn:BigButton;
      
      private var browseClubBtn:BigButton;
      
      private var transferHub:BGPanel;
      
      private var transferHistoryBtn:BigButton;
      
      private var topTransfersBtn:BigButton;
      
      public function TransfersScreen()
      {
         super();
         var _loc1_:StatusPanel = new StatusPanel();
         _loc1_.y = Globals.MARGIN_Y;
         addChild(_loc1_);
         this.tabs = new TopTabsBar(TopTabsBar.TAB_TRANSFERS);
         this.tabs.addEventListener(TopTabsBar.TAB_CLICK,this.tabClickHandler);
         this.tabs.y = _loc1_.y + StatusPanel.HEIGHT + 6;
         addChild(this.tabs);
         var _loc2_:int = this.tabs.y + 40;
         var _loc3_:int = Globals.MARGIN_X;
         this.playerSearchBtn = new BigButton("Search for a player","",240,70);
         this.playerSearchBtn.x = _loc3_;
         this.playerSearchBtn.y = _loc2_;
         addMadeButton(this.playerSearchBtn);
         this.browseClubBtn = new BigButton("Browse a club's player","",240,70);
         this.browseClubBtn.x = _loc3_;
         this.browseClubBtn.y = this.playerSearchBtn.y + 85;
         addMadeButton(this.browseClubBtn);
         this.transferHub = new BGPanel(260,260,16777215,0x0F3B2E,0.9,10);
         this.transferHub.x = _loc3_ + 260;
         this.transferHub.y = _loc2_;
         addChild(this.transferHub);
         var _loc4_:TextField = new TextField();
         TextHelper.doTextField2(_loc4_,Styles.HEADER_FONT,18,16777215);
         _loc4_.text = "Transfer hub";
         _loc4_.x = this.transferHub.x + (this.transferHub.width - _loc4_.textWidth) / 2;
         _loc4_.y = this.transferHub.y + 10;
         addChild(_loc4_);
         var _loc5_:int = this.transferHub.x + this.transferHub.width + 20;
         this.transferHistoryBtn = new BigButton("Transfer History","",220,70);
         this.transferHistoryBtn.x = _loc5_;
         this.transferHistoryBtn.y = _loc2_;
         addMadeButton(this.transferHistoryBtn);
         this.topTransfersBtn = new BigButton("Top Transfers","",220,70);
         this.topTransfersBtn.x = _loc5_;
         this.topTransfersBtn.y = this.transferHistoryBtn.y + 85;
         addMadeButton(this.topTransfersBtn);
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
            case this.playerSearchBtn:
               Main.instance.showScreen(Screen.PLAYER_SEARCH_SCREEN);
               break;
            case this.browseClubBtn:
               Main.instance.showScreen(Screen.BROWSE_CLUBS_SCREEN);
         }
      }
   }
}
