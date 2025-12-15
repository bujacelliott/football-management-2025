package com.utterlySuperb.chumpManager.model.dataObjects.matches
{
   public class MatchMessage
   {
      
      public var copy:String;
      
      public var team:int = -1;
      
      public var type:String = "";
      
      public function MatchMessage(param1:String = "")
      {
         super();
         this.copy = param1;
      }
   }
}

