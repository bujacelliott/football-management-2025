package com.utterlySuperb.chumpManager.engine
{
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.Game;
   import com.utterlySuperb.chumpManager.model.dataObjects.Player;
   import com.utterlySuperb.chumpManager.model.dataObjects.StatusEffect;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.MatchAction;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.MatchDetails;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.MatchMessage;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.MatchPlayerDetails;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.MatchTeamDetails;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.PitchMap;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.PitchSector;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.PlayerInfluence;
   import com.utterlySuperb.chumpManager.view.ui.widgets.FormationDiagram;
   import com.utterlySuperb.events.BudgetEventProxy;
   import com.utterlySuperb.utils.MyMath;
   import flash.geom.Point;
   
   public class MatchHelper
   {
      
      private static var distanceSortPoint:Point;
      
      public static const PASS:int = 0;
      
      public static const DRIBBLE:int = 1;
      
      public static const CROSS:int = 2;
      
      public static const SHOOT:int = 3;
      
      private static var POS_SCORES:Array = [1,0.8,0.7,0.5,0.4,0.6,0.1,0.3,0.4,0.05];
      
      public function MatchHelper()
      {
         super();
      }
      
      public static function getMatchCopy(param1:String, param2:Player = null, param3:Player = null, param4:MatchTeamDetails = null, param5:MatchTeamDetails = null) : String
      {
         var _loc6_:String = CopyManager.getCopy(param1 + Math.floor(Math.random() * CopyManager.matchCopyNumber[param1]));
         if(param2)
         {
            while(_loc6_.indexOf(CopyManager.PLAYER_NAME_REPLACE) >= 0)
            {
               _loc6_ = _loc6_.replace(CopyManager.PLAYER_NAME_REPLACE,param2.getLastName());
            }
         }
         if(param3)
         {
            while(_loc6_.indexOf(CopyManager.OTHER_PLAYER_NAME_REPLACE) >= 0)
            {
               _loc6_ = _loc6_.replace(CopyManager.OTHER_PLAYER_NAME_REPLACE,param3.getLastName());
            }
         }
         if(param4)
         {
            while(_loc6_.indexOf(CopyManager.CLUB_NAME_REPLACE) >= 0)
            {
               _loc6_ = _loc6_.replace(CopyManager.CLUB_NAME_REPLACE,param4.club.name);
            }
         }
         if(param5)
         {
            while(_loc6_.indexOf(CopyManager.OTHER_CLUB_NAME_REPLACE) >= 0)
            {
               _loc6_ = _loc6_.replace(CopyManager.OTHER_CLUB_NAME_REPLACE,param5.club.name);
            }
         }
         return _loc6_;
      }
      
      public static function getTeamNumber(param1:MatchTeamDetails, param2:MatchDetails) : int
      {
         return param1 == param2.team0 ? 0 : 1;
      }
      
      public static function makeSectors(param1:MatchDetails) : void
      {
         param1.pitchMap.reset();
         makeTeam0Sectors(param1.pitchMap,param1.team0);
         makeTeam1Sectors(param1.pitchMap,param1.team1);
      }
      
      public static function makeTeam0Sectors(param1:PitchMap, param2:MatchTeamDetails) : void
      {
         var _loc4_:int = 0;
         var _loc5_:PitchSector = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:Player = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc3_:int = 0;
         while(_loc3_ < PitchMap.NUM_COLUMNS)
         {
            _loc4_ = 0;
            while(_loc4_ < PitchMap.NUM_ROWS)
            {
               _loc5_ = param1.sectors[_loc3_][_loc4_];
               _loc6_ = (_loc3_ + 0.5) / PitchMap.NUM_COLUMNS * PitchMap.PITCH_WIDTH;
               _loc7_ = (_loc4_ + 0.5) / PitchMap.NUM_ROWS * PitchMap.PITCH_HEIGHT;
               _loc8_ = 1;
               while(_loc8_ < param2.players.length)
               {
                  _loc9_ = param2.players[_loc8_].player;
                  if(param2.players[_loc8_].canPlay())
                  {
                     _loc10_ = Number(param2.playerPositions[_loc8_].x);
                     _loc11_ = Number(param2.playerPositions[_loc8_].y);
                     if(Main.currentGame.matchDetails.matchSection % 2 == 0)
                     {
                     }
                     _loc10_ = PitchMap.PITCH_WIDTH - _loc10_;
                     _loc11_ = PitchMap.PITCH_HEIGHT - _loc11_;
                     _loc12_ = Math.max(2,MyMath.getDistance(_loc10_ - _loc6_,_loc11_ - _loc7_));
                     _loc13_ = 50 / Math.pow(_loc12_,1.3);
                     _loc13_ += _loc13_ * _loc9_.speed / 100;
                     _loc13_ += _loc13_ * 0.5 * _loc9_.stamina / 100;
                     _loc5_.addTeam0Player(param2.players[_loc8_],_loc13_);
                  }
                  _loc8_++;
               }
               _loc4_++;
            }
            _loc3_++;
         }
      }
      
      public static function makeTeam1Sectors(param1:PitchMap, param2:MatchTeamDetails) : void
      {
         var _loc4_:int = 0;
         var _loc5_:PitchSector = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:Player = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc3_:int = 0;
         while(_loc3_ < PitchMap.NUM_COLUMNS)
         {
            _loc4_ = 0;
            while(_loc4_ < PitchMap.NUM_ROWS)
            {
               _loc5_ = param1.sectors[_loc3_][_loc4_];
               _loc6_ = (_loc3_ + 0.5) / PitchMap.NUM_COLUMNS * PitchMap.PITCH_WIDTH;
               _loc7_ = (_loc4_ + 0.5) / PitchMap.NUM_ROWS * PitchMap.PITCH_HEIGHT;
               _loc8_ = 1;
               while(_loc8_ < param2.players.length)
               {
                  if(param2.players[_loc8_].canPlay())
                  {
                     _loc9_ = param2.players[_loc8_].player;
                     _loc10_ = Number(param2.playerPositions[_loc8_].x);
                     _loc11_ = Number(param2.playerPositions[_loc8_].y);
                     if(Main.currentGame.matchDetails.matchSection % 2 == 1)
                     {
                     }
                     _loc12_ = Math.max(2,MyMath.getDistance(_loc10_ - _loc6_,_loc11_ - _loc7_));
                     _loc13_ = 50 / Math.pow(_loc12_,1.3);
                     _loc13_ += _loc13_ * 1 * _loc9_.speed / 100;
                     _loc13_ += _loc13_ * 0.5 * _loc9_.stamina / 100;
                     _loc5_.addTeam1Player(param2.players[_loc8_],_loc13_);
                  }
                  _loc8_++;
               }
               _loc4_++;
            }
            _loc3_++;
         }
      }
      
      public static function getTeamKeeper(param1:MatchTeamDetails) : MatchPlayerDetails
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.players.length)
         {
            if(param1.players[_loc2_].player.isKeeper())
            {
               return param1.players[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public static function getPlayerInSector(param1:int, param2:int, param3:PitchMap, param4:int = 0, param5:MatchPlayerDetails = null, param6:int = 4) : MatchPlayerDetails
      {
         var _loc11_:int = 0;
         var _loc7_:PitchSector = param3.sectors[param1][param2];
         var _loc8_:Array = new Array();
         if(param4 == 0 || param4 == -1)
         {
            _loc11_ = 0;
            while(_loc11_ < _loc7_.team0Influence.length)
            {
               if(_loc7_.team0Influence[_loc11_].player != param5 && Boolean(_loc7_.team0Influence[_loc11_].player.canPlay()))
               {
                  _loc8_.push(_loc7_.team0Influence[_loc11_]);
               }
               _loc11_++;
            }
         }
         if(param4 == 1 || param4 == -1)
         {
            _loc11_ = 0;
            while(_loc11_ < _loc7_.team1Influence.length)
            {
               if(_loc7_.team1Influence[_loc11_].player != param5 && Boolean(_loc7_.team1Influence[_loc11_].player.canPlay()))
               {
                  _loc8_.push(_loc7_.team1Influence[_loc11_]);
               }
               _loc11_++;
            }
         }
         _loc8_.sort(bestInfluence);
         var _loc9_:Number = 0;
         _loc11_ = 0;
         while(_loc11_ < Math.min(_loc8_.length,param6))
         {
            if(_loc8_[_loc11_].player != param5)
            {
               _loc9_ += _loc8_[_loc11_].influence;
            }
            _loc11_++;
         }
         var _loc10_:Number = Math.random() * _loc9_;
         _loc9_ = 0;
         _loc11_ = 0;
         while(_loc11_ < _loc8_.length)
         {
            if(_loc8_[_loc11_].player != param5)
            {
               _loc9_ += _loc8_[_loc11_].influence;
               if(_loc9_ >= _loc10_)
               {
                  return _loc8_[_loc11_].player;
               }
            }
            _loc11_++;
         }
         throw new Error("getPlayerInsector null!");
      }
      
      private static function bestInfluence(param1:PlayerInfluence, param2:PlayerInfluence) : Number
      {
         if(param1.influence > param2.influence)
         {
            return -1;
         }
         if(param1.influence < param2.influence)
         {
            return 1;
         }
         return 1;
      }
      
      public static function getSector(param1:int, param2:int, param3:MatchDetails) : PitchSector
      {
         param1 = Math.max(0,Math.min(PitchMap.NUM_COLUMNS - 1,param1));
         param2 = Math.max(0,Math.min(PitchMap.NUM_ROWS - 1,param2));
         return param3.pitchMap.sectors[param1][param2];
      }
      
      public static function getSectorPlayerInfluence(param1:MatchPlayerDetails, param2:MatchDetails) : Number
      {
         var _loc3_:int = 0;
         while(_loc3_ < param2.currentSector.team0Influence.length)
         {
            if(param2.currentSector.team0Influence[_loc3_].player == param1)
            {
               return param2.currentSector.team0Influence[_loc3_].influence;
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < param2.currentSector.team1Influence.length)
         {
            if(param2.currentSector.team1Influence[_loc3_].player == param1)
            {
               return param2.currentSector.team1Influence[_loc3_].influence;
            }
            _loc3_++;
         }
         return 0;
      }
      
      public static function getSectorTeam(param1:int, param2:int, param3:MatchTeamDetails, param4:MatchDetails) : PitchSector
      {
         if(param3 == param4.team0)
         {
            return getSector(param1,param2,param4);
         }
         return convertSector(param1,param2,param4.pitchMap);
      }
      
      public static function getTeamSector(param1:PitchSector, param2:MatchDetails) : PitchSector
      {
         if(param2.playerIsInTeam0(param2.hasBall))
         {
            return param1;
         }
         return convertSector(param1.column,param1.row,param2.pitchMap);
      }
      
      public static function convertSector(param1:int, param2:int, param3:PitchMap) : PitchSector
      {
         param1 = Math.max(0,Math.min(PitchMap.NUM_COLUMNS - 1,param1));
         param2 = Math.max(0,Math.min(PitchMap.NUM_ROWS - 1,param2));
         return param3.sectors[PitchMap.NUM_COLUMNS - param1 - 1][PitchMap.NUM_ROWS - param2 - 1];
      }
      
      public static function makeFoul(param1:MatchDetails, param2:MatchPlayerDetails, param3:MatchPlayerDetails, param4:Number = 0, param5:Number = 0) : void
      {
         var _loc10_:MatchMessage = null;
         var _loc11_:StatusEffect = null;
         var _loc6_:PitchSector = getSectorTeam(param1.currentSector.column,param1.currentSector.row,param2.team,param1);
         var _loc7_:Number = param5;
         ++param2.foulsWon;
         ++param3.foulsConceeded;
         if(_loc6_.row == 0 && _loc6_.column == 2 && Math.random() > 0.6)
         {
            _loc10_ = new MatchMessage(MatchHelper.getMatchCopy(CopyManager.PENALTY_GIVEN,param2.player,param3.player,param1.teamWithBall,param1.teamWithBall));
            _loc10_.type = MatchAction.PENALTY;
            _loc10_.team = param1.teamWithBall.num;
            param1.messages.push(_loc10_);
            param1.lastMatchAction = new MatchAction(MatchAction.PENALTY_RUN_UP,param2);
            _loc7_ = 0.1;
            param1.hasBall = getPenaltyTaker(param2.team);
            param2.addToRating(11);
            param3.addToRating(-10);
         }
         else
         {
            _loc10_ = new MatchMessage(MatchHelper.getMatchCopy(CopyManager.FOUL_PLAYER,param2.player,param3.player,param1.teamWithBall,param1.teamWithBall));
            _loc10_.type = MatchAction.FREE_KICK;
            _loc10_.team = param1.teamWithBall.num;
            param1.messages.push(_loc10_);
            param1.lastMatchAction = new MatchAction(MatchAction.FREE_KICK,param2);
            param1.hasBall = getFreekickTaker(param2.team,param1);
            param3.addToRating(0);
         }
         var _loc8_:Number = param3.player.fitness / 85 + param3.player.stamina / 150;
         if(Math.random() + param4 > 0.98 || Math.random() > _loc8_)
         {
            _loc7_ += 0.1;
            _loc10_ = new MatchMessage(MatchHelper.getMatchCopy(CopyManager.INJURY,param2.player,param3.player));
            _loc10_.type = MatchEngine.INJURY;
            _loc10_.team = param2.team.num;
            param1.messages.push(_loc10_);
            if(param2.team.club == Main.currentGame.playerClub)
            {
               BudgetEventProxy.dispatchEvent(MatchEngine.MATCH_EVENT,{"event":MatchEngine.INJURY});
            }
            _loc11_ = new StatusEffect();
            _loc11_.type = StatusEffect.INJURY;
            _loc11_.time = 12 - int(Math.sqrt(Math.random() * Math.pow(12,2)));
            param2.player.statusEffects.push(_loc11_);
            param2.injured = true;
         }
         var _loc9_:Number = Math.random() + _loc7_ + param3.player.aggression / 500;
         if(_loc9_ > 1.11)
         {
            addStraightredCard(param3,param1);
         }
         else if(_loc9_ > 0.95)
         {
            addYellowCard(param3,param1);
         }
      }
      
      public static function addYellowCard(param1:MatchPlayerDetails, param2:MatchDetails) : void
      {
         var _loc4_:StatusEffect = null;
         var _loc3_:MatchMessage = new MatchMessage();
         _loc3_.team = param1.team.num;
         _loc3_.type = MatchEngine.YELLOW_CARD;
         if(param1.yellowCards == 0)
         {
            _loc3_.copy = MatchHelper.getMatchCopy(CopyManager.YELLOW_CARD,param1.player,null,param1.team);
            ++param1.yellowCards;
            param2.gameBreak = MatchEngine.YELLOW_CARD;
            BudgetEventProxy.dispatchEvent(MatchEngine.MATCH_EVENT,{"event":MatchEngine.YELLOW_CARD});
         }
         else
         {
            _loc3_.copy = MatchHelper.getMatchCopy(CopyManager.SECOND_YELLOW_CARD,param1.player,null,param1.team);
            ++param1.yellowCards;
            ++param1.redCards;
            _loc4_ = new StatusEffect();
            _loc4_.type = StatusEffect.SUSPENSION;
            _loc4_.time = 1;
            param1.player.statusEffects.push(_loc4_);
            param2.gameBreak = MatchEngine.RED_CARD;
            BudgetEventProxy.dispatchEvent(MatchEngine.MATCH_EVENT,{"event":MatchEngine.RED_CARD});
         }
         param1.addToRating(-40);
         param2.messages.push(_loc3_);
      }
      
      public static function addStraightredCard(param1:MatchPlayerDetails, param2:MatchDetails) : void
      {
         var _loc3_:MatchMessage = new MatchMessage();
         _loc3_.team = param1.team.num;
         _loc3_.type = MatchEngine.RED_CARD;
         var _loc4_:MatchTeamDetails = param1.team == param2.team0 ? param2.team1 : param2.team0;
         _loc3_.copy = MatchHelper.getMatchCopy(CopyManager.RED_CARD,param1.player,null,param1.team,_loc4_);
         param2.messages.push(_loc3_);
         ++param1.redCards;
         param2.gameBreak = MatchEngine.RED_CARD;
         var _loc5_:StatusEffect = new StatusEffect();
         _loc5_.type = StatusEffect.SUSPENSION;
         _loc5_.time = 3;
         param1.player.statusEffects.push(_loc5_);
         param1.addToRating(-90);
         BudgetEventProxy.dispatchEvent(MatchEngine.MATCH_EVENT,{"event":MatchEngine.RED_CARD});
         BudgetEventProxy.dispatchEvent(Game.DATA_CHANGED,null);
      }
      
      public static function getCornerTaker(param1:MatchTeamDetails) : MatchPlayerDetails
      {
         var _loc3_:MatchPlayerDetails = null;
         var _loc5_:Player = null;
         var _loc6_:Number = NaN;
         var _loc2_:Number = 0;
         var _loc4_:int = 0;
         while(_loc4_ < param1.players.length)
         {
            _loc5_ = param1.players[_loc4_].player;
            if(!_loc5_.isKeeper() && Boolean(param1.players[_loc4_].canPlay()))
            {
               _loc6_ = _loc5_.passing + _loc5_.crossing * 1.5 * _loc5_.creativity;
               if(_loc6_ > _loc2_)
               {
                  _loc2_ = _loc6_;
                  _loc3_ = param1.players[_loc4_];
               }
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function getFreekickTaker(param1:MatchTeamDetails, param2:MatchDetails) : MatchPlayerDetails
      {
         var _loc5_:MatchPlayerDetails = null;
         var _loc6_:int = 0;
         var _loc7_:Player = null;
         var _loc8_:Number = NaN;
         var _loc3_:PitchSector = getSectorTeam(param2.currentSector.column,param2.currentSector.row,param1,param2);
         var _loc4_:Number = 0;
         if(_loc3_.row > 2)
         {
            _loc6_ = 0;
            while(_loc6_ < param1.players.length)
            {
               _loc7_ = param1.players[_loc6_].player;
               if(!_loc7_.isKeeper() && Boolean(param1.players[_loc6_].canPlay()))
               {
                  _loc8_ = _loc7_.passing + _loc7_.crossing * 0.25 * _loc7_.creativity * 0.5;
                  if(_loc8_ > _loc4_)
                  {
                     _loc4_ = _loc8_;
                     _loc5_ = param1.players[_loc6_];
                  }
               }
               _loc6_++;
            }
         }
         else if(_loc3_.column == 0 || _loc3_.column == PitchMap.NUM_COLUMNS - 1)
         {
            _loc6_ = 0;
            while(_loc6_ < param1.players.length)
            {
               _loc7_ = param1.players[_loc6_].player;
               if(!_loc7_.isKeeper() && Boolean(param1.players[_loc6_].canPlay()))
               {
                  _loc8_ = _loc7_.passing + _loc7_.crossing * 2 * _loc7_.creativity * 0.5;
                  if(_loc8_ > _loc4_)
                  {
                     _loc4_ = _loc8_;
                     _loc5_ = param1.players[_loc6_];
                  }
               }
               _loc6_++;
            }
         }
         else
         {
            _loc6_ = 0;
            while(_loc6_ < param1.players.length)
            {
               _loc7_ = param1.players[_loc6_].player;
               if(!_loc7_.isKeeper() && Boolean(param1.players[_loc6_].canPlay()))
               {
                  _loc8_ = _loc7_.passing + _loc7_.shooting * _loc7_.creativity;
                  if(_loc8_ > _loc4_)
                  {
                     _loc4_ = _loc8_;
                     _loc5_ = param1.players[_loc6_];
                  }
               }
               _loc6_++;
            }
         }
         return _loc5_;
      }
      
      public static function getPenaltyTaker(param1:MatchTeamDetails) : MatchPlayerDetails
      {
         var _loc3_:MatchPlayerDetails = null;
         var _loc5_:Player = null;
         var _loc6_:Number = NaN;
         var _loc2_:Number = 0;
         var _loc4_:int = 0;
         while(_loc4_ < param1.players.length)
         {
            _loc5_ = param1.players[_loc4_].player;
            if(!_loc5_.isKeeper() && Boolean(param1.players[_loc4_].canPlay()))
            {
               _loc6_ = _loc5_.shooting;
               if(_loc6_ > _loc2_)
               {
                  _loc2_ = _loc6_;
                  _loc3_ = param1.players[_loc4_];
               }
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function getPassInterceptionInSector(param1:MatchTeamDetails, param2:PitchSector) : Number
      {
         var _loc6_:Player = null;
         var _loc3_:Array = getPlayerInfluence(param2,param1);
         var _loc4_:Number = 0;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.length)
         {
            _loc6_ = _loc3_[_loc5_].player.player;
            if(_loc6_.isKeeper())
            {
               _loc4_ += _loc3_[_loc5_].influence * (_loc6_.catching * 2);
            }
            else
            {
               _loc4_ += _loc3_[_loc5_].influence * (_loc6_.tackling + _loc6_.heading + _loc6_.strength / 2);
            }
            _loc5_++;
         }
         return _loc4_ * 0.7 + 0.3 * _loc4_ * (10 - param1.formation.attackingScore) / 10;
      }
      
      public static function getTeamInfluenceInSector(param1:MatchTeamDetails, param2:PitchSector) : Number
      {
         var _loc3_:Array = getPlayerInfluence(param2,param1);
         var _loc4_:Number = 0;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.length)
         {
            _loc4_ += _loc3_[_loc5_].influence;
            _loc5_++;
         }
         return _loc4_;
      }
      
      public static function getCrossInterceptionInSector(param1:MatchTeamDetails, param2:PitchSector) : Number
      {
         var _loc6_:Player = null;
         var _loc3_:Array = getPlayerInfluence(param2,param1);
         var _loc4_:Number = 0;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.length)
         {
            _loc6_ = _loc3_[_loc5_].player.player;
            if(_loc6_.isKeeper())
            {
               _loc4_ += _loc3_[_loc5_].influence * (_loc6_.catching * 4);
            }
            else
            {
               _loc4_ += _loc3_[_loc5_].influence * (_loc6_.tackling + _loc6_.heading * 2 + _loc6_.strength / 2 + _loc6_.aggression / 4);
            }
            _loc5_++;
         }
         return _loc4_ * 0.7 + 0.3 * _loc4_ * (10 - param1.formation.attackingScore) / 10;
      }
      
      public static function getTackleInSector(param1:MatchTeamDetails, param2:PitchSector) : Number
      {
         var _loc6_:Player = null;
         var _loc3_:Array = getPlayerInfluence(param2,param1);
         var _loc4_:Number = 0;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.length)
         {
            _loc6_ = _loc3_[_loc5_].player.player;
            if(_loc6_.isKeeper())
            {
               _loc4_ += _loc3_[_loc5_].influence * (_loc6_.catching + _loc6_.shotStopping);
            }
            else
            {
               _loc4_ += _loc3_[_loc5_].influence * (_loc6_.tackling * 2 + _loc6_.speed + _loc6_.strength + _loc6_.aggression / 2);
            }
            _loc5_++;
         }
         return _loc4_ * 0.7 + 0.3 * _loc4_ * (10 - param1.formation.attackingScore) / 10;
      }
      
      private static function getPlayerInfluence(param1:PitchSector, param2:MatchTeamDetails) : Array
      {
         return param2 == Main.currentGame.matchDetails.team0 ? param1.team0Influence : param1.team1Influence;
      }
      
      public static function getActionFactors(param1:int, param2:int) : Array
      {
         var _loc3_:Array = new Array(4);
         var _loc4_:int = MatchEngine.NUM_COLUMNS / 2 + MatchEngine.NUM_ROWS;
         var _loc5_:int = Math.abs(MatchEngine.NUM_COLUMNS / 2 - param1) + param2;
         var _loc6_:Number = (_loc4_ - _loc5_) / _loc4_;
         var _loc7_:Number = Math.min(param1,MatchEngine.NUM_COLUMNS - param1) / (MatchEngine.NUM_COLUMNS / 2);
         var _loc8_:Number = param2 / MatchEngine.NUM_ROWS;
         _loc3_[SHOOT] = Math.pow(2,1 + _loc6_ * 9 + _loc7_ * 1) / Math.pow(2,11);
         _loc3_[CROSS] = Math.pow(2,1 + _loc7_ * 5 + (1 - _loc8_) * 5) / Math.pow(2,11);
         _loc3_[PASS] = 0.5 + Math.pow(2,1 + _loc8_ * 10) / Math.pow(2,11) * 0.6;
         _loc3_[DRIBBLE] = 0.4 + Math.pow(2,1 + _loc8_ * 10) / Math.pow(2,11) * 0.3 + Math.pow(2,1 + _loc7_ * 10) / Math.pow(2,11) * 0.3;
         return _loc3_;
      }
      
      public static function getTeamWithBall(param1:MatchDetails) : MatchTeamDetails
      {
         return param1.playerIsInTeam0(param1.hasBall) ? param1.team0 : param1.team1;
      }
      
      public static function getTeamWithoutBall(param1:MatchDetails) : MatchTeamDetails
      {
         return !param1.playerIsInTeam0(param1.hasBall) ? param1.team0 : param1.team1;
      }
      
      public static function getOpposingTeam(param1:MatchDetails, param2:MatchPlayerDetails) : MatchTeamDetails
      {
         return param1.team1.players.indexOf(param2) >= 0 ? param1.team0 : param1.team1;
      }
      
      public static function positionPlayersForStart(param1:MatchDetails) : void
      {
         setTopStartFormation(param1.team1);
         setBottomStartFormation(param1.team0);
      }
      
      private static function setTopStartFormation(param1:MatchTeamDetails) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.players.length)
         {
            param1.players[_loc2_].column = MatchEngine.NUM_COLUMNS - 1 - param1.formation.positionsCol[_loc2_];
            param1.players[_loc2_].row = FormationDiagram.numRows - 1 - param1.formation.positionsRow[_loc2_];
            _loc2_++;
         }
      }
      
      private static function setBottomStartFormation(param1:MatchTeamDetails) : void
      {
         var _loc2_:int = MatchEngine.NUM_ROWS - FormationDiagram.numRows * 1.5;
         var _loc3_:int = 0;
         while(_loc3_ < param1.players.length)
         {
            param1.players[_loc3_].column = param1.formation.positionsCol[_loc3_];
            param1.players[_loc3_].row = param1.formation.positionsRow[_loc3_] + MatchEngine.NUM_ROWS / 2;
            _loc3_++;
         }
      }
      
      public static function getPlayersClosestToPoint(param1:Array, param2:Point) : Array
      {
         var _loc3_:Array = param1.slice();
         distanceSortPoint = param2;
         return _loc3_.sort(distanceSort);
      }
      
      private static function distanceSort(param1:MatchPlayerDetails, param2:MatchPlayerDetails) : Number
      {
         return new Point(distanceSortPoint.x - param1.x,distanceSortPoint.y - param1.y).length < new Point(distanceSortPoint.x - param2.x,distanceSortPoint.y - param2.y).length ? 1 : -1;
      }
      
      public static function playerDetailsToPlayers(param1:Array) : Array
      {
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.push(param1[_loc3_].player);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function playerToPlayerDetails(param1:Player, param2:Array) : MatchPlayerDetails
      {
         var _loc3_:MatchPlayerDetails = null;
         for each(_loc3_ in param2)
         {
            if(_loc3_.player == param1)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public static function getSubs(param1:Array, param2:Array) : Array
      {
         var _loc4_:MatchPlayerDetails = null;
         var _loc3_:Array = new Array();
         for each(_loc4_ in param1)
         {
            if(param2.indexOf(_loc4_) < 0)
            {
               _loc3_.push(_loc4_.player);
            }
         }
         return _loc3_;
      }
      
      public static function addTeamStaminaHalfTime(param1:Array, param2:Number = 1) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_].canPlay())
            {
               _loc4_ = 30 + 30 * (100 - param1[_loc3_].player.fitness) / 100;
               _loc5_ = _loc4_ * 0.25 * param2;
               param1[_loc3_].player.stamina = Math.min(param1[_loc3_].player.maxStamina,param1[_loc3_].player.stamina + _loc5_);
            }
            _loc3_++;
         }
      }
      
      public static function getLikelyScorer(param1:Array) : Player
      {
         var _loc5_:Number = NaN;
         var _loc2_:Number = 0;
         var _loc3_:Array = new Array();
         var _loc4_:int = 1;
         while(_loc4_ < param1.length)
         {
            _loc5_ = param1[_loc4_].isKeeper() ? 0 : param1[_loc4_].shooting + param1[_loc4_].heading * 0.6 + param1[_loc4_].creativity * 0.4 + param1[_loc4_].speed * 0.3 + param1[_loc4_].strength * 0.3 + param1[_loc4_].aggression * 0.2;
            if(_loc4_ > 10)
            {
               _loc5_ *= 0.3;
            }
            _loc5_ *= getPositionScoreFact(param1[_loc4_].positions);
            _loc2_ += _loc5_;
            _loc3_.push(_loc2_);
            _loc4_++;
         }
         _loc5_ = Math.random() * _loc2_;
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(_loc5_ < _loc3_[_loc4_])
            {
               return param1[_loc4_ + 1];
            }
            _loc4_++;
         }
         return param1[10];
      }
      
      private static function getPositionScoreFact(param1:String) : Number
      {
         var _loc2_:Number = 0;
         var _loc3_:Array = param1.split("-");
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.length)
         {
            _loc2_ += POS_SCORES[Player.POSITIONS.indexOf(_loc3_[_loc5_])];
            _loc5_++;
         }
         return _loc2_ / _loc3_.length;
      }
      
      public static function getPlayerRating(param1:Player) : Number
      {
         var _loc2_:MatchDetails = Main.currentGame.matchDetails;
         var _loc3_:MatchPlayerDetails = _loc2_.getPlayerDetails(param1);
         return _loc3_.averageRating;
      }
   }
}

