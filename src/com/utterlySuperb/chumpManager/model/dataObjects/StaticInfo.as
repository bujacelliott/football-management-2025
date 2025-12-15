package com.utterlySuperb.chumpManager.model.dataObjects
{
   import com.utterlySuperb.chumpManager.engine.PlayerHelper;
   
   public class StaticInfo
   {
      
      public static var playerBank:PlayerBank;
      
      public static var youthPlayerBank:PlayerBank;
      
      public static var startDate:Date;
      
      public function StaticInfo()
      {
         super();
      }
      
      public static function init() : void
      {
         playerBank = new PlayerBank();
         youthPlayerBank = new PlayerBank();
      }
      
      public static function addPlayer(param1:Player) : void
      {
         playerBank.addPlayer(param1);
      }
      
      public static function getPlayer(param1:String) : Player
      {
         if(playerBank.getPlayer(param1))
         {
            return playerBank.getPlayer(param1);
         }
         return getYouthPlayer(param1);
      }
      
      public static function getPlayerList() : Array
      {
         return playerBank.playersList;
      }
      
      public static function replacePlayer(param1:Player) : void
      {
         playerBank.replacePlayer(param1);
      }
      
      public static function addYouthPlayer(param1:Player) : void
      {
         youthPlayerBank.addPlayer(param1);
      }
      
      public static function getYouthPlayer(param1:String) : Player
      {
         if(youthPlayerBank.getPlayer(param1))
         {
            return youthPlayerBank.getPlayer(param1);
         }
         return PlayerHelper.getYouthPlayer(param1.split("_")[1],param1.split("_")[2],param1);
      }
      
      public static function getYouthPlayerList() : Array
      {
         return youthPlayerBank.playersList;
      }
      
      public static function replaceYouthPlayer(param1:Player) : void
      {
         youthPlayerBank.replacePlayer(param1);
      }
   }
}

