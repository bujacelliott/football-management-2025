package com.utterlySuperb.chumpManager.events
{
   import com.utterlySuperb.chumpManager.model.dataObjects.Player;
   import flash.events.Event;
   
   public class PlayerEvent extends Event
   {
      
      public static const OVER_PLAYER:String = "overPlayer";
      
      public static const CLICK_PLAYER:String = "clickPlayer";
      
      public var player:Player;
      
      public function PlayerEvent(param1:String, param2:Player)
      {
         super(param1,false,false);
         this.player = param2;
      }
      
      override public function clone() : Event
      {
         return new PlayerEvent(type,this.player);
      }
      
      override public function toString() : String
      {
         return formatToString("PlayerEvent","type","player","eventPhase");
      }
   }
}

