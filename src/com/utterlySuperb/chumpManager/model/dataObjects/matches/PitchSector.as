package com.utterlySuperb.chumpManager.model.dataObjects.matches
{
   public class PitchSector
   {
      
      public var team0Influence:Array;
      
      public var team1Influence:Array;
      
      public var column:int;
      
      public var row:int;
      
      public function PitchSector(param1:int, param2:int)
      {
         super();
         this.column = param1;
         this.row = param2;
         this.reset();
      }
      
      public function reset() : void
      {
         this.team0Influence = new Array();
         this.team1Influence = new Array();
      }
      
      public function addTeam0Player(param1:MatchPlayerDetails, param2:Number) : void
      {
         this.team0Influence.push(new PlayerInfluence(param1,param2));
      }
      
      public function addTeam1Player(param1:MatchPlayerDetails, param2:Number) : void
      {
         this.team1Influence.push(new PlayerInfluence(param1,param2));
      }
   }
}

