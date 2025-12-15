package com.utterlySuperb.chumpManager.view.screens
{
   import com.utterlySuperb.chumpManager.view.panels.NameInputPanel;
   import com.utterlySuperb.chumpManager.view.panels.SelectTeamPanel;
   
   public class SelectTeamScreen extends Screen
   {
      
      private var nameInput:NameInputPanel;
      
      private var selectTeamPanel:SelectTeamPanel;
      
      public function SelectTeamScreen()
      {
         super();
         makeBackButton();
         Main.instance.backOverride = Screen.START_SCREEN;
         this.selectTeamPanel = new SelectTeamPanel();
         addChild(this.selectTeamPanel);
         this.selectTeamPanel.x = Globals.GAME_WIDTH / 2;
         this.selectTeamPanel.y = Globals.HEADER_OFFSET + 20;
         enabled = true;
      }
   }
}

