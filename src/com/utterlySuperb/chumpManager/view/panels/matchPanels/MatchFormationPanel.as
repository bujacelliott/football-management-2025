package com.utterlySuperb.chumpManager.view.panels.matchPanels
{
   import com.utterlySuperb.chumpManager.engine.MatchEngine;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.MatchDetails;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.PitchMap;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.PitchSector;
   import com.utterlySuperb.chumpManager.view.panels.Panel;
   import com.utterlySuperb.chumpManager.view.ui.buttons.MatchPlayerButton;
   import com.utterlySuperb.chumpManager.view.ui.buttons.PlayerButton;
   import flash.events.MouseEvent;
   
   public class MatchFormationPanel extends Panel
   {
      
      private var bg:PitchBG_onSide;
      
      private var squareWidth:int;
      
      private var squareHeight:int;
      
      private var playerButtons0:Vector.<MatchPlayerButton>;
      
      private var playerButtons1:Vector.<MatchPlayerButton>;
      
      private var xFactor:Number;
      
      private var yFactor:Number;
      
      private var sectorWidth:Number;
      
      private var sectorHeight:Number;
      
      private var ball:BallMC;
      
      public function MatchFormationPanel()
      {
         super();
      }
      
      override protected function init() : void
      {
         var _loc4_:PlayerButton = null;
         var _loc1_:int = Globals.GAME_HEIGHT - y - 20;
         this.bg = new PitchBG_onSide();
         this.bg.x = this.bg.y = 20;
         this.bg.height = _loc1_ - 40;
         this.bg.scaleX = this.bg.scaleY;
         this.squareWidth = this.bg.width / MatchEngine.NUM_COLUMNS;
         this.squareHeight = this.bg.height / MatchEngine.NUM_ROWS;
         this.xFactor = this.bg.width / MatchEngine.pitchWidth;
         this.yFactor = this.bg.height / MatchEngine.pitchHeight;
         this.sectorWidth = this.bg.width / PitchMap.NUM_COLUMNS;
         this.sectorHeight = this.bg.height / PitchMap.NUM_ROWS;
         makeBox(this.bg.width + 40,_loc1_);
         addChild(this.bg);
         var _loc2_:MatchDetails = Main.currentGame.matchDetails;
         this.playerButtons0 = new Vector.<MatchPlayerButton>();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.team0.players.length)
         {
            _loc4_ = new MatchPlayerButton();
            addChild(_loc4_);
            _loc4_.setPlayer(_loc2_.team0.players[_loc3_].player);
            this.playerButtons0.push(_loc4_);
            _loc3_++;
         }
         this.playerButtons1 = new Vector.<MatchPlayerButton>();
         _loc3_ = 0;
         while(_loc3_ < _loc2_.team1.players.length)
         {
            _loc4_ = new MatchPlayerButton();
            addChild(_loc4_);
            _loc4_.setPlayer(_loc2_.team1.players[_loc3_].player);
            this.playerButtons1.push(_loc4_);
            _loc4_.setTeam(false);
            _loc3_++;
         }
         this.ball = new BallMC();
         addChild(this.ball);
         this.update();
         this.bg.team1TF.htmlText = Main.currentGame.matchDetails.team0.club.name;
         this.bg.team0TF.htmlText = Main.currentGame.matchDetails.team1.club.name;
      }
      
      private function clickBGDebugHandler(param1:MouseEvent) : void
      {
         var _loc2_:MatchDetails = Main.currentGame.matchDetails;
         var _loc3_:int = int((mouseX - this.bg.x) / this.bg.width * PitchMap.NUM_COLUMNS);
         var _loc4_:int = int((mouseY - this.bg.y) / this.bg.height * PitchMap.NUM_ROWS);
         var _loc5_:PitchSector = _loc2_.pitchMap.sectors[_loc3_][_loc4_];
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.team0Influence.length)
         {
            _loc6_++;
         }
         _loc6_ = 0;
         while(_loc6_ < _loc5_.team1Influence.length)
         {
            _loc6_++;
         }
      }
      
      override protected function cleanUp() : void
      {
      }
      
      override protected function update(param1:Object = null) : void
      {
         var _loc2_:MatchDetails = Main.currentGame.matchDetails;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.team0.players.length)
         {
            if(_loc2_.matchSection % 2 == 0)
            {
               this.playerButtons0[_loc3_].x = this.getX(_loc2_.team0.players[_loc3_].x);
               this.playerButtons0[_loc3_].y = this.getY(_loc2_.team0.players[_loc3_].y);
            }
            else
            {
               this.playerButtons0[_loc3_].x = this.getX(MatchEngine.pitchWidth - _loc2_.team0.players[_loc3_].x);
               this.playerButtons0[_loc3_].y = this.getY(MatchEngine.pitchHeight - _loc2_.team0.players[_loc3_].y);
            }
            if(_loc2_.team0.players[_loc3_] == _loc2_.hasBall)
            {
               this.playerButtons0[_loc3_].setOver();
            }
            else
            {
               this.playerButtons0[_loc3_].setNormal();
            }
            if(_loc2_.team0.players[_loc3_].canPlay())
            {
               this.playerButtons0[_loc3_].alpha = 1;
            }
            else
            {
               this.playerButtons0[_loc3_].alpha = 0.5;
            }
            this.playerButtons0[_loc3_].setStamina(int(_loc2_.team0.players[_loc3_].player.stamina / _loc2_.team0.players[_loc3_].player.maxStamina * 100));
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc2_.team1.players.length)
         {
            if(_loc2_.matchSection % 2 == 0)
            {
               this.playerButtons1[_loc3_].x = this.getX(_loc2_.team1.players[_loc3_].x);
               this.playerButtons1[_loc3_].y = this.getY(_loc2_.team1.players[_loc3_].y);
            }
            else
            {
               this.playerButtons1[_loc3_].x = this.getX(MatchEngine.pitchWidth - _loc2_.team1.players[_loc3_].x);
               this.playerButtons1[_loc3_].y = this.getY(MatchEngine.pitchHeight - _loc2_.team1.players[_loc3_].y);
            }
            if(_loc2_.team1.players[_loc3_] == _loc2_.hasBall)
            {
               this.playerButtons1[_loc3_].setOver();
            }
            else
            {
               this.playerButtons1[_loc3_].setNormal();
            }
            if(_loc2_.team1.players[_loc3_].canPlay())
            {
               this.playerButtons1[_loc3_].alpha = 1;
            }
            else
            {
               this.playerButtons1[_loc3_].alpha = 0.5;
            }
            this.playerButtons1[_loc3_].setStamina(int(_loc2_.team1.players[_loc3_].player.stamina / _loc2_.team1.players[_loc3_].player.maxStamina * 100));
            _loc3_++;
         }
         if(_loc2_.currentSector)
         {
            if(_loc2_.matchSection % 2 == 1)
            {
               this.bg.team0TF.htmlText = _loc2_.team0.club.name;
               this.bg.team1TF.htmlText = _loc2_.team1.club.name;
               this.ball.x = this.bg.x + this.sectorWidth / 2 + (PitchMap.NUM_COLUMNS - _loc2_.currentSector.column - 1) * this.sectorWidth;
               this.ball.y = this.bg.y + this.sectorHeight / 2 + (PitchMap.NUM_ROWS - _loc2_.currentSector.row - 1) * this.sectorHeight;
            }
            else
            {
               this.bg.team1TF.htmlText = _loc2_.team0.club.name;
               this.bg.team0TF.htmlText = _loc2_.team1.club.name;
               this.ball.x = this.bg.x + this.sectorWidth / 2 + _loc2_.currentSector.column * this.sectorWidth;
               this.ball.y = this.bg.y + this.sectorHeight / 2 + _loc2_.currentSector.row * this.sectorHeight;
            }
         }
      }
      
      public function getWidth() : int
      {
         return this.bg.width + 40;
      }
      
      private function getX(param1:int) : int
      {
         return param1 * this.xFactor + this.bg.x;
      }
      
      private function getY(param1:int) : int
      {
         return param1 * this.yFactor + this.bg.y;
      }
      
      private function getXfromCol(param1:int) : int
      {
         return param1 * this.squareWidth + this.squareWidth / 2 + this.bg.x;
      }
      
      private function getYfromRow(param1:int) : int
      {
         return param1 * this.squareHeight + this.squareHeight / 2 + this.bg.y;
      }
   }
}

