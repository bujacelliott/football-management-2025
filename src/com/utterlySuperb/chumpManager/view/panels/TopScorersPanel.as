package com.utterlySuperb.chumpManager.view.panels
{
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.Player;
   import com.utterlySuperb.chumpManager.model.dataObjects.StaticInfo;
   import com.utterlySuperb.chumpManager.view.ui.ChumpListBox;
   import com.utterlySuperb.chumpManager.view.ui.buttons.listButtons.TopScorerButton;
   import com.utterlySuperb.text.TextHelper;
   import flash.text.TextField;
   
   public class TopScorersPanel extends Panel
   {
      
      public static const BOX_WIDTH:int = 320;
      
      private var topScorersList:ChumpListBox;
      
      public function TopScorersPanel()
      {
         super();
      }
      
      override protected function init() : void
      {
         makeBox(BOX_WIDTH,Globals.GAME_HEIGHT - y - Globals.MARGIN_Y);
         var _loc1_:TextField = new TextField();
         TextHelper.doTextField2(_loc1_,Styles.HEADER_FONT,22,16777215,{"multiline":true});
         _loc1_.x = 20;
         _loc1_.y = 5;
         _loc1_.width = boxWidth - 20;
         _loc1_.htmlText = CopyManager.getCopy("topScorer");
         addChild(_loc1_);
         this.topScorersList = new ChumpListBox(boxWidth - 55,boxHeight - 30 - (_loc1_.y + _loc1_.textHeight + 5));
         addChild(this.topScorersList);
         this.topScorersList.x = 20;
         this.topScorersList.y = _loc1_.y + _loc1_.textHeight + 5;
         this.topScorersList.drawFrame();
         this.update();
      }
      
      override protected function update(param1:Object = null) : void
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Player = null;
         var _loc8_:PlayerScore = null;
         var _loc9_:TopScorerButton = null;
         var _loc10_:* = null;
         var _loc2_:Vector.<PlayerScore> = new Vector.<PlayerScore>();
         for(_loc3_ in Main.currentGame.goalsList)
         {
            _loc7_ = StaticInfo.getPlayer(_loc3_);
            _loc8_ = new PlayerScore(_loc7_,Main.currentGame.goalsList[_loc3_]);
            _loc2_.push(_loc8_);
         }
         _loc2_ = _loc2_.sort(this.sortPlayers);
         _loc4_ = 0;
         _loc5_ = -1;
         _loc6_ = 0;
         while(_loc6_ < Math.min(50,_loc2_.length))
         {
            _loc9_ = new TopScorerButton();
            _loc9_.bWidth = boxWidth - 55;
            if(_loc5_ != _loc2_[_loc6_].numGoals)
            {
               _loc4_ = _loc6_ + 1;
            }
            _loc5_ = _loc2_[_loc6_].numGoals;
            _loc10_ = _loc4_.toString();
            if(_loc6_ > 0 && _loc2_[_loc6_ - 1].numGoals == _loc2_[_loc6_].numGoals || _loc6_ < _loc2_.length - 1 && _loc2_[_loc6_ + 1].numGoals == _loc2_[_loc6_].numGoals)
            {
               _loc10_ += "=";
            }
            _loc9_.setScore(_loc2_[_loc6_].player,_loc10_,_loc2_[_loc6_].numGoals);
            _loc9_.setBG(_loc6_ % 2 == 0);
            if(_loc2_[_loc6_].player.club == Main.currentGame.playerClub)
            {
               _loc9_.setInTeam();
            }
            this.topScorersList.addItem(_loc9_);
            _loc6_++;
         }
         this.topScorersList.enable();
      }
      
      override protected function cleanUp() : void
      {
         this.topScorersList.disable();
      }
      
      private function sortPlayers(param1:PlayerScore, param2:PlayerScore) : Number
      {
         if(param1.numGoals > param2.numGoals)
         {
            return -1;
         }
         if(param1.numGoals < param2.numGoals)
         {
            return 1;
         }
         return -1;
      }
   }
}

import com.utterlySuperb.chumpManager.model.dataObjects.Player;

class PlayerScore
{
   
   public var player:Player;
   
   public var numGoals:int;
   
   public function PlayerScore(param1:Player, param2:int)
   {
      super();
      this.player = param1;
      this.numGoals = param2;
   }
}
