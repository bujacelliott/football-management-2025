package com.utterlySuperb.chumpManager.model.dataObjects
{
   import flash.utils.Dictionary;
   
   public class PlayerBank
   {
      
      public var players:Dictionary;
      
      public var playersList:Array;
      
      public function PlayerBank()
      {
         super();
         this.players = new Dictionary();
         this.playersList = new Array();
      }
      
      public function addPlayer(param1:Player) : void
      {
         this.players[param1.id] = param1;
         this.playersList.push(param1);
      }
      
      public function replacePlayer(param1:Player) : void
      {
         this.players[param1.id] = param1;
         var _loc2_:int = 0;
         while(_loc2_ < this.playersList.length)
         {
            if(this.playersList[_loc2_].id == param1.id)
            {
               this.playersList[_loc2_] = param1;
            }
            _loc2_++;
         }
      }
      
      public function removePlayer(param1:Player) : void
      {
         if(this.players[param1.id])
         {
            delete this.players[param1.id];
         }
         if(this.playersList.indexOf(param1) <= 0)
         {
            this.playersList.splice(this.playersList.indexOf(param1),1);
         }
      }
      
      public function removePlayerById(param1:String) : void
      {
         if(this.players[param1])
         {
            this.removePlayer(this.players[param1]);
         }
      }
      
      public function getPlayer(param1:String) : Player
      {
         return this.players[param1];
      }
   }
}

