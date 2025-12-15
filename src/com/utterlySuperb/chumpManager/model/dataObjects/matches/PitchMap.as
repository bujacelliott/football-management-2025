package com.utterlySuperb.chumpManager.model.dataObjects.matches
{
   public class PitchMap
   {
      
      public static const NUM_COLUMNS:int = 5;
      
      public static const NUM_ROWS:int = 7;
      
      public static const PITCH_WIDTH:int = 80;
      
      public static const PITCH_HEIGHT:int = 120;
      
      public static const PLAYER_ROW_MULT:Number = 0.8;
      
      public var sectors:Array;
      
      public function PitchMap()
      {
         super();
         this.init();
      }
      
      public function init() : void
      {
         var _loc2_:int = 0;
         this.sectors = [];
         var _loc1_:int = 0;
         while(_loc1_ < NUM_COLUMNS)
         {
            this.sectors[_loc1_] = new Vector.<PitchSector>();
            _loc2_ = 0;
            while(_loc2_ < NUM_ROWS)
            {
               this.sectors[_loc1_][_loc2_] = new PitchSector(_loc1_,_loc2_);
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      public function reset() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < NUM_COLUMNS)
         {
            _loc2_ = 0;
            while(_loc2_ < NUM_ROWS)
            {
               PitchSector(this.sectors[_loc1_][_loc2_]).reset();
               _loc2_++;
            }
            _loc1_++;
         }
      }
   }
}

