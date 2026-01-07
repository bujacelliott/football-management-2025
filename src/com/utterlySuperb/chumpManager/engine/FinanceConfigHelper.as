package com.utterlySuperb.chumpManager.engine
{
   import com.utterlySuperb.chumpManager.model.dataObjects.Club;
   import com.utterlySuperb.chumpManager.model.dataObjects.Game;
   import com.utterlySuperb.chumpManager.model.dataObjects.competitions.Cup;
   import com.utterlySuperb.chumpManager.model.dataObjects.competitions.League;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.Match;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.MatchDetails;
   import flash.utils.ByteArray;
   
   public class FinanceConfigHelper
   {
      
      [Embed(source="../../../../../realistic_transfer_only_finances_config.json", mimeType="application/octet-stream")]
      private static const FinanceConfigData:Class;
      
      private static var config:Object;
      
      private static var leagueConfigs:Object;
      
      private static var competitionConfigs:Object;
      
      private static var leagueMedians:Object;
      
      private static var lastSeason:int = -1;
      
      public function FinanceConfigHelper()
      {
         super();
      }
      
      public static function getMatchIncome(param1:MatchDetails) : int
      {
         if(!param1 || !param1.match || !param1.match.competition)
         {
            return 0;
         }
         if(param1.match.competition is League)
         {
            var _loc2_:League = League(param1.match.competition);
            var _loc3_:Object = getLeagueConfig(_loc2_.name);
            if(!_loc3_)
            {
               return 0;
            }
            var _loc4_:Number = Number(_loc3_.per_match.guaranteed_fee);
            var _loc5_:Number = getMarketMultiplier(_loc2_,Main.currentGame.playerClub);
            var _loc6_:Number = _loc4_ * _loc5_;
            var _loc7_:Number = 0;
            if(param1.match.isDraw())
            {
               _loc7_ = Number(_loc3_.per_match.draw_bonus);
            }
            else if(param1.match.getWinner().club == Main.currentGame.playerClub)
            {
               _loc7_ = Number(_loc3_.per_match.win_bonus);
            }
            return int(_loc6_ + _loc7_);
         }
         if(param1.match.competition is Cup)
         {
            var _loc8_:Cup = Cup(param1.match.competition);
            var _loc9_:Object = getCompetitionConfig(_loc8_.name);
            if(_loc9_ && _loc9_.group_stage && isEuropeanCup(_loc8_))
            {
               var _loc10_:Object = _loc9_.group_stage.per_match;
               var _loc11_:Number = Number(_loc10_.guaranteed_fee);
               var _loc12_:Number = 0;
               if(param1.match.isDraw())
               {
                  _loc12_ = Number(_loc10_.draw_bonus);
               }
               else if(param1.match.getWinner().club == Main.currentGame.playerClub)
               {
                  _loc12_ = Number(_loc10_.win_bonus);
               }
               return int(_loc11_ + _loc12_);
            }
         }
         return 0;
      }
      
      public static function applySeasonPrize(param1:Game) : void
      {
         if(!param1 || !param1.playerClub)
         {
            return;
         }
         var _loc2_:League = param1.getMainLeague();
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:Object = getLeagueConfig(_loc2_.name);
         if(!_loc3_ || !_loc3_.end_of_season_prize)
         {
            return;
         }
         var _loc4_:Array = _loc2_.getStandings();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.length)
         {
            if(_loc4_[_loc5_].club == param1.playerClub)
            {
               break;
            }
            _loc5_++;
         }
         if(_loc5_ >= _loc4_.length)
         {
            return;
         }
         var _loc6_:Number = Number(_loc3_.end_of_season_prize.min);
         var _loc7_:Number = Number(_loc3_.end_of_season_prize.max);
         var _loc8_:int = _loc4_.length;
         if(_loc8_ <= 1)
         {
            param1.clubCash += int(_loc7_);
            return;
         }
         var _loc9_:Number = (_loc7_ - _loc6_) / (_loc8_ - 1);
         var _loc10_:Number = _loc7_ - _loc9_ * _loc5_;
         param1.clubCash += int(_loc10_);
      }
      
      public static function applyCupRoundPayout(param1:Cup, param2:Array) : void
      {
         if(!param1 || !param2 || !Main.currentGame || !Main.currentGame.playerClub)
         {
            return;
         }
         var _loc3_:Object = getCompetitionConfig(param1.name);
         if(!_loc3_ || !_loc3_.base_round_payout_by_league)
         {
            return;
         }
         var _loc4_:int = param1.matches.length - 1;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         while(_loc6_ < param2.length)
         {
            if(param2[_loc6_].club0.club == Main.currentGame.playerClub || param2[_loc6_].club1.club == Main.currentGame.playerClub)
            {
               if(param2[_loc6_].loser && param2[_loc6_].loser.club != Main.currentGame.playerClub)
               {
                  _loc5_ = true;
                  break;
               }
            }
            _loc6_++;
         }
         if(!_loc5_)
         {
            return;
         }
         var _loc7_:String = getLeagueNameForClub(Main.currentGame.playerClub);
         var _loc8_:Number = Number(_loc3_.base_round_payout_by_league[_loc7_]);
         if(isNaN(_loc8_) || _loc8_ <= 0)
         {
            return;
         }
         var _loc9_:Number = Number(_loc3_.round_multiplier_each_win);
         if(isNaN(_loc9_) || _loc9_ <= 0)
         {
            _loc9_ = 1;
         }
         var _loc10_:Number = _loc8_ * Math.pow(_loc9_,_loc4_);
         Main.currentGame.clubCash += int(_loc10_);
      }
      
      public static function applyCupWinnerBonus(param1:Cup) : void
      {
         if(!param1 || !Main.currentGame || !Main.currentGame.playerClub)
         {
            return;
         }
         var _loc2_:Object = getCompetitionConfig(param1.name);
         if(!_loc2_ || !_loc2_.winner_bonus_by_league)
         {
            return;
         }
         if(param1.entrants.length != 1)
         {
            return;
         }
         if(param1.entrants[0].club != Main.currentGame.playerClub)
         {
            return;
         }
         var _loc3_:String = getLeagueNameForClub(Main.currentGame.playerClub);
         var _loc4_:Number = Number(_loc2_.winner_bonus_by_league[_loc3_]);
         if(!isNaN(_loc4_) && _loc4_ > 0)
         {
            Main.currentGame.clubCash += int(_loc4_);
         }
      }
      
      public static function applyUclRoundBonuses(param1:Cup) : void
      {
         if(!param1 || !Main.currentGame || !Main.currentGame.playerClub)
         {
            return;
         }
         if(!isEuropeanCup(param1))
         {
            return;
         }
         var _loc2_:Object = getCompetitionConfig(param1.name);
         if(!_loc2_ || !_loc2_.knockout_bonuses)
         {
            return;
         }
         var _loc3_:Boolean = param1.hasClub(Main.currentGame.playerClub);
         if(param1.entrants.length == 1 && param1.entrants[0].club == Main.currentGame.playerClub)
         {
            Main.currentGame.clubCash += int(Number(_loc2_.knockout_bonuses.winner));
         }
         else if(param1.entrants.length == 1 && param1.knockedOut.length > 0)
         {
            var _loc4_:Club = param1.knockedOut[param1.knockedOut.length - 1];
            if(_loc4_ == Main.currentGame.playerClub)
            {
               Main.currentGame.clubCash += int(Number(_loc2_.knockout_bonuses.runner_up));
            }
         }
         else if(param1.entrants.length == 2 && _loc3_)
         {
            Main.currentGame.clubCash += int(Number(_loc2_.knockout_bonuses.semi_final));
         }
         else if(param1.entrants.length == 4 && _loc3_)
         {
            Main.currentGame.clubCash += int(Number(_loc2_.knockout_bonuses.quarter_final));
         }
         else if(param1.entrants.length == 16 && _loc3_)
         {
            Main.currentGame.clubCash += int(Number(_loc2_.knockout_bonuses.round_of_16));
         }
      }
      
      public static function applyUclParticipationBonus(param1:Game) : void
      {
         if(!param1 || !param1.fixtureList || !param1.fixtureList.europeanCup || !param1.playerClub)
         {
            return;
         }
         if(!param1.fixtureList.europeanCup.hasClub(param1.playerClub))
         {
            return;
         }
         var _loc2_:Object = getCompetitionConfig(param1.fixtureList.europeanCup.name);
         if(!_loc2_ || !_loc2_.group_stage)
         {
            return;
         }
         param1.clubCash += int(Number(_loc2_.group_stage.participation_bonus));
      }
      
      private static function getMarketMultiplier(param1:League, param2:Club) : Number
      {
         var _loc3_:Object = getLeagueConfig(param1.name);
         if(!_loc3_)
         {
            return 1;
         }
         var _loc4_:Number = Number(_loc3_.per_match.guaranteed_fee);
         var _loc5_:Number = getLeagueMedianBudget(param1);
         var _loc6_:Number = getClubBudget(param1.name,param2);
         if(_loc5_ <= 0 || _loc6_ <= 0 || _loc4_ <= 0)
         {
            return 1;
         }
         var _loc7_:Number = Math.sqrt(_loc6_ / _loc5_);
         return clamp(_loc7_,0.75,1.6);
      }
      
      private static function getClubBudget(param1:String, param2:Club) : Number
      {
         var _loc3_:int = TransferBudgetHelper.getBudget(param1,param2.name);
         if(_loc3_ > 0)
         {
            return _loc3_;
         }
         return 1000000;
      }
      
      private static function getLeagueMedianBudget(param1:League) : Number
      {
         var _loc2_:String = normalize(param1.name);
         if(!leagueMedians || lastSeason != Main.currentGame.seasonNum)
         {
            leagueMedians = {};
            lastSeason = Main.currentGame.seasonNum;
         }
         if(leagueMedians.hasOwnProperty(_loc2_))
         {
            return Number(leagueMedians[_loc2_]);
         }
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < param1.entrants.length)
         {
            var _loc5_:Club = param1.entrants[_loc4_].club;
            var _loc6_:Number = getClubBudget(param1.name,_loc5_);
            _loc3_.push(_loc6_);
            _loc4_++;
         }
         _loc3_.sort(Array.NUMERIC);
         var _loc7_:Number = 1000000;
         if(_loc3_.length > 0)
         {
            var _loc8_:int = int(_loc3_.length / 2);
            if(_loc3_.length % 2 == 0)
            {
               _loc7_ = (_loc3_[_loc8_ - 1] + _loc3_[_loc8_]) / 2;
            }
            else
            {
               _loc7_ = _loc3_[_loc8_];
            }
         }
         leagueMedians[_loc2_] = _loc7_;
         return _loc7_;
      }
      
      private static function getLeagueConfig(param1:String) : Object
      {
         loadConfig();
         if(!leagueConfigs)
         {
            return null;
         }
         var _loc2_:String = normalize(param1);
         if(leagueConfigs.hasOwnProperty(_loc2_))
         {
            return leagueConfigs[_loc2_];
         }
         if(param1 == "premierLeague")
         {
            _loc2_ = normalize("Premier League");
            if(leagueConfigs.hasOwnProperty(_loc2_))
            {
               return leagueConfigs[_loc2_];
            }
         }
         if(param1 == "championship")
         {
            _loc2_ = normalize("Championship");
            if(leagueConfigs.hasOwnProperty(_loc2_))
            {
               return leagueConfigs[_loc2_];
            }
         }
         if(param1 == "leagueOne")
         {
            _loc2_ = normalize("League One");
            if(leagueConfigs.hasOwnProperty(_loc2_))
            {
               return leagueConfigs[_loc2_];
            }
         }
         if(param1 == "leagueTwo")
         {
            _loc2_ = normalize("League Two");
            if(leagueConfigs.hasOwnProperty(_loc2_))
            {
               return leagueConfigs[_loc2_];
            }
         }
         return null;
      }
      
      private static function getCompetitionConfig(param1:String) : Object
      {
         loadConfig();
         if(!competitionConfigs)
         {
            return null;
         }
         var _loc2_:String = normalizeCompetition(param1);
         if(competitionConfigs.hasOwnProperty(_loc2_))
         {
            return competitionConfigs[_loc2_];
         }
         return null;
      }
      
      private static function loadConfig() : void
      {
         if(config)
         {
            return;
         }
         var _loc1_:ByteArray = new FinanceConfigData() as ByteArray;
         if(!_loc1_)
         {
            return;
         }
         config = JSON.parse(_loc1_.readUTFBytes(_loc1_.length));
         leagueConfigs = {};
         competitionConfigs = {};
         if(config && config.leagues)
         {
            for(var _loc2_:* in config.leagues)
            {
               leagueConfigs[normalize(String(_loc2_))] = config.leagues[_loc2_];
            }
         }
         if(config && config.competitions)
         {
            for(var _loc3_:* in config.competitions)
            {
               competitionConfigs[normalizeCompetition(String(_loc3_))] = config.competitions[_loc3_];
            }
         }
      }
      
      private static function normalize(param1:String) : String
      {
         if(!param1)
         {
            return "";
         }
         return param1.toLowerCase().replace(/[^a-z0-9]/g,"");
      }
      
      private static function normalizeCompetition(param1:String) : String
      {
         var _loc2_:String = normalize(param1);
         switch(_loc2_)
         {
            case "facup":
               return normalize("FA Cup");
            case "leaguecup":
               return normalize("EFL Cup");
            case "europeancup":
               return normalize("UEFA Champions League");
         }
         return _loc2_;
      }
      
      private static function isEuropeanCup(param1:Cup) : Boolean
      {
         return normalizeCompetition(param1.name) == normalize("UEFA Champions League");
      }
      
      private static function getLeagueNameForClub(param1:Club) : String
      {
         var _loc2_:int = 0;
         while(_loc2_ < Main.currentGame.leagues.length)
         {
            if(Main.currentGame.leagues[_loc2_] && Main.currentGame.leagues[_loc2_].getCompetitionInfo(param1))
            {
               return Main.currentGame.leagues[_loc2_].name;
            }
            _loc2_++;
         }
         return Main.currentGame.getMainLeague() ? Main.currentGame.getMainLeague().name : "";
      }
      
      private static function clamp(param1:Number, param2:Number, param3:Number) : Number
      {
         if(param1 < param2)
         {
            return param2;
         }
         if(param1 > param3)
         {
            return param3;
         }
         return param1;
      }
   }
}
