package com.utterlySuperb.chumpManager.model.dataObjects.matches
{
   import com.utterlySuperb.chumpManager.model.dataObjects.Player;
   
   public class MatchEvent
   {
      
      public static const SCORER:String = "scorer";
      
      public static const YELLOW:String = "yellowCard";
      
      public static const RED:String = "redCard";
      
      public static const OWN_GOAL:String = "ownGoal";
      
      public static const GOAL:String = "goal";
      
      public static const INJURY:String = "injury";
      
      public var player:Player;
      
      public var event:String;
      
      public var time:String;
      
      public var matchSection:int;
      
      public var team:MatchTeamDetails;
      
      public function MatchEvent()
      {
         super();
      }
   }
}

