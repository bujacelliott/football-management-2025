package com.utterlySuperb.chumpManager.engine
{
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.Game;
   import com.utterlySuperb.chumpManager.model.dataObjects.Message;
   import com.utterlySuperb.chumpManager.model.dataObjects.Player;
   import com.utterlySuperb.chumpManager.model.dataObjects.StaticInfo;
   import com.utterlySuperb.chumpManager.model.dataObjects.StatusEffect;
   
   public class PlayerHelper
   {
      
      public static const SIN_0:String = "sin0";
      
      public static const SIN_1:String = "sin1";
      
      public static const SIN_2:String = "sin2";
      
      public static const SIN_3:String = "sin3";
      
      public static const SIN_4:String = "sin4";
      
      public static const SIN_SLOW_DECAY_0:String = "sin_slow_decay";
      
      public function PlayerHelper()
      {
         super();
      }
      
      public static function makePlayer(param1:XML) : Player
      {
         var _loc9_:Array = null;
         var _loc2_:Player = new Player();
         _loc2_.name = param1.@name;
         _loc2_.id = param1.@id;
         _loc2_.positions = param1.@positions;
         _loc2_.basePostition = getMainPos(_loc2_);
         _loc2_.nationality = param1.@nationality;
         var _loc3_:Array = param1.@birthday.split("-");
         _loc2_.birthDay = new Date(int(_loc3_[2]),int(_loc3_[1]) - 1,int(_loc3_[0]));
         _loc2_.setAge();
         _loc2_.progressType = PlayerHelper.SIN_0;
         if(String(param1.@progressType).length > 0)
         {
            _loc2_.progressType = param1.@progressType;
         }
         // ageImprovement removed: use supplied current (CA) and potential (PA) stats directly.
         var _loc5_:Array = new Array();
         var _loc6_:Array = new Array();
         var _loc7_:int = 0;
         if(_loc2_.isKeeper())
         {
            _loc5_[0] = int(param1.stats.@catching);
            _loc5_[1] = int(param1.stats.@shotStopping);
            _loc5_[2] = int(param1.stats.@distribution);
            _loc5_[3] = int(param1.stats.@fitness);
            _loc5_[4] = int(param1.stats.@stamina);
            _loc6_[0] = param1.stats.attribute("paCatching").length() > 0 ? int(param1.stats.@paCatching) : _loc5_[0];
            _loc6_[1] = param1.stats.attribute("paShotStopping").length() > 0 ? int(param1.stats.@paShotStopping) : _loc5_[1];
            _loc6_[2] = param1.stats.attribute("paDistribution").length() > 0 ? int(param1.stats.@paDistribution) : _loc5_[2];
            _loc6_[3] = param1.stats.attribute("paFitness").length() > 0 ? int(param1.stats.@paFitness) : _loc5_[3];
            _loc6_[4] = param1.stats.attribute("paStamina").length() > 0 ? int(param1.stats.@paStamina) : _loc5_[4];
         }
         else
         {
            _loc5_[0] = int(param1.stats.@passing);
            _loc5_[1] = int(param1.stats.@tackling);
            _loc5_[2] = int(param1.stats.@heading);
            _loc5_[3] = int(param1.stats.@shooting);
            _loc5_[4] = int(param1.stats.@crossing);
            _loc5_[5] = int(param1.stats.@dribbling);
            _loc5_[6] = int(param1.stats.@speed);
            _loc5_[7] = int(param1.stats.@stamina);
            _loc5_[8] = int(param1.stats.@aggression);
            _loc5_[9] = int(param1.stats.@strength);
            _loc5_[10] = int(param1.stats.@fitness);
            _loc5_[11] = int(param1.stats.@creativity);
            _loc6_[0] = param1.stats.attribute("paPassing").length() > 0 ? int(param1.stats.@paPassing) : _loc5_[0];
            _loc6_[1] = param1.stats.attribute("paTackling").length() > 0 ? int(param1.stats.@paTackling) : _loc5_[1];
            _loc6_[2] = param1.stats.attribute("paHeading").length() > 0 ? int(param1.stats.@paHeading) : _loc5_[2];
            _loc6_[3] = param1.stats.attribute("paShooting").length() > 0 ? int(param1.stats.@paShooting) : _loc5_[3];
            _loc6_[4] = param1.stats.attribute("paCrossing").length() > 0 ? int(param1.stats.@paCrossing) : _loc5_[4];
            _loc6_[5] = param1.stats.attribute("paDribbling").length() > 0 ? int(param1.stats.@paDribbling) : _loc5_[5];
            _loc6_[6] = param1.stats.attribute("paSpeed").length() > 0 ? int(param1.stats.@paSpeed) : _loc5_[6];
            _loc6_[7] = param1.stats.attribute("paStamina").length() > 0 ? int(param1.stats.@paStamina) : _loc5_[7];
            _loc6_[8] = param1.stats.attribute("paAggression").length() > 0 ? int(param1.stats.@paAggression) : _loc5_[8];
            _loc6_[9] = param1.stats.attribute("paStrength").length() > 0 ? int(param1.stats.@paStrength) : _loc5_[9];
            _loc6_[10] = param1.stats.attribute("paFitness").length() > 0 ? int(param1.stats.@paFitness) : _loc5_[10];
            _loc6_[11] = param1.stats.attribute("paCreativity").length() > 0 ? int(param1.stats.@paCreativity) : _loc5_[11];
         }
         while(_loc7_ < _loc5_.length)
         {
            _loc2_.minStats[_loc7_] = _loc5_[_loc7_];
            _loc7_++;
         }
         _loc2_.maxStats = _loc6_;
         _loc2_.active = true;
         if(Main.currentGame.seasonNum > 0)
         {
            _loc2_.setAgeOffset();
         }
         TeamHelper.updatePlayer(_loc2_,true);
         StaticInfo.addPlayer(_loc2_);
         var _loc8_:int = 49 - int(Math.pow(Math.random() * Math.pow(50,4),0.25));
         _loc2_.form = Math.random() > 0.5 ? 50 + _loc8_ : 50 - _loc8_;
         _loc2_.squadNumber = int(param1.@number);
         switch(_loc2_.basePostition)
         {
            case Player.BASE_POSITIONS[0]:
               _loc2_.trainingType = Player.KEEPER_TRAINING;
               break;
            case Player.BASE_POSITIONS[1]:
               _loc2_.trainingType = Player.DEFENCE_TRAINING;
               break;
            case Player.BASE_POSITIONS[2]:
               _loc2_.trainingType = Player.MIDFIELD_TRAINING;
               break;
            case Player.BASE_POSITIONS[3]:
               _loc2_.trainingType = Player.FORWARD_TRAINING;
         }
         return _loc2_;
      }
      
      public static function makeLegend(param1:XML) : Player
      {
         var _loc2_:Player = new Player();
         _loc2_.name = param1.@name;
         _loc2_.id = param1.@id;
         _loc2_.positions = param1.@positions;
         _loc2_.basePostition = getMainPos(_loc2_);
         _loc2_.nationality = param1.@nationality;
         var _loc3_:Array = param1.@birthday.split("-");
         _loc2_.birthDay = new Date(int(_loc3_[2]),int(_loc3_[1]) - 1,int(_loc3_[0]));
         _loc2_.setAge();
         _loc2_.progressType = PlayerHelper.SIN_0;
         if(String(param1.@progressType).length > 0)
         {
            _loc2_.progressType = param1.@progressType;
         }
         // ageImprovement removed: use supplied current (CA) and potential (PA) stats directly.
         var _loc5_:Array = new Array();
         var _loc6_:Array = new Array();
         var _loc7_:int = 0;
         if(_loc2_.isKeeper())
         {
            _loc5_[0] = int(param1.stats.@catching);
            _loc5_[1] = int(param1.stats.@shotStopping);
            _loc5_[2] = int(param1.stats.@distribution);
            _loc5_[3] = int(param1.stats.@fitness);
            _loc5_[4] = int(param1.stats.@stamina);
            _loc6_[0] = param1.stats.attribute("paCatching").length() > 0 ? int(param1.stats.@paCatching) : _loc5_[0];
            _loc6_[1] = param1.stats.attribute("paShotStopping").length() > 0 ? int(param1.stats.@paShotStopping) : _loc5_[1];
            _loc6_[2] = param1.stats.attribute("paDistribution").length() > 0 ? int(param1.stats.@paDistribution) : _loc5_[2];
            _loc6_[3] = param1.stats.attribute("paFitness").length() > 0 ? int(param1.stats.@paFitness) : _loc5_[3];
            _loc6_[4] = param1.stats.attribute("paStamina").length() > 0 ? int(param1.stats.@paStamina) : _loc5_[4];
         }
         else
         {
            _loc5_[0] = int(param1.stats.@passing);
            _loc5_[1] = int(param1.stats.@tackling);
            _loc5_[2] = int(param1.stats.@heading);
            _loc5_[3] = int(param1.stats.@shooting);
            _loc5_[4] = int(param1.stats.@crossing);
            _loc5_[5] = int(param1.stats.@dribbling);
            _loc5_[6] = int(param1.stats.@speed);
            _loc5_[7] = int(param1.stats.@stamina);
            _loc5_[8] = int(param1.stats.@aggression);
            _loc5_[9] = int(param1.stats.@strength);
            _loc5_[10] = int(param1.stats.@fitness);
            _loc5_[11] = int(param1.stats.@creativity);
            _loc6_[0] = param1.stats.attribute("paPassing").length() > 0 ? int(param1.stats.@paPassing) : _loc5_[0];
            _loc6_[1] = param1.stats.attribute("paTackling").length() > 0 ? int(param1.stats.@paTackling) : _loc5_[1];
            _loc6_[2] = param1.stats.attribute("paHeading").length() > 0 ? int(param1.stats.@paHeading) : _loc5_[2];
            _loc6_[3] = param1.stats.attribute("paShooting").length() > 0 ? int(param1.stats.@paShooting) : _loc5_[3];
            _loc6_[4] = param1.stats.attribute("paCrossing").length() > 0 ? int(param1.stats.@paCrossing) : _loc5_[4];
            _loc6_[5] = param1.stats.attribute("paDribbling").length() > 0 ? int(param1.stats.@paDribbling) : _loc5_[5];
            _loc6_[6] = param1.stats.attribute("paSpeed").length() > 0 ? int(param1.stats.@paSpeed) : _loc5_[6];
            _loc6_[7] = param1.stats.attribute("paStamina").length() > 0 ? int(param1.stats.@paStamina) : _loc5_[7];
            _loc6_[8] = param1.stats.attribute("paAggression").length() > 0 ? int(param1.stats.@paAggression) : _loc5_[8];
            _loc6_[9] = param1.stats.attribute("paStrength").length() > 0 ? int(param1.stats.@paStrength) : _loc5_[9];
            _loc6_[10] = param1.stats.attribute("paFitness").length() > 0 ? int(param1.stats.@paFitness) : _loc5_[10];
            _loc6_[11] = param1.stats.attribute("paCreativity").length() > 0 ? int(param1.stats.@paCreativity) : _loc5_[11];
         }
         while(_loc7_ < _loc5_.length)
         {
            _loc2_.minStats[_loc7_] = _loc5_[_loc7_];
            _loc7_++;
         }
         _loc2_.maxStats = _loc6_;
         _loc2_.active = true;
         if(Main.currentGame.seasonNum > 0)
         {
            _loc2_.setAgeOffset();
         }
         TeamHelper.updatePlayer(_loc2_,true);
         StaticInfo.addPlayer(_loc2_);
         var _loc8_:int = 49 - int(Math.pow(Math.random() * Math.pow(50,4),0.25));
         _loc2_.form = Math.random() > 0.5 ? 50 + _loc8_ : 50 - _loc8_;
         _loc2_.squadNumber = int(param1.@number);
         switch(_loc2_.basePostition)
         {
            case Player.BASE_POSITIONS[0]:
               _loc2_.trainingType = Player.KEEPER_TRAINING;
               break;
            case Player.BASE_POSITIONS[1]:
               _loc2_.trainingType = Player.DEFENCE_TRAINING;
               break;
            case Player.BASE_POSITIONS[2]:
               _loc2_.trainingType = Player.MIDFIELD_TRAINING;
               break;
            case Player.BASE_POSITIONS[3]:
               _loc2_.trainingType = Player.FORWARD_TRAINING;
         }
         return _loc2_;
      }
      
      public static function getYouthPlayer(param1:String, param2:int = -1, param3:String = "") : Player
      {
         var cDate:Date;
         var maxStats:Array;
         var currentStats:Array;
         var j:int;
         var minMax:Array = null;
         var position:String = param1;
         var forceNum:int = param2;
         var forceID:String = param3;
         var makeStat:Function = function():int
         {
            return 30 + int(Math.random() * 40);
         };
         var player:Player = new Player();
         player.name = CopyManager.getCopy("youthPlayer");
         player.squadNumber = forceNum >= 0 ? forceNum : 50 + int(Math.random() * 50);
         player.id = forceID.length == 0 ? "youthPlayer" + int(Math.random() * 10000) + "_" + position + "_" + player.squadNumber : forceID;
         player.positions = position;
         player.basePostition = getMainPos(player);
         player.nationality = "en";
         cDate = Main.currentGame.getRoundDate();
         player.birthDay = new Date(cDate.getFullYear() - 16,cDate.getMonth() - 1,cDate.getDate());
         maxStats = new Array();
         currentStats = new Array();
         if(player.isKeeper())
         {
            currentStats[0] = makeStat();
            currentStats[1] = makeStat();
            currentStats[2] = makeStat();
            currentStats[3] = makeStat();
            currentStats[4] = makeStat();
         }
         else
         {
            currentStats[0] = makeStat();
            currentStats[1] = makeStat();
            currentStats[2] = makeStat();
            currentStats[3] = makeStat();
            currentStats[4] = makeStat();
            currentStats[5] = makeStat();
            currentStats[6] = makeStat();
            currentStats[7] = makeStat();
            currentStats[8] = makeStat();
            currentStats[9] = makeStat();
            currentStats[10] = makeStat();
            currentStats[11] = makeStat();
         }
         j = 0;
         while(j < currentStats.length)
         {
            minMax = getValues(player.progressType,currentStats[j],player.exactAge,40,getMaxAge(player.basePostition));
            player.minStats[j] = minMax[0];
            maxStats[j] = minMax[1];
            player.statAdditions[j] = 0;
            j++;
         }
         player.active = false;
         player.maxStats = maxStats;
         player.progressType = PlayerHelper.SIN_SLOW_DECAY_0;
         PlayerHelper.updatePlayer(player,true);
         StaticInfo.addYouthPlayer(player);
         player.stamina = player.maxStamina;
         player.form = 50 + Math.random() * 50;
         player.newSeason();
         return player;
      }
      
      public static function getMaxAge(param1:String) : int
      {
         var _loc2_:int = 40;
         switch(param1)
         {
            case Player.BASE_POSITIONS[0]:
               _loc2_ = 40;
               break;
            case Player.BASE_POSITIONS[1]:
               _loc2_ = 36;
               break;
            case Player.BASE_POSITIONS[2]:
               _loc2_ = 35;
               break;
            case Player.BASE_POSITIONS[3]:
               _loc2_ = 34;
         }
         return _loc2_;
      }
      
      public static function updatePlayer(param1:Player, param2:Boolean = false) : void
      {
         if(param2 || (!param1.club || param1.club.isCore) && param1.active)
         {
            setStats(param1);
         }
      }
      
      public static function checkInjuries(param1:Player) : void
      {
         var _loc3_:Message = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.statusEffects.length)
         {
            if(param1.statusEffects[_loc2_].type == StatusEffect.INJURY)
            {
               if(--param1.statusEffects[_loc2_].time <= 0)
               {
                  if(Main.currentGame.playerClub == param1.club)
                  {
                     _loc3_ = new Message();
                     _loc3_.title = CopyManager.getCopy("playerReturns");
                     _loc3_.body = CopyManager.getCopy("finishStatusEffect_" + param1.statusEffects[_loc2_].type).replace(CopyManager.PLAYER_NAME_REPLACE,param1.name);
                     Main.currentGame.userMessages.push(_loc3_);
                  }
                  param1.statusEffects.splice(_loc2_,1);
                  _loc2_--;
               }
            }
            _loc2_++;
         }
      }
      
      public static function checkSuspension(param1:Player) : void
      {
         var _loc3_:Message = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.statusEffects.length)
         {
            if(param1.statusEffects[_loc2_].type == StatusEffect.SUSPENSION)
            {
               if(--param1.statusEffects[_loc2_].time <= 0)
               {
                  if(Main.currentGame.playerClub == param1.club)
                  {
                     _loc3_ = new Message();
                     _loc3_.title = CopyManager.getCopy("playerReturns");
                     _loc3_.body = CopyManager.getCopy("finishStatusEffect_" + param1.statusEffects[_loc2_].type).replace(CopyManager.PLAYER_NAME_REPLACE,param1.name);
                     Main.currentGame.userMessages.push(_loc3_);
                  }
                  param1.statusEffects.splice(_loc2_,1);
                  _loc2_--;
               }
            }
            _loc2_++;
         }
      }
      
      public static function setStats(param1:Player) : void
      {
         var _loc2_:Game = Main.currentGame;
         param1.setAge();
         // On a fresh save (season 0), start at current ability (minStats). After that, follow the age curve.
         var _loc3_:Number = _loc2_.seasonNum == 0 ? 0 : getFactor(param1.progressType,param1.exactAge - Player.MIN_AGE,getMaxAge(param1.basePostition));
         var _loc4_:int = 0;
         while(_loc4_ < param1.minStats.length)
         {
            param1.currentStats[_loc4_] = Math.max(10,Math.min(100,param1.minStats[_loc4_] + _loc3_ * param1.statClimb[_loc4_] + param1.statAdditions[_loc4_]));
            _loc4_++;
         }
      }
      
      public static function getGraph(param1:Player) : Array
      {
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc2_:Game = Main.currentGame;
         var _loc3_:Date = _loc2_.currentDate;
         _loc2_.currentDate = new Date(2025,7,11);
         var _loc4_:Array = new Array();
         var _loc5_:Number = average(param1.minStats);
         var _loc6_:Number = average(param1.statClimb);
         var _loc7_:Number = averageNum(param1.statAdditions);
         var _loc8_:int = 0;
         while(_loc8_ < 100)
         {
            param1.setAgeOffset();
            updatePlayer(param1,true);
            _loc9_ = param1.isKeeper() ? 5 : 12;
            _loc10_ = 0;
            _loc11_ = 0;
            while(_loc11_ < _loc9_)
            {
               _loc10_ += param1.currentStats[_loc11_];
               _loc11_++;
            }
            _loc4_.push(_loc10_ / _loc9_);
            _loc2_.currentDate.setFullYear(_loc2_.currentDate.getFullYear() + 1);
            _loc8_++;
         }
         _loc2_.currentDate = _loc3_;
         return _loc4_;
      }
      
      private static function getFactor(param1:String, param2:Number, param3:int) : Number
      {
         var _loc4_:Number = 0;
         var _loc5_:Number = Math.max(0,Math.min(param2 / (param3 - Player.MIN_AGE),1));
         // Delay peak later in career: ease f toward 1 with exponent >1
         var _loc6_:Number = Math.pow(_loc5_,1.5);
         switch(param1)
         {
            case SIN_0:
               _loc4_ = Math.sin(Math.PI * 0.95 * _loc6_);
               break;
            case SIN_1:
               _loc4_ = _loc6_ < 0.15 ? Math.sin(Math.PI * 2 * (_loc6_ + 0)) : Math.sin(Math.PI * 0.5 * (_loc6_ + 0.75));
               break;
            case SIN_2:
               _loc4_ = Math.sin(Math.PI * 1 * _loc6_);
               break;
            case SIN_3:
               _loc4_ = _loc6_ < 0.25 ? Math.sin(Math.PI * 2 * (_loc6_ + 0)) : Math.sin(Math.PI / 3 * (_loc6_ + 1.35));
               break;
            case SIN_4:
               _loc4_ = _loc6_ < 0.15 ? Math.sin(Math.PI * 2 * (_loc6_ + 0)) : Math.sin(Math.PI / 4 * (_loc6_ + 1.85));
               break;
            case SIN_SLOW_DECAY_0:
               _loc4_ = _loc6_ < 0.25 ? Math.sin(Math.PI * 2 * _loc6_) : Math.sin(Math.PI * 0.5 * (_loc6_ + 0.75));
         }
         return _loc4_;
      }
      
      private static function getValues(param1:String, param2:int, param3:Number, param4:Number, param5:int) : Array
      {
         var _loc6_:Number = param3 - Player.MIN_AGE;
         var _loc7_:Number = getFactor(param1,_loc6_,param5);
         var _loc8_:Number = param4 * _loc7_;
         var _loc9_:Number = param4 * (1 - _loc7_);
         return [param2 - _loc8_,param2 + _loc9_];
      }
      
      private static function average(param1:Array) : Number
      {
         var _loc3_:int = 0;
         var _loc2_:Number = 0;
         for each(_loc3_ in param1)
         {
            _loc2_ += _loc3_;
         }
         return _loc2_ / param1.length;
      }
      
      private static function averageNum(param1:Array) : Number
      {
         var _loc3_:int = 0;
         var _loc2_:Number = 0;
         for each(_loc3_ in param1)
         {
            _loc2_ += _loc3_;
         }
         return _loc2_ / param1.length;
      }
      
      public static function getMainPos(param1:Player) : String
      {
         if(!param1 || !param1.positions || param1.positions.length == 0)
         {
            return Player.BASE_POSITIONS[2];
         }
         var _loc2_:Array = param1.positions.split("-");
         var _loc3_:String = _loc2_.length > 0 ? _loc2_[0] : "";
         switch(_loc3_)
         {
            case "gk":
               return Player.BASE_POSITIONS[0];
            case "cb":
            case "fb":
            case "wb":
               return Player.BASE_POSITIONS[1];
            case "dm":
            case "cm":
            case "sm":
            case "am":
               return Player.BASE_POSITIONS[2];
            case "cf":
            case "wf":
               return Player.BASE_POSITIONS[3];
         }
         return Player.BASE_POSITIONS[2];
      }
      
      public static function isAvailable(param1:Player) : Boolean
      {
         return param1.statusEffects.length == 0;
      }
      
      public static function releasePlayerFine(param1:Player) : int
      {
         return 100;
      }
      
      public static function getPlayerScore(param1:Player) : Number
      {
         var _loc2_:Array = param1.positions.split("-");
         var _loc3_:Number = 0;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc3_ += getSpecificPositionScore(param1,_loc2_[_loc4_]);
            _loc4_++;
         }
         return _loc3_ / _loc2_.length;
      }

      public static function getPlayerScoreFromStats(param1:Player, param2:Array) : Number
      {
         if(!param1 || !param2 || param2.length == 0)
         {
            return 0;
         }
         var _loc1_:Array = param1.currentStats;
         param1.currentStats = param2;
         var _loc2_:Number = getPlayerScore(param1);
         param1.currentStats = _loc1_;
         return _loc2_;
      }

      public static function getPlayerMaxStats(param1:Player) : Array
      {
         var _loc2_:Array = [];
         if(!param1 || !param1.minStats || !param1.statClimb)
         {
            return _loc2_;
         }
         var _loc1_:int = 0;
         while(_loc1_ < param1.minStats.length)
         {
            _loc2_[_loc1_] = param1.minStats[_loc1_] + param1.statClimb[_loc1_];
            _loc1_++;
         }
         return _loc2_;
      }
      
      public static function getBasePlayerScore(param1:Player, param2:String) : Number
      {
         var _loc6_:String = null;
         var _loc3_:Array = [];
         if(param1.isKeeper() && param2 != "gk" || !param1.isKeeper() && param2 == "gk")
         {
            return 0;
         }
         switch(param2)
         {
            case Player.BASE_POSITIONS[0]:
               _loc3_[Player.SHOT_STOPPING] = 3;
               _loc3_[Player.DISTRIBUTION] = 2.2;
               _loc3_[Player.CATCHING] = 2.3;
               _loc3_[Player.KEEPER_STAMINA] = 1.5;
               _loc3_[Player.KEEPER_FITNESS];
               break;
            case Player.BASE_POSITIONS[1]:
               _loc3_[Player.TACKLING] = 3;
               _loc3_[Player.HEADING] = 2.5;
               _loc3_[Player.STRENGTH] = 2.3;
               _loc3_[Player.SPEED] = 2.3;
               _loc3_[Player.PASSING] = 1.6;
               _loc3_[Player.SHOOTING] = 1;
               _loc3_[Player.DRIBBLING] = 1;
               _loc3_[Player.AGGRESSION] = 2.3;
               _loc3_[Player.CROSSING] = 1.5;
               _loc3_[Player.MAX_STAMINA] = 2;
               _loc3_[Player.FITNESS];
               break;
            case Player.BASE_POSITIONS[2]:
               _loc3_[Player.TACKLING] = 2.5;
               _loc3_[Player.HEADING] = 1.5;
               _loc3_[Player.STRENGTH] = 2;
               _loc3_[Player.SPEED] = 2.3;
               _loc3_[Player.PASSING] = 3;
               _loc3_[Player.SHOOTING] = 2;
               _loc3_[Player.DRIBBLING] = 2;
               _loc3_[Player.AGGRESSION] = 2.5;
               _loc3_[Player.CROSSING] = 2.5;
               _loc3_[Player.MAX_STAMINA] = 2.5;
               _loc3_[Player.FITNESS] = 1.5;
               _loc3_[Player.CREATIVITY] = 3;
               break;
            case Player.BASE_POSITIONS[3]:
               _loc3_[Player.TACKLING] = 1.5;
               _loc3_[Player.HEADING] = 2.5;
               _loc3_[Player.STRENGTH] = 2.5;
               _loc3_[Player.SPEED] = 2.7;
               _loc3_[Player.PASSING] = 2.3;
               _loc3_[Player.SHOOTING] = 3;
               _loc3_[Player.DRIBBLING] = 2.5;
               _loc3_[Player.AGGRESSION] = 2.5;
               _loc3_[Player.CROSSING] = 2.5;
               _loc3_[Player.MAX_STAMINA] = 2.5;
               _loc3_[Player.FITNESS] = 1;
               _loc3_[Player.CREATIVITY] = 4;
         }
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         for(_loc6_ in _loc3_)
         {
            _loc5_ += param1.currentStats[_loc6_] * _loc3_[_loc6_];
            _loc4_ += _loc3_[_loc6_];
         }
         return _loc5_ / _loc4_ / 100;
      }
      
      public static function getSpecificPositionScore(param1:Player, param2:String) : Number
      {
         var _loc6_:String = null;
         if(param2 == "gk" && param1.positions != "gk" || param1.positions == "gk" && param2 != "gk")
         {
            return 0;
         }
         var _loc3_:Array = [];
         switch(param2)
         {
            case "gk":
               _loc3_[Player.SHOT_STOPPING] = 3;
               _loc3_[Player.DISTRIBUTION] = 2.2;
               _loc3_[Player.CATCHING] = 2.3;
               _loc3_[Player.KEEPER_STAMINA] = 1.5;
               _loc3_[Player.KEEPER_FITNESS] = 1;
               break;
            case "cb":
               _loc3_[Player.TACKLING] = 4;
               _loc3_[Player.HEADING] = 4;
               _loc3_[Player.STRENGTH] = 2.5;
               _loc3_[Player.SPEED] = 2.3;
               _loc3_[Player.PASSING] = 1.4;
               _loc3_[Player.SHOOTING] = 0.5;
               _loc3_[Player.DRIBBLING] = 0.5;
               _loc3_[Player.AGGRESSION] = 2.3;
               _loc3_[Player.CROSSING] = 0.5;
               _loc3_[Player.MAX_STAMINA] = 2;
               _loc3_[Player.FITNESS] = 1;
               break;
            case "fb":
               _loc3_[Player.TACKLING] = 3;
               _loc3_[Player.HEADING] = 1.5;
               _loc3_[Player.STRENGTH] = 2;
               _loc3_[Player.SPEED] = 2.5;
               _loc3_[Player.PASSING] = 2;
               _loc3_[Player.SHOOTING] = 1;
               _loc3_[Player.DRIBBLING] = 1.5;
               _loc3_[Player.AGGRESSION] = 2;
               _loc3_[Player.CROSSING] = 2.5;
               _loc3_[Player.MAX_STAMINA] = 2.5;
               _loc3_[Player.FITNESS] = 1;
               _loc3_[Player.CREATIVITY] = 1;
               break;
            case "wb":
               _loc3_[Player.TACKLING] = 2.2;
               _loc3_[Player.HEADING] = 1.4;
               _loc3_[Player.STRENGTH] = 1.9;
               _loc3_[Player.SPEED] = 2.6;
               _loc3_[Player.PASSING] = 2.2;
               _loc3_[Player.SHOOTING] = 1.6;
               _loc3_[Player.DRIBBLING] = 1.8;
               _loc3_[Player.AGGRESSION] = 1.7;
               _loc3_[Player.CROSSING] = 2.5;
               _loc3_[Player.MAX_STAMINA] = 2.5;
               _loc3_[Player.FITNESS] = 1;
               _loc3_[Player.CREATIVITY] = 1;
               break;
            case "dm":
               _loc3_[Player.TACKLING] = 4;
               _loc3_[Player.HEADING] = 1;
               _loc3_[Player.STRENGTH] = 2.2;
               _loc3_[Player.SPEED] = 2;
               _loc3_[Player.PASSING] = 1.7;
               _loc3_[Player.SHOOTING] = 1.4;
               _loc3_[Player.DRIBBLING] = 1.4;
               _loc3_[Player.AGGRESSION] = 2;
               _loc3_[Player.CROSSING] = 1.3;
               _loc3_[Player.MAX_STAMINA] = 2.5;
               _loc3_[Player.FITNESS] = 1;
               _loc3_[Player.CREATIVITY] = 1;
               break;
            case "sm":
               _loc3_[Player.TACKLING] = 1.4;
               _loc3_[Player.HEADING] = 1;
               _loc3_[Player.STRENGTH] = 2;
               _loc3_[Player.SPEED] = 2.5;
               _loc3_[Player.PASSING] = 2.6;
               _loc3_[Player.SHOOTING] = 2.2;
               _loc3_[Player.DRIBBLING] = 2.1;
               _loc3_[Player.AGGRESSION] = 1.8;
               _loc3_[Player.CROSSING] = 4;
               _loc3_[Player.MAX_STAMINA] = 2.5;
               _loc3_[Player.FITNESS] = 1;
               _loc3_[Player.CREATIVITY] = 2.5;
               break;
            case "cm":
               _loc3_[Player.TACKLING] = 2;
               _loc3_[Player.HEADING] = 1;
               _loc3_[Player.STRENGTH] = 2;
               _loc3_[Player.SPEED] = 2;
               _loc3_[Player.PASSING] = 4;
               _loc3_[Player.SHOOTING] = 2;
               _loc3_[Player.DRIBBLING] = 2.5;
               _loc3_[Player.AGGRESSION] = 2;
               _loc3_[Player.CROSSING] = 1.3;
               _loc3_[Player.MAX_STAMINA] = 2.5;
               _loc3_[Player.FITNESS] = 1;
               _loc3_[Player.CREATIVITY] = 2.5;
               break;
            case "am":
               _loc3_[Player.TACKLING] = 1.3;
               _loc3_[Player.HEADING] = 1.8;
               _loc3_[Player.STRENGTH] = 2;
               _loc3_[Player.SPEED] = 2.1;
               _loc3_[Player.PASSING] = 3;
               _loc3_[Player.SHOOTING] = 2.5;
               _loc3_[Player.DRIBBLING] = 2.5;
               _loc3_[Player.AGGRESSION] = 2;
               _loc3_[Player.CROSSING] = 1.3;
               _loc3_[Player.MAX_STAMINA] = 2;
               _loc3_[Player.FITNESS] = 1;
               _loc3_[Player.CREATIVITY] = 4;
               break;
            case "wf":
               _loc3_[Player.TACKLING] = 1;
               _loc3_[Player.HEADING] = 1.7;
               _loc3_[Player.STRENGTH] = 2;
               _loc3_[Player.SPEED] = 2.4;
               _loc3_[Player.PASSING] = 2.2;
               _loc3_[Player.SHOOTING] = 2.5;
               _loc3_[Player.DRIBBLING] = 2.5;
               _loc3_[Player.AGGRESSION] = 2;
               _loc3_[Player.CROSSING] = 3;
               _loc3_[Player.MAX_STAMINA] = 2;
               _loc3_[Player.FITNESS] = 1;
               _loc3_[Player.CREATIVITY] = 3;
               break;
            case "cf":
               _loc3_[Player.TACKLING] = 0.5;
               _loc3_[Player.HEADING] = 4;
               _loc3_[Player.STRENGTH] = 2.5;
               _loc3_[Player.SPEED] = 3;
               _loc3_[Player.PASSING] = 2;
               _loc3_[Player.SHOOTING] = 5;
               _loc3_[Player.DRIBBLING] = 2.4;
               _loc3_[Player.AGGRESSION] = 2;
               _loc3_[Player.CROSSING] = 2;
               _loc3_[Player.MAX_STAMINA] = 2;
               _loc3_[Player.FITNESS] = 1;
               _loc3_[Player.CREATIVITY] = 3;
         }
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         for(_loc6_ in _loc3_)
         {
            _loc5_ += param1.currentStats[_loc6_] * _loc3_[_loc6_];
            _loc4_ += _loc3_[_loc6_];
         }
         return _loc5_ / _loc4_;
      }
      
      public static function applyTraining(param1:Player) : void
      {
         var _loc5_:Array = null;
         var _loc7_:StatusEffect = null;
         var _loc8_:Message = null;
         if(param1.hasInjury())
         {
            return;
         }
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         switch(param1.trainingIntensity)
         {
            case Player.LOW_TRAINING:
               _loc2_ = 2;
               _loc3_ = 0.25;
               break;
            case Player.MEDIUM_TRAINING:
               _loc2_ = 5;
               _loc3_ = 0.5;
               break;
            case Player.HIGH_TRAINING:
               _loc2_ = 12;
               _loc3_ = 1;
         }
         if(param1.isKeeper())
         {
            _loc3_ /= 2;
         }
         param1.stamina = Math.max(1,param1.stamina - _loc2_);
         var _loc4_:Number = Math.pow(103 - param1.stamina,1 + _loc2_ / 50) / Math.pow(125,1 + 12 / 50);
         if(0.2 + Math.random() * 3 < _loc4_)
         {
            _loc7_ = new StatusEffect();
            _loc7_.type = StatusEffect.INJURY;
            _loc7_.time = Math.round(Math.sqrt(Math.random() * 82));
            param1.statusEffects.push(_loc7_);
            _loc8_ = new Message();
            _loc8_.title = CopyManager.getCopy("playerInjured");
            _loc8_.body = CopyManager.getCopy("playerInjuredCopy").replace(CopyManager.PLAYER_NAME_REPLACE,param1.name).replace("{numWeeks}",CopyManager.getNumCopy(_loc7_.time,"week"));
            Main.currentGame.userMessages.push(_loc8_);
            return;
         }
         switch(param1.trainingType)
         {
            case Player.DEFENCE_TRAINING:
               _loc5_ = [Player.TACKLING,Player.TACKLING,Player.TACKLING,Player.HEADING,Player.HEADING,Player.AGGRESSION,Player.STRENGTH,Player.SPEED,Player.STRENGTH];
               break;
            case Player.FORWARD_TRAINING:
               _loc5_ = [Player.SHOOTING,Player.SHOOTING,Player.SPEED,Player.SPEED,Player.DRIBBLING,Player.HEADING,Player.STRENGTH,Player.CREATIVITY];
               break;
            case Player.FULLBACK_TRAINING:
               _loc5_ = [Player.MAX_STAMINA,Player.MAX_STAMINA,Player.TACKLING,Player.TACKLING,Player.CROSSING,Player.SPEED,Player.AGGRESSION];
               break;
            case Player.GENERAL_TRAINING:
               _loc5_ = [Player.PASSING,Player.DRIBBLING,Player.SPEED,Player.DRIBBLING,Player.TACKLING,Player.STRENGTH,Player.SHOOTING,Player.HEADING,Player.MAX_STAMINA,Player.AGGRESSION,Player.FITNESS];
               break;
            case Player.MIDFIELD_TRAINING:
               _loc5_ = [Player.PASSING,Player.PASSING,Player.TACKLING,Player.AGGRESSION,Player.STRENGTH,Player.FITNESS];
               break;
            case Player.PHYSICAL_TRAINING:
               _loc5_ = [Player.SPEED,Player.STRENGTH,Player.MAX_STAMINA,Player.FITNESS,Player.HEADING];
               break;
            case Player.TECHNIQUE_TRAINING:
               _loc5_ = [Player.PASSING,Player.CROSSING,Player.DRIBBLING,Player.SHOOTING,Player.HEADING];
               break;
            case Player.WINGER_TRAINING:
               _loc5_ = [Player.CROSSING,Player.CROSSING,Player.DRIBBLING,Player.SPEED,Player.PASSING,Player.SHOOTING];
               break;
            case Player.KEEPER_TRAINING:
               _loc5_ = [Player.SHOT_STOPPING,Player.CATCHING,Player.DISTRIBUTION,Player.KEEPER_FITNESS,Player.KEEPER_STAMINA];
         }
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length)
         {
            param1.statAdditions[_loc5_[_loc6_]] += _loc3_ / _loc5_.length;
            _loc6_++;
         }
         updatePlayer(param1);
      }
   }
}
