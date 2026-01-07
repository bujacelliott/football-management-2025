package com.utterlySuperb.chumpManager.view.screens
{
   import com.utterlySuperb.chumpManager.engine.SavesManager;
   import com.utterlySuperb.chumpManager.view.panels.TopTabsBar;
   import com.utterlySuperb.chumpManager.view.panels.universalPanels.StatusPanel;
   import com.utterlySuperb.chumpManager.view.ui.buttons.BigButton;
   import com.utterlySuperb.events.IntEvent;
   import flash.events.Event;
   
   public class ManagersScreen extends Screen
   {
      
      private var tabs:TopTabsBar;
      
      private var financesBtn:BigButton;
      
      private var competitionsBtn:BigButton;
      
      private var saveBtn:BigButton;
      
      private var quitBtn:BigButton;
      
      public function ManagersScreen()
      {
         super();
         var _loc1_:StatusPanel = new StatusPanel();
         _loc1_.y = Globals.MARGIN_Y;
         addChild(_loc1_);
         this.tabs = new TopTabsBar(TopTabsBar.TAB_OFFICE);
         this.tabs.addEventListener(TopTabsBar.TAB_CLICK,this.tabClickHandler);
         this.tabs.y = _loc1_.y + StatusPanel.HEIGHT + 6;
         addChild(this.tabs);
         var _loc2_:int = this.tabs.y + 40;
         var _loc3_:int = Globals.MARGIN_X;
         this.financesBtn = new BigButton("Finances","",240,140);
         this.financesBtn.x = _loc3_;
         this.financesBtn.y = _loc2_;
         addMadeButton(this.financesBtn);
         this.competitionsBtn = new BigButton("Competitions","",240,140);
         this.competitionsBtn.x = this.financesBtn.x + this.financesBtn.width + 40;
         this.competitionsBtn.y = _loc2_;
         addMadeButton(this.competitionsBtn);
         this.saveBtn = new BigButton("Save Game","",200,70);
         this.saveBtn.x = this.competitionsBtn.x + this.competitionsBtn.width + 30;
         this.saveBtn.y = _loc2_;
         addMadeButton(this.saveBtn);
         this.quitBtn = new BigButton("Quit","",200,70);
         this.quitBtn.x = this.saveBtn.x;
         this.quitBtn.y = this.saveBtn.y + 85;
         addMadeButton(this.quitBtn);
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
            case this.financesBtn:
               Main.instance.showScreen(Screen.FINANCE_SCREEN);
               break;
            case this.competitionsBtn:
               Main.instance.showScreen(Screen.COMPETITIONS_SCREEN);
               break;
            case this.saveBtn:
               SavesManager.saveGame();
               break;
            case this.quitBtn:
               Main.instance.showScreen(Screen.START_SCREEN);
         }
      }
   }
}
