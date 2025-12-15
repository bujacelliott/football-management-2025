package com.utterlySuperb.chumpManager.model.dataObjects.matches
{
   import com.utterlySuperb.chumpManager.engine.MatchEngine;
   import com.utterlySuperb.chumpManager.engine.TeamHelper;
   import com.utterlySuperb.chumpManager.model.dataObjects.Player;
   
   public class MatchPlayerDetails
   {
      
      public var player:Player;
      
      public var team:MatchTeamDetails;
      
      public var playerPosition:String;
      
      public var stunned:Boolean;
      
      public var injured:Boolean = false;
      
      public var foulsWon:int = 0;
      
      public var foulsConceeded:int = 0;
      
      public var passesSuceeded:int = 0;
      
      public var passesFailed:int = 0;
      
      public var dribblesSucceeded:int = 0;
      
      public var dribblesFailed:int = 0;
      
      public var shotsOnTarget:int = 0;
      
      public var shotsOffTarget:int = 0;
      
      public var assists:int = 0;
      
      public var goals:int = 0;
      
      public var saves:int = 0;
      
      public var yellowCards:int = 0;
      
      public var redCards:int = 0;
      
      public var timeCameOut:String = "";
      
      public var timeSubstituted:String = "";
      
      public var ratings:Array;
      
      private var _column:int;
      
      private var _row:int;
      
      public var x:Number;
      
      public var y:Number;
      
      private var _baseColumn:int;
      
      private var _baseRow:int;
      
      public var maxRating:Number = 0;
      
      public var minRating:Number = 100;
      
      public function MatchPlayerDetails()
      {
         super();
         this.ratings = new Array();
         var _loc1_:int = 0;
         while(_loc1_ < 50)
         {
            this.ratings.push(5);
            _loc1_++;
         }
      }
      
      public function addToRating(param1:int = 666) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(param1 == 666)
         {
            _loc2_ = this.player.playerRating * TeamHelper.NON_FORM_PERC + this.player.playerRating * TeamHelper.FORM_PERC * this.player.form / 100 + this.player.playerRating * TeamHelper.STAMINA_PERC * this.player.stamina / this.player.maxStamina;
            this.maxRating = Math.max(this.maxRating,_loc2_);
            this.minRating = Math.min(this.minRating,_loc2_);
            _loc3_ = Math.ceil(Math.min(Math.max(0,_loc2_ - 45),55) / 25 * 10);
            this.ratings.push(_loc3_);
         }
         else
         {
            this.ratings.push(param1);
         }
      }
      
      public function get averageRating() : Number
      {
         var _loc1_:Number = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this.ratings.length)
         {
            _loc1_ += this.ratings[_loc2_];
            _loc2_++;
         }
         return Math.max(0,Math.min(10,_loc1_ / this.ratings.length));
      }
      
      private function addToNum(param1:Number, param2:Number) : Number
      {
         return Math.min(10,Math.max(0,param2 + 5 / Math.max(1,Math.abs(5 - param2) * 5) * param1));
      }
      
      public function get baseRow() : int
      {
         return this._baseRow;
      }
      
      public function set baseRow(param1:int) : void
      {
         this._baseRow = this.row = param1;
      }
      
      public function get baseColumn() : int
      {
         return this._baseColumn;
      }
      
      public function set baseColumn(param1:int) : void
      {
         this._baseColumn = this.column = param1;
      }
      
      public function get column() : int
      {
         return this._column;
      }
      
      public function set column(param1:int) : void
      {
         this._column = param1;
         this.x = param1 * MatchEngine.SQUARE_WIDTH;
      }
      
      public function get row() : int
      {
         return this._row;
      }
      
      public function set row(param1:int) : void
      {
         this._row = param1;
         this.y = param1 * MatchEngine.SQUARE_WIDTH;
      }
      
      public function get playerName() : String
      {
         return this.player.name;
      }
      
      public function setSquare() : void
      {
         this._column = int(this.x / MatchEngine.SQUARE_WIDTH);
         this._row = int(this.y / MatchEngine.SQUARE_WIDTH);
      }
      
      public function canPlay() : Boolean
      {
         return !this.injured && this.redCards <= 0;
      }
   }
}

