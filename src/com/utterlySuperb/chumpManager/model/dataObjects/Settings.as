package com.utterlySuperb.chumpManager.model.dataObjects
{
   import com.utterlySuperb.chumpManager.engine.MatchEngine;
   
   public class Settings
   {
      
      public static const SHOW_ALL:int = 0;
      
      public static const SHOW_HALF:int = 1;
      
      public static const SHOW_GOALS:int = 2;
      
      public var gameSpeed:int = 10;
      
      public var matchEvents:Array;
      
      public var matchFilter:int;
      
      public function Settings()
      {
         super();
         this.matchEvents = [];
         this.matchEvents[MatchEngine.GOAL] = true;
         this.matchEvents[MatchEngine.HALF_TIME] = true;
         this.matchEvents[MatchEngine.RED_CARD] = true;
         this.matchEvents[MatchEngine.INJURY] = true;
         this.matchEvents[MatchEngine.YELLOW_CARD] = true;
         this.matchFilter = SHOW_ALL;
      }
   }
}

