package com.utterlySuperb.chumpManager.view.panels
{
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.Match;
   import com.utterlySuperb.chumpManager.view.ui.ChumpListBox;
   import com.utterlySuperb.chumpManager.view.ui.buttons.listButtons.MatchListButton;
   import com.utterlySuperb.text.TextHelper;
   import flash.text.TextField;
   
   public class ClubFixturesPanel extends Panel
   {
      
      private var matchesList:ChumpListBox;
      
      private var maxItems:int = 5;
      
      private var listWidth:int;
      
      private var listHeight:int;
      
      public function ClubFixturesPanel(param1:int = 260, param2:int = 360)
      {
         this.listWidth = param1 - 40;
         this.listHeight = param2 - 60;
         super();
         this.boxWidth = param1;
         this.boxHeight = param2;
      }
      
      override protected function init() : void
      {
         makeBox(this.boxWidth,this.boxHeight,0,0);
         var _loc1_:TextField = new TextField();
         TextHelper.doTextField2(_loc1_,Styles.HEADER_FONT,18,16777215);
         _loc1_.htmlText = "Fixtures";
         _loc1_.x = (this.boxWidth - _loc1_.textWidth) / 2;
         _loc1_.y = 5;
         TextHelper.fitTextField(_loc1_);
         addChild(_loc1_);
         this.matchesList = new ChumpListBox(this.listWidth,this.listHeight);
         this.matchesList.x = 20;
         this.matchesList.y = 35;
         this.matchesList.drawFrame();
         addChild(this.matchesList);
         this.update();
      }
      
      override protected function update(param1:Object = null) : void
      {
         var _loc4_:Match = null;
         var _loc5_:MatchListButton = null;
         var _loc2_:Array = this.getUpcomingFixtures();
         var _loc3_:int = 0;
         this.matchesList.depopulate();
         for each(_loc4_ in _loc2_)
         {
            _loc5_ = new MatchListButton();
            _loc5_.bWidth = this.listWidth;
            _loc5_.bHeight = 28;
            _loc5_.setBG(_loc3_ % 2 == 0);
            _loc5_.setMatch(_loc4_);
            this.matchesList.addItem(_loc5_);
            _loc3_++;
            if(_loc3_ >= this.maxItems)
            {
               break;
            }
         }
         if(_loc3_ == 0)
         {
            _loc5_ = new MatchListButton();
            _loc5_.bWidth = this.listWidth;
            _loc5_.bHeight = 28;
            _loc5_.setBG(false);
            _loc5_.setType("No fixtures");
            this.matchesList.addItem(_loc5_);
         }
         this.matchesList.enable();
      }

      private function getUpcomingFixtures() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:int = Main.currentGame.weekNum;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Match = null;
         if(!Main.currentGame.fixtureList || !Main.currentGame.fixtureList.weeks)
         {
            return _loc1_;
         }
         _loc3_ = _loc2_;
         while(_loc3_ < Main.currentGame.fixtureList.weeks.length && _loc1_.length < this.maxItems)
         {
            _loc4_ = 0;
            while(_loc4_ < Main.currentGame.fixtureList.weeks[_loc3_].length && _loc1_.length < this.maxItems)
            {
               _loc5_ = Main.currentGame.fixtureList.weeks[_loc3_][_loc4_];
               if(_loc5_.club0.club == Main.currentGame.playerClub || _loc5_.club1.club == Main.currentGame.playerClub)
               {
                  _loc1_.push(_loc5_);
               }
               _loc4_++;
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      override protected function cleanUp() : void
      {
         if(this.matchesList)
         {
            this.matchesList.disable();
         }
      }
   }
}
