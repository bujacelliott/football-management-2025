package com.utterlySuperb.chumpManager.model.dataObjects.matches
{
   import com.utterlySuperb.chumpManager.model.dataObjects.competitions.Competition;
   import com.utterlySuperb.chumpManager.model.dataObjects.competitions.CompetitionInfo;
   
   public class Match
   {
      
      public static const MATCH_PLAYED:String = "matchPlayed";
      
      public var club0:CompetitionInfo;
      
      public var club1:CompetitionInfo;
      
      public var club0Scorers:String = "";
      
      public var club1Scorers:String = "";
      
      public var club0Score:int = 0;
      
      public var club1Score:int = 0;
      
      public var club0ETScore:int = 0;
      
      public var club1ETScore:int = 0;
      
      public var competition:Competition;
      
      public var beenPlayed:Boolean;
      
      public var extraTimePlayed:Boolean;
      
      public var needsWinner:Boolean;
      
      public var penaltiesScore0:int;
      
      public var penaltiesScore1:int;
      
      public var loser:CompetitionInfo;
      
      public var firstLeg:Match;
      
      public function Match()
      {
         super();
      }
      
      public function workOut() : void
      {
         if(this.club0Score == this.club1Score)
         {
            ++this.club0.draws;
            ++this.club1.draws;
         }
         else if(this.club0Score > this.club1Score)
         {
            ++this.club0.wins;
            ++this.club1.loses;
            this.loser = this.club1;
         }
         else
         {
            ++this.club1.wins;
            ++this.club0.loses;
            this.loser = this.club0;
         }
         this.club0.goalsScored += this.club0Score;
         this.club0.goalsConceeded += this.club1Score;
         this.club1.goalsScored += this.club1Score;
         this.club1.goalsConceeded += this.club0Score;
         this.beenPlayed = true;
         this.competition.matchPlayed(this);
      }
      
      public function workOutET() : void
      {
         --this.club0.draws;
         --this.club1.draws;
         if(this.club0ETScore > this.club1ETScore)
         {
            ++this.club0.wins;
            ++this.club1.loses;
            this.loser = this.club1;
         }
         else if(this.club1ETScore > this.club0ETScore)
         {
            ++this.club1.wins;
            ++this.club0.loses;
            this.loser = this.club0;
         }
         this.club0.goalsScored += this.club0ETScore;
         this.club0.goalsConceeded += this.club1ETScore;
         this.club1.goalsScored += this.club1ETScore;
         this.club1.goalsConceeded += this.club0ETScore;
         this.extraTimePlayed = true;
         this.competition.matchPlayed(this);
      }
      
      public function workOutPenalties() : void
      {
         if(this.penaltiesScore0 > this.penaltiesScore1)
         {
            ++this.club0.wins;
            ++this.club1.loses;
            this.loser = this.club1;
         }
         else
         {
            ++this.club1.wins;
            ++this.club0.loses;
            this.loser = this.club0;
         }
         this.competition.matchPlayed(this);
      }
      
      public function getLoser() : CompetitionInfo
      {
         return this.club0Score > this.club1Score ? this.club0 : this.club1;
      }
      
      public function getWinner() : CompetitionInfo
      {
         return this.club1 == this.loser ? this.club0 : this.club1;
      }
      
      public function isDraw() : Boolean
      {
         return this.club0Score == this.club1Score;
      }
   }
}

