package com.utterlySuperb.chumpManager.view.screens
{
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.view.panels.StatDisplayPanel;
   import com.utterlySuperb.chumpManager.view.ui.buttons.BigButton;
   import flash.events.Event;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   
   public class FinanceScreen extends Screen
   {
      
      private var backBtn2:BigButton;
      
      public function FinanceScreen()
      {
         var _loc2_:FinanceImage = null;
         super();
         makeBackButton();
         makeHomeButton();
         Main.instance.backOverride = Screen.MANAGERS_SCREEN;
         addStatus();
         var _loc1_:StatDisplayPanel = new StatDisplayPanel();
         _loc1_.x = Globals.MARGIN_X;
         _loc1_.y = Globals.belowStatus + 20;
         addChild(_loc1_);
         this.backBtn2 = new BigButton(CopyManager.getCopy("back"),CopyManager.getCopy("backToManagerInfo"));
         this.backBtn2.x = Globals.MARGIN_X;
         this.backBtn2.y = _loc1_.y + 300;
         addMadeButton(this.backBtn2);
         _loc2_ = new FinanceImage();
         _loc2_.x = 410;
         _loc2_.y = _loc1_.y;
         addChild(_loc2_);
         _loc2_.filters = [new GlowFilter(16777215,1,2,2,5,3),new DropShadowFilter(4,45,0,0.5)];
         enabled = true;
      }
      
      override protected function clickButtonHandler(param1:Event) : void
      {
         Main.instance.showScreen(Screen.MANAGERS_SCREEN);
      }
   }
}

