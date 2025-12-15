package com.utterlySuperb.chumpManager.engine
{
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.Club;
   import com.utterlySuperb.chumpManager.model.dataObjects.Game;
   import com.utterlySuperb.chumpManager.model.dataObjects.Message;
   import com.utterlySuperb.chumpManager.model.dataObjects.Player;
   import com.utterlySuperb.chumpManager.model.dataObjects.PlayerOffers;
   import com.utterlySuperb.chumpManager.model.dataObjects.StaticInfo;
   import com.utterlySuperb.text.TextHelper;
   
   public class TransfersEngine
   {
      
      public static const MAX_TRANSFER:int = 100000000;
      
      public static const MAX_SALARY:int = 4000000;
      
      private static const NEEDED_NUMBERS:Array = [4,1,2,2,2,4,4,4,1,3];
      
      public static const TRANSFER_SLOTS:Array = [0,1000000,5000000,10000000,15000000,20000000,35000000,50000000,75000000,100000000,250000000];
      
      public function TransfersEngine()
      {
         super();
      }
      
      public static function doAITeamTransfers(param1:Game) : void
      {
         var _loc5_:Player = null;
         var _loc6_:int = 0;
         var _loc7_:Boolean = false;
         var _loc8_:int = 0;
         var _loc2_:Array = StaticInfo.getPlayerList();
         var _loc3_:Array = new Array();
         var _loc4_:Array = GameHelper.getCoreClubs();
         for each(_loc5_ in _loc2_)
         {
            if(!_loc5_.club && _loc5_.active)
            {
               _loc3_.push(_loc5_);
            }
         }
         _loc6_ = 0;
         while(_loc6_ < _loc4_.length)
         {
            if(_loc4_[_loc6_].club != param1.playerClub)
            {
               _loc7_ = false;
               _loc8_ = 0;
               while((!_loc7_ || _loc4_[_loc6_].club.players.length < 20) && _loc8_++ < 15)
               {
                  doClubTransfer(_loc4_[_loc6_].club,_loc3_,_loc4_);
                  _loc7_ = true;
               }
            }
            _loc6_++;
         }
      }
      
      private static function doClubTransfer(param1:Club, param2:Array, param3:Array) : void
      {
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:Array = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Message = null;
         var _loc12_:int = 0;
         var _loc13_:Boolean = false;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:Player = null;
         var _loc17_:PlayerOffers = null;
         if((Math.random() > 0.5 || param1.players.length < 20) && param1.players.length < 30)
         {
            _loc4_ = getPositionNumbers(param1);
            _loc5_ = Player.POSITIONS.slice();
            _loc6_ = 0;
            while(_loc6_ < _loc4_.length)
            {
               if(_loc4_[_loc6_] < NEEDED_NUMBERS[_loc6_])
               {
                  _loc9_ = 0;
                  while(_loc9_ < NEEDED_NUMBERS[_loc6_] - _loc4_[_loc6_])
                  {
                     _loc5_.push(Player.POSITIONS[_loc6_]);
                     _loc9_++;
                  }
               }
               _loc6_++;
            }
            _loc7_ = _loc5_.length == 0 ? Player.POSITIONS[int(Player.POSITIONS.length * Math.random())] : _loc5_[int(Math.random() * _loc5_.length)];
            _loc8_ = new Array();
            _loc6_ = 0;
            while(_loc6_ < param2.length)
            {
               if(param2[_loc6_].positions.indexOf(_loc7_) >= 0 && !param2[_loc6_].club)
               {
                  _loc8_.push(param2[_loc6_]);
               }
               _loc6_++;
            }
            if(_loc8_.length > 0)
            {
               _loc10_ = int(Math.random() * _loc8_.length);
               transferPlayer(_loc8_[_loc10_],param1,null);
               param2.splice(param2.indexOf(_loc8_[_loc10_]),1);
               _loc11_ = new Message();
               _loc11_.title = CopyManager.getCopy("transferNotification");
               _loc11_.body = CopyManager.getCopy("transferNotificationCopyFree").replace(CopyManager.PLAYER_NAME_REPLACE,_loc8_[_loc10_].name).replace(CopyManager.CLUB_NAME_REPLACE,param1.name);
            }
            else
            {
               _loc12_ = 0;
               _loc13_ = false;
               while(_loc12_++ < 5 && !_loc13_)
               {
                  _loc14_ = int(Math.random() * param3.length);
                  _loc15_ = 0;
                  _loc6_ = 0;
                  while(_loc6_ < Main.currentGame.userMessages.length)
                  {
                     if(Message(Main.currentGame.userMessages[_loc6_]).offer)
                     {
                        _loc15_++;
                     }
                     _loc6_++;
                  }
                  while(param3[_loc14_].club == param1 || _loc15_ > 6 && param1 == Main.currentGame.playerClub)
                  {
                     _loc14_ = int(Math.random() * param3.length);
                  }
                  _loc16_ = getPlayerInPostion(param3[_loc14_].club,param1,_loc7_);
                  if(_loc16_)
                  {
                     if(param3[_loc14_].club == Main.currentGame.playerClub)
                     {
                        _loc13_ = true;
                        _loc17_ = new PlayerOffers();
                        _loc17_.player = _loc16_.id;
                        _loc17_.cashOff = getExpectedTransferFee(_loc16_) * (0.4 + Math.random() / 2);
                        _loc17_.toClub = param1;
                        _loc11_ = new Message();
                        _loc11_.title = CopyManager.getCopy("transferOffer");
                        _loc11_.body = CopyManager.getCopy("transferOfferCopy").replace(CopyManager.PLAYER_NAME_REPLACE,_loc16_.name).replace(CopyManager.CLUB_NAME_REPLACE,param1.name).replace("{transferFee}",CopyManager.getCurrency() + TextHelper.prettifyNumber(_loc17_.cashOff));
                        _loc11_.offer = _loc17_;
                        Main.currentGame.userMessages.push(_loc11_);
                     }
                     else if(canTakePlayerFrom(param3[_loc14_].club,_loc16_))
                     {
                        transferPlayer(_loc16_,param1,param3[_loc14_].club);
                        _loc11_ = new Message();
                        _loc11_.title = CopyManager.getCopy("transferNotification");
                        _loc11_.body = CopyManager.getCopy("transferNotificationCopy").replace(CopyManager.PLAYER_NAME_REPLACE,_loc16_.name).replace(CopyManager.CLUB_NAME_REPLACE,param1.name).replace("{clubName2}",param3[_loc14_].club.name);
                        _loc13_ = true;
                     }
                  }
               }
            }
         }
      }
      
      public static function getInterestedClub(param1:Player, param2:Array) : Club
      {
         var _loc4_:Club = null;
         var _loc7_:Club = null;
         var _loc8_:Number = NaN;
         var _loc3_:Number = 0;
         var _loc5_:Array = GameHelper.getCoreClubs();
         var _loc6_:int = 0;
         while(_loc6_ < 15)
         {
            _loc7_ = _loc5_[int(Math.random() * _loc5_.length)].club;
            if(param2.indexOf(_loc7_) < 0 && _loc7_ != Main.currentGame.playerClub)
            {
               _loc8_ = getNeedForPlayer(param1,_loc7_);
               if(_loc8_ > _loc3_)
               {
                  _loc3_ = _loc8_;
                  _loc4_ = _loc7_;
               }
            }
            _loc6_++;
         }
         return _loc4_ ? _loc4_ : null;
      }
      
      public static function getNeedForPlayer(param1:Player, param2:Club) : Number
      {
         var _loc6_:Player = null;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc3_:Number = 20;
         var _loc4_:Array = param1.positions.split("-");
         var _loc5_:int = 0;
         while(_loc5_ < param2.players.length)
         {
            _loc6_ = StaticInfo.getPlayer(param2.players[_loc5_]);
            _loc7_ = _loc6_.positions.split("-");
            _loc8_ = 0;
            while(_loc8_ < _loc7_.length)
            {
               if(_loc4_.indexOf(_loc7_[_loc8_]) >= 0)
               {
                  if(_loc6_.playerRating > param1.playerRating)
                  {
                     _loc3_ -= 3;
                  }
                  else
                  {
                     _loc3_--;
                  }
               }
               _loc8_++;
            }
            _loc5_++;
         }
         return Math.max(0,_loc3_);
      }
      
      public static function getPlayerOffer(param1:Club, param2:Player) : int
      {
         var _loc3_:Number = getNeedForPlayer(param2,param1);
         var _loc4_:Number = param2.playerRating - param1.profile / 100;
         var _loc5_:int = param2.transferValue;
         _loc5_ = _loc5_ * 0.4 + _loc5_ * 0.5 * param1.profile / 95 + _loc5_ * 0.1 * _loc3_ / 15;
         return int(_loc5_);
      }
      
      public static function transferPlayer(param1:Player, param2:Club, param3:Club) : void
      {
         if(param3)
         {
            param3.removePlayer(param1.id);
            param3.getFormation().removeSoldPlayers(param3.players);
         }
         param2.addPlayer(param1.id);
         param1.club = param2;
      }
      
      private static function getPlayerInPostion(param1:Club, param2:Club, param3:String) : Player
      {
         var _loc4_:Player = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc5_:int = 0;
         while(!_loc4_ && _loc5_++ < 30)
         {
            _loc6_ = int(Math.random() * param1.players.length);
            if(StaticInfo.getPlayer(param1.players[_loc6_]).positions.indexOf(param3) >= 0)
            {
               _loc4_ = StaticInfo.getPlayer(param1.players[_loc6_]);
            }
            if(_loc4_)
            {
               _loc7_ = Math.ceil(Math.min(Math.max(0,_loc4_.playerRating - 40),60) / 50 * 100);
               if(Math.abs(_loc7_ - param2.profile) > 20)
               {
                  _loc4_ = null;
               }
            }
         }
         return _loc4_;
      }
      
      private static function canTakePlayerFrom(param1:Club, param2:Player) : Boolean
      {
         var _loc7_:int = 0;
         if(param1.players.length < 20)
         {
            return false;
         }
         var _loc3_:Array = param2.positions.split("-");
         var _loc4_:Boolean = true;
         var _loc5_:Array = getPositionNumbers(param1);
         var _loc6_:int = 0;
         if(_loc6_ < _loc3_.length)
         {
            _loc7_ = int(Player.POSITIONS.indexOf(_loc3_[_loc6_]));
            if(_loc5_[_loc7_] < NEEDED_NUMBERS[_loc7_])
            {
               _loc4_ = false;
            }
         }
         return _loc4_;
      }
      
      private static function getPositionNumbers(param1:Club) : Array
      {
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < Player.POSITIONS.length)
         {
            _loc2_[_loc3_] = 0;
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < param1.players.length)
         {
            _loc4_ = StaticInfo.getPlayer(param1.players[_loc3_]).positions.split("-");
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               ++_loc2_[Player.POSITIONS.indexOf(_loc4_[_loc5_])];
               _loc5_++;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function getExpectedTransferFee(param1:Player) : int
      {
         var _loc2_:Number = param1.playerRating > 0 ? param1.playerRating / 110 : PlayerHelper.getPlayerScore(param1) / 110;
         var _loc3_:int = PlayerHelper.getMaxAge(param1.basePostition);
         var _loc4_:int = _loc3_ - Player.MIN_AGE;
         _loc2_ = _loc2_ * 0.9 + _loc2_ * 0.1 * (_loc4_ - (param1.age - Player.MIN_AGE)) / _loc4_;
         return Math.pow(21350,1 + _loc2_);
      }
      
      public static function getExpectedSalary(param1:Player) : int
      {
         var _loc2_:Number = PlayerHelper.getPlayerScore(param1) / 100;
         var _loc3_:int = Player.MAX_AGE - Player.MIN_AGE;
         return Math.pow(19000,1 + _loc2_ * 0.55);
      }
      
      public static function getEstimateTransfer(param1:int) : int
      {
         var _loc2_:int = 0;
         while(TRANSFER_SLOTS[_loc2_] < param1)
         {
            _loc2_++;
         }
         return TRANSFER_SLOTS[_loc2_];
      }
      
      public static function processPlayerTransfers() : void
      {
         var _loc2_:PlayerOffers = null;
         var _loc3_:Player = null;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc1_:Game = Main.currentGame;
         while(_loc1_.playerOffers.length > 0)
         {
            _loc2_ = _loc1_.playerOffers.shift();
            _loc3_ = StaticInfo.getPlayer(_loc2_.player);
            _loc4_ = getExpectedTransferFee(_loc3_);
            _loc5_ = _loc2_.cashOff >= _loc4_ || !_loc3_.club;
            if(_loc5_)
            {
               _loc7_ = CopyManager.getCopy("transferSuccess");
               _loc6_ = CopyManager.getCopy("transferSuccessCopy");
               transferPlayer(_loc3_,_loc1_.playerClub,_loc3_.club);
               _loc3_.newSeason();
               _loc1_.savedPlayers.addPlayer(_loc3_);
            }
            else
            {
               Main.currentGame.clubCash += _loc2_.cashOff;
               if(!_loc5_)
               {
                  _loc6_ = CopyManager.getCopy("transferFeeBad");
               }
               else if(_loc3_.club)
               {
                  _loc6_ = CopyManager.getCopy("salaryFeeBad");
               }
               else
               {
                  _loc6_ = CopyManager.getCopy("salaryFeeBadNoClub");
               }
               _loc7_ = CopyManager.getCopy("transferUnsuccessful");
            }
            _loc6_ = _loc6_.replace(CopyManager.PLAYER_NAME_REPLACE,_loc3_.name);
            if(_loc3_.club)
            {
               _loc6_ = _loc6_.replace(CopyManager.CLUB_NAME_REPLACE,_loc3_.club.name);
            }
            Main.currentGame.addMessage(_loc7_,_loc6_);
         }
      }
   }
}

