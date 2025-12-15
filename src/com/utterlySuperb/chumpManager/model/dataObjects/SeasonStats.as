package com.utterlySuperb.chumpManager.model.dataObjects
{
   public class SeasonStats
   {
      
      public var goals:int;
      
      public var assists:int;
      
      public var appearances:int;
      
      public var subsAppearances:int;
      
      public var yellowCards:int;
      
      public var redCards:int;
      
      public var scoreTotal:Number;
      
      public function SeasonStats()
      {
         super();
         this.goals = this.assists = this.appearances = this.subsAppearances = this.yellowCards = this.redCards = this.scoreTotal = 0;
      }
      
      public function getAverageScore() : Number
      {
         return this.appearances > 0 ? this.scoreTotal / (this.appearances + this.subsAppearances) : -1;
      }
   }
}

