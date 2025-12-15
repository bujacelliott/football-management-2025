package com.utterlySuperb.events
{
   import flash.events.Event;
   
   public class IntEvent extends Event
   {
      
      private var _num:int;
      
      public function IntEvent(param1:String, param2:int)
      {
         super(param1,true);
         this._num = param2;
      }
      
      public function get num() : int
      {
         return this._num;
      }
      
      override public function clone() : Event
      {
         return new IntEvent(type,this._num);
      }
   }
}

