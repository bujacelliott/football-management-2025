package com.utterlySuperb.chumpManager.model.dataObjects
{
   public class StatusEffect
   {
      
      public static const INJURY:String = "injury";
      
      public static const SUSPENSION:String = "suspension";
      
      public static const FORM_CHANGE:String = "formChange";
      
      public var time:int;
      
      public var type:String;
      
      public var amount:String;
      
      public function StatusEffect()
      {
         super();
      }
   }
}

