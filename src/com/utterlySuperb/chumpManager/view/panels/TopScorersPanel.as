package com.utterlySuperb.chumpManager.view.panels
{
import com.utterlySuperb.chumpManager.model.dataObjects.Player;
import com.utterlySuperb.chumpManager.model.dataObjects.StaticInfo;
import com.utterlySuperb.chumpManager.model.dataObjects.competitions.League;
   import com.utterlySuperb.chumpManager.view.ui.ChumpListBox;
   import com.utterlySuperb.chumpManager.view.ui.buttons.listButtons.TopScorerButton;
   import com.utterlySuperb.text.TextHelper;
   import flash.text.TextField;
   
   public class TopScorersPanel extends Panel
   {
      
      public static const BOX_WIDTH:int = 320;
      
      public static const MODE_GOALS:int = 0;
      
      public static const MODE_ASSISTS:int = 1;
      
      private var topScorersList:ChumpListBox;
      
      private var league:League;
      
      private var mode:int = MODE_GOALS;
      
      private var header:TextField;
      
      public function TopScorersPanel()
      {
         super();
      }
      
      override protected function init() : void
      {
         makeBox(BOX_WIDTH,Globals.GAME_HEIGHT - y - Globals.MARGIN_Y);
         this.header = new TextField();
         TextHelper.doTextField2(this.header,Styles.HEADER_FONT,22,16777215,{"multiline":true});
         this.header.x = 20;
         this.header.y = 5;
         this.header.width = boxWidth - 20;
         addChild(this.header);
         this.topScorersList = new ChumpListBox(boxWidth - 55,boxHeight - 30 - (this.header.y + this.header.textHeight + 5));
         addChild(this.topScorersList);
         this.topScorersList.x = 20;
         this.topScorersList.y = this.header.y + this.header.textHeight + 5;
         this.topScorersList.drawFrame();
         this.update();
      }
      
      public function setLeague(param1:League) : void
      {
         this.league = param1;
         if(this.topScorersList)
         {
            this.update();
         }
      }
      
      public function setMode(param1:int) : void
      {
         this.mode = param1;
         this.update();
      }

      public function getMode() : int
      {
         return this.mode;
      }
      
      override protected function update(param1:Object = null) : void
      {
         var _loc2_:Vector.<PlayerScore> = new Vector.<PlayerScore>();
         var _loc3_:League = this.league ? this.league : Main.currentGame.getMainLeague();
         var _loc4_:Player = null;
         var _loc5_:PlayerScore = null;
         var _loc6_:TopScorerButton = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:* = null;
         var _loc11_:Boolean = false;
         var _loc12_:Object = null;
         var _loc13_:Object = null;
         var _loc14_:* = null;
         if(!this.topScorersList)
         {
            return;
         }
         if(!_loc3_)
         {
            return;
         }
         this.topScorersList.depopulate();
         this.header.htmlText = this.mode == MODE_GOALS ? "Top Scorers" : "Top Assisters";
         _loc12_ = this.getLeaguePlayerIdSet(_loc3_);
         _loc13_ = this.mode == MODE_GOALS ? Main.currentGame.goalsList : Main.currentGame.assistsList;
         if(_loc13_)
         {
            for(_loc14_ in _loc13_)
            {
               if(_loc12_[_loc14_])
               {
                  _loc4_ = StaticInfo.getPlayer(String(_loc14_));
                  if(_loc4_)
                  {
                     _loc5_ = new PlayerScore(_loc4_,int(_loc13_[_loc14_]));
                     _loc2_.push(_loc5_);
                  }
               }
            }
         }
         _loc2_ = _loc2_.sort(this.sortPlayers);
         _loc7_ = 0;
         _loc8_ = -1;
         _loc9_ = 0;
         while(_loc9_ < Math.min(50,_loc2_.length))
         {
            if(_loc2_[_loc9_].numGoals <= 0)
            {
               _loc9_++;
               continue;
            }
            _loc6_ = new TopScorerButton();
            _loc6_.bWidth = boxWidth - 55;
            if(_loc8_ != _loc2_[_loc9_].numGoals)
            {
               _loc7_ = _loc9_ + 1;
            }
            _loc8_ = _loc2_[_loc9_].numGoals;
            _loc10_ = _loc7_.toString();
            if(_loc9_ > 0 && _loc2_[_loc9_ - 1].numGoals == _loc2_[_loc9_].numGoals || _loc9_ < _loc2_.length - 1 && _loc2_[_loc9_ + 1].numGoals == _loc2_[_loc9_].numGoals)
            {
               _loc10_ += "=";
            }
            _loc6_.setScore(_loc2_[_loc9_].player,_loc10_,_loc2_[_loc9_].numGoals);
            _loc6_.setBG(_loc9_ % 2 == 0);
            if(_loc2_[_loc9_].player.club == Main.currentGame.playerClub)
            {
               _loc6_.setInTeam();
            }
            this.topScorersList.addItem(_loc6_);
            _loc11_ = true;
            _loc9_++;
         }
         if(!_loc11_)
         {
            _loc6_ = new TopScorerButton();
            _loc6_.bWidth = boxWidth - 55;
            _loc6_.setBG(false);
            _loc6_.setScore(this.makeEmptyPlayer(),"",0);
            this.topScorersList.addItem(_loc6_);
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
      
      private function getLeaguePlayerIdSet(param1:League) : Object
      {
         var _loc2_:Object = {};
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(_loc3_ < param1.entrants.length)
         {
            _loc4_ = 0;
            while(_loc4_ < param1.entrants[_loc3_].club.players.length)
            {
               _loc2_[param1.entrants[_loc3_].club.players[_loc4_]] = true;
               _loc4_++;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function makeEmptyPlayer() : Player
      {
         var _loc1_:Player = new Player();
         _loc1_.name = "No stats yet";
         return _loc1_;
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
