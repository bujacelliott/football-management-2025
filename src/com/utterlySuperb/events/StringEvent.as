package com.utterlySuperb.events
{
   import flash.events.Event;
   
   public class StringEvent extends Event
   {
      
      private var _str:String;
      
      public function StringEvent(param1:String, param2:String)
      {
         super(param1,true);
         this._str = param2;
      }
      
      public function get str() : String
      {
         return this._str;
      }
      
      override public function clone() : Event
      {
         return new StringEvent(type,this._str);
      }
   }
}

