package com.utterlySuperb.chumpManager.view.panels
{
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.view.ui.ChumpListBox;
   import com.utterlySuperb.chumpManager.view.ui.buttons.listButtons.MatchListButton;
   import com.utterlySuperb.text.TextHelper;
   import flash.text.TextField;
   
   public class NextRoundMatchesPanel extends Panel
   {
      
      private var matchesList:ChumpListBox;
      
      public function NextRoundMatchesPanel()
      {
         super();
      }
      
      override protected function init() : void
      {
         makeBox(360,400,0,0);
         var _loc1_:TextField = new TextField();
         TextHelper.doTextField2(_loc1_,Styles.HEADER_FONT,18,16777215);
         _loc1_.htmlText = CopyManager.getCopy("upcomingMatches");
         _loc1_.x = (360 - _loc1_.textWidth) / 2;
         _loc1_.y = 5;
         TextHelper.fitTextField(_loc1_);
         addChild(_loc1_);
         this.matchesList = new ChumpListBox(305,340);
         this.matchesList.x = 20;
         this.matchesList.y = 40;
         this.matchesList.drawFrame();
         addChild(this.matchesList);
         this.update(null);
      }
      
      override protected function update(param1:Object = null) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc5_:MatchListButton = null;
         this.matchesList.depopulate();
         _loc3_ = Main.currentGame.getNextMatches();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(_loc2_ != _loc3_[_loc4_].competition.name)
            {
               _loc5_ = new MatchListButton();
               _loc5_.bWidth = 305;
               _loc5_.bHeight = 50;
               _loc5_.setBG(_loc4_ % 2 == 0);
               _loc5_.setType(CopyManager.getCopy(_loc3_[_loc4_].competition.name));
               _loc2_ = _loc3_[_loc4_].competition.name;
               this.matchesList.addItem(_loc5_);
            }
            _loc5_ = new MatchListButton();
            _loc5_.bWidth = 305;
            _loc5_.bHeight = 30;
            _loc5_.setBG(_loc4_ % 2 == 0);
            _loc5_.setMatch(_loc3_[_loc4_]);
            this.matchesList.addItem(_loc5_);
            if(_loc3_[_loc4_].club0.club == Main.currentGame.playerClub || _loc3_[_loc4_].club1.club == Main.currentGame.playerClub)
            {
               _loc5_.setBGCol(Styles.PLAYER_CLUB_COLOR);
            }
            _loc4_++;
         }
         this.matchesList.enable();
      }
      
      override protected function cleanUp() : void
      {
         this.matchesList.disable();
      }
   }
}

