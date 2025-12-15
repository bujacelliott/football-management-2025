package com.utterlySuperb.chumpManager.model.dataObjects
{
   import com.utterlySuperb.chumpManager.engine.MatchEngine;
   import com.utterlySuperb.chumpManager.engine.PlayerHelper;
   import com.utterlySuperb.chumpManager.engine.TeamHelper;
   import com.utterlySuperb.chumpManager.view.ui.widgets.FormationDiagram;
   
   public class Formation
   {
      
      public static var FOUR42_A:String = "4-4-2_a";
      
      public static var FOUR42_B:String = "4-4-2_b";
      
      public static var THREE52_A:String = "3-5-2_a";
      
      public static var THREE52_B:String = "3-5-2_b";
      
      public static var FOUR33_A:String = "4-3-3_a";
      
      public static var FOUR33_B:String = "4-3-3_b";
      
      public static var FORMATIONS:Array = [FOUR42_A,FOUR42_B,THREE52_A,THREE52_B,FOUR33_A,FOUR33_B];
      
      public static var BALANCED:String = "balanced";
      
      public static var DEFENSE_FOCUSED:String = "defenseFocused";
      
      public static var ATTACK_FOCUSED:String = "attackFocused";
      
      public static var COUNTER_ATTACK:String = "counterAttack";
      
      public static var POSSESSION:String = "possession";
      
      public static var LONG_BALL:String = "longBall";
      
      public static var WINGS_AND_CROSS:String = "wingAndCross";
      
      public var positionsCol:Array;
      
      public var positionsRow:Array;
      
      public var prefferedPlayersID:Array;
      
      public var positionTypes:Array;
      
      public var attackingScore:int = 5;
      
      public function Formation()
      {
         super();
         this.positionsCol = new Array(11);
         this.positionsRow = new Array(11);
         this.prefferedPlayersID = new Array();
         this.positionTypes = new Array();
         this.positionsCol[0] = Math.floor(MatchEngine.NUM_COLUMNS / 2);
         this.positionsRow[0] = FormationDiagram.numRows - 1;
      }
      
      public static function getStandardFormation(param1:String) : Formation
      {
         var _loc2_:Formation = new Formation();
         _loc2_.setStandardFormation(param1);
         return _loc2_;
      }
      
      public function clone() : Formation
      {
         var _loc1_:Formation = new Formation();
         _loc1_.attackingScore = this.attackingScore;
         _loc1_.positionsCol = this.positionsCol.slice();
         _loc1_.positionsRow = this.positionsRow.slice();
         _loc1_.prefferedPlayersID = this.prefferedPlayersID.slice();
         _loc1_.positionTypes = this.positionTypes.slice();
         return _loc1_;
      }
      
      public function setPlayers(param1:Club) : void
      {
         var _loc2_:Array = null;
         if(this.prefferedPlayersID.length == 0)
         {
            _loc2_ = TeamHelper.getBestPlayers(this,param1.getPlayersList());
            this.setPrefferedPlayers(_loc2_);
         }
      }
      
      public function setStandardFormation(param1:String) : void
      {
         var _loc2_:int = FormationDiagram.numRows - FormationDiagram.numRows / 6;
         var _loc3_:int = FormationDiagram.numRows / 2 - 1;
         var _loc4_:int = 3;
         var _loc5_:int = MatchEngine.NUM_COLUMNS / 5;
         var _loc6_:int = MatchEngine.NUM_COLUMNS / 2;
         switch(param1)
         {
            case FOUR42_A:
               this.positionsCol[1] = _loc5_;
               this.positionsRow[1] = _loc2_;
               this.positionsCol[2] = _loc5_ * 2;
               this.positionsRow[2] = _loc2_;
               this.positionsCol[3] = _loc5_ * 3;
               this.positionsRow[3] = _loc2_;
               this.positionsCol[4] = _loc5_ * 4;
               this.positionsRow[4] = _loc2_;
               this.positionsCol[5] = _loc5_;
               this.positionsRow[5] = _loc3_;
               this.positionsCol[6] = _loc5_ * 2;
               this.positionsRow[6] = _loc3_;
               this.positionsCol[7] = _loc5_ * 3;
               this.positionsRow[7] = _loc3_;
               this.positionsCol[8] = _loc5_ * 4;
               this.positionsRow[8] = _loc3_;
               this.positionsCol[9] = _loc5_ * 2;
               this.positionsRow[9] = _loc4_;
               this.positionsCol[10] = _loc5_ * 3;
               this.positionsRow[10] = _loc4_;
               break;
            case FOUR42_B:
               this.positionsCol[1] = _loc5_;
               this.positionsRow[1] = _loc2_;
               this.positionsCol[2] = _loc5_ * 2;
               this.positionsRow[2] = _loc2_;
               this.positionsCol[3] = _loc5_ * 3;
               this.positionsRow[3] = _loc2_;
               this.positionsCol[4] = _loc5_ * 4;
               this.positionsRow[4] = _loc2_;
               this.positionsCol[5] = _loc6_;
               this.positionsRow[5] = _loc2_ - FormationDiagram.numRows / 6;
               this.positionsCol[6] = _loc5_;
               this.positionsRow[6] = _loc3_;
               this.positionsCol[7] = _loc5_ * 4;
               this.positionsRow[7] = _loc3_;
               this.positionsCol[8] = _loc6_;
               this.positionsRow[8] = _loc3_ - FormationDiagram.numRows / 6;
               this.positionsCol[9] = _loc5_ * 2;
               this.positionsRow[9] = _loc4_;
               this.positionsCol[10] = _loc5_ * 3;
               this.positionsRow[10] = _loc4_;
               break;
            case THREE52_A:
               _loc5_ = MatchEngine.NUM_COLUMNS / 4;
               this.positionsCol[1] = _loc5_;
               this.positionsRow[1] = _loc2_;
               this.positionsCol[2] = _loc5_ * 2;
               this.positionsRow[2] = _loc2_;
               this.positionsCol[3] = _loc5_ * 3;
               this.positionsRow[3] = _loc2_;
               _loc5_ = MatchEngine.NUM_COLUMNS / 6;
               this.positionsCol[4] = _loc6_;
               this.positionsRow[4] = _loc3_ - FormationDiagram.numRows / 6;
               this.positionsCol[5] = _loc6_ - 3;
               this.positionsRow[5] = _loc3_ + FormationDiagram.numRows / 6;
               this.positionsCol[6] = _loc6_ + 3;
               this.positionsRow[6] = _loc3_ + FormationDiagram.numRows / 6;
               this.positionsCol[7] = _loc5_;
               this.positionsRow[7] = _loc3_;
               this.positionsCol[8] = _loc5_ * 6;
               this.positionsRow[8] = _loc3_;
               this.positionsCol[9] = _loc6_ - 3;
               this.positionsRow[9] = _loc4_;
               this.positionsCol[10] = _loc6_ + 3;
               this.positionsRow[10] = _loc4_;
               break;
            case THREE52_B:
               _loc5_ = MatchEngine.NUM_COLUMNS / 4;
               this.positionsCol[1] = _loc5_;
               this.positionsRow[1] = _loc2_;
               this.positionsCol[2] = _loc5_ * 2;
               this.positionsRow[2] = _loc2_;
               this.positionsCol[3] = _loc5_ * 3;
               this.positionsRow[3] = _loc2_;
               _loc5_ = MatchEngine.NUM_COLUMNS / 6;
               this.positionsCol[4] = _loc6_;
               this.positionsRow[4] = _loc3_ + FormationDiagram.numRows / 6;
               this.positionsCol[5] = _loc6_ - 3;
               this.positionsRow[5] = _loc3_ - FormationDiagram.numRows / 8;
               this.positionsCol[6] = _loc6_ + 3;
               this.positionsRow[6] = _loc3_ - FormationDiagram.numRows / 8;
               this.positionsCol[7] = _loc5_;
               this.positionsRow[7] = _loc3_;
               this.positionsCol[8] = _loc5_ * 6;
               this.positionsRow[8] = _loc3_;
               this.positionsCol[9] = _loc6_ - 3;
               this.positionsRow[9] = _loc4_;
               this.positionsCol[10] = _loc6_ + 3;
               this.positionsRow[10] = _loc4_;
               break;
            case FOUR33_A:
               this.positionsCol[1] = _loc5_;
               this.positionsRow[1] = _loc2_;
               this.positionsCol[2] = _loc5_ * 2;
               this.positionsRow[2] = _loc2_;
               this.positionsCol[3] = _loc5_ * 3;
               this.positionsRow[3] = _loc2_;
               this.positionsCol[4] = _loc5_ * 4;
               this.positionsRow[4] = _loc2_;
               _loc5_ = MatchEngine.NUM_COLUMNS / 4;
               this.positionsCol[5] = _loc6_;
               this.positionsRow[5] = _loc3_;
               this.positionsCol[6] = _loc5_;
               this.positionsRow[6] = _loc3_;
               this.positionsCol[7] = _loc5_ * 3;
               this.positionsRow[7] = _loc3_;
               this.positionsCol[8] = _loc6_;
               this.positionsRow[8] = _loc4_;
               this.positionsCol[9] = _loc5_;
               this.positionsRow[9] = _loc4_ + 2;
               this.positionsCol[10] = _loc5_ * 3;
               this.positionsRow[10] = _loc4_ + 2;
               break;
            case FOUR33_B:
               this.positionsCol[1] = _loc5_;
               this.positionsRow[1] = _loc2_;
               this.positionsCol[2] = _loc5_ * 2;
               this.positionsRow[2] = _loc2_;
               this.positionsCol[3] = _loc5_ * 3;
               this.positionsRow[3] = _loc2_;
               this.positionsCol[4] = _loc5_ * 4;
               this.positionsRow[4] = _loc2_;
               _loc5_ = MatchEngine.NUM_COLUMNS / 4;
               this.positionsCol[5] = _loc6_;
               this.positionsRow[5] = _loc3_ - 4;
               this.positionsCol[6] = _loc5_ + 2;
               this.positionsRow[6] = _loc3_ + 4;
               this.positionsCol[7] = _loc5_ * 3 - 2;
               this.positionsRow[7] = _loc3_ + 4;
               this.positionsCol[8] = _loc6_;
               this.positionsRow[8] = _loc4_;
               this.positionsCol[9] = _loc5_ - 2;
               this.positionsRow[9] = _loc4_ + 3;
               this.positionsCol[10] = _loc5_ * 3 + 2;
               this.positionsRow[10] = _loc4_ + 3;
         }
      }
      
      public function setPositions() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         this.positionTypes[0] = "gk";
         var _loc1_:int = 1;
         while(_loc1_ < 11)
         {
            _loc2_ = 1 - this.positionsRow[_loc1_] / FormationDiagram.numRows;
            _loc3_ = Math.abs(this.positionsCol[_loc1_] - MatchEngine.NUM_COLUMNS / 2) / (MatchEngine.NUM_COLUMNS / 2);
            if(_loc2_ < 0.25)
            {
               if(_loc3_ > 0.5)
               {
                  this.positionTypes[_loc1_] = "fb";
               }
               else
               {
                  this.positionTypes[_loc1_] = "cb";
               }
            }
            else if(_loc2_ < 0.4)
            {
               if(_loc3_ > 0.5)
               {
                  this.positionTypes[_loc1_] = "wb";
               }
               else
               {
                  this.positionTypes[_loc1_] = "dm";
               }
            }
            else if(_loc2_ < 0.6)
            {
               if(_loc3_ > 0.5)
               {
                  this.positionTypes[_loc1_] = "sm";
               }
               else
               {
                  this.positionTypes[_loc1_] = "cm";
               }
            }
            else if(_loc2_ < 0.8)
            {
               if(_loc3_ > 0.5)
               {
                  this.positionTypes[_loc1_] = _loc2_ < 0.7 ? "sm" : "wf";
               }
               else
               {
                  this.positionTypes[_loc1_] = "am";
               }
            }
            else if(_loc3_ > 0.5)
            {
               this.positionTypes[_loc1_] = "wf";
            }
            else
            {
               this.positionTypes[_loc1_] = "cf";
            }
            _loc1_++;
         }
      }
      
      public function removeSoldPlayers(param1:Array) : void
      {
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:Array = null;
         var _loc8_:Player = null;
         var _loc2_:Array = this.getNonPlayingPlayers(param1,false);
         var _loc3_:int = 0;
         while(_loc3_ < this.prefferedPlayersID.length)
         {
            if(param1.indexOf(this.prefferedPlayersID[_loc3_]) < 0)
            {
               if(_loc3_ < 11)
               {
                  _loc6_ = this.positionTypes[_loc3_];
               }
               else
               {
                  _loc7_ = StaticInfo.getPlayer(this.prefferedPlayersID[_loc3_]).positions.split("-");
                  _loc6_ = _loc7_[int(Math.random() * _loc7_.length)];
               }
               _loc4_ = true;
               _loc5_ = 0;
               while(_loc5_ < _loc2_.length)
               {
                  if(_loc2_[_loc5_].positions == "gk" && _loc6_ == "gk" || _loc2_[_loc5_].positions != "gk" && _loc6_ != "gk")
                  {
                     _loc4_ = false;
                  }
                  _loc5_++;
               }
               if(_loc4_)
               {
                  _loc8_ = PlayerHelper.getYouthPlayer(_loc6_);
               }
               else
               {
                  _loc8_ = TeamHelper.getBestPlayerInPosition(_loc2_,_loc6_,false);
                  if(_loc2_.indexOf(_loc8_) >= 0)
                  {
                     _loc2_.splice(_loc2_.indexOf(_loc8_),1);
                  }
                  if(this.prefferedPlayersID.indexOf(_loc8_) > 10)
                  {
                     this.prefferedPlayersID.splice(this.prefferedPlayersID.indexOf(_loc8_.id),1);
                  }
               }
               this.prefferedPlayersID[_loc3_] = _loc8_.id;
            }
            _loc3_++;
         }
         TeamHelper.getSubstitutes(this.getPrefferedPlayers(),_loc2_,false);
      }
      
      public function removeIneligablePlayers(param1:Array) : void
      {
         var _loc4_:Player = null;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:Array = null;
         var _loc9_:Player = null;
         var _loc2_:Array = this.getNonPlayingPlayers(param1,true);
         var _loc3_:int = 0;
         while(_loc3_ < this.prefferedPlayersID.length)
         {
            _loc4_ = this.getPrefferedPlayer(_loc3_);
            if(_loc4_.hasInjury() || _loc4_.hasSuspension())
            {
               if(_loc3_ < 11)
               {
                  _loc7_ = this.positionTypes[_loc3_];
               }
               else
               {
                  _loc8_ = _loc4_.positions.split("-");
                  _loc7_ = _loc8_[int(Math.random() * _loc8_.length)];
               }
               _loc5_ = true;
               _loc6_ = 0;
               while(_loc6_ < _loc2_.length)
               {
                  if(_loc2_[_loc6_].positions == "gk" && _loc7_ == "gk" || _loc2_[_loc6_].positions != "gk" && _loc7_ != "gk")
                  {
                     _loc5_ = false;
                  }
                  _loc6_++;
               }
               if(_loc5_)
               {
                  _loc9_ = PlayerHelper.getYouthPlayer(_loc7_);
               }
               else
               {
                  _loc9_ = TeamHelper.getBestPlayerInPosition(_loc2_,_loc7_,true);
                  if(_loc2_.indexOf(_loc9_) >= 0)
                  {
                     _loc2_.splice(_loc2_.indexOf(_loc9_),1);
                  }
                  if(this.prefferedPlayersID.indexOf(_loc9_.id) > 10)
                  {
                     this.prefferedPlayersID.splice(this.prefferedPlayersID.indexOf(_loc9_.id),1);
                  }
               }
               this.setPrefferedPlayer(_loc9_,_loc3_);
            }
            _loc3_++;
         }
         this.setPrefferedPlayers(TeamHelper.getSubstitutes(this.getPrefferedPlayers(),_loc2_,true));
      }
      
      public function getNonPlayingPlayers(param1:Array, param2:Boolean) : Array
      {
         var _loc5_:int = 0;
         var _loc6_:Player = null;
         var _loc3_:Array = new Array();
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc5_ = int(this.prefferedPlayersID.indexOf(param1[_loc4_]));
            _loc6_ = StaticInfo.getPlayer(param1[_loc4_]);
            if((_loc5_ < 0 || _loc5_ > 11) && !(param2 && !_loc6_.canPlay))
            {
               _loc3_.push(_loc6_);
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function setPrefferedPlayer(param1:Player, param2:int) : void
      {
         this.prefferedPlayersID[param2] = param1.id;
      }
      
      public function getPrefferedPlayer(param1:int) : Player
      {
         return StaticInfo.getPlayer(this.prefferedPlayersID[param1]);
      }
      
      public function getPrefferedPlayers() : Array
      {
         var _loc1_:Array = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < this.prefferedPlayersID.length)
         {
            _loc1_.push(StaticInfo.getPlayer(this.prefferedPlayersID[_loc2_]));
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function setPrefferedPlayers(param1:Array) : void
      {
         this.prefferedPlayersID = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            this.setPrefferedPlayer(param1[_loc2_],_loc2_);
            _loc2_++;
         }
      }
   }
}

