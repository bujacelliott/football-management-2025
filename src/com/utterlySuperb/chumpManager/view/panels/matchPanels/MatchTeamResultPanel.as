package com.utterlySuperb.chumpManager.view.panels.matchPanels
{
   import com.utterlySuperb.chumpManager.view.panels.Panel;
   import com.utterlySuperb.chumpManager.view.ui.ChumpListBox;
   import com.utterlySuperb.chumpManager.view.ui.buttons.listButtons.PlayerResultListButton;
   
   public class MatchTeamResultPanel extends Panel
   {
      
      private var playersBox:ChumpListBox;
      
      public function MatchTeamResultPanel()
      {
         super();
      }
      
      public function setTeam(param1:Array) : void
      {
         var _loc3_:PlayerResultListButton = null;
         makeBox(280,Globals.usableHeight - 120);
         this.playersBox = new ChumpListBox(225,Globals.usableHeight - 160);
         this.playersBox.drawFrame();
         this.playersBox.x = this.playersBox.y = 20;
         addChild(this.playersBox);
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = new PlayerResultListButton();
            _loc3_.setPlayerDetails(param1[_loc2_]);
            this.playersBox.addItem(_loc3_);
            _loc3_.setBG(_loc2_ % 2 == 0);
            _loc2_++;
         }
         this.playersBox.enable();
      }
      
      override protected function cleanUp() : void
      {
         this.playersBox.disable();
      }
   }
}

