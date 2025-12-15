package com.utterlySuperb.chumpManager.view.screens
{
   import com.utterlySuperb.chumpManager.view.panels.TrainingList;
   
   public class TrainingScreen extends Screen
   {
      
      private var trainingList:TrainingList;
      
      public function TrainingScreen()
      {
         super();
         makeBackButton();
         makeHomeButton();
         Main.instance.backOverride = Screen.CLUB_SCREEN;
         addStatus();
         this.trainingList = new TrainingList();
         addChild(this.trainingList);
         this.trainingList.x = Globals.MARGIN_X;
         this.trainingList.y = Globals.belowStatus;
         enabled = true;
      }
   }
}

