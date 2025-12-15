package com.utterlySuperb.chumpManager.view.screens
{
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.view.panels.universalPanels.StatusPanel;
   import com.utterlySuperb.chumpManager.view.ui.buttons.BigButton;
   import flash.events.Event;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   
   public class ManagersScreen extends Screen
   {
      
      private var competitionsBtn:BigButton;
      
      private var transfersBtn:BigButton;
      
      private var financesBtn:BigButton;
      
      private var backBtn2:BigButton;
      
      public function ManagersScreen()
      {
         super();
         makeBackButton();
         makeHomeButton();
         var _loc1_:StatusPanel = new StatusPanel();
         addChild(_loc1_);
         this.competitionsBtn = new BigButton(CopyManager.getCopy("competitions"),CopyManager.getCopy("competitionsInfo"));
         this.competitionsBtn.x = Globals.MARGIN_X;
         this.competitionsBtn.y = Globals.MARGIN_Y + StatusPanel.HEIGHT + 50;
         addMadeButton(this.competitionsBtn);
         this.transfersBtn = new BigButton(CopyManager.getCopy("transfers"),CopyManager.getCopy("transfersInfo"));
         this.transfersBtn.x = Globals.MARGIN_X;
         this.transfersBtn.y = this.competitionsBtn.y + 100;
         addMadeButton(this.transfersBtn);
         this.financesBtn = new BigButton(CopyManager.getCopy("finances"),CopyManager.getCopy("financesInfo"));
         this.financesBtn.x = Globals.MARGIN_X;
         this.financesBtn.y = this.transfersBtn.y + 100;
         addMadeButton(this.financesBtn);
         this.backBtn2 = new BigButton(CopyManager.getCopy("back"),CopyManager.getCopy("backInfo"));
         this.backBtn2.x = Globals.MARGIN_X;
         this.backBtn2.y = this.financesBtn.y + 100;
         addMadeButton(this.backBtn2);
         var _loc2_:ManagerImage = new ManagerImage();
         _loc2_.x = 410;
         _loc2_.y = this.competitionsBtn.y;
         addChild(_loc2_);
         _loc2_.filters = [new GlowFilter(16777215,1,2,2,5,3),new DropShadowFilter(4,45,0,0.5)];
         enabled = true;
      }
      
      override protected function clickButtonHandler(param1:Event) : void
      {
         switch(param1.target)
         {
            case this.competitionsBtn:
               Main.instance.showScreen(Screen.COMPETITIONS_SCREEN);
               break;
            case this.transfersBtn:
               Main.instance.showScreen(Screen.TRANSFERS_SCREEN);
               break;
            case this.financesBtn:
               Main.instance.showScreen(Screen.FINANCE_SCREEN);
               break;
            case this.backBtn2:
               Main.instance.showScreen(Screen.MAIN_SCREEN);
         }
      }
   }
}

