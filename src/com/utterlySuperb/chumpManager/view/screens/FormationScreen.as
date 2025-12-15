package com.utterlySuperb.chumpManager.view.screens
{
   import com.utterlySuperb.chumpManager.view.panels.PlayerList;
   import com.utterlySuperb.chumpManager.view.panels.SetFormationPanel;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class FormationScreen extends Screen
   {
      
      private var playerList:PlayerList;
      
      private var setFormation:SetFormationPanel;
      
      private var screenButton:Sprite;
      
      public function FormationScreen()
      {
         super();
         addStatus();
         this.screenButton = new Sprite();
         addChild(this.screenButton);
         this.screenButton.graphics.beginFill(0,0);
         this.screenButton.graphics.drawRect(0,0,Globals.GAME_WIDTH,Globals.GAME_HEIGHT);
         this.screenButton.addEventListener(MouseEvent.CLICK,this.clickBGHandler);
         makeBackButton();
         makeHomeButton();
         Main.instance.backOverride = Screen.CLUB_SCREEN;
         this.setFormation = new SetFormationPanel();
         this.setFormation.state = SetFormationPanel.NON_MATCH;
         addChild(this.setFormation);
         this.setFormation.y = Globals.belowStatus;
         enabled = true;
      }
      
      private function clickBGHandler(param1:MouseEvent) : void
      {
         this.setFormation.deselectPlayers();
      }
      
      override public function cleanUp() : void
      {
         super.cleanUp();
         this.screenButton.removeEventListener(MouseEvent.CLICK,this.clickBGHandler);
      }
   }
}

