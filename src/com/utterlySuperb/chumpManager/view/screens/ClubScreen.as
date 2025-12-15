package com.utterlySuperb.chumpManager.view.screens
{
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.view.panels.universalPanels.StatusPanel;
   import com.utterlySuperb.chumpManager.view.ui.buttons.BigButton;
   import flash.events.Event;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   
   public class ClubScreen extends Screen
   {
      
      private var squadButton:BigButton;
      
      private var tacticsButton:BigButton;
      
      private var trainingButton:BigButton;
      
      private var backButton2:BigButton;
      
      public function ClubScreen()
      {
         super();
         makeBackButton();
         makeHomeButton();
         addStatus();
         this.squadButton = new BigButton(CopyManager.getCopy("squad"),CopyManager.getCopy("squadInfo"));
         this.squadButton.x = Globals.MARGIN_X;
         this.squadButton.y = Globals.MARGIN_Y + StatusPanel.HEIGHT + 50;
         addMadeButton(this.squadButton);
         this.tacticsButton = new BigButton(CopyManager.getCopy("tactics"),CopyManager.getCopy("tacticsInfo"));
         this.tacticsButton.x = Globals.MARGIN_X;
         this.tacticsButton.y = this.squadButton.y + 100;
         addMadeButton(this.tacticsButton);
         this.trainingButton = new BigButton(CopyManager.getCopy("training"),CopyManager.getCopy("trainingInfo"));
         this.trainingButton.x = Globals.MARGIN_X;
         this.trainingButton.y = this.tacticsButton.y + 100;
         addMadeButton(this.trainingButton);
         this.backButton2 = new BigButton(CopyManager.getCopy("back"),CopyManager.getCopy("backInfo"));
         this.backButton2.x = Globals.MARGIN_X;
         this.backButton2.y = this.trainingButton.y + 100;
         addMadeButton(this.backButton2);
         var _loc1_:TacticsImage = new TacticsImage();
         _loc1_.x = 410;
         _loc1_.y = this.squadButton.y;
         addChild(_loc1_);
         _loc1_.filters = [new GlowFilter(16777215,1,2,2,5,3),new DropShadowFilter(4,45,0,0.5)];
         enabled = true;
      }
      
      override protected function clickButtonHandler(param1:Event) : void
      {
         switch(param1.target)
         {
            case this.squadButton:
               Main.instance.showScreen(Screen.TEAM_SCREEN);
               break;
            case this.tacticsButton:
               Main.instance.showScreen(Screen.FORMATION_SCREEN);
               break;
            case this.trainingButton:
               Main.instance.showScreen(Screen.TRAINING_SCREEN);
               break;
            case this.backButton2:
               Main.instance.showScreen(Screen.MAIN_SCREEN);
         }
      }
   }
}

