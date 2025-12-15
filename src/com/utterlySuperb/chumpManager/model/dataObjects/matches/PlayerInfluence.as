package com.utterlySuperb.chumpManager.model.dataObjects.matches
{
   public class PlayerInfluence
   {
      
      public var player:MatchPlayerDetails;
      
      public var influence:Number;
      
      public function PlayerInfluence(param1:MatchPlayerDetails, param2:Number)
      {
         super();
         this.player = param1;
         this.influence = param2;
      }
   }
}

