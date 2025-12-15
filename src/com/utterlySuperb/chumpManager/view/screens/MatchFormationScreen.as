package com.utterlySuperb.chumpManager.view.screens
{
   import com.utterlySuperb.chumpManager.view.panels.SetFormationPanel;
   
   public class MatchFormationScreen extends Screen
   {
      
      private var setFormation:SetFormationPanel;
      
      public function MatchFormationScreen()
      {
         super();
         makeBackButton();
         addStatus();
         Main.instance.backOverride = Screen.MATCH_SCREEN;
         this.setFormation = new SetFormationPanel();
         this.setFormation.state = SetFormationPanel.IN_MATCH;
         addChild(this.setFormation);
         this.setFormation.y = Globals.belowStatus;
         enabled = true;
      }
   }
}

