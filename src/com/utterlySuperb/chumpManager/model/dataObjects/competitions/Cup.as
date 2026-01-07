package com.utterlySuperb.chumpManager.model.dataObjects.competitions
{
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.Club;
   import com.utterlySuperb.chumpManager.model.dataObjects.Message;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.Match;
   import com.utterlySuperb.chumpManager.engine.FinanceConfigHelper;
   
   public class Cup extends Competition
   {
      
      public static const KNOCK_OUT:String = "knockOut";
      
      public static const KNOCK_OUT_2_LEG:String = "knockOut2Leg";
      
      public static const TOP_TWO_DOMESTIC:String = "topTwoDomestic";
      
      public static const DOMESTIC_ALL:String = "domesticAll";
      
      public static const EUROPE_BEST:String = "europeBest";
      
      public static const EUROPE_REST:String = "europeRest";
      
      private static const AMOUNTS:Array = [1,2,4,8,16,32,64,128];
      
      public var type:String;
      
      public var numRounds:int;
      
      public var finalRound:int;
      
      public var playsMatchesMidweek:Boolean;
      
      public var matches:Array;
      
      public var legNum:int = 0;
      
      public var knockedOut:Array;
      
      public function Cup()
      {
         super();
         this.matches = [];
         this.knockedOut = new Array();
      }
      
      public function makeNextMatches() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Array = null;
         var _loc4_:* = false;
         var _loc5_:int = 0;
         var _loc6_:Match = null;
         var _loc7_:int = 0;
         var _loc1_:Array = new Array();
         if(this.type == KNOCK_OUT || this.matches.length % 2 == 0)
         {
            _loc2_ = entrants.length / 2;
            if(AMOUNTS.indexOf(_loc2_) < 0)
            {
               _loc5_ = 0;
               while(AMOUNTS.indexOf(entrants.length - _loc5_) < 0)
               {
                  _loc5_++;
               }
            }
            _loc3_ = entrants.slice();
            _loc4_ = AMOUNTS.indexOf(_loc3_.length) < 0;
            while(_loc3_.length > 1 && !(_loc4_ && _loc1_.length == _loc5_))
            {
               _loc6_ = new Match();
               _loc6_.competition = this;
               _loc6_.needsWinner = true;
               _loc6_.club0 = _loc3_.splice(Math.floor(Math.random() * _loc3_.length),1)[0];
               _loc6_.club1 = _loc3_.splice(Math.floor(Math.random() * _loc3_.length),1)[0];
               _loc1_.push(_loc6_);
            }
         }
         else
         {
            _loc7_ = 0;
            while(_loc7_ < this.matches[this.matches.length - 1].length)
            {
               _loc6_ = new Match();
               _loc6_.competition = this;
               if(this.legNum == 1 || this.type == KNOCK_OUT)
               {
                  _loc6_.needsWinner = true;
               }
               _loc6_.club0 = this.matches[this.matches.length - 1][_loc7_].club1;
               _loc6_.club1 = this.matches[this.matches.length - 1][_loc7_].club0;
               _loc6_.firstLeg = this.matches[this.matches.length - 1][_loc7_];
               _loc1_.push(_loc6_);
               _loc7_++;
            }
         }
         this.matches.push(_loc1_);
      }
      
      public function getNextMatches() : Array
      {
         return this.matches[this.matches.length - 1];
      }
      
      public function isPlayedThisWeek(param1:int) : Boolean
      {
         var _loc4_:int = 0;
         var _loc2_:int = Math.min(32,this.finalRound) / this.numRounds;
         var _loc3_:int = this.finalRound - _loc2_ * this.numRounds;
         if(!this.isFinished() && param1 >= _loc3_)
         {
            _loc4_ = this.finalRound;
            while(_loc4_ >= param1)
            {
               if(_loc4_ == param1)
               {
                  return true;
               }
               _loc4_ -= _loc2_;
            }
         }
         return false;
      }
      
      public function getNextMatchesRound(param1:int) : int
      {
         var _loc4_:int = 0;
         if(!Main.currentGame.weekend && !this.playsMatchesMidweek)
         {
            param1++;
         }
         var _loc2_:int = Math.min(32,this.finalRound) / this.numRounds;
         var _loc3_:int = this.finalRound - _loc2_ * this.numRounds;
         if(param1 <= this.finalRound)
         {
            _loc4_ = this.finalRound;
            while(_loc4_ >= -_loc3_ - _loc2_)
            {
               if(_loc4_ < Math.max(param1,_loc3_))
               {
                  return _loc4_ + _loc2_;
               }
               if(_loc4_ == Math.max(param1,_loc3_))
               {
                  return _loc4_;
               }
               _loc4_ -= _loc2_;
            }
         }
         return -1;
      }
      
      public function playerIsStillIn() : Boolean
      {
         var _loc1_:int = 0;
         while(_loc1_ < entrants.length)
         {
            if(entrants[_loc1_].club == Main.currentGame.playerClub)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      public function getNextPlayerRound(param1:int) : int
      {
         var _loc3_:Boolean = false;
         var _loc2_:int = this.getNextMatchesRound(param1);
         if(this.isFinished() || !this.playerIsStillIn())
         {
            return -1;
         }
         var _loc4_:Array = this.matches[this.matches.length - 1];
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.length)
         {
            if(_loc4_[_loc5_].club0.club == Main.currentGame.playerClub || _loc4_[_loc5_].club1.club == Main.currentGame.playerClub)
            {
               _loc3_ = true;
            }
            _loc5_++;
         }
         if(_loc3_)
         {
            return _loc2_;
         }
         return _loc2_ + Math.min(32,this.finalRound) / this.numRounds;
      }
      
      public function isFinal() : Boolean
      {
         return entrants.length == 2;
      }
      
      public function isFinished() : Boolean
      {
         return entrants.length == 1;
      }
      
      override public function matchPlayed(param1:Match) : void
      {
         var _loc5_:CompetitionInfo = null;
         var _loc6_:Message = null;
         if(param1.needsWinner && !param1.loser)
         {
            return;
         }
         var _loc2_:Array = this.matches[this.matches.length - 1];
         var _loc3_:Boolean = true;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(!_loc2_[_loc4_].beenPlayed)
            {
               _loc3_ = false;
            }
            _loc4_++;
         }
         if(_loc3_)
         {
            if(this.type == KNOCK_OUT || this.matches.length % 2 == 0)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc2_.length)
               {
                  _loc5_ = _loc2_[_loc4_].loser;
                  entrants.splice(entrants.indexOf(_loc5_),1);
                  this.knockedOut.push(_loc5_.club);
                  _loc4_++;
               }
            }
            FinanceConfigHelper.applyCupRoundPayout(this,_loc2_);
            FinanceConfigHelper.applyUclRoundBonuses(this);
            if(entrants.length > 1)
            {
               this.makeNextMatches();
            }
            else
            {
               _loc6_ = new Message();
               if(entrants[0].club == Main.currentGame.playerClub)
               {
                  _loc6_.title = CopyManager.getCopy("youWinCup").replace("{cupName}",CopyManager.getCopy(name));
                  _loc6_.body = CopyManager.getCopy("youWinCupCopy");
               }
               else
               {
                  _loc6_.title = CopyManager.getCopy(name);
                  _loc6_.body = CopyManager.getCopy("cupWonCopy").replace(CopyManager.CLUB_NAME_REPLACE,entrants[0].club.name).replace("{cupName}",CopyManager.getCopy(name));
               }
               Main.currentGame.userMessages.push(_loc6_);
               FinanceConfigHelper.applyCupWinnerBonus(this);
            }
         }
      }
      
      public function remakeCompInfRelationships() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Match = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.matches.length)
         {
            _loc2_ = 0;
            while(_loc2_ < this.matches[_loc1_].length)
            {
               _loc3_ = 0;
               while(_loc3_ < entrants.length)
               {
                  _loc4_ = this.matches[_loc1_][_loc2_];
                  if(entrants[_loc3_].club == _loc4_.club0.club)
                  {
                     _loc4_.club0 = entrants[_loc3_];
                  }
                  else if(entrants[_loc3_].club == _loc4_.club1.club)
                  {
                     _loc4_.club1 = entrants[_loc3_];
                  }
                  _loc4_.competition = this;
                  _loc3_++;
               }
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      public function beenKnockedOut(param1:Club) : Boolean
      {
         return this.knockedOut.indexOf(param1) >= 0;
      }
   }
}

