package com.utterlySuperb.utils
{
   public class MyMath
   {
      
      public static const PiRads:Number = Math.PI / 180;
      
      public function MyMath()
      {
         super();
      }
      
      public static function getAngle(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         var _loc5_:Number = Math.atan2(param4 - param2,param3 - param1) / PiRads;
         if(_loc5_ < 0)
         {
            _loc5_ += 360;
         }
         if(_loc5_ > 360)
         {
            _loc5_ - 360;
         }
         return _loc5_;
      }
      
      public static function getX(param1:Number, param2:Number) : Number
      {
         return Math.cos(param1 * PiRads) * param2;
      }
      
      public static function getY(param1:Number, param2:Number) : Number
      {
         return Math.sin(param1 * PiRads) * param2;
      }
      
      public static function getDistance(param1:Number, param2:Number) : Number
      {
         return Math.sqrt(param1 * param1 + param2 * param2);
      }
   }
}

