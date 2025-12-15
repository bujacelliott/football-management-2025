package com.utterlySuperb.chumpManager.view.screens
{
   import com.utterlySuperb.chumpManager.view.panels.SetFormationPanel;
   
   public class PreMatchFormationScreen extends Screen
   {
      
      private var setFormation:SetFormationPanel;
      
      public function PreMatchFormationScreen()
      {
         super();
         makeBackButton();
         addStatus();
         Main.instance.backOverride = Screen.PRE_MATCH_SCREEN;
         this.setFormation = new SetFormationPanel();
         this.setFormation.state = SetFormationPanel.PRE_MATCH;
         addChild(this.setFormation);
         this.setFormation.y = Globals.belowStatus;
         enabled = true;
      }
   }
}

