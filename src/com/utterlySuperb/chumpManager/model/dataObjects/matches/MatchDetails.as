package com.utterlySuperb.chumpManager.model.dataObjects.matches
{
   import com.utterlySuperb.chumpManager.engine.MatchEngine;
   import com.utterlySuperb.chumpManager.engine.MatchHelper;
   import com.utterlySuperb.chumpManager.engine.FinanceConfigHelper;
   import com.utterlySuperb.chumpManager.model.dataObjects.Formation;
   import com.utterlySuperb.chumpManager.model.dataObjects.Game;
   import com.utterlySuperb.chumpManager.model.dataObjects.Player;
   import flash.geom.Point;
   
   public class MatchDetails
   {
      
      public var team0:MatchTeamDetails;
      
      public var team1:MatchTeamDetails;
      
      public var playerTeam:MatchTeamDetails;
      
      public var pitchMap:PitchMap;
      
      public var closestOpposingToBall:Array;
      
      public var subs:Array;
      
      public var messages:Array;
      
      public var events:Array;
      
      public var match:Match;
      
      public var time:int;
      
      public var lastAction:int;
      
      public var extraTime:int;
      
      public var matchSection:int;
      
      public var gameBreak:String;
      
      public var hasBall:MatchPlayerDetails;
      
      public var ballPos:Point;
      
      public var initted:Boolean;
      
      public var lastPasser:MatchPlayerDetails;
      
      public var teamToRestart:MatchTeamDetails;
      
      public var currentSector:PitchSector;
      
      public var lastSector:PitchSector;
      
      public var lastMatchAction:MatchAction;
      
      public var rebuildMessages:Boolean = true;
      
      public function MatchDetails()
      {
         super();
         this.events = new Array();
         this.messages = new Array();
         this.subs = new Array();
         this.time = this.extraTime = this.lastAction = 0;
         this.matchSection = 0;
         this.gameBreak = MatchEngine.BEFORE_GAME;
         this.team0 = new MatchTeamDetails(0);
         this.team1 = new MatchTeamDetails(1);
         this.pitchMap = new PitchMap();
      }
      
      public function setFormations(param1:Match) : void
      {
         this.match = param1;
         this.playerTeam = this.playerClubIsTeam0() ? this.team0 : this.team1;
         this.team0.init(param1.club0.club.getFormation(),param1.club0.club);
         this.team1.init(param1.club1.club.getFormation(),param1.club1.club);
      }
      
      public function init() : void
      {
         if(!this.initted)
         {
            this.initted = true;
            this.team0.makeTeam();
            this.team1.makeTeam();
         }
      }
      
      public function setPositions() : void
      {
         MatchHelper.positionPlayersForStart(this);
      }
      
      public function playerClubIsTeam0() : Boolean
      {
         return this.match.club0.club == Main.currentGame.playerClub;
      }
      
      public function getPlayerFormation() : Formation
      {
         return this.playerTeam.formation;
      }
      
      public function setPlayerFormation(param1:Formation) : void
      {
         this.playerTeam.formation = param1.clone();
         this.playerTeam.makeTeam();
      }
      
      public function adjustFormation(param1:Formation, param2:Array) : void
      {
         this.playerTeam.formation = param1.clone();
         this.playerTeam.setPlayers(param2,this.getMinutesString());
      }
      
      public function playerIsInTeam0(param1:MatchPlayerDetails) : Boolean
      {
         return this.team0.players.indexOf(param1) >= 0;
      }
      
      public function get teamWithBall() : MatchTeamDetails
      {
         return this.playerIsInTeam0(this.hasBall) ? this.team0 : this.team1;
      }
      
      public function get teamWithoutBall() : MatchTeamDetails
      {
         return !this.playerIsInTeam0(this.hasBall) ? this.team0 : this.team1;
      }
      
      public function getTimeString() : String
      {
         var _loc1_:int = Math.floor(this.time / 60);
         if(this.matchSection == 1)
         {
            _loc1_ += 45;
         }
         if(this.matchSection == 2)
         {
            _loc1_ += 90;
         }
         if(this.matchSection == 3)
         {
            _loc1_ += 105;
         }
         var _loc2_:int = this.time % 60;
         return this.formatNum(_loc1_) + ":" + this.formatNum(_loc2_);
      }
      
      public function getMinutesString() : String
      {
         var _loc1_:int = Math.floor(this.time / 60);
         if(this.matchSection == 0 && _loc1_ > 45)
         {
            return "45+";
         }
         if(this.matchSection == 1)
         {
            _loc1_ += 45;
         }
         if(this.matchSection == 1 && _loc1_ > 90)
         {
            return "90+";
         }
         if(this.matchSection == 2)
         {
            _loc1_ += 90;
         }
         if(this.matchSection == 2 && _loc1_ > 105)
         {
            return "105+";
         }
         if(this.matchSection == 3)
         {
            _loc1_ += 105;
         }
         if(this.matchSection == 3 && _loc1_ > 120)
         {
            return "120+";
         }
         return this.formatNum(_loc1_);
      }
      
      public function getSecondsPlayed() : int
      {
         if(this.matchSection == 1)
         {
            return this.time + 45 * 60;
         }
         return this.time;
      }
      
      public function getMinutesPlayed() : int
      {
         if(this.matchSection == 1)
         {
            return Math.floor(this.time / 60) + 45;
         }
         return Math.floor(this.time / 60);
      }
      
      private function formatNum(param1:int) : String
      {
         var _loc2_:String = param1.toString();
         return _loc2_.length == 1 ? "0" + _loc2_ : _loc2_;
      }
      
      public function getPlayerDetails(param1:Player) : MatchPlayerDetails
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.team0.squad.length)
         {
            if(this.team0.squad[_loc2_].player == param1)
            {
               return this.team0.squad[_loc2_];
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.team1.squad.length)
         {
            if(this.team1.squad[_loc2_].player == param1)
            {
               return this.team1.squad[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getPlayerSubs() : Array
      {
         return this.playerClubIsTeam0() ? this.team0.getAvailableSubs() : this.team0.getAvailableSubs();
      }
      
      public function get topTeam() : MatchTeamDetails
      {
         return this.matchSection % 2 == 1 ? this.team0 : this.team1;
      }
      
      public function get bottomTeam() : MatchTeamDetails
      {
         return this.matchSection % 2 == 0 ? this.team0 : this.team1;
      }
      
      public function getTeamPossession(param1:int) : String
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         while(_loc5_ < this.messages.length)
         {
            if(this.messages[_loc5_].team >= 0)
            {
               _loc2_++;
               if(this.messages[_loc5_].team == 0)
               {
                  _loc3_++;
               }
               else
               {
                  _loc4_++;
               }
            }
            _loc5_++;
         }
         return param1 == 0 ? (_loc3_ / _loc2_ * 100).toFixed(1) : (_loc4_ / _loc2_ * 100).toFixed(1);
      }
      
      public function getTeamPossessionNum(param1:MatchTeamDetails) : Number
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         while(_loc5_ < this.messages.length)
         {
            if(this.messages[_loc5_].team >= 0)
            {
               _loc2_++;
               if(this.messages[_loc5_].team == 0)
               {
                  _loc3_++;
               }
               else
               {
                  _loc4_++;
               }
            }
            _loc5_++;
         }
         return param1 == this.team0 ? _loc3_ / _loc2_ * 100 : _loc4_ / _loc2_ * 100;
      }
      
      public function getMatchIncome() : int
      {
         return FinanceConfigHelper.getMatchIncome(this);
      }
   }
}

