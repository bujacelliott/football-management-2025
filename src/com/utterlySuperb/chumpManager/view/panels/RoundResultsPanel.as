package com.utterlySuperb.chumpManager.view.panels
{
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.view.ui.ChumpListBox;
   import com.utterlySuperb.chumpManager.view.ui.buttons.listButtons.GameResultListButton;
   import com.utterlySuperb.chumpManager.view.ui.buttons.listButtons.MatchListButton;
   
   public class RoundResultsPanel extends Panel
   {
      
      private var resultsBox:ChumpListBox;
      
      public function RoundResultsPanel()
      {
         super();
      }
      
      override protected function init() : void
      {
         var _loc3_:String = null;
         var _loc6_:GameResultListButton = null;
         var _loc7_:MatchListButton = null;
         var _loc1_:int = Globals.GAME_WIDTH - Globals.MARGIN_X * 2;
         var _loc2_:int = Globals.usableHeight - 20 - 70;
         makeBox(_loc1_,_loc2_);
         this.resultsBox = new ChumpListBox(_loc1_ - 55,_loc2_ - 40);
         this.resultsBox.drawFrame();
         this.resultsBox.x = this.resultsBox.y = 20;
         addChild(this.resultsBox);
         var _loc4_:Array = Main.currentGame.getNextMatches();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.length)
         {
            if(_loc3_ != _loc4_[_loc5_].competition.name)
            {
               _loc7_ = new MatchListButton();
               _loc7_.bWidth = _loc1_ - 55;
               _loc7_.bHeight = 40;
               _loc7_.setBG(_loc5_ % 2 == 0);
               _loc7_.setType(CopyManager.getCopy(_loc4_[_loc5_].competition.name));
               _loc3_ = _loc4_[_loc5_].competition.name;
               this.resultsBox.addItem(_loc7_);
            }
            _loc6_ = new GameResultListButton();
            _loc6_.bWidth = _loc1_ - 55;
            _loc6_.bHeight = 40;
            _loc6_.setMatch(_loc4_[_loc5_]);
            _loc6_.setBG(_loc5_ % 2 == 0);
            this.resultsBox.addItem(_loc6_);
            _loc5_++;
         }
         this.resultsBox.enable();
      }
      
      override protected function cleanUp() : void
      {
         this.resultsBox.disable();
      }
   }
}

