package com.utterlySuperb.chumpManager.model.dataObjects
{
   import com.utterlySuperb.chumpManager.engine.PlayerHelper;
   import com.utterlySuperb.chumpManager.engine.TeamHelper;
   
   public class Player
   {
      
      public static const PASSING:int = 0;
      
      public static const TACKLING:int = 1;
      
      public static const HEADING:int = 2;
      
      public static const SHOOTING:int = 3;
      
      public static const CROSSING:int = 4;
      
      public static const DRIBBLING:int = 5;
      
      public static const SPEED:int = 6;
      
      public static const MAX_STAMINA:int = 7;
      
      public static const AGGRESSION:int = 8;
      
      public static const FITNESS:int = 10;
      
      public static const STRENGTH:int = 9;
      
      public static const CREATIVITY:int = 11;
      
      public static const CATCHING:int = 0;
      
      public static const SHOT_STOPPING:int = 1;
      
      public static const DISTRIBUTION:int = 2;
      
      public static const KEEPER_STAMINA:int = 3;
      
      public static const KEEPER_FITNESS:int = 4;
      
      public static const PLAYER_STATS:Array = ["passing","tackling","heading","shooting","crossing","dribbling","speed","maxStamina","aggression","strength","fitness","creativity"];
      
      public static const KEEPER_STATS:Array = ["catching","shotStopping","distribution","maxStamina","fitness"];
      
      public static const NO_TRAINING:int = 0;
      
      public static const LOW_TRAINING:int = 1;
      
      public static const MEDIUM_TRAINING:int = 2;
      
      public static const HIGH_TRAINING:int = 3;
      
      public static const GENERAL_TRAINING:int = 0;
      
      public static const PHYSICAL_TRAINING:int = 1;
      
      public static const TECHNIQUE_TRAINING:int = 2;
      
      public static const FORWARD_TRAINING:int = 3;
      
      public static const MIDFIELD_TRAINING:int = 4;
      
      public static const DEFENCE_TRAINING:int = 5;
      
      public static const WINGER_TRAINING:int = 6;
      
      public static const FULLBACK_TRAINING:int = 7;
      
      public static const KEEPER_TRAINING:int = 8;
      
      public static const TRAINING_TYPES:Array = ["generalTraining","physicalTraining","techniqueTraining","forwardTraining","midfieldTraining","defenceTraining","wingerTraining","fullbackTraining"];
      
      public static const POSITIONS:Array = ["cf","wf","am","cm","dm","sm","fb","cb","wb","gk"];
      
      public static const BASE_POSITIONS:Array = ["gk","def","mid","fwd"];
      
      public static const MIN_AGE:int = 16;
      
      public static const MAX_AGE:int = 38;
      
      public static const MAX_KEEPER_AGE:int = 40;
      
      public var name:String;
      
      public var nationality:String;
      
      public var id:String;
      
      private var _age:Number;
      
      public var ageOffset:int = 0;
      
      public var birthDay:Date;
      
      public var squadNumber:int;
      
      public var trainingIntensity:int = 2;
      
      public var trainingType:int = 0;
      
      public var statusEffects:Array;
      
      public var minStats:Array;
      
      public var statClimb:Array;
      
      public var statAdditions:Array;
      
      public var currentStats:Array;
      
      public var progressType:String;
      
      public var club:Club;
      
      public var transferValue:int = 0;
      
      public var playerRating:int = 0;
      
      public var playerStars:int = 0;
      
      public var positions:String;
      
      public var basePostition:String;
      
      public var form:Number;
      
      public var stamina:Number;
      
      public var active:Boolean;
      
      public var retireFlag:Boolean;
      
      public var seasonStats:Array;
      
      public function Player()
      {
         super();
         this.minStats = new Array();
         this.maxStats = new Array();
         this.statClimb = new Array();
         this.statAdditions = new Array();
         this.currentStats = new Array();
         this.statusEffects = new Array();
      }
      
      public function reset() : void
      {
         this.statusEffects = new Array();
         this.statAdditions = new Array();
         var _loc1_:int = 0;
         while(_loc1_ < this.minStats.length)
         {
            this.statAdditions[_loc1_] = 0;
            _loc1_++;
         }
         PlayerHelper.updatePlayer(this);
      }
      
      public function newSeason() : void
      {
         if(!this.seasonStats || this.seasonStats.length == 0)
         {
            this.seasonStats = new Array();
         }
         this.seasonStats.push(new SeasonStats());
         this.statusEffects = new Array();
         PlayerHelper.updatePlayer(this);
         this.stamina = this.maxStamina;
      }
      
      public function get age() : Number
      {
         return int(this._age);
      }
      
      public function set age(param1:Number) : void
      {
         this._age = param1;
      }
      
      public function get exactAge() : Number
      {
         return this._age;
      }
      
      public function setAgeOffset() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(Main.currentGame.seasonNum > 0)
         {
            _loc1_ = Main.currentGame.currentDate.getTime() - this.birthDay.getTime();
            _loc1_ = _loc1_ / 1000 / 60 / 60 / 24 / 365;
            _loc2_ = PlayerHelper.getMaxAge(this.basePostition);
            _loc3_ = _loc2_ - 15;
            this.ageOffset = _loc1_ < _loc2_ ? 0 : int((_loc1_ - 16) / _loc3_);
         }
         else
         {
            this.ageOffset = 0;
         }
      }
      
      public function setAge(param1:Boolean = false) : void
      {
         var _loc4_:int = 0;
         var _loc2_:Number = Main.currentGame.currentDate.getTime() - this.birthDay.getTime();
         _loc2_ = _loc2_ / 1000 / 60 / 60 / 24 / 365;
         var _loc3_:int = PlayerHelper.getMaxAge(this.basePostition);
         if(Main.currentGame.seasonNum > 0)
         {
            _loc4_ = _loc3_ - 15;
            _loc2_ -= this.ageOffset * _loc4_;
         }
         if(_loc2_ > _loc3_)
         {
            this.retireFlag = true;
         }
         this._age = _loc2_;
      }
      
      public function get passing() : Number
      {
         return this.getStat(PASSING);
      }
      
      public function get tackling() : Number
      {
         return this.getStat(TACKLING);
      }
      
      public function get heading() : Number
      {
         return this.getStat(HEADING);
      }
      
      public function get shooting() : Number
      {
         return this.getStat(SHOOTING);
      }
      
      public function get dribbling() : Number
      {
         return this.getStat(DRIBBLING);
      }
      
      public function get crossing() : Number
      {
         return this.getStat(CROSSING);
      }
      
      public function get speed() : Number
      {
         return this.getStat(SPEED);
      }
      
      public function get strength() : Number
      {
         return this.getStat(STRENGTH);
      }
      
      public function get creativity() : Number
      {
         return this.getStat(CREATIVITY);
      }
      
      public function get aggression() : Number
      {
         return this.getStat(AGGRESSION);
      }
      
      public function get catching() : Number
      {
         return this.getStat(CATCHING);
      }
      
      public function get shotStopping() : Number
      {
         return this.getStat(SHOT_STOPPING);
      }
      
      public function get distribution() : Number
      {
         return this.getStat(DISTRIBUTION);
      }
      
      public function get fitness() : Number
      {
         if(this.isKeeper())
         {
            return this.currentStats[4];
         }
         return this.currentStats[FITNESS];
      }
      
      public function getStat(param1:int) : Number
      {
         return this.form / 100 * this.currentStats[param1] * TeamHelper.FORM_PERC + this.stamina / this.maxStamina * this.currentStats[param1] * TeamHelper.STAMINA_PERC + this.currentStats[param1] * TeamHelper.NON_FORM_PERC;
      }
      
      public function get maxStamina() : Number
      {
         if(this.isKeeper())
         {
            return this.currentStats[3];
         }
         return this.currentStats[MAX_STAMINA];
      }
      
      public function set maxStats(param1:Array) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            this.statAdditions[_loc2_] = 0;
            this.statClimb[_loc2_] = param1[_loc2_] - this.minStats[_loc2_];
            _loc2_++;
         }
      }
      
      public function isKeeper() : Boolean
      {
         return this.positions == "gk";
      }
      
      public function getLastName() : String
      {
         var _loc1_:Array = this.name.split(" ");
         var _loc2_:* = "";
         var _loc3_:int = Math.min(1,_loc1_.length - 1);
         while(_loc3_ < _loc1_.length)
         {
            if(_loc2_.length > 0)
            {
               _loc2_ += " ";
            }
            _loc2_ += _loc1_[_loc3_];
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function hasInjury() : Boolean
      {
         var _loc1_:StatusEffect = null;
         for each(_loc1_ in this.statusEffects)
         {
            if(_loc1_.type == StatusEffect.INJURY)
            {
               return true;
            }
         }
         return false;
      }
      
      public function hasSuspension() : Boolean
      {
         var _loc1_:StatusEffect = null;
         for each(_loc1_ in this.statusEffects)
         {
            if(_loc1_.type == StatusEffect.SUSPENSION)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get canPlay() : Boolean
      {
         return !(this.hasInjury() || this.hasSuspension());
      }
   }
}

