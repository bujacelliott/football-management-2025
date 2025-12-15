package com.utterlySuperb.events
{
   public class BudgetEventProxy
   {
      
      private static var listeners:Array = [];
      
      public function BudgetEventProxy()
      {
         super();
      }
      
      public static function addEventListener(param1:String, param2:Function) : void
      {
         if(!listeners[param1])
         {
            listeners[param1] = [];
         }
         if(listeners[param1].indexOf(param2) < 0)
         {
            listeners[param1].push(param2);
         }
      }
      
      public static function dispatchEvent(param1:String, param2:Object = null) : void
      {
         var _loc3_:uint = 0;
         if(listeners[param1])
         {
            _loc3_ = 0;
            while(_loc3_ < listeners[param1].length)
            {
               listeners[param1][_loc3_](param2);
               _loc3_++;
            }
         }
      }
      
      public static function removeEventListener(param1:String, param2:Function) : void
      {
         if(listeners[param1])
         {
            if(listeners[param1].indexOf(param2) >= 0)
            {
               listeners[param1].splice(listeners[param1].indexOf(param2),1);
            }
         }
      }
      
      public static function hasEventListener(param1:String, param2:Function) : Boolean
      {
         return Boolean(listeners[param1]) && listeners[param1].indexOf(param2) >= 0;
      }
   }
}

