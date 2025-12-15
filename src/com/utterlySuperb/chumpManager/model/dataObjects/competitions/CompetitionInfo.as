package com.utterlySuperb.chumpManager.model.dataObjects.competitions
{
   import com.utterlySuperb.chumpManager.model.dataObjects.Club;
   
   public class CompetitionInfo
   {
      
      public var club:Club;
      
      public var wins:int;
      
      public var loses:int;
      
      public var draws:int;
      
      public var goalsScored:int;
      
      public var goalsConceeded:int;
      
      public var eliminated:Boolean;
      
      public var currentPosition:int;
      
      public function CompetitionInfo()
      {
         super();
      }
      
      public function makeCompetionInfo(param1:Club) : void
      {
         this.club = param1;
         this.wins = this.loses = this.draws = this.goalsScored = this.goalsConceeded = 0;
         this.eliminated = false;
      }
      
      public function get points() : int
      {
         return this.wins * 3 + this.draws;
      }
      
      public function get gamesPlayed() : int
      {
         return this.wins + this.draws + this.loses;
      }
      
      public function get goalDifference() : int
      {
         return this.goalsScored - this.goalsConceeded;
      }
   }
}

