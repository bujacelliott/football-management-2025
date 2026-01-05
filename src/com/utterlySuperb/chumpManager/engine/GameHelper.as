package com.utterlySuperb.chumpManager.engine
{
   import com.utterlySuperb.chumpManager.model.dataObjects.Game;
   
   public class GameHelper
   {
      
      public function GameHelper()
      {
         super();
      }
      
      public static function getMatchesLeft() : int
      {
         var _loc1_:Game = Main.currentGame;
         return _loc1_.getMainLeague().entrants.length * 2 - 2 - _loc1_.getMainLeague().getCompetitionInfo(_loc1_.playerClub).gamesPlayed;
      }
      
      public static function getExpectedIncome() : int
      {
         var _loc1_:int = getMatchesLeft();
         return Game.CASH_PER_WIN * _loc1_ * 0.5 + Game.CASH_PER_LOSS * _loc1_ * 0.2 + Game.CASH_PER_DRAW * _loc1_ * 0.3;
      }
      
      public static function getMeritPayment() : int
      {
         var _loc1_:Game = Main.currentGame;
         _loc1_.getMainLeague().getStandings();
         return 2500000 + (_loc1_.getMainLeague().entrants.length - _loc1_.getMainLeague().getCompetitionInfo(_loc1_.playerClub).currentPosition) * 1000000;
      }
      
      public static function getPlayerLeaguePosition() : int
      {
         var _loc1_:Game = Main.currentGame;
         _loc1_.getMainLeague().getStandings();
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.getMainLeague().entrants.length)
         {
            if(_loc1_.getMainLeague().entrants[_loc2_].club == _loc1_.playerClub)
            {
               return _loc1_.getMainLeague().entrants[_loc2_].currentPosition;
            }
            _loc2_++;
         }
         return 1;
      }
      
      public static function getClubs() : Array
      {
         var _loc1_:Array = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < Main.currentGame.leagues.length)
         {
            _loc1_ = _loc1_.concat(Main.currentGame.leagues[_loc2_].entrants);
            _loc2_++;
         }
         return _loc1_;
      }
      
      public static function getCoreClubs() : Array
      {
         var _loc1_:Array = getClubs();
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            if(!_loc1_[_loc2_].club.isCore)
            {
               _loc1_.splice(_loc2_,1);
               _loc2_--;
            }
            _loc2_++;
         }
         return _loc1_;
      }
   }
}

