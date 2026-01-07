package com.utterlySuperb.chumpManager.engine
{
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.Formation;
   import com.utterlySuperb.chumpManager.model.dataObjects.Game;
   import com.utterlySuperb.chumpManager.model.dataObjects.Player;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.Match;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.MatchAction;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.MatchDetails;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.MatchMessage;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.MatchPlayerDetails;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.MatchTeamDetails;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.PitchMap;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.PitchSector;
   import com.utterlySuperb.events.BudgetEventProxy;
   import com.utterlySuperb.utils.MyMath;
   import flash.geom.Point;
   
   public class MatchEngine
   {
      
      public static var topGoalPoint:Point;
      
      public static var bottomGoalPoint:Point;
      
      public static const BEFORE_GAME:String = "beforeGame";
      
      public static const HALF_TIME:String = "halfTime";
      
      public static const HALF_TIME_2:String = "halfTime2";
      
      public static const HALF_TIME_3:String = "halfTime3";
      
      public static const FULL_TIME:String = "fullTime";
      
      public static const GOAL:String = "goal";
      
      public static const RED_CARD:String = "redCard";
      
      public static const YELLOW_CARD:String = "yellowCard";
      
      public static const INJURY:String = "injury";
      
      public static const SUBSTITUTION:String = "substitution";
      
      public static const PENALTIES:String = "penalities";
      
      public static const MATCH_EVENT:String = "matchEvent";
      
      public static const ACTION_INT:int = 30;
      
      public static const NUM_ROWS:int = 70;
      
      public static const NUM_COLUMNS:int = 41;
      
      public static const SQUARE_WIDTH:int = 20;
      
      public static var pitchWidth:int = NUM_COLUMNS * SQUARE_WIDTH;
      
      public static var pitchHeight:int = NUM_ROWS * SQUARE_WIDTH;
      
      public function MatchEngine()
      {
         super();
      }
      
      public static function initMatch(param1:Game) : void
      {
         var _loc2_:MatchDetails = param1.matchDetails;
         _loc2_.init();
         _loc2_.setPositions();
      }
      
      public static function startMatch(param1:Game) : void
      {
         var _loc2_:MatchDetails = param1.matchDetails;
         _loc2_.time = _loc2_.extraTime = _loc2_.lastAction = 0;
         MatchHelper.positionPlayersForStart(_loc2_);
         _loc2_.setPositions();
         MatchHelper.makeSectors(_loc2_);
         _loc2_.teamToRestart = _loc2_.matchSection % 2 == 0 ? _loc2_.team0 : _loc2_.team1;
         _loc2_.hasBall = MatchHelper.getPlayerInSector(2,3,_loc2_.pitchMap,_loc2_.teamToRestart.num,MatchHelper.getTeamKeeper(_loc2_.teamToRestart),3);
         if(_loc2_.gameBreak == MatchEngine.HALF_TIME)
         {
            ++_loc2_.matchSection;
            switch(_loc2_.matchSection)
            {
               case 1:
                  _loc2_.messages.push(new MatchMessage(MatchHelper.getMatchCopy(CopyManager.SECOND_HALF_START,_loc2_.hasBall.player)));
                  break;
               case 2:
                  _loc2_.messages.push(new MatchMessage(MatchHelper.getMatchCopy(CopyManager.FIRST_EXTRA_TIME_START,_loc2_.hasBall.player)));
                  break;
               case 3:
                  _loc2_.messages.push(new MatchMessage(MatchHelper.getMatchCopy(CopyManager.SECOND_EXTRA_TIME_START,_loc2_.hasBall.player)));
            }
         }
         else
         {
            _loc2_.messages.push(new MatchMessage(MatchHelper.getMatchCopy(CopyManager.MATCH_STARTED,_loc2_.hasBall.player)));
         }
         _loc2_.gameBreak = null;
         kickOffMatch(_loc2_);
      }
      
      public static function restartMatchGoal() : void
      {
         var _loc1_:MatchDetails = Main.currentGame.matchDetails;
         _loc1_.hasBall = MatchHelper.getPlayerInSector(2,3,_loc1_.pitchMap,_loc1_.teamToRestart.num,MatchHelper.getTeamKeeper(_loc1_.teamToRestart),3);
         kickOffMatch(_loc1_);
         _loc1_.gameBreak = null;
      }
      
      private static function kickOffMatch(param1:MatchDetails) : void
      {
         MatchHelper.positionPlayersForStart(param1);
         MatchHelper.makeSectors(param1);
         param1.lastMatchAction = new MatchAction(MatchAction.KICK_OFF);
         param1.currentSector = param1.pitchMap.sectors[2][3];
      }
      
      public static function processMatch(param1:Game) : void
      {
         var _loc6_:String = null;
         var _loc2_:MatchDetails = param1.matchDetails;
         var _loc3_:int = _loc2_.time + Main.instance.settings.gameSpeed;
         _loc2_.time += Main.instance.settings.gameSpeed;
         var _loc4_:Boolean = false;
         var _loc5_:* = true;
         while(_loc3_ > _loc2_.lastAction + ACTION_INT && _loc5_)
         {
            _loc4_ = true;
            _loc2_.time = _loc2_.lastAction + ACTION_INT;
            _loc2_.lastAction += ACTION_INT;
            doStamina(_loc2_);
            _loc5_ = !makeAction(_loc2_);
         }
         if(!_loc4_)
         {
            _loc2_.time = _loc3_;
         }
         if(_loc2_.matchSection < 2)
         {
            if((_loc2_.time - _loc2_.extraTime) / 60 > 45)
            {
               _loc6_ = _loc2_.matchSection == 0 ? HALF_TIME : FULL_TIME;
               if(_loc6_ == HALF_TIME)
               {
                  MatchHelper.addTeamStaminaHalfTime(_loc2_.team0.players);
                  MatchHelper.addTeamStaminaHalfTime(_loc2_.team1.players);
                  _loc2_.messages.push(new MatchMessage(MatchHelper.getMatchCopy(CopyManager.FIRST_HALF_END)));
               }
               else if(_loc2_.match.needsWinner && _loc2_.team0.getGoals() == _loc2_.team1.getGoals())
               {
                  _loc6_ = HALF_TIME;
                  MatchHelper.addTeamStaminaHalfTime(_loc2_.team0.players,0.3);
                  MatchHelper.addTeamStaminaHalfTime(_loc2_.team1.players,0.3);
                  _loc2_.messages.push(new MatchMessage(MatchHelper.getMatchCopy(CopyManager.NOW_EXTRA_TIME)));
                  _loc2_.match.extraTimePlayed = true;
               }
               else
               {
                  _loc2_.messages.push(new MatchMessage(MatchHelper.getMatchCopy(CopyManager.GAME_OVER)));
               }
               param1.matchDetails.gameBreak = _loc6_;
               BudgetEventProxy.dispatchEvent(MATCH_EVENT,{"event":_loc6_});
            }
         }
         else if((param1.matchDetails.time - param1.matchDetails.extraTime) / 60 > 15)
         {
            _loc6_ = param1.matchDetails.matchSection == 2 ? HALF_TIME : FULL_TIME;
            if(_loc6_ == HALF_TIME)
            {
               MatchHelper.addTeamStaminaHalfTime(_loc2_.team0.players,0.3);
               MatchHelper.addTeamStaminaHalfTime(_loc2_.team1.players,0.3);
               Main.currentGame.matchDetails.messages.push(new MatchMessage(MatchHelper.getMatchCopy(CopyManager.FIRST_EXTRA_TIME_END)));
            }
            else if(_loc2_.team0.getGoals() != _loc2_.team1.getGoals())
            {
               _loc2_.messages.push(new MatchMessage(MatchHelper.getMatchCopy(CopyManager.SECOND_EXTRA_TIME_END)));
            }
            param1.matchDetails.gameBreak = _loc6_;
            BudgetEventProxy.dispatchEvent(MATCH_EVENT,{"event":_loc6_});
         }
         BudgetEventProxy.dispatchEvent(Game.DATA_CHANGED,null);
      }
      
      public static function makeAction(param1:MatchDetails) : void
      {
         var _loc4_:MatchMessage = null;
         var _loc2_:PitchSector = MatchHelper.getTeamSector(param1.currentSector,param1);
         var _loc3_:int = 0;
         switch(param1.lastMatchAction.action)
         {
            case MatchAction.GOAL_KICK:
               doAISubstitutions(param1);
               checkAITactics(param1);
               goalKick(param1);
               break;
            case MatchAction.KICK_OFF:
               doAISubstitutions(param1);
               checkAITactics(param1);
               kickOff(param1);
               break;
            case MatchAction.PASS:
               receivePass(param1);
               break;
            case MatchAction.PASS_FAIL:
               receivePass(param1);
               break;
            case MatchAction.THROW_IN:
               doAISubstitutions(param1);
               throwIn(param1);
               break;
            case MatchAction.CROSS_MADE:
               receiveMadeCross(param1);
               break;
            case MatchAction.CROSS_FAIL:
               crossFailed(param1);
               break;
            case MatchAction.CORNER:
               doAISubstitutions(param1);
               doCorner(param1);
               break;
            case MatchAction.FREE_KICK:
               doAISubstitutions(param1);
               checkAITactics(param1);
               doFreeKick(param1);
               break;
            case MatchAction.GOAL:
               makePlayerScore(param1);
               break;
            case MatchAction.SAVE:
               doSave(param1);
               break;
            case MatchAction.PENALTY_RUN_UP:
               _loc4_ = new MatchMessage(MatchHelper.getMatchCopy(CopyManager.PENALTY_RUN_UP,param1.hasBall.player));
               _loc4_.team = param1.teamWithBall.num;
               _loc4_.type = MatchAction.PENALTY;
               param1.messages.push(_loc4_);
               param1.lastMatchAction = new MatchAction(MatchAction.PENALTY);
               break;
            case MatchAction.PENALTY:
               doAISubstitutions(param1);
               doPenalty(param1);
         }
         MatchHelper.makeSectors(param1);
         doTeamRatings(param1);
      }
      
      private static function doTeamRatings(param1:MatchDetails) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.team0.players.length)
         {
            if(param1.team0.players[_loc2_].canPlay())
            {
               param1.team0.players[_loc2_].addToRating();
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < param1.team1.players.length)
         {
            if(param1.team1.players[_loc2_].canPlay())
            {
               param1.team1.players[_loc2_].addToRating();
            }
            _loc2_++;
         }
      }
      
      private static function kickOff(param1:MatchDetails) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:Number = Math.random();
         var _loc3_:PitchSector = MatchHelper.getTeamSector(param1.currentSector,param1);
         if(_loc2_ < 0.4)
         {
            attemptPass(param1.currentSector,param1,1.5);
         }
         else if(_loc2_ < 0.5)
         {
            _loc4_ = Math.random() > 0.3 ? _loc3_.column - 1 : _loc3_.column - 2;
            attemptPass(MatchHelper.getSectorTeam(_loc4_,_loc3_.row,param1.teamWithBall,param1),param1,1.5);
         }
         else if(_loc2_ < 0.6)
         {
            _loc4_ = Math.random() > 0.3 ? _loc3_.column + 1 : _loc3_.column + 2;
            attemptPass(MatchHelper.getSectorTeam(_loc4_,_loc3_.row,param1.teamWithBall,param1),param1,1.5);
         }
         else if(_loc2_ < 0.7)
         {
            _loc5_ = Math.random() > 0.3 ? _loc3_.row + 1 : _loc3_.row + 2;
            attemptPass(MatchHelper.getSectorTeam(_loc3_.column,_loc5_,param1.teamWithBall,param1),param1,1.5);
         }
         else if(_loc2_ < 0.8)
         {
            _loc5_ = Math.random() > 0.3 ? _loc3_.row + 1 : _loc3_.row + 2;
            _loc4_ = Math.random() > 0.3 ? _loc3_.column - 1 : _loc3_.column - 2;
            attemptPass(MatchHelper.getSectorTeam(_loc4_,_loc5_,param1.teamWithBall,param1),param1,1.5);
         }
         else if(_loc2_ < 0.9)
         {
            _loc5_ = Math.random() > 0.3 ? _loc3_.row + 1 : _loc3_.row + 2;
            _loc4_ = Math.random() > 0.3 ? _loc3_.column + 1 : _loc3_.column + 2;
            attemptPass(MatchHelper.getSectorTeam(_loc4_,_loc5_,param1.teamWithBall,param1),param1,1.5);
         }
         else
         {
            doMove(param1,0,0,0,0,1.5);
         }
      }
      
      private static function goalKick(param1:MatchDetails) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(Math.random() > 0.6)
         {
            _loc4_ = 1 + Math.floor(Math.random() * 3);
            _loc5_ = Math.floor(Math.random() * PitchMap.NUM_COLUMNS);
         }
         else
         {
            _loc4_ = 4 + Math.floor(Math.random() * 3);
            _loc5_ = Math.floor(Math.random() * PitchMap.NUM_COLUMNS);
         }
         var _loc2_:PitchSector = MatchHelper.getSector(_loc5_,_loc4_,param1);
         var _loc3_:PitchSector = MatchHelper.getTeamSector(_loc2_,param1);
         attemptPass(_loc3_,param1);
      }
      
      private static function throwIn(param1:MatchDetails) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(Math.random() > 0.3)
         {
            attemptPass(param1.currentSector,param1);
         }
         else
         {
            _loc2_ = Math.floor(Math.random() * 3) - 1 + param1.currentSector.column;
            _loc3_ = Math.floor(Math.random() * 3) - 1 + param1.currentSector.row;
            attemptPass(MatchHelper.getSector(_loc2_,_loc3_,param1),param1);
         }
      }
      
      private static function doCorner(param1:MatchDetails) : void
      {
         if(Math.random() > 0.9)
         {
            attemptPass(param1.currentSector,param1,1.5);
         }
         else
         {
            attemptCross(param1);
         }
      }
      
      private static function doFreeKick(param1:MatchDetails) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc2_:PitchSector = MatchHelper.getSectorTeam(param1.currentSector.column,param1.currentSector.row,param1.teamWithBall,param1);
         if(_loc2_.row > 4)
         {
            _loc3_ = _loc2_.row - getNumExpo(4);
            _loc4_ = getNumExpo(6);
            _loc5_ = Math.random() > 0.5 ? _loc2_.column + _loc4_ : _loc2_.column - _loc4_;
            _loc5_ = Math.min(PitchMap.NUM_COLUMNS - 1,Math.max(0,_loc5_));
            attemptPass(MatchHelper.getSectorTeam(_loc5_,_loc3_,param1.teamWithBall,param1),param1);
         }
         else if(_loc2_.row > 2)
         {
            _loc5_ = Math.floor(Math.random() * 3) - 1;
            _loc3_ = Math.random() > 0.7 ? 1 : 0;
            attemptPass(MatchHelper.getSectorTeam(_loc5_,_loc3_,param1.teamWithBall,param1),param1);
         }
         else if(_loc2_.column == 0 || _loc2_.column == PitchMap.NUM_COLUMNS - 1)
         {
            attemptCross(param1);
         }
         else
         {
            _loc6_ = MyMath.getDistance(_loc2_.column - 2,_loc2_.row);
            if(Math.random() * 4 > _loc6_)
            {
               attemptShot(param1,1.5);
            }
            else
            {
               attemptPass(MatchHelper.getSectorTeam(2,0,param1.teamWithBall,param1),param1);
            }
         }
      }
      
      private static function doPenalty(param1:MatchDetails) : void
      {
         var _loc3_:MatchMessage = null;
         var _loc4_:Number = NaN;
         var _loc5_:PitchSector = null;
         var _loc6_:int = 0;
         var _loc2_:MatchPlayerDetails = MatchHelper.getTeamKeeper(param1.teamWithoutBall);
         ++param1.hasBall.shotsOnTarget;
         if(Math.random() > 0.9 || _loc2_.player.shotStopping > param1.hasBall.player.shooting * 1.2)
         {
            _loc3_ = new MatchMessage(MatchHelper.getMatchCopy(CopyManager.PENALTY_SAVE,param1.hasBall.player,_loc2_.player));
            _loc3_.type = MatchAction.SAVE;
            _loc4_ = Math.random();
            if(_loc4_ > 0.6)
            {
               param1.hasBall = _loc2_;
               param1.lastMatchAction = new MatchAction(MatchAction.GOAL_KICK);
            }
            else if(_loc4_ > 0.45)
            {
               param1.hasBall = MatchHelper.getPlayerInSector(param1.currentSector.column,param1.currentSector.row,param1.pitchMap,MatchHelper.getTeamNumber(param1.teamWithBall,param1));
               param1.lastMatchAction = new MatchAction(MatchAction.PASS);
            }
            else if(_loc4_ > 0.2)
            {
               param1.hasBall = MatchHelper.getPlayerInSector(param1.currentSector.column,param1.currentSector.row,param1.pitchMap,MatchHelper.getTeamNumber(param1.teamWithoutBall,param1));
               param1.lastMatchAction = new MatchAction(MatchAction.PASS);
            }
            else
            {
               param1.hasBall = MatchHelper.getCornerTaker(param1.teamWithBall);
               param1.lastMatchAction = new MatchAction(MatchAction.CORNER);
               _loc5_ = MatchHelper.getTeamSector(param1.currentSector,param1);
               _loc6_ = Math.random() > 0.5 ? 0 : PitchMap.NUM_COLUMNS - 1;
               param1.currentSector = MatchHelper.getSectorTeam(_loc6_,_loc5_.row,param1.teamWithBall,param1);
            }
         }
         else
         {
            _loc3_ = new MatchMessage(MatchHelper.getMatchCopy(CopyManager.PENALTY_SCORE,param1.hasBall.player,_loc2_.player));
            makePlayerScore(param1);
            _loc3_.type = MatchAction.GOAL;
         }
         _loc3_.team = param1.teamWithBall.num;
         param1.messages.push(_loc3_);
      }
      
      private static function doSave(param1:MatchDetails) : void
      {
         var _loc4_:MatchMessage = null;
         var _loc5_:int = 0;
         var _loc2_:MatchPlayerDetails = MatchHelper.getTeamKeeper(param1.teamWithoutBall);
         ++_loc2_.saves;
         var _loc3_:MatchPlayerDetails = param1.hasBall;
         if(Math.random() > 0.6)
         {
            _loc4_ = new MatchMessage(MatchHelper.getMatchCopy(CopyManager.SAVE_TO_CORNER,_loc2_.player,param1.hasBall.player,_loc2_.team));
            _loc5_ = Math.random() > 0.5 ? 0 : PitchMap.NUM_COLUMNS - 1;
            param1.currentSector = MatchHelper.getSectorTeam(_loc5_,0,param1.teamWithBall,param1);
            param1.hasBall = MatchHelper.getCornerTaker(param1.teamWithBall);
            param1.lastMatchAction = new MatchAction(MatchAction.CORNER);
         }
         else
         {
            _loc4_ = new MatchMessage(MatchHelper.getMatchCopy(CopyManager.SAVE_TO_COLLECT,_loc2_.player,_loc3_.player,_loc2_.team));
            param1.hasBall = MatchHelper.getTeamKeeper(param1.teamWithoutBall);
            param1.lastMatchAction = new MatchAction(MatchAction.GOAL_KICK);
         }
         _loc4_.type = MatchAction.SAVE;
         _loc4_.team = _loc3_.team.num;
         param1.messages.push(_loc4_);
      }
      
      private static function receivePass(param1:MatchDetails) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc2_:PitchSector = MatchHelper.getTeamSector(param1.currentSector,param1);
         if(_loc2_.row >= 5)
         {
            if(Math.random() > 0.3 || param1.hasBall.player.isKeeper())
            {
               _loc3_ = _loc2_.row - getNumExpo(4);
               _loc4_ = getNumExpo(6);
               _loc5_ = Math.random() > 0.5 ? _loc2_.column + _loc4_ : _loc2_.column - _loc4_;
               _loc5_ = Math.min(PitchMap.NUM_COLUMNS - 1,Math.max(0,_loc5_));
               attemptPass(MatchHelper.getSectorTeam(_loc5_,_loc3_,param1.teamWithBall,param1),param1);
            }
            else
            {
               _loc4_ = Math.floor(Math.random() * 2) - 1;
               _loc6_ = Math.random() > 0.2 ? 1 : 0;
               _loc7_ = Math.min(PitchMap.NUM_COLUMNS - 1,Math.max(0,_loc2_.column + _loc4_));
               attemptDribble(MatchHelper.getSectorTeam(_loc7_,_loc2_.row - _loc6_,param1.teamWithBall,param1),param1,1.5);
            }
         }
         else if(_loc2_.row >= 3)
         {
            _loc8_ = param1.hasBall.player.dribbling > param1.hasBall.player.passing ? 0.2 : 0;
            if(Math.random() + _loc8_ > 0.6)
            {
               _loc4_ = Math.floor(Math.random() * 2) - 1;
               _loc9_ = Math.random();
               if(_loc9_ < 0.4)
               {
                  _loc6_ = 0;
               }
               else if(_loc9_ < 0.8)
               {
                  _loc6_ = 1;
               }
               else
               {
                  _loc6_ = -1;
               }
               _loc7_ = Math.min(PitchMap.NUM_COLUMNS - 1,Math.max(0,_loc2_.column + _loc4_));
               attemptDribble(MatchHelper.getSectorTeam(_loc7_,_loc2_.row - _loc6_,param1.teamWithBall,param1),param1);
            }
            else
            {
               _loc4_ = getNumExpo(6);
               _loc10_ = Math.max(0,(param1.hasBall.player.passing - 50) / 250);
               _loc9_ = Math.random() + _loc10_;
               if(_loc9_ < 0.4)
               {
                  _loc6_ = getNumExpo(2);
               }
               else
               {
                  _loc6_ = getNumExpo(3);
               }
               attemptPass(MatchHelper.getSectorTeam(_loc2_.row + _loc6_,_loc2_.row - _loc6_,param1.teamWithBall,param1),param1);
            }
         }
         else if(_loc2_.row == 2)
         {
            row2Action(param1);
         }
         else if(_loc2_.row == 1)
         {
            row1Action(param1);
         }
         else if(_loc2_.row == 0)
         {
            row0Action(param1);
         }
      }
      
      private static function row0Action(param1:MatchDetails, param2:Number = 1) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc3_:PitchSector = MatchHelper.getTeamSector(param1.currentSector,param1);
         if(_loc3_.column == 0 || _loc3_.column == PitchMap.NUM_COLUMNS - 1)
         {
            _loc4_ = Math.max(0,(param1.hasBall.player.crossing - 50) / 250);
            _loc5_ = Math.random();
            if(_loc5_ + _loc4_ > 0.4)
            {
               attemptCross(param1);
            }
            else if(_loc5_ > 0.2)
            {
               _loc6_ = _loc3_.column == 0 ? 0 : 1;
               doPass(param1,2,3,_loc6_,0.7);
            }
            else
            {
               _loc7_ = _loc3_.column == 0 ? 1 : -1;
               doMove(param1,0.1,_loc7_,0.1,0.2);
            }
         }
         else if(_loc3_.column == 2)
         {
            _loc8_ = getShootMult(param1.hasBall.player);
            _loc5_ = Math.random();
            if(_loc5_ + _loc8_ > 0.3)
            {
               attemptShot(param1);
            }
            else if(_loc5_ > 0.4)
            {
               doPass(param1,2,2,0.5,0.4);
            }
            else
            {
               doMove(param1,0.3,0,0.2,0.2);
            }
         }
         else
         {
            _loc8_ = getShootMult(param1.hasBall.player);
            _loc5_ = Math.random();
            if(_loc5_ + _loc8_ > 0.5)
            {
               attemptShot(param1);
            }
            else
            {
               _loc5_ = Math.random();
               if(_loc5_ > 0.67)
               {
                  attemptCross(param1);
               }
               else if(_loc5_ > 0.33)
               {
                  doPass(param1,4,2,0.5,0.4);
               }
               else
               {
                  doMove(param1,0.3,0,0.1,-0.3);
               }
            }
         }
      }
      
      private static function row1Action(param1:MatchDetails, param2:Number = 1) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc3_:PitchSector = MatchHelper.getTeamSector(param1.currentSector,param1);
         if(_loc3_.column == 0 || _loc3_.column == PitchMap.NUM_COLUMNS - 1)
         {
            _loc4_ = Math.max(0.1,(param1.hasBall.player.crossing - 50) / 250);
            _loc5_ = Math.random();
            if(_loc5_ + _loc4_ > 0.7)
            {
               attemptCross(param1);
            }
            else if(_loc5_ > 0.5)
            {
               doPass(param1,4,2,0.5,0.6);
            }
            else
            {
               doMove(param1,-0.1,0,0.2,-0.2);
            }
         }
         else if(_loc3_.column == 2)
         {
            _loc6_ = getShootMult(param1.hasBall.player);
            _loc5_ = Math.random();
            if(_loc5_ + _loc6_ > 0.5)
            {
               attemptShot(param1);
            }
            else if(_loc5_ > 0.5)
            {
               doPass(param1,4,2,0.5,0.6);
            }
            else
            {
               doMove(param1,0.1,0,0.2,-0.2);
            }
         }
         else
         {
            _loc6_ = getShootMult(param1.hasBall.player);
            _loc5_ = Math.random();
            if(_loc5_ + _loc6_ > 0.7)
            {
               attemptShot(param1);
            }
            else if(_loc5_ > 0.5)
            {
               if(_loc3_.column == 1)
               {
                  doPass(param1,4,2,0.2,0.7);
               }
               else
               {
                  doPass(param1,4,2,0.8,0.7);
               }
            }
            else if(_loc3_.column == 1)
            {
               doMove(param1,0.1,0.25,0.1,-0.25);
            }
            else
            {
               doMove(param1,0.1,0.25,0.1,-0.25);
            }
         }
      }
      
      private static function getShootMult(param1:Player) : Number
      {
         var _loc2_:Number = Math.max(0.1,(param1.shooting - 50) / 240);
         return 0.1;
      }
      
      private static function row2Action(param1:MatchDetails, param2:Number = 1) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc3_:PitchSector = MatchHelper.getTeamSector(param1.currentSector,param1);
         if(_loc3_.column == 0 || _loc3_.column == PitchMap.NUM_COLUMNS - 1)
         {
            _loc4_ = Math.max(0,(param1.hasBall.player.crossing - 50) / 250);
            _loc5_ = Math.random();
            if(_loc5_ + _loc4_ > 0.9)
            {
               attemptCross(param1);
            }
            else if(_loc5_ > 0.5)
            {
               doPass(param1,4,2,0.5,0.6);
            }
            else
            {
               doMove(param1,-0.1,0,0.2,-0.2);
            }
         }
         else if(_loc3_.column == 2)
         {
            _loc6_ = getShootMult(param1.hasBall.player);
            _loc5_ = Math.random();
            if(_loc5_ + _loc6_ > 0.7)
            {
               attemptShot(param1);
            }
            else if(_loc5_ > 0.4)
            {
               doPass(param1,4,2,0.5,0.6);
            }
            else
            {
               doMove(param1,0.1,0,0.2,-0.2);
            }
         }
         else
         {
            _loc5_ = Math.random();
            if(_loc5_ > 0.5)
            {
               doPass(param1,4,2,0.5,0.6);
            }
            else
            {
               doMove(param1,0.1,0,0.2,-0.2);
            }
         }
      }
      
      private static function doPass(param1:MatchDetails, param2:int, param3:int, param4:Number, param5:Number) : void
      {
         var _loc6_:PitchSector = MatchHelper.getTeamSector(param1.currentSector,param1);
         var _loc7_:Number = 0.4;
         var _loc8_:int = getNumExpo(4);
         var _loc9_:int = getNumExpo(2);
         var _loc10_:int = Math.random() > param4 ? _loc6_.column + _loc8_ : _loc6_.column - _loc8_;
         var _loc11_:int = Math.random() > param5 + _loc7_ ? _loc6_.row + _loc9_ : _loc6_.row - _loc9_;
         attemptPass(MatchHelper.getSectorTeam(_loc10_,_loc11_,param1.teamWithBall,param1),param1);
      }
      
      private static function doMove(param1:MatchDetails, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Number = 0, param6:Number = 1) : void
      {
         var _loc7_:int = param1.currentSector.column;
         var _loc8_:int = param1.currentSector.row;
         var _loc9_:Number = Math.random();
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         if(_loc9_ + param2 > 0.4)
         {
            _loc9_ = Math.random();
            if(_loc9_ + param3 > 0.5)
            {
               _loc10_ = 1;
            }
            else
            {
               _loc10_ = -1;
            }
         }
         _loc9_ = Math.random();
         if(_loc9_ + param4 > 0.4)
         {
            if(_loc9_ + param5 > 0.6)
            {
               _loc11_ = 1;
            }
            else
            {
               _loc11_ = -1;
            }
         }
         attemptDribble(MatchHelper.getSector(_loc7_ + _loc10_,_loc8_ + _loc11_,param1),param1,param6);
      }
      
      private static function attemptPass(param1:PitchSector, param2:MatchDetails, param3:Number = 1) : void
      {
         var _loc11_:MatchMessage = null;
         var _loc12_:MatchPlayerDetails = null;
         var _loc13_:int = 0;
         var _loc4_:PitchSector = MatchHelper.getTeamSector(param2.currentSector,param2);
         var _loc5_:Number = MyMath.getDistance(param1.column - param2.currentSector.column,param1.row - param2.currentSector.row);
         var _loc6_:Number = Math.pow(_loc5_,2.2);
         var _loc7_:Number = MatchHelper.getPassInterceptionInSector(param2.teamWithoutBall,param1);
         _loc6_ += Math.pow(_loc7_,0.63) - 10;
         _loc6_ = _loc6_ * 0.7 + _loc6_ * 0.3 * Math.random();
         var _loc8_:MatchPlayerDetails = MatchHelper.getPlayerInSector(param1.column,param1.row,param2.pitchMap,MatchHelper.getTeamNumber(param2.teamWithBall,param2),param2.hasBall);
         var _loc9_:Number = param2.hasBall.player.isKeeper() ? param2.hasBall.player.distribution : param2.hasBall.player.passing + param2.hasBall.player.creativity * 0.5 * Math.random();
         var _loc10_:Number = Math.max(Math.pow(MatchHelper.getTeamInfluenceInSector(param2.teamWithBall,_loc4_),0.28) - 0.2,1);
         _loc9_ *= _loc10_;
         _loc9_ = _loc9_ * getEqualizer(param2,param2.teamWithBall);
         param2.currentSector = param1;
         if(_loc6_ < _loc9_ * param3)
         {
            _loc11_ = new MatchMessage();
            _loc11_.type = MatchAction.PASS;
            param2.lastPasser = param2.hasBall;
            switch(param2.lastMatchAction.action)
            {
               case MatchAction.KICK_OFF:
                  _loc11_.copy = MatchHelper.getMatchCopy(CopyManager.KICK_OFF_MADE,param2.hasBall.player,_loc8_.player);
                  _loc11_.type = MatchAction.KICK_OFF;
                  break;
               case MatchAction.FREE_KICK:
                  _loc11_.copy = MatchHelper.getMatchCopy(CopyManager.FREE_KICK_PASS,param2.hasBall.player,_loc8_.player,param2.teamWithBall);
                  _loc11_.type = MatchAction.FREE_KICK;
                  break;
               default:
                  if(_loc5_ < 3)
                  {
                     _loc11_.copy = MatchHelper.getMatchCopy(CopyManager.SHORT_PASS,param2.hasBall.player,_loc8_.player,param2.teamWithBall);
                     break;
                  }
                  _loc11_.copy = MatchHelper.getMatchCopy(CopyManager.LONG_PASS,param2.hasBall.player,_loc8_.player,param2.teamWithBall);
            }
            _loc11_.team = param2.teamWithBall.num;
            param2.messages.push(_loc11_);
            param2.lastMatchAction = new MatchAction(MatchAction.PASS,param2.hasBall);
            ++param2.hasBall.passesSuceeded;
            param2.hasBall = _loc8_;
         }
         else
         {
            param2.lastPasser = null;
            _loc12_ = MatchHelper.getPlayerInSector(param1.column,param1.row,param2.pitchMap,MatchHelper.getTeamNumber(param2.teamWithoutBall,param2),MatchHelper.getTeamKeeper(param2.teamWithoutBall));
            ++param2.hasBall.passesFailed;
            if(param1.column == 0 || param1.column == PitchMap.NUM_COLUMNS - 1 && Math.random() > 0.6)
            {
               _loc11_ = new MatchMessage(MatchHelper.getMatchCopy(CopyManager.GOES_THROW_IN,param2.hasBall.player,_loc8_.player));
               _loc11_.type = MatchAction.THROW_IN;
               _loc11_.team = param2.teamWithBall.num;
               param2.messages.push(_loc11_);
               param2.lastMatchAction = new MatchAction(MatchAction.THROW_IN,param2.hasBall);
               param2.hasBall = _loc12_;
            }
            else if(_loc4_.row == 0 && Math.random() > 0.5)
            {
               if(Math.random() > 0.7)
               {
                  _loc11_ = new MatchMessage(MatchHelper.getMatchCopy(CopyManager.PASS_TO_CORNER,param2.hasBall.player,_loc8_.player));
                  _loc11_.type = MatchAction.CORNER;
                  _loc11_.team = param2.teamWithBall.num;
                  param2.messages.push(_loc11_);
                  param2.hasBall = MatchHelper.getCornerTaker(param2.teamWithBall);
                  param2.lastMatchAction = new MatchAction(MatchAction.CORNER,param2.hasBall);
                  _loc13_ = _loc4_.column > 2 ? PitchMap.NUM_COLUMNS - 1 : 0;
                  if(_loc4_.column == 2)
                  {
                     _loc13_ = Math.random() > 0.5 ? PitchMap.NUM_COLUMNS - 1 : 0;
                  }
                  param2.currentSector = MatchHelper.getSectorTeam(_loc13_,_loc4_.row,param2.teamWithBall,param2);
               }
               else
               {
                  _loc11_ = new MatchMessage(MatchHelper.getMatchCopy(CopyManager.PASS_TO_OPP_GOALKICK,param2.hasBall.player,_loc8_.player));
                  _loc11_.type = MatchAction.CORNER;
                  _loc11_.team = param2.teamWithBall.num;
                  param2.messages.push(_loc11_);
                  param2.lastMatchAction = new MatchAction(MatchAction.GOAL_KICK,param2.hasBall);
                  param2.hasBall = MatchHelper.getTeamKeeper(param2.teamWithoutBall);
               }
            }
            else if(_loc4_.row == PitchMap.NUM_ROWS - 1 && Math.random() > 0.5)
            {
               if(Math.random() > 0.4)
               {
                  _loc11_ = new MatchMessage(MatchHelper.getMatchCopy(CopyManager.PASS_TO_GOALKICK,param2.hasBall.player,_loc8_.player));
                  _loc11_.type = MatchAction.GOAL_KICK;
                  _loc11_.team = param2.teamWithBall.num;
                  param2.messages.push(_loc11_);
                  param2.hasBall = MatchHelper.getTeamKeeper(param2.teamWithBall);
                  param2.lastMatchAction = new MatchAction(MatchAction.GOAL_KICK,param2.hasBall);
               }
               else
               {
                  _loc11_ = new MatchMessage(MatchHelper.getMatchCopy(CopyManager.PASS_TO_OPP_CORNER,param2.hasBall.player,_loc8_.player));
                  _loc11_.type = MatchAction.CORNER;
                  _loc11_.team = param2.teamWithBall.num;
                  param2.messages.push(_loc11_);
                  param2.lastMatchAction = new MatchAction(MatchAction.CORNER,param2.hasBall);
                  param2.hasBall = MatchHelper.getCornerTaker(param2.teamWithoutBall);
                  _loc4_ = MatchHelper.getTeamSector(param2.currentSector,param2);
                  _loc13_ = _loc4_.column > 2 ? PitchMap.NUM_COLUMNS - 1 : 0;
                  if(_loc4_.column == 2)
                  {
                     _loc13_ = Math.random() > 0.5 ? PitchMap.NUM_COLUMNS - 1 : 0;
                  }
                  param2.currentSector = MatchHelper.getSectorTeam(_loc13_,_loc4_.row,param2.teamWithBall,param2);
               }
            }
            else if(Math.random() > 0.95)
            {
               if(Math.random() > 0.4)
               {
                  MatchHelper.makeFoul(param2,param2.hasBall,_loc12_);
               }
               else
               {
                  MatchHelper.makeFoul(param2,_loc12_,param2.hasBall);
               }
            }
            else
            {
               _loc11_ = new MatchMessage(MatchHelper.getMatchCopy(CopyManager.PASS_FAIL,param2.hasBall.player,_loc8_.player));
               _loc11_.type = MatchAction.PASS_FAIL;
               _loc11_.team = param2.teamWithBall.num;
               param2.messages.push(_loc11_);
               param2.lastMatchAction = new MatchAction(MatchAction.PASS_FAIL,param2.hasBall);
               param2.hasBall = _loc12_;
               _loc11_ = new MatchMessage(MatchHelper.getMatchCopy(CopyManager.TAKE_POSSESSION,param2.hasBall.player,null,param2.teamWithBall));
               _loc11_.team = param2.teamWithBall.num;
               param2.messages.push(_loc11_);
            }
         }
      }
      
      private static function attemptDribble(param1:PitchSector, param2:MatchDetails, param3:Number = 1) : void
      {
         var _loc13_:MatchMessage = null;
         param2.currentSector = param1;
         var _loc4_:PitchSector = MatchHelper.getTeamSector(param2.currentSector,param2);
         var _loc5_:Number = MatchHelper.getTackleInSector(param2.teamWithoutBall,param1);
         var _loc6_:Number = Math.pow(_loc5_,0.58) - 16;
         var _loc7_:MatchPlayerDetails = MatchHelper.getPlayerInSector(param1.column,param1.row,param2.pitchMap,MatchHelper.getTeamNumber(param2.teamWithoutBall,param2),MatchHelper.getTeamKeeper(param2.teamWithoutBall));
         var _loc8_:Player = _loc7_.player;
         var _loc9_:Number = _loc6_ + _loc8_.tackling + _loc8_.strength / 2 + _loc8_.speed / 4 + _loc8_.aggression / 4 * Math.min(1.2,Math.max(0.5,MatchHelper.getSectorPlayerInfluence(_loc7_,param2)));
         _loc9_ = _loc9_ * 0.7 + _loc9_ * 0.3 * Math.random();
         var _loc10_:Number = 20 + param2.hasBall.player.dribbling + param2.hasBall.player.creativity / 2 + param2.hasBall.player.speed / 4 + param2.hasBall.player.strength / 4;
         var _loc11_:Number = Math.max(Math.pow(MatchHelper.getTeamInfluenceInSector(param2.teamWithBall,_loc4_),0.24) - 0.3,0.9);
         _loc10_ *= _loc11_;
         _loc10_ = _loc10_ * getEqualizer(param2,param2.teamWithBall);
         var _loc12_:* = "==DRIBBLE ATTEMPT==<br>Dribbler:" + param2.hasBall.playerName + "<br>interceptScore:" + _loc5_.toFixed(2) + "<br>";
         _loc12_ = _loc12_ + ("tackleDifficulty:" + _loc6_.toFixed(2) + "<br>tackleScore:" + _loc9_.toFixed(2) + "<br>playerScore:" + _loc10_.toFixed(2));
         if(Math.random() > 0.99)
         {
            _loc12_ += "<br>FOUL FROM RANDOM";
            MatchHelper.makeFoul(param2,param2.hasBall,_loc7_,0.1,-0.1);
         }
         else if(_loc10_ > _loc9_)
         {
            if(Math.random() < 0.7 - _loc4_.row / 10)
            {
               _loc13_ = new MatchMessage(MatchHelper.getMatchCopy(CopyManager.TACKLE_FAIL,param2.hasBall.player,_loc7_.player,param2.hasBall.team,_loc7_.team));
               _loc13_.team = param2.hasBall.team.num;
               _loc13_.type = CopyManager.TACKLE_FAIL;
               param2.messages.push(_loc13_);
               ++param2.hasBall.dribblesSucceeded;
            }
         }
         else if(Math.random() > 0.94)
         {
            _loc12_ += "<br>FOUL FROM FAIL";
            MatchHelper.makeFoul(param2,param2.hasBall,_loc7_,0.1,-0.1);
         }
         else
         {
            _loc13_ = new MatchMessage(MatchHelper.getMatchCopy(CopyManager.TACKLE_MADE,param2.hasBall.player,_loc7_.player,param2.hasBall.team,_loc7_.team));
            _loc13_.team = _loc7_.team.num;
            _loc13_.type = CopyManager.TACKLE_MADE;
            param2.messages.push(_loc13_);
            ++param2.hasBall.dribblesFailed;
            param2.hasBall = _loc7_;
         }
      }
      
      private static function attemptCross(param1:MatchDetails) : void
      {
         var _loc2_:PitchSector = MatchHelper.getTeamSector(param1.currentSector,param1);
         var _loc3_:int = 2;
         if(Math.random() > 0.5)
         {
            _loc3_ = Math.random() > 0.5 ? 1 : 3;
         }
         var _loc4_:PitchSector = MatchHelper.getSector(_loc3_,0,param1);
         _loc4_ = MatchHelper.getTeamSector(_loc4_,param1);
         var _loc5_:Number = MyMath.getDistance(_loc2_.column - _loc4_.column,_loc2_.row - _loc4_.row);
         var _loc6_:Number = Math.pow(_loc5_,2.2);
         var _loc7_:Number = MatchHelper.getCrossInterceptionInSector(param1.teamWithoutBall,_loc4_);
         _loc6_ += Math.pow(_loc7_,0.58) - 20;
         var _loc8_:int = 4;
         if(param1.lastMatchAction.action == MatchAction.CORNER || param1.lastMatchAction.action == MatchAction.FREE_KICK)
         {
            _loc8_ = 11;
         }
         var _loc9_:MatchPlayerDetails = MatchHelper.getPlayerInSector(_loc4_.column,_loc4_.row,param1.pitchMap,MatchHelper.getTeamNumber(param1.teamWithBall,param1),param1.hasBall,_loc8_);
         _loc6_ = _loc6_ * 0.8 + _loc6_ * 0.2 * Math.random();
         param1.currentSector = _loc4_;
         var _loc10_:MatchMessage = new MatchMessage(MatchHelper.getMatchCopy(CopyManager.CROSS_MADE,param1.hasBall.player));
         if(param1.lastMatchAction.action == MatchAction.CORNER)
         {
            _loc10_.copy = MatchHelper.getMatchCopy(CopyManager.CORNER,param1.hasBall.player,_loc9_.player,param1.hasBall.team);
         }
         _loc10_.team = param1.teamWithBall.num;
         _loc10_.type = MatchAction.CROSS;
         param1.messages.push(_loc10_);
         var _loc11_:Number = param1.hasBall.player.crossing + param1.hasBall.player.creativity * 0.2 + _loc9_.player.heading * 0.2;
         var _loc12_:Number = Math.max(Math.pow(MatchHelper.getTeamInfluenceInSector(param1.teamWithBall,_loc4_),0.21) - 0.4,0.8);
         _loc11_ *= _loc12_;
         _loc11_ = _loc11_ * getEqualizer(param1,param1.teamWithBall);
         if(_loc6_ < _loc11_)
         {
            param1.lastMatchAction = new MatchAction(MatchAction.CROSS_MADE,param1.hasBall);
            param1.lastPasser = param1.hasBall;
            param1.hasBall = _loc9_;
         }
         else
         {
            param1.lastMatchAction = new MatchAction(MatchAction.CROSS_FAIL,param1.hasBall);
            param1.lastPasser = null;
         }
      }
      
      private static function receiveMadeCross(param1:MatchDetails) : void
      {
         var _loc4_:MatchMessage = null;
         var _loc5_:Number = NaN;
         var _loc6_:MatchPlayerDetails = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc2_:MatchPlayerDetails = MatchHelper.getPlayerInSector(param1.currentSector.column,param1.currentSector.row,param1.pitchMap,MatchHelper.getTeamNumber(param1.teamWithoutBall,param1),MatchHelper.getTeamKeeper(param1.teamWithoutBall));
         var _loc3_:Player = param1.hasBall.player;
         if(Math.random() > 0.9)
         {
            attemptPass(param1.currentSector,param1,0.5);
         }
         else
         {
            _loc5_ = _loc3_.heading * 2.8 + _loc3_.shooting * 1.8 + _loc3_.creativity;
            _loc5_ += _loc5_ * Math.random();
            _loc6_ = MatchHelper.getTeamKeeper(param1.teamWithoutBall);
            if(Math.random() > 0.93)
            {
               _loc5_ -= 1000;
            }
            if(Math.random() > 0.9)
            {
               _loc5_ += 1000;
            }
            if(_loc5_ > 440)
            {
               _loc4_ = new MatchMessage(MatchHelper.getMatchCopy(CopyManager.AIR_SHOT,param1.hasBall.player,_loc2_.player));
               _loc4_.team = param1.teamWithBall.num;
               _loc4_.type = MatchAction.SHOT;
               param1.messages.push(_loc4_);
               ++param1.hasBall.shotsOnTarget;
               _loc7_ = _loc3_.heading * 0.9 + _loc3_.shooting * 0.6 + 50 * Math.random();
               _loc8_ = _loc6_.player.shotStopping * (1 + param1.teamWithBall.getGoals() * 0.1 + Math.random() * (1.7 + param1.teamWithBall.getGoals() * 0.2));
               _loc9_ = Math.random();
               if(_loc9_ > 0.97 || _loc8_ < _loc7_ && _loc9_ > 0.02)
               {
                  param1.lastMatchAction = new MatchAction(MatchAction.GOAL,param1.hasBall);
               }
               else
               {
                  param1.lastMatchAction = new MatchAction(MatchAction.SAVE,param1.hasBall);
               }
            }
            else
            {
               if(Math.random() > 0.45)
               {
                  _loc4_ = new MatchMessage(MatchHelper.getMatchCopy(CopyManager.SHOT_OVER,_loc3_));
               }
               else
               {
                  _loc4_ = new MatchMessage(MatchHelper.getMatchCopy(CopyManager.SHOT_WIDE,_loc3_));
               }
               ++param1.hasBall.shotsOffTarget;
               _loc4_.team = param1.hasBall.team.num;
               _loc4_.type = MatchAction.SHOT;
               param1.messages.push(_loc4_);
               param1.hasBall = _loc6_;
               param1.lastMatchAction = new MatchAction(MatchAction.GOAL_KICK,param1.hasBall);
            }
         }
      }
      
      private static function crossFailed(param1:MatchDetails) : void
      {
         var _loc4_:MatchPlayerDetails = null;
         var _loc5_:MatchPlayerDetails = null;
         var _loc6_:MatchPlayerDetails = null;
         var _loc7_:MatchMessage = null;
         var _loc2_:MatchPlayerDetails = MatchHelper.getTeamKeeper(param1.teamWithoutBall);
         var _loc3_:Number = Math.random() + _loc2_.player.catching / 120;
         if(Math.random() > 0.99)
         {
            _loc3_ = -1;
         }
         if(Math.random() > 0.98)
         {
            _loc4_ = MatchHelper.getPlayerInSector(param1.currentSector.column,param1.currentSector.row,param1.pitchMap,MatchHelper.getTeamNumber(param1.teamWithBall,param1),MatchHelper.getTeamKeeper(param1.teamWithBall));
            _loc5_ = MatchHelper.getPlayerInSector(param1.currentSector.column,param1.currentSector.row,param1.pitchMap,MatchHelper.getTeamNumber(param1.teamWithoutBall,param1));
            MatchHelper.makeFoul(param1,_loc5_,_loc4_,-0.2,-0.2);
         }
         else if(Math.random() > 0.98)
         {
            _loc5_ = MatchHelper.getPlayerInSector(param1.currentSector.column,param1.currentSector.row,param1.pitchMap,MatchHelper.getTeamNumber(param1.teamWithBall,param1),param1.hasBall);
            _loc4_ = MatchHelper.getPlayerInSector(param1.currentSector.column,param1.currentSector.row,param1.pitchMap,MatchHelper.getTeamNumber(param1.teamWithoutBall,param1),MatchHelper.getTeamKeeper(param1.teamWithoutBall));
            MatchHelper.makeFoul(param1,_loc5_,_loc4_,-0.2,-0.1);
         }
         else if(_loc3_ > 0.8)
         {
            param1.hasBall = _loc2_;
            _loc7_ = new MatchMessage(MatchHelper.getMatchCopy(CopyManager.KEEPER_CLAIM_CROSS,_loc2_.player));
            _loc7_.team = _loc2_.team.num;
            param1.messages.push(_loc7_);
            param1.lastMatchAction = new MatchAction(MatchAction.GOAL_KICK);
         }
         else if(_loc3_ > 0.4)
         {
            _loc6_ = MatchHelper.getPlayerInSector(param1.currentSector.column,param1.currentSector.row,param1.pitchMap,MatchHelper.getTeamNumber(param1.teamWithoutBall,param1));
            param1.hasBall = MatchHelper.getPlayerInSector(param1.currentSector.column,param1.currentSector.row,param1.pitchMap,MatchHelper.getTeamNumber(param1.teamWithoutBall,param1),_loc6_);
            _loc7_ = new MatchMessage(MatchHelper.getMatchCopy(CopyManager.HEADED_AWAY,_loc6_.player,param1.hasBall.player,_loc6_.team));
            _loc7_.team = _loc6_.team.num;
            param1.messages.push(_loc7_);
            param1.messages.push(_loc7_);
            param1.lastMatchAction = new MatchAction(MatchAction.PASS);
         }
         else
         {
            param1.hasBall = MatchHelper.getPlayerInSector(param1.currentSector.column,param1.currentSector.row,param1.pitchMap,MatchHelper.getTeamNumber(param1.teamWithBall,param1));
            param1.lastMatchAction = new MatchAction(MatchAction.PASS);
         }
      }
      
      private static function attemptShot(param1:MatchDetails, param2:Number = 1) : void
      {
         var _loc9_:MatchMessage = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Player = null;
         var _loc3_:MatchPlayerDetails = MatchHelper.getPlayerInSector(param1.currentSector.column,param1.currentSector.row,param1.pitchMap,MatchHelper.getTeamNumber(param1.teamWithoutBall,param1),MatchHelper.getTeamKeeper(param1.teamWithoutBall));
         var _loc4_:Player = param1.hasBall.player;
         var _loc5_:Number = _loc4_.heading * 0.9 + _loc4_.shooting * 2.8 + _loc4_.creativity * 1.2;
         _loc5_ += _loc5_ * Math.random();
         var _loc6_:MatchPlayerDetails = MatchHelper.getTeamKeeper(param1.teamWithoutBall);
         var _loc7_:PitchSector = MatchHelper.getTeamSector(param1.currentSector,param1);
         var _loc8_:Number = MyMath.getDistance(_loc7_.column - 2,_loc7_.row);
         _loc5_ -= _loc8_ * 20;
         if(Math.random() > 0.93)
         {
            _loc5_ -= 1000;
         }
         if(Math.random() > 0.9)
         {
            _loc5_ += 1000;
         }
         if(_loc5_ > 330)
         {
            _loc9_ = new MatchMessage(MatchHelper.getMatchCopy(CopyManager.PLAYER_SHOT,param1.hasBall.player,_loc3_.player));
            if(param1.lastMatchAction.action == MatchAction.FREE_KICK)
            {
               _loc13_ = MatchHelper.getPlayerInSector(param1.currentSector.column,param1.currentSector.row,param1.pitchMap,MatchHelper.getTeamNumber(param1.teamWithBall,param1),param1.hasBall).player;
               _loc9_.copy = MatchHelper.getMatchCopy(CopyManager.PLAYER_SHOT,param1.hasBall.player,_loc13_);
            }
            _loc9_.team = param1.teamWithBall.num;
            _loc9_.type = MatchAction.SHOT;
            param1.messages.push(_loc9_);
            ++param1.hasBall.shotsOnTarget;
            _loc10_ = _loc6_.player.shotStopping * (1 + param1.teamWithBall.getGoals() * 0.1 + Math.random() * (1.5 + param1.teamWithBall.getGoals() * 0.2));
            _loc11_ = _loc4_.shooting * (1.1 + Math.random()) + 10;
            _loc12_ = Math.random();
            if(_loc12_ > 0.97 || _loc10_ < _loc11_ && _loc12_ > 0.03)
            {
               param1.lastMatchAction = new MatchAction(MatchAction.GOAL,param1.hasBall);
            }
            else
            {
               param1.lastMatchAction = new MatchAction(MatchAction.SAVE,param1.hasBall);
            }
         }
         else
         {
            if(Math.random() > 0.45)
            {
               _loc9_ = new MatchMessage(MatchHelper.getMatchCopy(CopyManager.SHOT_OVER,_loc4_));
            }
            else
            {
               _loc9_ = new MatchMessage(MatchHelper.getMatchCopy(CopyManager.SHOT_WIDE,_loc4_));
            }
            ++param1.hasBall.shotsOffTarget;
            _loc9_.team = param1.hasBall.team.num;
            _loc9_.type = MatchAction.SHOT;
            param1.messages.push(_loc9_);
            param1.hasBall = _loc6_;
            param1.lastMatchAction = new MatchAction(MatchAction.GOAL_KICK,param1.hasBall);
         }
      }
      
      private static function getNumExpo(param1:int) : int
      {
         return param1 - int(Math.sqrt(Math.random() * Math.pow(param1,2)));
      }
      
      public static function doStamina(param1:MatchDetails) : void
      {
         TeamHelper.doTeamStaminaHit(param1.team0.players);
         TeamHelper.doTeamStaminaHit(param1.team1.players);
      }
      
      public static function doAISubstitutions(param1:MatchDetails) : void
      {
         var _loc2_:MatchTeamDetails = param1.team0.club == Main.currentGame.playerClub ? param1.team1 : param1.team0;
         if(_loc2_.subs.length == 5)
         {
            return;
         }
         var _loc3_:Array = new Array();
         var _loc4_:Array = new Array();
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         while(_loc6_ < 11)
         {
            if(_loc2_.players[_loc6_].injured)
            {
               _loc3_.push(_loc2_.players[_loc6_]);
            }
            else if(_loc2_.players[_loc6_].player.stamina / _loc2_.players[_loc6_].player.maxStamina < 0.25)
            {
               _loc4_.push(_loc2_.players[_loc6_]);
            }
            _loc6_++;
         }
         _loc6_ = 0;
         while(_loc6_ < _loc3_.length)
         {
            if(_loc2_.subs.length == 5)
            {
               break;
            }
            doAiSubstitution(_loc3_[_loc6_],_loc2_,param1);
            _loc5_ = true;
            _loc6_++;
         }
         _loc6_ = 0;
         while(_loc6_ < _loc4_.length)
         {
            if(_loc2_.subs.length == 5)
            {
               break;
            }
            doAiSubstitution(_loc4_[_loc6_],_loc2_,param1);
            _loc5_ = true;
            _loc6_++;
         }
         if(_loc5_)
         {
            BudgetEventProxy.dispatchEvent(MATCH_EVENT,{"event":SUBSTITUTION});
         }
      }
      
      private static function doAiSubstitution(param1:MatchPlayerDetails, param2:MatchTeamDetails, param3:MatchDetails) : void
      {
         var _loc4_:Array = param2.getAvailableSubs();
         var _loc5_:int = int(param2.players.indexOf(param1));
         var _loc6_:Player = TeamHelper.getBestPlayerInPosition(MatchHelper.playerDetailsToPlayers(_loc4_),param2.formation.positionTypes[_loc5_],true);
         if(!_loc6_)
         {
            return;
         }
         var _loc7_:String = param3.getMinutesString();
         var _loc8_:MatchPlayerDetails = MatchHelper.playerToPlayerDetails(_loc6_,param2.squad);
         param2.players[_loc5_] = _loc8_;
         param1.timeSubstituted = _loc7_;
         _loc8_.timeCameOut = _loc7_;
         param2.subs.push(param1);
         _loc8_.column = param1.column;
         _loc8_.row = param1.row;
         _loc8_.x = param1.x;
         _loc8_.y = param1.y;
         var _loc9_:MatchMessage = new MatchMessage(MatchHelper.getMatchCopy(CopyManager.SUBSTITUTION,_loc6_,param1.player,param2));
         _loc9_.team = MatchHelper.getTeamNumber(param2,param3);
         _loc9_.type = MatchAction.SUBSTITUTION;
         param3.messages.push(_loc9_);
      }
      
      private static function checkAITactics(param1:MatchDetails) : void
      {
         var _loc5_:Number = NaN;
         if(param1.matchSection == 0)
         {
            return;
         }
         var _loc2_:MatchTeamDetails = param1.team0.club == Main.currentGame.playerClub ? param1.team1 : param1.team0;
         var _loc3_:Number = param1.time / (60 * 45);
         var _loc4_:MatchTeamDetails = param1.playerTeam;
         if(param1.playerTeam.getGoals() > _loc2_.getGoals())
         {
            _loc5_ = 5 + 5 * _loc3_;
         }
         else if(param1.playerTeam.getGoals() < _loc2_.getGoals())
         {
            _loc5_ = 5 - 5 / _loc3_;
         }
         _loc2_.formation.attackingScore = _loc5_;
         _loc2_.positionPlayers();
         MatchHelper.makeSectors(param1);
      }
      
      private static function makePlayerScore(param1:MatchDetails) : void
      {
         var _loc3_:MatchMessage = null;
         var _loc2_:MatchPlayerDetails = param1.hasBall;
         ++_loc2_.goals;
         MatchHelper.getTeamKeeper(param1.teamWithoutBall).addToRating(-10);
         _loc2_.addToRating(90);
         _loc2_.addToRating(90);
         if(param1.lastPasser && param1.lastPasser != _loc2_)
         {
            ++param1.lastPasser.assists;
            param1.lastPasser.addToRating(50);
            if(isLeagueMatch(param1))
            {
               Main.currentGame.addPlayerAssist(param1.lastPasser.player.id);
            }
         }
         if(param1.playerIsInTeam0(_loc2_))
         {
            ++param1.match.club0Score;
            param1.team0.addGoal(_loc2_,param1.getMinutesString());
         }
         else
         {
            ++param1.match.club1Score;
            param1.team1.addGoal(_loc2_,param1.getMinutesString());
         }
         param1.extraTime += 30;
         if(param1.lastMatchAction.action != MatchAction.PENALTY)
         {
            _loc3_ = new MatchMessage(MatchHelper.getMatchCopy(CopyManager.GOAL,param1.hasBall.player,null,param1.hasBall.team));
            _loc3_.type = MatchAction.GOAL;
            _loc3_.team = param1.hasBall.team.num;
            param1.messages.push(_loc3_);
         }
         if(isLeagueMatch(param1))
         {
            Main.currentGame.addPlayerGoal(_loc2_.player.id);
         }
         param1.teamToRestart = param1.playerIsInTeam0(_loc2_) ? param1.team1 : param1.team0;
         param1.gameBreak = GOAL;
         BudgetEventProxy.dispatchEvent(MATCH_EVENT,{"event":GOAL});
         BudgetEventProxy.dispatchEvent(Game.DATA_CHANGED,null);
      }
      
      public static function playAIMatch(param1:Match) : void
      {
         var _loc11_:Number = NaN;
         var _loc12_:String = null;
         var _loc2_:Formation = param1.club0.club.getFormation();
         var _loc3_:Formation = param1.club1.club.getFormation();
         var _loc4_:Array = TeamHelper.getBestPlayers(_loc2_,param1.club0.club.getPlayersList(),true);
         var _loc5_:Array = TeamHelper.getBestPlayers(_loc3_,param1.club1.club.getPlayersList(),true);
         var _loc6_:Number = TeamHelper.getDefendingScore(_loc4_,_loc2_) / 2.65;
         var _loc7_:Number = TeamHelper.getAttckingScore(_loc4_,_loc2_);
         var _loc8_:Number = TeamHelper.getDefendingScore(_loc5_,_loc3_) / 2.65;
         var _loc9_:Number = TeamHelper.getAttckingScore(_loc5_,_loc3_);
         _loc7_ = _loc7_ * 0.8 + _loc7_ * 0.45 * Math.random();
         _loc9_ = _loc9_ * 0.8 + _loc9_ * 0.35 * Math.random();
         param1.club0Score = _loc7_ > _loc8_ ? int(Math.pow(_loc7_ - _loc8_,0.2)) : 0;
         param1.club1Score = _loc9_ > _loc6_ ? int(Math.pow(_loc9_ - _loc6_,0.2)) : 0;
         if(param1.club0Score > param1.club1Score)
         {
            if(param1.club1Score == 0 && Math.random() > 0.6)
            {
               ++param1.club1Score;
            }
            _loc11_ = Math.random();
            if(_loc11_ > 0.98 && param1.club0Score < 2)
            {
               param1.club0Score += 3;
            }
            else if(_loc11_ > 0.95 && param1.club0Score < 3)
            {
               param1.club0Score += 2;
            }
            else if(_loc11_ > 0.9 && param1.club0Score < 4)
            {
               param1.club0Score += 1;
            }
            else if(_loc11_ > 0.89)
            {
               param1.club0Score = 0;
            }
         }
         else if(param1.club0Score < param1.club1Score)
         {
            if(param1.club0Score == 0 && Math.random() > 0.6)
            {
               ++param1.club0Score;
            }
            _loc11_ = Math.random();
            if(_loc11_ > 0.98 && param1.club1Score < 2)
            {
               param1.club1Score += 3;
            }
            else if(_loc11_ > 0.95 && param1.club1Score < 3)
            {
               param1.club1Score += 2;
            }
            else if(_loc11_ > 0.9 && param1.club1Score < 4)
            {
               param1.club1Score += 1;
            }
            else if(_loc11_ > 0.89)
            {
               param1.club1Score = 0;
            }
         }
         else
         {
            _loc11_ = Math.random();
            if(_loc11_ > 0.95 && param1.club0Score < 1)
            {
               param1.club0Score += 3;
               param1.club1Score += 3;
            }
            else if(_loc11_ > 0.85 && param1.club0Score < 2)
            {
               param1.club0Score += 2;
               param1.club1Score += 2;
            }
            else if(_loc11_ > 0.6 && param1.club0Score < 3)
            {
               param1.club0Score += 1;
               param1.club1Score += 1;
            }
            else if(_loc11_ > 0.5)
            {
               if(Math.random() > 0.5)
               {
                  param1.club0Score += 1;
               }
               else
               {
                  param1.club1Score += 1;
               }
            }
         }
         var _loc10_:Number = Math.min(0.8,(param1.club0Score + param1.club1Score - 4) / 5);
         if(Math.random() < _loc10_)
         {
            if(param1.club0Score > 0 && param1.club1Score > 0)
            {
               --param1.club0Score;
               --param1.club1Score;
            }
            else if(param1.club0Score > 0)
            {
               param1.club0Score = Math.ceil(param1.club0Score * Math.random());
            }
            else
            {
               param1.club1Score = Math.ceil(param1.club1Score * Math.random());
            }
         }
         var _loc20_:Boolean = param1.competition is com.utterlySuperb.chumpManager.model.dataObjects.competitions.League;
         param1.club0Scorers = makeScorers(param1.club0Score,_loc4_,false,_loc20_);
         param1.club1Scorers = makeScorers(param1.club1Score,_loc5_,false,_loc20_);
         param1.workOut();
         if(param1.isDraw())
         {
            if(param1.needsWinner)
            {
               param1.extraTimePlayed = true;
               param1.club0ETScore = Math.floor(Math.random() * 2.8);
               param1.club1ETScore = Math.floor(Math.random() * 2.2);
               param1.workOutET();
               if(!param1.loser)
               {
                  doPenalties(param1);
                  param1.workOutPenalties();
               }
               _loc12_ = param1.club0Score > 0 ? ", " : "";
               param1.club0Scorers = param1.club0Scorers + _loc12_ + makeScorers(param1.club0ETScore,_loc4_,true,_loc20_);
               _loc12_ = param1.club1Score > 0 ? ", " : "";
               param1.club1Scorers = param1.club1Scorers + _loc12_ + makeScorers(param1.club1ETScore,_loc5_,true,_loc20_);
            }
         }
      }
      
      private static function makeScorers(param1:int, param2:Array, param3:Boolean = false, param4:Boolean = false) : String
      {
         var _loc12_:int = 0;
         var _loc13_:Player = null;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc4_:String = "";
         var _loc5_:Array = new Array();
         var _loc6_:int = param3 ? 90 : 0;
         var _loc7_:int = param3 ? 125 : 95;
         var _loc8_:int = param3 ? 35 : 95;
         var _loc9_:int = param3 ? 90 : 0;
         var _loc10_:Array = [];
         var _loc11_:int = 0;
         while(_loc11_ < param1)
         {
            _loc12_ = _loc9_ + int(Math.random() * _loc8_);
            _loc10_.push(_loc12_);
            _loc11_++;
         }
         _loc10_.sort(Array.NUMERIC);
         _loc11_ = 0;
         while(_loc11_ < _loc10_.length)
         {
            _loc13_ = MatchHelper.getLikelyScorer(param2);
            if(param4)
            {
               Main.currentGame.addPlayerGoal(_loc13_.id);
               var _loc16_:Player = MatchHelper.getLikelyAssist(param2,_loc13_);
               if(_loc16_)
               {
                  Main.currentGame.addPlayerAssist(_loc16_.id);
               }
            }
            _loc14_ = -1;
            _loc15_ = 0;
            while(_loc15_ < _loc5_.length)
            {
               if(_loc5_[_loc15_].indexOf(_loc13_.getLastName()) >= 0)
               {
                  _loc14_ = _loc15_;
               }
               _loc15_++;
            }
            if(_loc14_ < 0)
            {
               _loc5_.push(_loc13_.getLastName() + " " + _loc10_[_loc11_]);
            }
            else
            {
               _loc5_[_loc14_] += ", " + _loc10_[_loc11_];
            }
            _loc11_++;
         }
         _loc11_ = 0;
         while(_loc11_ < _loc5_.length)
         {
            _loc4_ += _loc11_ > 0 ? ", " + _loc5_[_loc11_] : _loc5_[_loc11_];
            _loc11_++;
         }
        return _loc4_;
     }

      private static function isLeagueMatch(param1:MatchDetails) : Boolean
      {
         return param1 && param1.match && param1.match.competition is com.utterlySuperb.chumpManager.model.dataObjects.competitions.League;
      }
      
      public static function doPenalties(param1:Match) : void
      {
         var _loc2_:int = 0;
         param1.penaltiesScore0 = param1.penaltiesScore1 = 0;
         while(!hasWinner(param1.penaltiesScore0,param1.penaltiesScore1,_loc2_))
         {
            _loc2_++;
            if(Math.random() > 0.25)
            {
               ++param1.penaltiesScore0;
            }
            if(Math.random() > 0.25)
            {
               ++param1.penaltiesScore1;
            }
         }
      }
      
      private static function hasWinner(param1:int, param2:int, param3:int) : Boolean
      {
         var _loc4_:int = Math.max(0,5 - param3);
         var _loc5_:int = Math.abs(param1 - param2);
         return _loc5_ > _loc4_;
      }
      
      private static function getEqualizer(param1:MatchDetails, param2:MatchTeamDetails) : Number
      {
         var _loc3_:Number = param1.getTeamPossessionNum(param2);
         return 1 + (50 - _loc3_) / 70;
      }
   }
}

