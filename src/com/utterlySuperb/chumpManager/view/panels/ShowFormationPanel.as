package com.utterlySuperb.chumpManager.view.panels
{
   import com.utterlySuperb.chumpManager.events.PlayerEvent;
   import com.utterlySuperb.chumpManager.model.dataObjects.Formation;
   import com.utterlySuperb.chumpManager.model.dataObjects.Player;
   import com.utterlySuperb.chumpManager.view.ui.ChumpListBox;
   import com.utterlySuperb.chumpManager.view.ui.buttons.listButtons.PlayerListButton;
   import com.utterlySuperb.chumpManager.view.ui.buttons.listButtons.PlayerListFormationButton;
   import com.utterlySuperb.chumpManager.view.ui.widgets.FormationDiagram;
   import com.utterlySuperb.events.IntEvent;
   import com.utterlySuperb.text.TextHelper;
   import com.utterlySuperb.ui.ListBox;
   import flash.text.TextField;
   
   public class ShowFormationPanel extends Panel
   {
      
      public static const OVER_PLAYER:String = "overPlayer";
      
      private var formationDiagram:FormationDiagram;
      
      private var subsBox:ChumpListBox;
      
      public function ShowFormationPanel()
      {
         super();
         var _loc1_:int = 300;
         makeBox(_loc1_,Globals.usableHeight,0,0);
         this.formationDiagram = new FormationDiagram();
         addChild(this.formationDiagram);
         this.formationDiagram.isMovable = false;
         this.formationDiagram.x = 20;
         this.formationDiagram.y = 50;
         this.formationDiagram.width = _loc1_ - 40;
         this.formationDiagram.scaleY = this.formationDiagram.scaleX;
         this.formationDiagram.addEventListener(PlayerEvent.OVER_PLAYER,this.overFormationPlayerHandler);
         this.subsBox = new ChumpListBox(_loc1_ - 55,Globals.usableHeight - (this.formationDiagram.y + this.formationDiagram.height + 10) - 20);
         this.subsBox.drawFrame();
         addChild(this.subsBox);
         this.subsBox.x = 20;
         this.subsBox.y = this.formationDiagram.y + this.formationDiagram.height + 10;
         this.subsBox.addEventListener(ListBox.OVER_ITEM,this.overItemHandler);
      }
      
      private function overFormationPlayerHandler(param1:PlayerEvent) : void
      {
         dispatchEvent(param1);
         this.formationDiagram.setPlayerSelected(param1.player);
      }
      
      private function overItemHandler(param1:IntEvent) : void
      {
         var _loc2_:Player = PlayerListButton(this.subsBox.getButtonAt(param1.num)).player;
         this.formationDiagram.setPlayerSelected(_loc2_);
         dispatchEvent(new PlayerEvent(OVER_PLAYER,_loc2_));
      }
      
      override protected function init() : void
      {
      }
      
      public function setFormation(param1:Formation, param2:String) : void
      {
         var _loc3_:Array = null;
         var _loc6_:PlayerListButton = null;
         this.formationDiagram.setFormation(param1);
         _loc3_ = param1.getPrefferedPlayers();
         this.formationDiagram.setPlayers(_loc3_);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc6_ = new PlayerListFormationButton();
            _loc6_.bWidth = 245;
            _loc6_.setBG(_loc4_ % 2 == 0);
            _loc6_.setPlayer(_loc3_[_loc4_]);
            this.subsBox.addItem(_loc6_);
            if(_loc4_ < 11)
            {
               _loc6_.setInTeam();
            }
            else
            {
               _loc6_.setInSubs();
            }
            _loc4_++;
         }
         this.subsBox.enable();
         var _loc5_:TextField = new TextField();
         TextHelper.doTextField2(_loc5_,Styles.HEADER_FONT,20,16777215);
         _loc5_.htmlText = param2;
         addChild(_loc5_);
         TextHelper.fitTextField(_loc5_);
         _loc5_.y = 5;
         _loc5_.x = (300 - _loc5_.textWidth) / 2;
      }
      
      override protected function cleanUp() : void
      {
         this.subsBox.disable();
         this.subsBox.removeEventListener(ListBox.OVER_ITEM,this.overItemHandler);
         this.formationDiagram.removeEventListener(PlayerEvent.OVER_PLAYER,this.overFormationPlayerHandler);
         this.formationDiagram.cleanUp();
      }
   }
}

