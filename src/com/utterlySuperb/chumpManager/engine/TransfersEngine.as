package com.utterlySuperb.chumpManager.engine
{
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.Club;
import com.utterlySuperb.chumpManager.model.dataObjects.Game;
import com.utterlySuperb.chumpManager.model.dataObjects.Message;
import com.utterlySuperb.chumpManager.model.dataObjects.Player;
import com.utterlySuperb.chumpManager.model.dataObjects.PlayerOffers;
import com.utterlySuperb.chumpManager.engine.TransferBudgetHelper;
import com.utterlySuperb.chumpManager.model.dataObjects.StaticInfo;
import com.utterlySuperb.chumpManager.engine.PlayerHelper;
import com.utterlySuperb.text.TextHelper;
import flash.utils.ByteArray;
   
   public class TransfersEngine
   {
      
      public static const MAX_TRANSFER:int = 100000000;
      
      public static const MAX_SALARY:int = 4000000;
      
   private static const NEEDED_NUMBERS:Array = [4,1,2,2,2,4,4,4,1,3];

      private static const ELITE_PROFILE:int = 85;

      private static const ELITE_TRANSFER_CHANCE:Number = 0.05;
      
   public static const TRANSFER_SLOTS:Array = [0,1000000,5000000,10000000,15000000,20000000,35000000,50000000,75000000,100000000,250000000];

      [Embed(source="../../../../../data/value_mapping_rescaled.csv", mimeType="application/octet-stream")]
      private static const ValueMapData:Class;

      private static var valueMap:Object;

      private static var valueMapList:Array;

      private static var minGameOverall:int = 0;

      private static var maxGameOverall:int = 0;

      private static var minGamePotential:int = 0;

      private static var maxGamePotential:int = 0;

      private static var minAge:int = 0;

      private static var maxAge:int = 0;
      
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
               recordTransfer(_loc8_[_loc10_],null,param1,0);
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
                     if(!canBuyFromClub(param1,param3[_loc14_].club,_loc16_))
                     {
                        _loc12_++;
                        continue;
                     }
                     if(param3[_loc14_].club == Main.currentGame.playerClub)
                     {
                        _loc13_ = true;
                        _loc17_ = new PlayerOffers();
                        _loc17_.player = _loc16_.id;
                        _loc17_.cashOff = getExpectedTransferFee(_loc16_) * (0.4 + Math.random() / 2);
                        if(!canAffordTransfer(param1,_loc17_.cashOff))
                        {
                           _loc12_++;
                           continue;
                        }
                        _loc17_.toClub = param1;
                        _loc11_ = new Message();
                        _loc11_.title = CopyManager.getCopy("transferOffer");
                        _loc11_.body = CopyManager.getCopy("transferOfferCopy").replace(CopyManager.PLAYER_NAME_REPLACE,_loc16_.name).replace(CopyManager.CLUB_NAME_REPLACE,param1.name).replace("{transferFee}",CopyManager.getCurrency() + TextHelper.prettifyNumber(_loc17_.cashOff));
                        _loc11_.offer = _loc17_;
                        Main.currentGame.userMessages.push(_loc11_);
                     }
                     else if(canTakePlayerFrom(param3[_loc14_].club,_loc16_) && canBuyFromClub(param1,param3[_loc14_].club,_loc16_))
                     {
                        if(!canAffordTransfer(param1,getExpectedTransferFee(_loc16_)))
                        {
                           _loc12_++;
                           continue;
                        }
                        transferPlayer(_loc16_,param1,param3[_loc14_].club);
                        recordTransfer(_loc16_,param3[_loc14_].club,param1,getExpectedTransferFee(_loc16_));
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
               if(_loc4_ && !canBuyFromClub(param2,param1,_loc4_))
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

      private static function canBuyFromClub(param1:Club, param2:Club, param3:Player) : Boolean
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(!param1 || !param2 || !param3)
         {
            return false;
         }
         if(param1 == param2)
         {
            return false;
         }
         _loc5_ = getClubTier(param1);
         _loc6_ = getClubTier(param2);
         if((_loc5_ == 2 || _loc5_ == 3) && _loc6_ == 0)
         {
            return false;
         }
         if(_loc5_ == 1 && _loc6_ == 0)
         {
            if(isStartingXI(param2,param3) || getPlayerStars(param3) > 6)
            {
               return false;
            }
         }
         if(_loc5_ == 3)
         {
            return _loc6_ == 3 || _loc6_ == 2;
         }
         if(_loc5_ == 2)
         {
            if(_loc6_ > 2)
            {
               return false;
            }
            if(_loc6_ == 1 && param2.profile > param1.profile + 5)
            {
               return false;
            }
         }
         if(_loc5_ == 1 && _loc6_ == 0)
         {
            if(getPlayerRatingValue(param3) > param1.profile + 4)
            {
               return false;
            }
         }
         if(_loc5_ == 0)
         {
            if(_loc6_ == 0 && param2.profile > param1.profile && isStartingXI(param2,param3))
            {
               return false;
            }
            if(param2.profile > param1.profile + 10 && getPlayerRatingValue(param3) > param1.profile + 2)
            {
               return false;
            }
            if(isEliteClub(param1) && isEliteClub(param2))
            {
               return Math.random() < ELITE_TRANSFER_CHANCE;
            }
         }
         if(param2.profile > param1.profile + 20 && getPlayerRatingValue(param3) > param1.profile)
         {
            return false;
         }
         return true;
      }

      private static function getClubTier(param1:Club) : int
      {
         var _loc2_:int = getClubLeagueIndex(param1);
         if(_loc2_ >= 0 && _loc2_ <= 3)
         {
            return _loc2_;
         }
         return 0;
      }

      private static function getClubLeagueIndex(param1:Club) : int
      {
         var _loc2_:int = 0;
         while(_loc2_ < Main.currentGame.leagues.length)
         {
            if(Main.currentGame.leagues[_loc2_].getCompetitionInfo(param1))
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }

      private static function isEliteClub(param1:Club) : Boolean
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:int = getClubLeagueIndex(param1);
         if(_loc6_ < 0)
         {
            return false;
         }
         if(param1.profile < ELITE_PROFILE)
         {
            return false;
         }
         _loc2_ = Main.currentGame.leagues[_loc6_].entrants.concat();
         _loc2_.sort(function(a:Object, b:Object) : Number
         {
            return b.club.profile - a.club.profile;
         });
         _loc5_ = _loc2_.slice(0,4);
         _loc3_ = 0;
         while(_loc3_ < _loc5_.length)
         {
            if(_loc5_[_loc3_].club == param1)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }

      private static function getPlayerRatingValue(param1:Player) : Number
      {
         if(param1.playerRating > 0)
         {
            return param1.playerRating;
         }
         return PlayerHelper.getPlayerScore(param1);
      }

      private static function canAffordTransfer(param1:Club, param2:int) : Boolean
      {
         var _loc3_:int = getClubBudgetValue(param1);
         if(_loc3_ <= 0)
         {
            return false;
         }
         return param2 <= _loc3_;
      }

      private static function getClubBudgetValue(param1:Club) : int
      {
         var _loc2_:String = "";
         var _loc3_:int = getClubLeagueIndex(param1);
         if(_loc3_ >= 0 && _loc3_ < Main.currentGame.leagues.length && Main.currentGame.leagues[_loc3_])
         {
            _loc2_ = Main.currentGame.leagues[_loc3_].name;
         }
         var _loc4_:int = TransferBudgetHelper.getBudget(_loc2_,param1.name);
         if(_loc4_ <= 0)
         {
            _loc4_ = TransferBudgetHelper.getBudget(_loc2_,param1.shortName);
         }
         return _loc4_;
      }

      private static function getPlayerStars(param1:Player) : int
      {
         var _loc2_:Number = getPlayerRatingValue(param1);
         return Math.ceil(Math.min(Math.max(1,_loc2_ - 40),60) / 50 * 10);
      }

      private static function isStartingXI(param1:Club, param2:Player) : Boolean
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Player = null;
         var _loc6_:Array = [];
         if(!param1 || !param2)
         {
            return false;
         }
         _loc3_ = param1.players;
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = StaticInfo.getPlayer(_loc3_[_loc4_]);
            if(_loc5_)
            {
               _loc6_.push({
                  "player":_loc5_,
                  "rating":getPlayerRatingValue(_loc5_)
               });
            }
            _loc4_++;
         }
         if(_loc6_.length == 0)
         {
            return false;
         }
         _loc6_.sortOn("rating",Array.NUMERIC | Array.DESCENDING);
         _loc4_ = 0;
         while(_loc4_ < Math.min(11,_loc6_.length))
         {
            if(_loc6_[_loc4_].player == param2)
            {
               return true;
            }
            _loc4_++;
         }
         return false;
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
         var _loc2_:int = getMappedValue(param1);
         if(_loc2_ > 0)
         {
            return _loc2_;
         }
         var _loc3_:Number = param1.playerRating > 0 ? param1.playerRating / 110 : PlayerHelper.getPlayerScore(param1) / 110;
         var _loc4_:int = PlayerHelper.getMaxAge(param1.basePostition);
         var _loc5_:int = _loc4_ - Player.MIN_AGE;
         _loc3_ = _loc3_ * 0.9 + _loc3_ * 0.1 * (_loc5_ - (param1.age - Player.MIN_AGE)) / _loc5_;
         return Math.pow(21350,1 + _loc3_);
   }

      private static function getMappedValue(param1:Player) : int
      {
         if(!param1)
         {
            return 0;
         }
        if(!valueMap)
        {
           buildValueMap();
        }
        if(!valueMap)
        {
           return 0;
        }
        var _loc1_:int = Math.round(param1.playerRating > 0 ? param1.playerRating : PlayerHelper.getPlayerScore(param1));
        var _loc2_:Number = PlayerHelper.getPlayerScoreFromStats(param1,PlayerHelper.getPlayerMaxStats(param1));
        var _loc3_:int = Math.round(_loc2_);
        var _loc4_:int = int(param1.age);
        if(minGameOverall > 0)
        {
           _loc1_ = Math.max(minGameOverall,Math.min(maxGameOverall,_loc1_));
        }
        if(minGamePotential > 0)
        {
           _loc3_ = Math.max(minGamePotential,Math.min(maxGamePotential,_loc3_));
        }
        if(minAge > 0)
        {
           _loc4_ = Math.max(minAge,Math.min(maxAge,_loc4_));
        }
        var _loc5_:String = getMappedPrimaryPos(param1);
        var _loc6_:String = _loc5_ + "|" + _loc1_ + "|" + _loc3_ + "|" + _loc4_;
        if(valueMap.hasOwnProperty(_loc6_))
        {
           return int(valueMap[_loc6_]);
        }
        return getNearestMappedValue(_loc5_,_loc1_,_loc3_,_loc4_);
      }

      private static function getNearestMappedValue(param1:String, param2:int, param3:int, param4:int) : int
      {
         var _loc5_:Object = null;
         var _loc6_:Number = Number.MAX_VALUE;
         if(!valueMapList)
         {
            return 0;
         }
         for each(var _loc7_:Object in valueMapList)
         {
            if(_loc7_.pos != param1)
            {
               continue;
            }
            var _loc8_:Number = Math.abs(_loc7_.overall - param2) * 3 + Math.abs(_loc7_.potential - param3) * 2 + Math.abs(_loc7_.age - param4);
            if(_loc8_ < _loc6_)
            {
               _loc6_ = _loc8_;
               _loc5_ = _loc7_;
            }
         }
         if(_loc5_)
         {
            return int(_loc5_.value);
         }
         return 0;
      }

      private static function getMappedPrimaryPos(param1:Player) : String
      {
         var _loc1_:String = param1.positions ? param1.positions.split("-")[0] : "";
         switch(_loc1_)
         {
            case "gk":
               return "GK";
            case "cb":
               return "CB";
            case "fb":
            case "wb":
               return "RB";
            case "dm":
               return "CDM";
            case "cm":
               return "CM";
            case "sm":
               return "RM";
            case "am":
               return "CAM";
            case "cf":
               return "ST";
            case "wf":
               return "RW";
         }
         return "CM";
      }

      private static function buildValueMap() : void
      {
         var _loc1_:ByteArray = new ValueMapData() as ByteArray;
         if(!_loc1_)
         {
            return;
         }
         var _loc2_:String = _loc1_.readUTFBytes(_loc1_.length);
         var _loc3_:Array = _loc2_.split(/\r?\n/);
         if(_loc3_.length <= 1)
         {
            return;
         }
         valueMap = {};
         valueMapList = [];
         minGameOverall = 0;
         maxGameOverall = 0;
         minGamePotential = 0;
         maxGamePotential = 0;
         minAge = 0;
         maxAge = 0;
         var _loc4_:Array = String(_loc3_[0]).split(",");
         var _loc5_:Object = {};
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_.length)
         {
            _loc5_[_loc4_[_loc6_]] = _loc6_;
            _loc6_++;
         }
         var _loc7_:int = 1;
         while(_loc7_ < _loc3_.length)
         {
            if(String(_loc3_[_loc7_]).length == 0)
            {
               _loc7_++;
               continue;
            }
            var _loc8_:Array = String(_loc3_[_loc7_]).split(",");
            var _loc9_:String = _loc8_[_loc5_["primary_pos"]];
            var _loc10_:Number = Number(_loc8_[_loc5_["game_overall_bin"]]);
            var _loc11_:Number = Number(_loc8_[_loc5_["game_potential_bin"]]);
            if(isNaN(_loc10_))
            {
               _loc10_ = Number(_loc8_[_loc5_["overall_bin"]]);
            }
            if(isNaN(_loc11_))
            {
               _loc11_ = Number(_loc8_[_loc5_["potential_bin"]]);
            }
            var _loc12_:int = int(Number(_loc8_[_loc5_["age_bin"]]));
            var _loc13_:Number = Number(_loc8_[_loc5_["value_eur"]]);
            var _loc14_:int = Math.round(_loc10_);
            var _loc15_:int = Math.round(_loc11_);
            var _loc16_:int = convertEurToPoundsRounded(_loc13_);
            var _loc17_:String = _loc9_ + "|" + _loc14_ + "|" + _loc15_ + "|" + _loc12_;
            valueMap[_loc17_] = _loc16_;
            valueMapList.push({
               "pos":_loc9_,
               "overall":_loc14_,
               "potential":_loc15_,
               "age":_loc12_,
               "value":_loc16_
            });
            if(minGameOverall == 0 || _loc14_ < minGameOverall)
            {
               minGameOverall = _loc14_;
            }
            if(maxGameOverall == 0 || _loc14_ > maxGameOverall)
            {
               maxGameOverall = _loc14_;
            }
            if(minGamePotential == 0 || _loc15_ < minGamePotential)
            {
               minGamePotential = _loc15_;
            }
            if(maxGamePotential == 0 || _loc15_ > maxGamePotential)
            {
               maxGamePotential = _loc15_;
            }
            if(minAge == 0 || _loc12_ < minAge)
            {
               minAge = _loc12_;
            }
            if(maxAge == 0 || _loc12_ > maxAge)
            {
               maxAge = _loc12_;
            }
            _loc7_++;
         }
      }

      private static function convertEurToPoundsRounded(param1:Number) : int
      {
         var _loc2_:Number = param1 * 0.87;
         if(_loc2_ < 1000000)
         {
            return Math.round(_loc2_ / 10000) * 10000;
         }
         return Math.round(_loc2_ / 100000) * 100000;
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
               recordTransfer(_loc3_,_loc3_.club,_loc1_.playerClub,_loc2_.cashOff);
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

      public static function recordTransfer(param1:Player, param2:Club, param3:Club, param4:int) : void
      {
         if(!Main.currentGame.transferHistory)
         {
            Main.currentGame.transferHistory = [];
         }
         Main.currentGame.transferHistory.push({
            "player":param1.name,
            "fromClub":param2 ? param2.name : "Free Agent",
            "toClub":param3 ? param3.name : "",
            "fee":param4,
            "season":Main.currentGame.seasonNum,
            "week":Main.currentGame.weekNum
         });
      }
   }
}

