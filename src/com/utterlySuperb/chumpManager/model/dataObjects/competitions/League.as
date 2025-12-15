package com.utterlySuperb.chumpManager.model.dataObjects.competitions
{
   public class League extends Competition
   {
      
      public var numInEuropeanCup:int;
      
      public var numInUefaCup:int;
      
      public function League()
      {
         super();
      }
      
      public function isFinished() : Boolean
      {
         return false;
      }
      
      public function getStandings() : Array
      {
         var _loc2_:CompetitionInfo = null;
         var _loc3_:CompetitionInfo = null;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc7_:int = 0;
         var _loc1_:Array = new Array();
         var _loc6_:int = 0;
         while(_loc6_ < entrants.length)
         {
            _loc2_ = entrants[_loc6_];
            _loc4_ = false;
            _loc7_ = 0;
            while(_loc7_ < _loc1_.length)
            {
               if(!_loc4_)
               {
                  _loc5_ = false;
                  _loc3_ = _loc1_[_loc7_];
                  if(_loc2_.points > _loc3_.points)
                  {
                     _loc5_ = true;
                  }
                  else if(_loc2_.points == _loc3_.points)
                  {
                     if(_loc2_.goalDifference > _loc3_.goalDifference)
                     {
                        _loc5_ = true;
                     }
                     else if(_loc2_.goalDifference == _loc3_.goalDifference && _loc2_.goalsScored > _loc3_.goalsScored)
                     {
                        _loc5_ = true;
                     }
                  }
                  if(_loc5_)
                  {
                     _loc1_.splice(_loc7_,0,_loc2_);
                     _loc4_ = true;
                  }
               }
               _loc7_++;
            }
            if(!_loc4_)
            {
               _loc1_.push(_loc2_);
            }
            _loc6_++;
         }
         _loc6_ = 0;
         while(_loc6_ < _loc1_.length)
         {
            CompetitionInfo(_loc1_[_loc6_]).currentPosition = _loc6_ + 1;
            _loc6_++;
         }
         return _loc1_;
      }
   }
}

