package com.utterlySuperb.chumpManager.model.dataObjects.matches
{
   public class MatchAction
   {
      
      public static const KICK_OFF:String = "kickOff";
      
      public static const PASS:String = "pass";
      
      public static const PASS_FAIL:String = "passFail";
      
      public static const CROSS:String = "cross";
      
      public static const CROSS_FAIL:String = "crossFail";
      
      public static const CROSS_MADE:String = "crossMade";
      
      public static const FREE_KICK:String = "freeKick";
      
      public static const PENALTY:String = "penalty";
      
      public static const PENALTY_RUN_UP:String = "penaltyRunUp";
      
      public static const GOAL_KICK:String = "goalKick";
      
      public static const GOAL:String = "goal";
      
      public static const SAVE:String = "save";
      
      public static const THROW_IN:String = "throwIn";
      
      public static const CORNER:String = "corner";
      
      public static const SHOT:String = "shot";
      
      public static const SUBSTITUTION:String = "substitution";
      
      public static const SWITCH_PLAY:String = "switchPlay";
      
      public var player:MatchPlayerDetails;
      
      public var action:String;
      
      public function MatchAction(param1:String, param2:MatchPlayerDetails = null)
      {
         super();
         this.action = param1;
         this.player = param2;
      }
   }
}

