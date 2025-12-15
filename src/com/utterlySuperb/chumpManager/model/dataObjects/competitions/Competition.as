package com.utterlySuperb.chumpManager.model.dataObjects.competitions
{
   import com.utterlySuperb.chumpManager.model.dataObjects.Club;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.Match;
   
   public class Competition
   {
      
      public var entrants:Array;
      
      public var name:String;
      
      public function Competition()
      {
         super();
         this.entrants = new Array();
      }
      
      public function addEntrant(param1:Club) : void
      {
         var _loc2_:CompetitionInfo = new CompetitionInfo();
         _loc2_.makeCompetionInfo(param1);
         this.entrants.push(_loc2_);
      }
      
      public function removeEntrant(param1:Club) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.entrants.length)
         {
            if(this.entrants[_loc2_].club == param1)
            {
               this.entrants.splice(_loc2_,1);
               _loc2_--;
            }
            _loc2_++;
         }
      }
      
      public function hasClub(param1:Club) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.entrants.length)
         {
            if(this.entrants[_loc2_].club.name == param1.name)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function matchPlayed(param1:Match) : void
      {
      }
      
      public function getCompetitionInfo(param1:Club) : CompetitionInfo
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.entrants.length)
         {
            if(this.entrants[_loc2_].club == param1)
            {
               return this.entrants[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
   }
}

