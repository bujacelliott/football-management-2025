package com.utterlySuperb.chumpManager.view.panels.matchPanels
{
   import com.utterlySuperb.chumpManager.engine.MatchEngine;
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.Settings;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.MatchAction;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.MatchDetails;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.MatchMessage;
   import com.utterlySuperb.chumpManager.view.panels.Panel;
   import com.utterlySuperb.chumpManager.view.ui.ChumpListBox;
   import com.utterlySuperb.chumpManager.view.ui.buttons.listButtons.MatchMessageButton;
   
   public class MatchTextInfoPanel extends Panel
   {
      
      private var infoBox:ChumpListBox;
      
      private var currentMessage:Vector.<MatchMessage>;
      
      public function MatchTextInfoPanel()
      {
         super();
      }
      
      override protected function init() : void
      {
         var _loc1_:int = Globals.GAME_WIDTH - x - Globals.MARGIN_X;
         var _loc2_:int = Globals.GAME_HEIGHT - y - 120;
         makeBox(_loc1_,_loc2_);
         this.infoBox = new ChumpListBox(_loc1_ - 55,_loc2_ - 50);
         this.infoBox.x = this.infoBox.y = 20;
         this.infoBox.drawFrame();
         addChild(this.infoBox);
         this.currentMessage = new Vector.<MatchMessage>();
         this.update();
      }
      
      override protected function update(param1:Object = null) : void
      {
         var _loc5_:MatchMessage = null;
         var _loc6_:Boolean = false;
         var _loc7_:MatchMessageButton = null;
         var _loc2_:MatchDetails = Main.currentGame.matchDetails;
         var _loc3_:Settings = Main.instance.settings;
         if(_loc2_.rebuildMessages)
         {
            _loc2_.rebuildMessages = false;
            this.infoBox.depopulate();
            this.currentMessage = new Vector.<MatchMessage>();
         }
         var _loc4_:int = 0;
         while(_loc4_ < Main.currentGame.matchDetails.messages.length)
         {
            _loc5_ = Main.currentGame.matchDetails.messages[_loc4_];
            _loc6_ = true;
            if(_loc3_.matchFilter == Settings.SHOW_HALF)
            {
               _loc6_ = _loc5_.type != MatchAction.PASS && _loc5_.type != CopyManager.TACKLE_FAIL;
            }
            else if(_loc3_.matchFilter == Settings.SHOW_GOALS)
            {
               _loc6_ = _loc5_.type == MatchAction.GOAL || _loc5_.type == CopyManager.RED_CARD || _loc5_.type == MatchEngine.INJURY || _loc5_.type == MatchAction.SHOT;
            }
            if(_loc6_)
            {
               if(this.currentMessage.indexOf(_loc5_) < 0)
               {
                  _loc7_ = new MatchMessageButton();
                  _loc7_.bWidth = Globals.GAME_WIDTH - x - Globals.MARGIN_X - 55;
                  if(_loc5_.type == MatchAction.GOAL)
                  {
                     _loc7_.setText("<font size=\'20\'>" + _loc5_.copy + "</font>");
                  }
                  else if(_loc5_.type == MatchAction.SHOT || _loc5_.type == MatchAction.PENALTY || _loc5_.type == MatchEngine.INJURY || _loc5_.type == CopyManager.RED_CARD)
                  {
                     _loc7_.setText("<font size=\'17\'>" + _loc5_.copy + "</font>");
                  }
                  else
                  {
                     _loc7_.setText(_loc5_.copy);
                  }
                  if(_loc5_.type.length > 0)
                  {
                     _loc7_.setType(_loc5_.type);
                  }
                  _loc7_.setBG(_loc4_ % 2 == 0);
                  if(_loc5_.team >= 0)
                  {
                     _loc7_.setTeam(_loc5_.team);
                  }
                  this.infoBox.addItemAtTop(_loc7_);
                  this.currentMessage.push(Main.currentGame.matchDetails.messages[_loc4_]);
               }
            }
            _loc4_++;
         }
      }
      
      public function getHeight() : int
      {
         return Globals.GAME_HEIGHT - y - 120;
      }
      
      override protected function cleanUp() : void
      {
         this.infoBox.disable();
      }
   }
}

