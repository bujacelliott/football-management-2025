package com.utterlySuperb.chumpManager.engine
{
   import com.greensock.TweenLite;
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.Club;
   import com.utterlySuperb.chumpManager.model.dataObjects.Formation;
   import com.utterlySuperb.chumpManager.model.dataObjects.Game;
   import com.utterlySuperb.chumpManager.model.dataObjects.Player;
   import com.utterlySuperb.chumpManager.model.dataObjects.StaticInfo;
   import com.utterlySuperb.events.BudgetEventProxy;
   
   public class TeamHelper
   {
      
      private static var playerUpdated:int;
      
      public static const FORM_PERC:Number = 0.25;
      
      public static const STAMINA_PERC:Number = 0.25;
      
      public static const NON_FORM_PERC:Number = 0.5;
      
      public static const NON_STAM_PERC:Number = 0.75;
      
      public static const FINISH_TEAM_UPDATE:String = "finishTeamUpdate";
      
      public function TeamHelper()
      {
         super();
      }
      
      public static function checkRetirePlayers(param1:Game) : void
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Player = null;
         var _loc6_:Array = null;
         if(Main.currentGame.seasonNum == 0)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.leagues.length)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.leagues[_loc2_].entrants.length)
            {
               if(param1.leagues[_loc2_].entrants[_loc3_].club.isCore)
               {
                  for each(_loc4_ in param1.leagues[_loc2_].entrants[_loc3_].club.players)
                  {
                     _loc5_ = StaticInfo.getPlayer(_loc4_);
                     _loc5_.setAgeOffset();
                     _loc5_.setAge();
                     if(Main.currentGame.seasonNum > 0 && (_loc5_.age > PlayerHelper.getMaxAge(_loc5_.basePostition) || _loc5_.retireFlag))
                     {
                        param1.leagues[_loc2_].entrants[_loc3_].club.removePlayer(_loc4_);
                        param1.savedPlayers.removePlayerById(_loc4_);
                        _loc5_.active = false;
                        if(_loc5_.club)
                        {
                           _loc5_.club.removePlayer(_loc5_.id);
                           if(_loc5_.club == param1.playerClub)
                           {
                              Main.currentGame.addMessage(CopyManager.getCopy("playerRetires"),CopyManager.getCopy("playerRetiresCopy").replace("{playerName}",_loc5_.name));
                           }
                           _loc5_.club = null;
                        }
                        _loc5_.retireFlag = false;
                     }
                  }
               }
               _loc3_++;
            }
            _loc2_++;
         }
         if(Main.currentGame.seasonNum > 0)
         {
            _loc6_ = StaticInfo.getPlayerList();
            for each(_loc5_ in _loc6_)
            {
               if(!_loc5_.active)
               {
                  _loc5_.setAgeOffset();
                  PlayerHelper.updatePlayer(_loc5_,true);
                  if(_loc5_.age >= 16 && _loc5_.age < 20)
                  {
                     _loc5_.reset();
                     _loc5_.active = true;
                  }
               }
               _loc5_.setAgeOffset();
            }
         }
      }
      
      public static function getPlayerValue(param1:Player) : int
      {
         return TransfersEngine.getExpectedTransferFee(param1);
      }
      
      public static function getBestPlayers(param1:Formation, param2:Array, param3:Boolean = true) : Array
      {
         var _loc5_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         var _loc11_:int = 0;
         var _loc12_:String = null;
         var _loc13_:Player = null;
         var _loc4_:Array = new Array();
         _loc4_[0] = getBestPlayerInPosition(param2,"gk",param3);
         if(_loc4_[0] == null)
         {
            _loc4_[0] = PlayerHelper.getYouthPlayer("gk");
         }
         var _loc6_:Number = 0;
         var _loc7_:Number = 0;
         var _loc8_:int = 0;
         while(_loc8_ < 20)
         {
            _loc6_ = 0;
            _loc9_ = param2.slice();
            _loc10_ = new Array(10);
            _loc11_ = 0;
            while(_loc11_ < 10)
            {
               _loc12_ = param1.positionTypes[1 + (_loc8_ + _loc11_) % 10];
               _loc13_ = getBestPlayerInPosition(_loc9_,_loc12_,param3);
               if(_loc13_ == null)
               {
                  _loc13_ = PlayerHelper.getYouthPlayer(_loc12_);
               }
               else
               {
                  _loc9_.splice(_loc9_.indexOf(_loc13_),1);
               }
               _loc10_[(_loc8_ + _loc11_) % 10] = _loc13_;
               _loc6_ += getPlayerScoreInPosition(_loc13_,_loc12_,param3);
               _loc11_++;
            }
            if(_loc6_ > _loc7_)
            {
               _loc7_ = _loc6_;
               _loc5_ = _loc10_;
            }
            _loc8_++;
         }
         _loc8_ = 0;
         while(_loc8_ < _loc5_.length)
         {
            _loc4_[_loc8_ + 1] = _loc5_[_loc8_];
            _loc8_++;
         }
         getSubstitutes(_loc4_,param2,param3);
         return _loc4_;
      }
      
      public static function getSubstitutes(param1:Array, param2:Array, param3:Boolean) : Array
      {
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         var _loc9_:Player = null;
         var _loc10_:int = 0;
         var _loc11_:Number = NaN;
         var _loc12_:String = null;
         var _loc4_:Array = new Array();
         var _loc5_:int = 0;
         while(_loc5_ < param2.length)
         {
            if(param1.indexOf(param2[_loc5_]) < 0 && _loc4_.indexOf(param2[_loc5_]) < 0 && !(param3 && !param2[_loc5_].canPlay))
            {
               _loc4_.push(param2[_loc5_]);
            }
            _loc5_++;
         }
         if(!subOk(11,param1,param3))
         {
            param1[11] = getBestPlayerInPosition(_loc4_,"gk",param3);
            if(!param1[11])
            {
               param1[11] = PlayerHelper.getYouthPlayer("gk");
            }
         }
         var _loc6_:int = 12;
         _loc5_ = 1;
         while(_loc5_ < Player.BASE_POSITIONS.length)
         {
            _loc7_ = 0;
            while(_loc7_ < 2)
            {
               if(!subOk(_loc6_,param1,param3))
               {
                  _loc8_ = 0;
                  _loc9_ = null;
                  _loc10_ = 0;
                  while(_loc10_ < _loc4_.length)
                  {
                     _loc11_ = PlayerHelper.getBasePlayerScore(_loc4_[_loc10_],Player.BASE_POSITIONS[_loc5_]);
                     if(param3)
                     {
                        _loc11_ = _loc11_ * NON_STAM_PERC + _loc4_[_loc10_].stamina / _loc4_[_loc10_].maxStamina * _loc11_ * STAMINA_PERC;
                     }
                     if(_loc11_ > _loc8_)
                     {
                        _loc8_ = _loc11_;
                        _loc9_ = _loc4_[_loc10_];
                     }
                     _loc10_++;
                  }
                  if(_loc9_)
                  {
                     param1[_loc6_] = _loc9_;
                     _loc4_.splice(_loc4_.indexOf(_loc9_),1);
                  }
                  else
                  {
                     if(_loc5_ < 2)
                     {
                        _loc12_ = "cb-fb";
                     }
                     else if(_loc5_ < 4)
                     {
                        _loc12_ = "cm-sm";
                     }
                     else
                     {
                        _loc12_ = "cf";
                     }
                     param1[_loc6_] = PlayerHelper.getYouthPlayer(_loc12_);
                  }
               }
               _loc6_++;
               _loc7_++;
            }
            _loc5_++;
         }
         return param1;
      }
      
      private static function subOk(param1:int, param2:Array, param3:Boolean) : Boolean
      {
         if(param1 >= param2.length)
         {
            return false;
         }
         var _loc4_:Player = param2[param1];
         if(_loc4_ == null)
         {
            return false;
         }
         if(param2.indexOf(_loc4_) >= 0 && param2.indexOf(_loc4_) < 11)
         {
            return false;
         }
         if(param3 && !_loc4_.canPlay)
         {
            return false;
         }
         return true;
      }
      
      public static function regrowStamina(param1:Game) : void
      {
         var _loc3_:Player = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.playerClub.players.length)
         {
            _loc3_ = StaticInfo.getPlayer(param1.playerClub.players[_loc2_]);
            _loc3_.stamina += 8 + Math.sqrt(_loc3_.fitness) * 1.5;
            _loc3_.stamina = Math.min(_loc3_.stamina,_loc3_.maxStamina);
            _loc2_++;
         }
      }
      
      public static function newSeason(param1:Game) : void
      {
         var _loc3_:Player = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.playerClub.players.length)
         {
            _loc3_ = StaticInfo.getPlayer(param1.playerClub.players[_loc2_]);
            _loc3_.newSeason();
            _loc2_++;
         }
      }
      
      public static function doTraining(param1:Game) : void
      {
         checkInjuriess(param1.playerClub);
         var _loc2_:int = 0;
         while(_loc2_ < param1.playerClub.players.length)
         {
            PlayerHelper.applyTraining(StaticInfo.getPlayer(param1.playerClub.players[_loc2_]));
            _loc2_++;
         }
      }
      
      public static function doTeamStaminaHit(param1:Array) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc2_:int = 90 * 60;
         var _loc3_:Number = MatchEngine.ACTION_INT / _loc2_;
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            if(param1[_loc4_].canPlay())
            {
               _loc5_ = 30 + 30 * (100 - param1[_loc4_].player.fitness) / 100;
               _loc6_ = _loc5_ * _loc3_;
               param1[_loc4_].player.stamina = Math.max(0,param1[_loc4_].player.stamina - _loc6_);
            }
            _loc4_++;
         }
      }
      
      public static function makeClub(param1:XML) : Club
      {
         var _loc4_:XML = null;
         var _loc5_:Player = null;
         var _loc2_:Club = new Club();
         _loc2_.makeClub();
         _loc2_.name = param1..name.text();
         _loc2_.shortName = param1..shortName.text() ? param1..shortName.text() : "";
         _loc2_.profile = int(param1..profile.text());
         _loc2_.shirtColor = Number(param1..@shirtColor);
         _loc2_.sleevesColor = Number(param1..@sleevesColor);
         _loc2_.stripesType = param1..@stripesType;
         _loc2_.scoreMultiplier = int(param1..@scoreMultiplier);
         _loc2_.attackScore = param1..@attackScore;
         _loc2_.defendScore = param1..@defendScore;
         if(_loc2_.stripesType != "none")
         {
            _loc2_.stripesColor = Number(param1..@stripesColor);
         }
         var _loc3_:int = 0;
         while(_loc3_ < param1..players.player.length())
         {
            _loc4_ = param1..players.player[_loc3_];
            _loc5_ = PlayerHelper.makePlayer(_loc4_);
            _loc5_.club = _loc2_;
            _loc2_.addPlayer(_loc5_.id);
            _loc3_++;
         }
         // Derive reputation from the current squad instead of the XML seed: average of the best XI,
         // plus optional silverware weighting (starts at 0 for a new game).
         var _loc6_:Number = calculateClubProfile(_loc2_,0,0);
         if(!isNaN(_loc6_))
         {
            _loc2_.profile = _loc6_;
         }
         // Replace legacy letter grades with live star numbers based on current squad.
         var _loc7_:Object = getUnitStarBreakdown(_loc2_);
         _loc2_.attackScore = _loc7_.forwards.toString();
         _loc2_.defendScore = _loc7_.defence.toString();
         return _loc2_;
      }

      public static function getUnitStarBreakdown(param1:Club) : Object
      {
         var _loc5_:Player = null;
         var _loc9_:Array = null;
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         var _loc4_:Array = [];
         var _loc6_:Array = param1.players ? param1.players.concat() : [];
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_.length)
         {
            _loc5_ = StaticInfo.getPlayer(_loc6_[_loc7_]);
            if(_loc5_)
            {
               _loc9_ = _loc5_.positions.split("-");
               if(_loc5_.positions.indexOf("gk") >= 0)
               {
                  _loc4_.push(_loc5_);
               }
               else
               {
                  if(_loc5_.positions.indexOf("cb") >= 0)
                  {
                     _loc4_.push(_loc5_);
                  }
                  if(_loc5_.positions.indexOf("fb") >= 0 || _loc5_.positions.indexOf("wb") >= 0)
                  {
                     _loc4_.push(_loc5_);
                  }
                  if(_loc5_.positions.indexOf("cm") >= 0 || _loc5_.positions.indexOf("dm") >= 0 || _loc5_.positions.indexOf("sm") >= 0)
                  {
                     _loc3_.push(_loc5_);
                  }
                  if(_loc5_.positions.indexOf("cf") >= 0 || _loc5_.positions.indexOf("wf") >= 0 || _loc5_.positions.indexOf("am") >= 0)
                  {
                     _loc2_.push(_loc5_);
                  }
               }
            }
            _loc7_++;
         }
         var _loc8_:Object = {};
         _loc8_.forwards = getAverageStars(_loc2_,3);
         _loc8_.midfield = getAverageStars(_loc3_,3);
         _loc8_.defence = getAverageStarsDefence(_loc4_);
         return _loc8_;
      }

      private static function getAverageStars(param1:Array, param2:int) : Number
      {
         param1.sortOn("playerStars",Array.NUMERIC | Array.DESCENDING);
         var _loc3_:int = Math.min(param2,param1.length);
         if(_loc3_ == 0)
         {
            return 0;
         }
         var _loc4_:Number = 0;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ += param1[_loc5_].playerStars;
            _loc5_++;
         }
         return Math.round(_loc4_ / _loc3_ * 10) / 10;
      }

      private static function getAverageStarsDefence(param1:Array) : Number
      {
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         var _loc4_:Array = [];
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            if(param1[_loc5_].positions.indexOf("gk") >= 0)
            {
               _loc2_.push(param1[_loc5_]);
            }
            else if(param1[_loc5_].positions.indexOf("cb") >= 0)
            {
               _loc3_.push(param1[_loc5_]);
            }
            else if(param1[_loc5_].positions.indexOf("fb") >= 0 || param1[_loc5_].positions.indexOf("wb") >= 0)
            {
               _loc4_.push(param1[_loc5_]);
            }
            _loc5_++;
         }
         var _loc6_:Number = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         _loc2_.sortOn("playerStars",Array.NUMERIC | Array.DESCENDING);
         _loc3_.sortOn("playerStars",Array.NUMERIC | Array.DESCENDING);
         _loc4_.sortOn("playerStars",Array.NUMERIC | Array.DESCENDING);
         var _loc9_:Array = [];
         if(_loc2_.length > 0)
         {
            _loc9_.push(_loc2_[0]);
         }
         while(_loc7_ < Math.min(2,_loc3_.length))
         {
            _loc9_.push(_loc3_[_loc7_]);
            _loc7_++;
         }
         while(_loc8_ < Math.min(2,_loc4_.length))
         {
            _loc9_.push(_loc4_[_loc8_]);
            _loc8_++;
         }
         if(_loc9_.length == 0)
         {
            return 0;
         }
         _loc6_ = 0;
         _loc7_ = 0;
         while(_loc7_ < _loc9_.length)
         {
            _loc6_ += _loc9_[_loc7_].playerStars;
            _loc7_++;
         }
         return Math.round(_loc6_ / _loc9_.length * 10) / 10;
      }

      public static function calculateClubProfile(param1:Club, param2:int = 0, param3:int = 0) : Number
      {
         var _loc7_:Player = null;
         var _loc4_:Array = [];
         var _loc5_:int = 0;
         while(_loc5_ < param1.players.length)
         {
            _loc7_ = StaticInfo.getPlayer(param1.players[_loc5_]);
            if(_loc7_)
            {
               _loc4_.push(_loc7_);
            }
            _loc5_++;
         }
         if(_loc4_.length == 0)
         {
            return NaN;
         }
         _loc4_.sortOn("playerRating",Array.NUMERIC | Array.DESCENDING);
         var _loc6_:int = Math.min(11,_loc4_.length);
         var _loc8_:Number = 0;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc8_ += _loc4_[_loc5_].playerRating;
            _loc5_++;
         }
         var _loc9_:Number = _loc8_ / _loc6_;
         var _loc10_:Number = _loc9_ + param3 * 3 + param2 * 2;
         return Math.max(1,Math.min(100,Math.round(_loc10_)));
      }
      
      public static function getBestPlayerInPosition(param1:Array, param2:String, param3:Boolean) : Player
      {
         var _loc5_:Player = null;
         var _loc8_:Number = NaN;
         var _loc9_:String = null;
         var _loc10_:Number = NaN;
         var _loc4_:Array = getPositionMultipliers(param2);
         var _loc6_:Number = 0;
         var _loc7_:int = 0;
         while(_loc7_ < param1.length)
         {
            _loc8_ = 0;
            for(_loc9_ in _loc4_)
            {
               if(param1[_loc7_].positions.indexOf(_loc9_) >= 0)
               {
                  _loc8_ = Math.max(_loc8_,_loc4_[_loc9_]);
               }
               else if(!param1[_loc7_].positions == "gk" && !param2 == "gk")
               {
                  _loc8_ += 0.01;
               }
            }
            _loc10_ = _loc8_ * PlayerHelper.getSpecificPositionScore(param1[_loc7_],param2);
            if(param3)
            {
               _loc10_ = _loc10_ * NON_STAM_PERC + _loc10_ * STAMINA_PERC * param1[_loc7_].stamina / param1[_loc7_].maxStamina;
               if(Boolean(param1[_loc7_].hasInjury()) || Boolean(param1[_loc7_].hasSuspension()))
               {
                  _loc10_ = 0;
               }
            }
            if(_loc10_ > _loc6_ && !(param3 && !param1[_loc7_].canPlay))
            {
               _loc6_ = _loc10_;
               _loc5_ = param1[_loc7_];
            }
            _loc7_++;
         }
         return _loc5_;
      }
      
      private static function getPlayerScoreInPosition(param1:Player, param2:String, param3:Boolean = true) : Number
      {
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         var _loc6_:Array = getPositionMultipliers(param2);
         var _loc7_:Array = param1.positions.split("-");
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_.length)
         {
            if(_loc6_[_loc7_[_loc8_]])
            {
               _loc5_ = Math.max(_loc5_,_loc6_[_loc7_[_loc8_]]);
            }
            _loc8_++;
         }
         if(param3)
         {
            _loc5_ = _loc5_ * NON_STAM_PERC + _loc5_ * STAMINA_PERC * param1.stamina / param1.maxStamina;
         }
         return PlayerHelper.getSpecificPositionScore(param1,param2) * _loc5_;
      }
      
      private static function getPositionMultipliers(param1:String) : Array
      {
         var _loc2_:Array = [];
         _loc2_["cb"] = 0.1;
         _loc2_["fb"] = 0.1;
         _loc2_["wb"] = 0.1;
         _loc2_["dm"] = 0.4;
         _loc2_["am"] = 0.3;
         _loc2_["sm"] = 0.1;
         _loc2_["cm"] = 0.1;
         _loc2_["wf"] = 0.1;
         _loc2_["cf"] = 0.1;
         switch(param1)
         {
            case "gk":
               _loc2_["gk"] = 1;
               break;
            case "cb":
               _loc2_["cb"] = 1;
               _loc2_["fb"] = 0.3;
               _loc2_["dm"] = 0.4;
               _loc2_["wb"] = 0.3;
               _loc2_["wb"] = 0.3;
               break;
            case "fb":
               _loc2_["fb"] = 1;
               _loc2_["cb"] = 0.4;
               _loc2_["sm"] = 0.4;
               _loc2_["wb"] = 0.7;
               break;
            case "wb":
               _loc2_["wb"] = 1;
               _loc2_["fb"] = 0.7;
               _loc2_["sm"] = 0.5;
               _loc2_["cb"] = 0.3;
               _loc2_["wf"] = 0.3;
               break;
            case "dm":
               _loc2_["dm"] = 1;
               _loc2_["cm"] = 0.7;
               _loc2_["am"] = 0.5;
               _loc2_["fb"] = 0.5;
               _loc2_["cb"] = 0.6;
               break;
            case "cm":
               _loc2_["cm"] = 1;
               _loc2_["dm"] = 0.7;
               _loc2_["am"] = 0.7;
               _loc2_["sm"] = 0.5;
               break;
            case "am":
               _loc2_["am"] = 1;
               _loc2_["cm"] = 0.7;
               _loc2_["dm"] = 0.4;
               _loc2_["wf"] = 0.5;
               _loc2_["sm"] = 0.6;
               _loc2_["cf"] = 0.6;
               break;
            case "sm":
               _loc2_["sm"] = 1;
               _loc2_["fb"] = 0.6;
               _loc2_["wf"] = 0.7;
               _loc2_["wb"] = 0.7;
               _loc2_["cm"] = 0.4;
               _loc2_["am"] = 0.4;
               break;
            case "wf":
               _loc2_["wf"] = 1;
               _loc2_["sm"] = 0.8;
               _loc2_["am"] = 0.7;
               _loc2_["wb"] = 0.5;
               _loc2_["fb"] = 0.3;
               _loc2_["cf"] = 0.8;
               break;
            case "cf":
               _loc2_["cf"] = 1;
               _loc2_["wf"] = 0.75;
               _loc2_["am"] = 0.75;
               _loc2_["sm"] = 0.5;
               _loc2_["am"] = 0.5;
               _loc2_["dm"] = 0.4;
         }
         return _loc2_;
      }
      
      public static function getAttckingScore(param1:Array, param2:Formation, param3:Boolean = true) : Number
      {
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc4_:Number = 0;
         if(param3)
         {
            _loc5_ = 0;
            while(_loc5_ < 11)
            {
               _loc6_ = getPlayerAttackingScoreMatch(param1[_loc5_],param2.positionTypes[_loc5_]);
               _loc4_ += _loc6_;
               _loc5_++;
            }
         }
         else
         {
            _loc5_ = 0;
            while(_loc5_ < 11)
            {
               _loc6_ = getPlayerAttackingScore(param1[_loc5_],param2.positionTypes[_loc5_]);
               _loc4_ += _loc6_;
               _loc5_++;
            }
         }
         return _loc4_;
      }
      
      public static function getDefendingScore(param1:Array, param2:Formation, param3:Boolean = true) : Number
      {
         var _loc5_:int = 0;
         var _loc4_:Number = 0;
         if(param3)
         {
            _loc5_ = 0;
            while(_loc5_ < 11)
            {
               _loc4_ += getPlayerDefendingScoreMatch(param1[_loc5_],param2.positionTypes[_loc5_]);
               _loc5_++;
            }
         }
         else
         {
            _loc5_ = 0;
            while(_loc5_ < 11)
            {
               _loc4_ += getPlayerDefendingScore(param1[_loc5_],param2.positionTypes[_loc5_]);
               _loc5_++;
            }
         }
         return _loc4_;
      }
      
      private static function getPlayerAttackingScore(param1:Player, param2:String) : Number
      {
         if(param2 == "gk")
         {
            return param1.currentStats[Player.DISTRIBUTION];
         }
         var _loc3_:Number = 0;
         _loc3_ += param1.currentStats[Player.DRIBBLING] * 0.8;
         _loc3_ += param1.currentStats[Player.PASSING] * 0.8;
         _loc3_ += param1.currentStats[Player.SHOOTING] * 1.2;
         _loc3_ += param1.currentStats[Player.HEADING] * 0.5;
         _loc3_ += param1.currentStats[Player.CROSSING] * 0.7;
         _loc3_ += param1.currentStats[Player.SPEED] * 0.7;
         _loc3_ += param1.currentStats[Player.STRENGTH] * 0.7;
         _loc3_ += param1.currentStats[Player.CREATIVITY] * 1.2;
         _loc3_ += param1.currentStats[Player.MAX_STAMINA] * 0.4;
         _loc3_ += param1.currentStats[Player.FITNESS] * 0.4;
         return _loc3_ * getPositionAttackingFactor(param2);
      }
      
      private static function getPlayerDefendingScore(param1:Player, param2:String) : Number
      {
         if(param2 == "gk")
         {
            return (param1.currentStats[Player.CATCHING] + param1.currentStats[Player.SHOT_STOPPING] * 2) * 5;
         }
         var _loc3_:Number = 0;
         _loc3_ += param1.currentStats[Player.TACKLING] * 2;
         _loc3_ += param1.currentStats[Player.PASSING] * 0.7;
         _loc3_ += param1.currentStats[Player.HEADING] * 1.5;
         _loc3_ += param1.currentStats[Player.SPEED] * 0.7;
         _loc3_ += param1.currentStats[Player.STRENGTH] * 1;
         _loc3_ += param1.currentStats[Player.AGGRESSION] * 0.7;
         _loc3_ += param1.currentStats[Player.MAX_STAMINA] * 0.4;
         return _loc3_ + param1.currentStats[Player.FITNESS] * 0.4;
      }
      
      private static function getPlayerAttackingScoreMatch(param1:Player, param2:String) : Number
      {
         if(param2 == "gk")
         {
            return param1.distribution;
         }
         var _loc3_:Number = 0;
         _loc3_ += param1.dribbling * 0.8;
         _loc3_ += param1.passing * 0.8;
         _loc3_ += param1.shooting * 1.2;
         _loc3_ += param1.heading * 0.5;
         _loc3_ += param1.crossing * 0.7;
         _loc3_ += param1.speed * 0.7;
         _loc3_ += param1.strength * 0.7;
         _loc3_ += param1.creativity * 1.2;
         _loc3_ += param1.stamina * 0.4;
         _loc3_ += param1.fitness * 0.4;
         return _loc3_ * getPositionAttackingFactor(param2);
      }
      
      private static function getPlayerDefendingScoreMatch(param1:Player, param2:String) : Number
      {
         if(param2 == "gk")
         {
            return (param1.catching + param1.shotStopping * 2) * 5;
         }
         var _loc3_:Number = 0;
         _loc3_ += param1.tackling * 2;
         _loc3_ += param1.passing * 0.7;
         _loc3_ += param1.heading * 1.5;
         _loc3_ += param1.speed * 0.7;
         _loc3_ += param1.strength * 1;
         _loc3_ += param1.aggression * 0.7;
         _loc3_ += param1.stamina * 0.4;
         return _loc3_ + param1.fitness * 0.4;
      }
      
      private static function getPositionAttackingFactor(param1:String) : Number
      {
         switch(param1)
         {
            case "gk":
               return 0;
            case "cb":
               return 0.2;
            case "fb":
               return 0.3;
            case "wb":
               return 0.4;
            case "dm":
               return 0.4;
            case "cm":
               return 0.5;
            case "am":
               return 0.6;
            case "sm":
               return 0.5;
            case "wf":
               return 0.8;
            case "cf":
               return 0.9;
            default:
               return 0;
         }
      }
      
      private static function getPositionDefendingFactor(param1:String) : Number
      {
         switch(param1)
         {
            case "gk":
               return 2;
            case "cb":
               return 1;
            case "fb":
               return 0.9;
            case "wb":
               return 0.8;
            case "dm":
               return 0.75;
            case "cm":
               return 0.6;
            case "am":
               return 0.4;
            case "sm":
               return 0.5;
            case "wf":
               return 0.2;
            case "cf":
               return 0.1;
            default:
               return 0;
         }
      }
      
      public static function updateTeams() : void
      {
         playerUpdated = 0;
         updateTeam();
      }
      
      private static function updateTeam() : void
      {
         var _loc1_:Array = StaticInfo.getPlayerList();
         var _loc2_:int = playerUpdated;
         while(_loc2_ < Math.min(_loc1_.length,playerUpdated + 20))
         {
            if(!_loc1_[_loc2_].active || !_loc1_[_loc2_].club || Boolean(_loc1_[_loc2_].club.isCore))
            {
               updatePlayer(_loc1_[_loc2_]);
            }
            _loc2_++;
         }
         if(_loc2_ == _loc1_.length)
         {
            BudgetEventProxy.dispatchEvent(FINISH_TEAM_UPDATE,null);
         }
         else
         {
            playerUpdated = _loc2_;
            TweenLite.delayedCall(0.05,updateTeam);
         }
      }
      
      public static function updatePlayer(param1:Player, param2:Boolean = false) : void
      {
         PlayerHelper.updatePlayer(param1,param2);
         var _loc3_:int = 49 - int(Math.pow(Math.random() * Math.pow(50,4),0.25));
         param1.form = Math.random() > 0.5 ? 50 + _loc3_ : 50 - _loc3_;
         param1.playerRating = PlayerHelper.getPlayerScore(param1);
         if(param1.isKeeper())
         {
            param1.playerRating = Math.max(1,param1.playerRating - 5);
         }
         param1.playerStars = Math.ceil(Math.min(Math.max(1,param1.playerRating - 40),60) / 50 * 10);
         param1.transferValue = TransfersEngine.getExpectedTransferFee(param1);
         if(!param1.club || param1.club != Main.currentGame.playerClub)
         {
            param1.stamina = Math.max(param1.maxStamina - Math.random() * param1.maxStamina / 4,20);
         }
      }
      
      public static function checkSuspensions(param1:Club) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.players.length)
         {
            PlayerHelper.checkSuspension(StaticInfo.getPlayer(param1.players[_loc2_]));
            _loc2_++;
         }
      }
      
      public static function checkInjuriess(param1:Club) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.players.length)
         {
            PlayerHelper.checkInjuries(StaticInfo.getPlayer(param1.players[_loc2_]));
            _loc2_++;
         }
      }
   }
}

