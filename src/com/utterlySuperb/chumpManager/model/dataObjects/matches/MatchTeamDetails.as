package com.utterlySuperb.chumpManager.model.dataObjects.matches
{
   import com.utterlySuperb.chumpManager.engine.MatchEngine;
   import com.utterlySuperb.chumpManager.model.dataObjects.Club;
   import com.utterlySuperb.chumpManager.model.dataObjects.Formation;
   import com.utterlySuperb.chumpManager.model.dataObjects.Player;
   import flash.geom.Point;
   
   public class MatchTeamDetails
   {
      
      public var formation:Formation;
      
      public var players:Array;
      
      public var subs:Array;
      
      public var squad:Array;
      
      public var events:Array;
      
      public var club:Club;
      
      public var playerPositions:Array;
      
      public var num:int;
      
      public var opposingGoal:Point;
      
      public var myGoal:Point;
      
      public function MatchTeamDetails(param1:int = 0)
      {
         super();
         this.num = param1;
         this.events = new Array();
         this.subs = new Array();
      }
      
      public function init(param1:Formation, param2:Club) : void
      {
         this.club = param2;
         this.formation = param1.clone();
         this.formation.removeIneligablePlayers(param2.players);
      }
      
      public function makeTeam() : void
      {
         var _loc4_:MatchPlayerDetails = null;
         this.players = new Array();
         this.squad = new Array();
         this.playerPositions = new Array();
         var _loc1_:Number = 0.5 + this.formation.attackingScore / 20;
         var _loc2_:int = 0;
         while(_loc2_ < this.formation.prefferedPlayersID.length)
         {
            _loc4_ = new MatchPlayerDetails();
            _loc4_.player = this.formation.getPrefferedPlayer(_loc2_);
            _loc4_.team = this;
            this.squad.push(_loc4_);
            if(_loc2_ < 11)
            {
               _loc4_.baseColumn = this.formation.positionsCol[_loc2_];
               _loc4_.baseRow = this.formation.positionsRow[_loc2_];
               this.players.push(_loc4_);
               _loc4_.timeCameOut = "0";
               this.playerPositions[_loc2_] = new Point((MatchEngine.NUM_COLUMNS - this.formation.positionsCol[_loc2_] - 1) / MatchEngine.NUM_COLUMNS * PitchMap.PITCH_WIDTH,(MatchEngine.NUM_ROWS / 2 - this.formation.positionsRow[_loc2_] - 1) / (MatchEngine.NUM_ROWS / 2) * PitchMap.PITCH_HEIGHT * _loc1_);
            }
            _loc2_++;
         }
         var _loc3_:int = 0;
      }
      
      public function setPlayers(param1:Array, param2:String) : void
      {
         var _loc3_:Number = 0.5 + this.formation.attackingScore / 20;
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            if(this.players.indexOf(param1[_loc4_]) < 0)
            {
               param1[_loc4_].timeCameOut = param2;
               param1[_loc4_].player.form = Math.min(param1[_loc4_].player.form + Math.random() * 40,100);
            }
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < this.players.length)
         {
            if(param1.indexOf(this.players[_loc4_]) < 0)
            {
               param1[_loc4_].timeSubstituted = param2;
               this.subs.push(this.players[_loc4_]);
            }
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < param1.length)
         {
            this.players[_loc4_] = param1[_loc4_];
            this.playerPositions[_loc4_] = new Point((MatchEngine.NUM_COLUMNS - this.formation.positionsCol[_loc4_] - 1) / MatchEngine.NUM_COLUMNS * PitchMap.PITCH_WIDTH,(MatchEngine.NUM_ROWS / 2 - this.formation.positionsRow[_loc4_] - 1) / (MatchEngine.NUM_ROWS / 2) * PitchMap.PITCH_HEIGHT * _loc3_);
            _loc4_++;
         }
      }
      
      public function positionPlayers() : void
      {
         var _loc1_:Number = 0.5 + this.formation.attackingScore / 20;
         var _loc2_:int = 0;
         while(_loc2_ < this.players.length)
         {
            this.playerPositions[_loc2_] = new Point((MatchEngine.NUM_COLUMNS - this.formation.positionsCol[_loc2_] - 1) / MatchEngine.NUM_COLUMNS * PitchMap.PITCH_WIDTH,(MatchEngine.NUM_ROWS / 2 - this.formation.positionsRow[_loc2_] - 1) / (MatchEngine.NUM_ROWS / 2) * PitchMap.PITCH_HEIGHT * _loc1_);
            _loc2_++;
         }
      }
      
      public function getAvailableSubs() : Array
      {
         var _loc2_:MatchPlayerDetails = null;
         var _loc1_:Array = new Array();
         for each(_loc2_ in this.squad)
         {
            if(_loc2_.timeCameOut.length == 0)
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      public function getSubs() : Array
      {
         var _loc2_:MatchPlayerDetails = null;
         var _loc1_:Array = new Array();
         for each(_loc2_ in this.squad)
         {
            if(this.players.indexOf(_loc2_) < 0)
            {
               _loc1_.push(_loc2_.player);
            }
         }
         return _loc1_;
      }
      
      public function playerHasPlayed(param1:Player) : Boolean
      {
         var _loc2_:MatchPlayerDetails = null;
         for each(_loc2_ in this.squad)
         {
            if(_loc2_.player == param1 && _loc2_.timeCameOut.length > 0)
            {
               return true;
            }
         }
         return false;
      }
      
      public function makeSubstitution(param1:MatchPlayerDetails, param2:MatchPlayerDetails, param3:int) : void
      {
      }
      
      public function addGoal(param1:MatchPlayerDetails, param2:String) : void
      {
         var _loc3_:MatchEvent = new MatchEvent();
         _loc3_.event = MatchEvent.GOAL;
         _loc3_.player = param1.player;
         _loc3_.time = param2;
         this.events.push(_loc3_);
      }
      
      public function getScorers() : String
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc1_:Array = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < this.events.length)
         {
            if(this.events[_loc2_].event == MatchEvent.GOAL)
            {
               _loc4_ = -1;
               _loc5_ = 0;
               while(_loc5_ < _loc1_.length)
               {
                  if(_loc1_[_loc5_].indexOf(this.events[_loc2_].player.getLastName()) >= 0)
                  {
                     _loc4_ = _loc5_;
                  }
                  _loc5_++;
               }
               if(_loc4_ >= 0)
               {
                  _loc1_[_loc4_] += ", " + this.events[_loc2_].time;
               }
               else
               {
                  _loc1_.push(this.events[_loc2_].player.getLastName() + " " + this.events[_loc2_].time);
               }
            }
            _loc2_++;
         }
         var _loc3_:String = "";
         _loc2_ = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ += _loc2_ < _loc1_.length - 1 ? _loc1_[_loc2_] + ", " : _loc1_[_loc2_] + " ";
            _loc2_++;
         }
         return _loc3_;
      }
      
      public function getGoals() : int
      {
         var _loc2_:MatchEvent = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this.events)
         {
            if(_loc2_.event == MatchEvent.GOAL)
            {
               _loc1_++;
            }
         }
         return _loc1_;
      }
      
      public function getShots() : int
      {
         var _loc2_:MatchPlayerDetails = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this.squad)
         {
            _loc1_ += _loc2_.shotsOnTarget + _loc2_.shotsOffTarget;
         }
         return _loc1_;
      }
      
      public function getShotsOnTarget() : int
      {
         var _loc2_:MatchPlayerDetails = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this.squad)
         {
            _loc1_ += _loc2_.shotsOnTarget;
         }
         return _loc1_;
      }
   }
}

