package com.utterlySuperb.chumpManager.model.dataObjects
{
   public class Club
   {
      
      public static const NONE:String = "none";
      
      public static const HORIZONTAL:String = "horizontal";
      
      public static const VERTICAL:String = "vertical";
      
      public var players:Array;
      
      public var name:String;
      
      public var _shortName:String;
      
      public var profile:Number;
      
      public var shirtColor:Number;
      
      public var sleevesColor:Number;
      
      public var stripesColor:Number;
      
      public var stripesType:String;
      
      public var scoreMultiplier:int;
      
      public var attackScore:String;
      
      public var defendScore:String;
      
      public var isCore:Boolean;
      
      public function Club()
      {
         super();
      }
      
      public function makeClub() : void
      {
         this.players = new Array();
      }
      
      public function addPlayer(param1:String) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Player = StaticInfo.getPlayer(param1);
         var _loc4_:int = 0;
         while(_loc4_ < this.players.length)
         {
            if(StaticInfo.getPlayer(this.players[_loc4_]).squadNumber == _loc3_.squadNumber)
            {
               _loc2_ = true;
            }
            _loc4_++;
         }
         if(_loc2_ || _loc3_.squadNumber <= 0)
         {
            StaticInfo.getPlayer(param1).squadNumber = this.getNextSquadNumber(_loc3_);
         }
         this.players.push(param1);
      }
      
      public function getNextSquadNumber(param1:Player) : int
      {
         var _loc2_:int = 1;
         switch(param1.basePostition)
         {
            case "gk":
               if(this.hasSquadNumber(1))
               {
                  _loc2_ = 16;
               }
               break;
            case "def":
               _loc2_ = 2;
               break;
            case "mid":
               _loc2_ = 4;
               break;
            case "fwd":
               _loc2_ = 7;
         }
         return _loc2_;
      }
      
      public function hasSquadNumber(param1:int) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.players.length)
         {
            if(StaticInfo.getPlayer(this.players[_loc2_]).squadNumber == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function removePlayer(param1:String) : void
      {
         if(this.players.indexOf(param1) >= 0)
         {
            this.players.splice(this.players.indexOf(param1),1);
         }
      }
      
      public function getPlayer(param1:String) : Player
      {
         if(this.players.indexOf(param1) >= 0)
         {
            return StaticInfo.getPlayer(param1);
         }
         return null;
      }
      
      public function getPlayersList() : Array
      {
         var _loc1_:Array = new Array(this.players.length);
         var _loc2_:int = 0;
         while(_loc2_ < this.players.length)
         {
            _loc1_[_loc2_] = StaticInfo.getPlayer(this.players[_loc2_]);
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getFormation(param1:int = -1) : Formation
      {
         var _loc2_:Formation = null;
         var _loc3_:int = 0;
         if(this == Main.currentGame.playerClub)
         {
            _loc2_ = Main.currentGame.playerFormation;
         }
         else
         {
            _loc3_ = param1 >= 0 ? param1 : int(Math.random() * Formation.FORMATIONS.length);
            _loc2_ = Formation.getStandardFormation(Formation.FORMATIONS[_loc3_]);
         }
         _loc2_.setPositions();
         _loc2_.setPlayers(this);
         return _loc2_;
      }
      
      public function get shortName() : String
      {
         return Boolean(this._shortName) && this._shortName.length > 0 ? this._shortName : this.name;
      }
      
      public function set shortName(param1:String) : void
      {
         this._shortName = param1;
      }
   }
}

