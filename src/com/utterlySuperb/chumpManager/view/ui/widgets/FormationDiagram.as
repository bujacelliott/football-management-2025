package com.utterlySuperb.chumpManager.view.ui.widgets
{
   import com.utterlySuperb.chumpManager.engine.MatchEngine;
   import com.utterlySuperb.chumpManager.events.PlayerEvent;
   import com.utterlySuperb.chumpManager.model.dataObjects.Club;
   import com.utterlySuperb.chumpManager.model.dataObjects.Formation;
   import com.utterlySuperb.chumpManager.model.dataObjects.Player;
   import com.utterlySuperb.chumpManager.view.ui.buttons.PlayerButton;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class FormationDiagram extends Sprite
   {
      
      public static const OVER_PLAYER:String = "overPlayer";
      
      public static const CLICK_PLAYER:String = "clickPlayer";
      
      public static const CLICK_BG:String = "clickBG";
      
      private var bg:MovieClip;
      
      private var playerButtons:Vector.<PlayerButton>;
      
      private var movingPlayerButton:PlayerButton;
      
      private var currentOverButton:PlayerButton;
      
      public var isMovable:Boolean;
      
      public function FormationDiagram()
      {
         super();
         this.bg = new PitchBG();
         addChild(this.bg);
         this.bg.height = 200;
         this.bg.addEventListener(MouseEvent.CLICK,this.clickBGHandler);
      }
      
      public static function get numRows() : int
      {
         return MatchEngine.NUM_ROWS / 2;
      }
      
      private function clickBGHandler(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(CLICK_BG));
      }
      
      public function setSize(param1:String) : void
      {
      }
      
      private function makeButtons() : void
      {
         var _loc1_:int = 0;
         var _loc2_:PlayerButton = null;
         if(!this.playerButtons)
         {
            this.playerButtons = new Vector.<PlayerButton>(11);
            _loc1_ = 0;
            while(_loc1_ < 11)
            {
               _loc2_ = new PlayerButton();
               addChild(_loc2_);
               _loc2_.num = _loc1_;
               this.playerButtons[_loc1_] = _loc2_;
               if(this.isMovable)
               {
                  _loc2_.addEventListener(MouseEvent.MOUSE_DOWN,this.pressButton);
               }
               _loc2_.addEventListener(MouseEvent.MOUSE_OVER,this.overButtonHandler);
               _loc2_.activate();
               _loc1_++;
            }
         }
      }
      
      public function setClub(param1:Club) : void
      {
      }
      
      public function setFormation(param1:Formation) : void
      {
         this.makeButtons();
         var _loc2_:int = 0;
         while(_loc2_ < param1.positionsCol.length)
         {
            this.playerButtons[_loc2_].column = param1.positionsCol[_loc2_];
            this.playerButtons[_loc2_].x = this.getXfromCol(param1.positionsCol[_loc2_]);
            this.playerButtons[_loc2_].row = param1.positionsRow[_loc2_];
            this.playerButtons[_loc2_].y = this.getYfromRow(param1.positionsRow[_loc2_]);
            _loc2_++;
         }
      }
      
      public function setPlayers(param1:Array) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < 11)
         {
            this.playerButtons[_loc2_].setPlayer(param1[_loc2_]);
            this.playerButtons[_loc2_].setTeam(true);
            _loc2_++;
         }
      }
      
      public function getPlayers() : Array
      {
         var _loc1_:Array = new Array(11);
         var _loc2_:int = 0;
         while(_loc2_ < this.playerButtons.length)
         {
            _loc1_[_loc2_] = this.playerButtons[_loc2_].player;
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function setPlayerSelected(param1:Player) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.playerButtons.length)
         {
            if(this.playerButtons[_loc2_].player == param1)
            {
               if(this.playerButtons[_loc2_] != this.movingPlayerButton)
               {
                  this.playerButtons[_loc2_].setOver();
               }
            }
            else
            {
               this.playerButtons[_loc2_].setNormal();
            }
            _loc2_++;
         }
      }
      
      private function getXfromCol(param1:int) : int
      {
         return param1 * this.bg.width / MatchEngine.NUM_COLUMNS + this.bg.width / MatchEngine.NUM_COLUMNS / 2;
      }
      
      private function getYfromRow(param1:int) : int
      {
         return param1 * this.bg.height / numRows + this.bg.height / numRows / 2;
      }
      
      private function getColFromX(param1:int) : int
      {
         return Math.floor(param1 / (this.bg.width / MatchEngine.NUM_COLUMNS));
      }
      
      private function getRowFromY(param1:int) : int
      {
         return Math.floor(param1 / (this.bg.height / numRows));
      }
      
      private function overButtonHandler(param1:MouseEvent) : void
      {
         dispatchEvent(new PlayerEvent(OVER_PLAYER,PlayerButton(param1.currentTarget).player));
      }
      
      private function pressButton(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.playerButtons.length)
         {
            if(this.playerButtons[_loc2_] == param1.currentTarget)
            {
               this.startPlayerButtonMove(this.playerButtons[_loc2_]);
            }
            _loc2_++;
         }
         param1.stopPropagation();
      }
      
      private function startPlayerButtonMove(param1:PlayerButton) : void
      {
         param1.setMoving();
         param1.startDrag(false,new Rectangle(this.bg.x,this.bg.y,this.bg.width,this.bg.height));
         stage.addEventListener(MouseEvent.MOUSE_UP,this.stopPlayerButtonMove);
         this.movingPlayerButton = param1;
         dispatchEvent(new PlayerEvent(CLICK_PLAYER,this.movingPlayerButton.player));
         addEventListener(Event.ENTER_FRAME,this.moveButtonEF);
      }
      
      private function stopPlayerButtonMove(param1:MouseEvent) : void
      {
         var _loc3_:PlayerButton = null;
         var _loc5_:Player = null;
         param1.stopPropagation();
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.stopPlayerButtonMove);
         removeEventListener(Event.ENTER_FRAME,this.moveButtonEF);
         this.movingPlayerButton.stopDrag();
         var _loc2_:Boolean = true;
         var _loc4_:int = 0;
         while(_loc4_ < this.playerButtons.length)
         {
            if(this.movingPlayerButton != this.playerButtons[_loc4_] && this.getColFromX(this.movingPlayerButton.x) == this.playerButtons[_loc4_].column && this.getRowFromY(this.movingPlayerButton.y) == this.playerButtons[_loc4_].row)
            {
               _loc3_ = this.playerButtons[_loc4_];
            }
            this.playerButtons[_loc4_].setNormal();
            _loc4_++;
         }
         if(_loc3_)
         {
            _loc5_ = this.movingPlayerButton.player;
            this.movingPlayerButton.setPlayer(_loc3_.player);
            _loc3_.setPlayer(_loc5_);
         }
         else
         {
            this.movingPlayerButton.column = this.getColFromX(this.movingPlayerButton.x);
            this.movingPlayerButton.row = this.getRowFromY(this.movingPlayerButton.y);
         }
         this.movingPlayerButton.x = this.getXfromCol(this.movingPlayerButton.column);
         this.movingPlayerButton.y = this.getYfromRow(this.movingPlayerButton.row);
         this.currentOverButton = null;
         dispatchEvent(new PlayerEvent(CLICK_PLAYER,this.movingPlayerButton.player));
         this.movingPlayerButton.setOver();
      }
      
      private function moveButtonEF(param1:Event) : void
      {
         var _loc2_:PlayerButton = null;
         var _loc3_:int = this.getColFromX(this.movingPlayerButton.x);
         var _loc4_:int = this.getRowFromY(this.movingPlayerButton.y);
         var _loc5_:int = 0;
         while(_loc5_ < this.playerButtons.length)
         {
            if(this.movingPlayerButton != this.playerButtons[_loc5_] && _loc3_ == this.playerButtons[_loc5_].column && _loc4_ == this.playerButtons[_loc5_].row)
            {
               _loc2_ = this.playerButtons[_loc5_];
            }
            _loc5_++;
         }
         if(_loc2_ != this.currentOverButton && Boolean(this.currentOverButton))
         {
            this.currentOverButton.setNormal();
            this.currentOverButton = null;
         }
         if(Boolean(_loc2_) && _loc2_ != this.currentOverButton)
         {
            this.currentOverButton = _loc2_;
            _loc2_.setOver();
            dispatchEvent(new PlayerEvent(OVER_PLAYER,this.currentOverButton.player));
         }
      }
      
      public function getFormation() : Formation
      {
         var _loc1_:Formation = new Formation();
         var _loc2_:int = 0;
         while(_loc2_ < 11)
         {
            _loc1_.positionsCol[_loc2_] = this.getColFromX(this.playerButtons[_loc2_].x);
            _loc1_.positionsRow[_loc2_] = this.getRowFromY(this.playerButtons[_loc2_].y);
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function cleanUp() : void
      {
         var _loc2_:PlayerButton = null;
         if(hasEventListener(Event.ENTER_FRAME))
         {
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.stopPlayerButtonMove,true);
            removeEventListener(Event.ENTER_FRAME,this.moveButtonEF);
            this.movingPlayerButton.stopDrag();
         }
         var _loc1_:int = 0;
         while(_loc1_ < 11)
         {
            _loc2_ = this.playerButtons[_loc1_];
            if(this.isMovable)
            {
               _loc2_.removeEventListener(MouseEvent.MOUSE_DOWN,this.pressButton);
            }
            _loc2_.removeEventListener(MouseEvent.MOUSE_OVER,this.overButtonHandler);
            _loc2_.deactivate();
            _loc1_++;
         }
         this.bg.removeEventListener(MouseEvent.CLICK,this.clickBGHandler);
      }
   }
}

