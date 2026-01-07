package com.utterlySuperb.chumpManager.view.screens
{
   import com.utterlySuperb.chumpManager.view.panels.TopTabsBar;
   import com.utterlySuperb.chumpManager.view.panels.universalPanels.StatusPanel;
   import com.utterlySuperb.chumpManager.view.ui.buttons.BigButton;
   import com.utterlySuperb.events.IntEvent;
   import flash.events.Event;
   
   public class AcademyScreen extends Screen
   {
      
      private var tabs:TopTabsBar;
      
      private var scoutingBtn:BigButton;
      
      private var academyBtn:BigButton;
      
      private var trainingBtn:BigButton;
      
      public function AcademyScreen()
      {
         super();
         var _loc1_:StatusPanel = new StatusPanel();
         _loc1_.y = Globals.MARGIN_Y;
         addChild(_loc1_);
         this.tabs = new TopTabsBar(TopTabsBar.TAB_ACADEMY);
         this.tabs.addEventListener(TopTabsBar.TAB_CLICK,this.tabClickHandler);
         this.tabs.y = _loc1_.y + StatusPanel.HEIGHT + 6;
         addChild(this.tabs);
         var _loc2_:int = Globals.MARGIN_X;
         var _loc3_:int = this.tabs.y + 40;
         var _loc4_:int = 240;
         var _loc5_:int = 140;
         this.scoutingBtn = new BigButton("Scouting","",_loc4_,_loc5_);
         this.scoutingBtn.x = _loc2_;
         this.scoutingBtn.y = _loc3_;
         addMadeButton(this.scoutingBtn);
         this.academyBtn = new BigButton("Academy","",_loc4_,_loc5_);
         this.academyBtn.x = _loc2_ + _loc4_ + 20;
         this.academyBtn.y = _loc3_;
         addMadeButton(this.academyBtn);
         this.trainingBtn = new BigButton("Training","",_loc4_,_loc5_);
         this.trainingBtn.x = this.academyBtn.x + _loc4_ + 20;
         this.trainingBtn.y = _loc3_;
         addMadeButton(this.trainingBtn);
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
            case TopTabsBar.TAB_OFFICE:
               Main.instance.showScreen(Screen.OFFICE_SCREEN);
         }
      }
      
      override protected function clickButtonHandler(param1:Event) : void
      {
         switch(param1.target)
         {
            case this.trainingBtn:
               Main.instance.showScreen(Screen.TRAINING_SCREEN);
               break;
         }
      }
   }
}
