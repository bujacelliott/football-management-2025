package com.utterlySuperb.chumpManager.view.panels
{
   import com.utterlySuperb.chumpManager.engine.GameEngine;
   import com.utterlySuperb.chumpManager.events.PlayerEvent;
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.Club;
   import com.utterlySuperb.chumpManager.model.dataObjects.Game;
   import com.utterlySuperb.chumpManager.model.dataObjects.Player;
   import com.utterlySuperb.chumpManager.model.dataObjects.StaticInfo;
   import com.utterlySuperb.chumpManager.view.modals.SellPlayerBox;
   import com.utterlySuperb.chumpManager.view.ui.ChumpListBox;
   import com.utterlySuperb.chumpManager.view.ui.buttons.listButtons.PlayerListButton;
   import com.utterlySuperb.events.BudgetEventProxy;
   import com.utterlySuperb.events.IntEvent;
   import com.utterlySuperb.ui.ListBox;
   import com.utterlySuperb.ui.ModalDialogue;
   import flash.events.Event;
   
   public class PlayerList extends Panel
   {
      
      public static const ROLLOVER_PLAYER:String = "rollOverPlayer";
      
      private var playerBox:ChumpListBox;
      
      private var player:Player;
      
      public function PlayerList()
      {
         super();
         var _loc1_:int = 340;
         makeBox(_loc1_,Globals.usableHeight,0,0);
         this.playerBox = new ChumpListBox(_loc1_ - 55,Globals.usableHeight - 60);
         this.playerBox.drawFrame();
         addChild(this.playerBox);
         this.playerBox.x = 20;
         this.playerBox.y = 20;
         this.playerBox.addEventListener(ListBox.OVER_ITEM,this.overPlayerHandler);
         this.playerBox.addEventListener(ListBox.CLICK_ITEM,this.clickPlayerHandler);
         this.update(null);
      }
      
      override protected function init() : void
      {
      }
      
      override protected function cleanUp() : void
      {
         this.playerBox.removeEventListener(ListBox.OVER_ITEM,this.overPlayerHandler);
         this.playerBox.removeEventListener(ListBox.CLICK_ITEM,this.clickPlayerHandler);
         this.playerBox.disable();
      }
      
      override protected function update(param1:Object = null) : void
      {
         var _loc4_:Player = null;
         var _loc5_:PlayerListButton = null;
         this.playerBox.depopulate();
         var _loc2_:Club = Main.currentGame.playerClub;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.players.length)
         {
            _loc4_ = StaticInfo.getPlayer(_loc2_.players[_loc3_]);
            _loc5_ = new PlayerListButton();
            _loc5_.bHeight = 30;
            _loc5_.bWidth = 300;
            _loc5_.setBG(_loc3_ % 2 == 0);
            _loc5_.setPlayer(_loc4_);
            this.playerBox.addItem(_loc5_);
            _loc3_++;
         }
         this.playerBox.enable();
      }
      
      private function overPlayerHandler(param1:IntEvent) : void
      {
         var _loc2_:Player = StaticInfo.getPlayer(Main.currentGame.playerClub.players[param1.num]);
         dispatchEvent(new PlayerEvent(ROLLOVER_PLAYER,_loc2_));
      }
      
      private function clickPlayerHandler(param1:IntEvent) : void
      {
         this.player = StaticInfo.getPlayer(Main.currentGame.playerClub.players[param1.num]);
         var _loc2_:Array = [CopyManager.getCopy("releasePlayer"),CopyManager.getCopy("cancel")];
         if(GameEngine.canTransfer(Main.currentGame))
         {
            _loc2_.splice(0,0,CopyManager.getCopy("sellPlayer"));
         }
         var _loc3_:ModalDialogue = new ModalDialogue(CopyManager.getCopy("chooseAction"),CopyManager.getCopy("choosePlayerActionCopy").replace("{playerName}",this.player.name),_loc2_);
         Main.instance.addModal(_loc3_);
         _loc3_.addEventListener(ModalDialogue.MAKE_CHOICE,this.madeInitialChoiceHandler);
      }
      
      private function madeInitialChoiceHandler(param1:IntEvent) : void
      {
         var _loc2_:ModalDialogue = param1.target as ModalDialogue;
         _loc2_.removeEventListener(ModalDialogue.MAKE_CHOICE,this.madeInitialChoiceHandler);
         Main.instance.removeModal(_loc2_);
         if(GameEngine.canTransfer(Main.currentGame))
         {
            if(param1.num == 0)
            {
               _loc2_ = new SellPlayerBox("","",[],this.player);
               Main.instance.addModal(_loc2_);
               Main.instance.addModal(_loc2_);
               _loc2_.addEventListener(ModalDialogue.MAKE_CHOICE,this.madeSellChoiceHandler);
            }
            else if(param1.num == 1)
            {
               this.showReleaseDialogue();
            }
         }
         else if(param1.num == 0)
         {
            this.showReleaseDialogue();
         }
      }
      
      private function showReleaseDialogue() : void
      {
         var _loc1_:String = CopyManager.getCopy("reallyReleasePlayer").replace("{playerName}",this.player.name);
         var _loc2_:ModalDialogue = new ModalDialogue(CopyManager.getCopy("areYouSure"),_loc1_,[CopyManager.getCopy("ok"),CopyManager.getCopy("cancel")]);
         Main.instance.addModal(_loc2_);
         _loc2_.addEventListener(ModalDialogue.MAKE_CHOICE,this.madeReleaseChoiceHandler);
      }
      
      private function madeReleaseChoiceHandler(param1:IntEvent) : void
      {
         var _loc2_:ModalDialogue = param1.target as ModalDialogue;
         _loc2_.removeEventListener(ModalDialogue.MAKE_CHOICE,this.madeReleaseChoiceHandler);
         Main.instance.removeModal(_loc2_);
         if(param1.num == 0)
         {
            Main.currentGame.playerClub.removePlayer(this.player.id);
            this.player.club = null;
            this.player = null;
            Main.currentGame.playerClub.getFormation().removeSoldPlayers(Main.currentGame.playerClub.players);
            BudgetEventProxy.dispatchEvent(Game.DATA_CHANGED,null);
         }
      }
      
      private function madeSellChoiceHandler(param1:Event) : void
      {
         var _loc2_:ModalDialogue = param1.target as ModalDialogue;
         Main.instance.removeModal(_loc2_);
         _loc2_.removeEventListener(ModalDialogue.MAKE_CHOICE,this.madeSellChoiceHandler);
         _loc2_ = null;
      }
   }
}

