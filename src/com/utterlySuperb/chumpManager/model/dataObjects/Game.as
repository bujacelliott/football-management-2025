package com.utterlySuperb.chumpManager.model.dataObjects
{
   import com.utterlySuperb.chumpManager.engine.GameEngine;
   import com.utterlySuperb.chumpManager.engine.TeamHelper;
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.Match;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.MatchDetails;
   
   public class Game
   {
      
      public static const DATA_CHANGED:String = "dataChanged";
      
      public static const CASH_PER_WIN:int = 1500000;
      
      public static const CASH_PER_DRAW:int = 500000;
      
      public static const CASH_PER_LOSS:int = 200000;
      
      public var version:String;
      
      public var firstWeekend:Date;
      
      public var currentDate:Date;
      
      public var savedPlayers:PlayerBank;
      
      public var playerClub:Club;
      
      public var playerFormation:Formation;
      
      public var playerOffers:Array;
      
      public var leagues:Array;
      
      public var otherLeagues:Array;
      
      public var goalsList:Object;
      
      public var fixtureList:FixturesList;
      
      public var offSeasonNum:int;
      
      public var clubCash:int;
      
      public var seasonNum:int;
      
      public var weekNum:int;
      
      public var weekend:Boolean;
      
      public var leagueWinners:Array;
      
      public var cupWinners:Array;
      
      public var faCupWinner:Club;
      
      public var leagueCupWinner:Club;
      
      public var promotedTeams:Array;
      
      public var nextPlayerMatch:Match;
      
      public var matchDetails:MatchDetails;
      
      public var userMessages:Array;
      
      public var slotNumber:int;
      
      public function Game()
      {
         super();
         this.savedPlayers = new PlayerBank();
         this.playerOffers = new Array();
         this.playerFormation = Formation.getStandardFormation(Formation.FOUR42_A);
         this.clubCash = 20000000;
         this.leagues = new Array();
         this.otherLeagues = new Array();
         this.userMessages = new Array();
         this.goalsList = {};
         this.seasonNum = 0;
      }
      
      public function nextWeek() : void
      {
         if(this.offSeasonNum > 0)
         {
            --this.offSeasonNum;
         }
         else
         {
            ++this.weekNum;
            this.weekend = true;
         }
         if(this.offSeasonNum == 0 || this.weekNum == GameEngine.WINTER_TRANSFER_CLOSE)
         {
            --this.offSeasonNum;
            GameEngine.addTransferWindow(false);
         }
         else if(this.weekNum == GameEngine.WINTER_TRANSFER_OPEN)
         {
            GameEngine.addTransferWindow(true);
         }
         TeamHelper.doTraining(this);
      }
      
      public function setPlayerclub(param1:Club) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.players.length)
         {
            this.addPlayerToPlayerClub(StaticInfo.getPlayer(param1.players[_loc2_]));
            _loc2_++;
         }
         this.playerClub = param1;
      }
      
      public function addPlayerToPlayerClub(param1:Player) : void
      {
         this.savedPlayers.addPlayer(param1);
      }
      
      public function hasOfferOnPlayer(param1:Player) : Boolean
      {
         var _loc2_:PlayerOffers = null;
         for each(_loc2_ in this.playerOffers)
         {
            if(_loc2_.player == param1.id)
            {
               return true;
            }
         }
         return false;
      }
      
      public function getOfferOnPlayer(param1:Player) : PlayerOffers
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.playerOffers.length)
         {
            if(this.playerOffers[_loc2_].player == param1.id)
            {
               return this.playerOffers[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function removePlayerOffer(param1:Player) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.playerOffers.length)
         {
            if(this.playerOffers[_loc2_].player == param1.id)
            {
               this.playerOffers.splice(_loc2_,1);
               _loc2_--;
            }
            _loc2_++;
         }
      }
      
      public function getNextMatches() : Array
      {
         if(this.weekend)
         {
            return this.fixtureList.weekendMatches;
         }
         return this.fixtureList.midweekMatches;
      }
      
      public function getRoundDate() : Date
      {
         this.currentDate = new Date(this.firstWeekend.getTime());
         this.currentDate.setFullYear(this.firstWeekend.getFullYear());
         var _loc1_:int = this.weekend ? int(this.currentDate.getDate() + this.weekNum * 7) : int(this.currentDate.getDate() + this.weekNum * 7 + 3);
         _loc1_ -= this.offSeasonNum * 7;
         this.currentDate.setDate(_loc1_);
         return this.currentDate;
      }
      
      public function addMessage(param1:String, param2:String) : void
      {
         var _loc3_:Message = new Message();
         _loc3_.title = param1;
         _loc3_.body = param2;
         this.userMessages.push(_loc3_);
      }
      
      public function getWeekString() : String
      {
         var _loc1_:String = null;
         if(this.offSeasonNum > 0)
         {
            _loc1_ = CopyManager.getCopy("offSeasonNum").replace(CopyManager.WEEKNUM_REPLACE,this.offSeasonNum);
         }
         else if(this.weekend)
         {
            _loc1_ = CopyManager.getCopy("matchWeeknum").replace(CopyManager.WEEKNUM_REPLACE,this.weekNum + 1);
         }
         else
         {
            _loc1_ = CopyManager.getCopy("matchMidWeeknum").replace(CopyManager.WEEKNUM_REPLACE,this.weekNum + 1);
         }
         return _loc1_;
      }
      
      public function addPlayerGoal(param1:String) : void
      {
         if(this.goalsList[param1])
         {
            ++this.goalsList[param1];
         }
         else
         {
            this.goalsList[param1] = 1;
         }
      }
   }
}

