package com.utterlySuperb.chumpManager.view.screens.transfers
{
   import com.utterlySuperb.chumpManager.engine.GameEngine;
   import com.utterlySuperb.chumpManager.engine.PlayerHelper;
   import com.utterlySuperb.chumpManager.events.PlayerEvent;
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.Game;
   import com.utterlySuperb.chumpManager.model.dataObjects.Player;
   import com.utterlySuperb.chumpManager.model.dataObjects.PlayerOffers;
   import com.utterlySuperb.chumpManager.view.modals.PlayerOfferBox;
   import com.utterlySuperb.chumpManager.view.modals.SellPlayerBox;
   import com.utterlySuperb.chumpManager.view.panels.managerPanels.TransferPlayerInfo;
   import com.utterlySuperb.chumpManager.view.screens.Screen;
   import com.utterlySuperb.events.BudgetEventProxy;
   import com.utterlySuperb.events.IntEvent;
   import com.utterlySuperb.text.TextHelper;
   import com.utterlySuperb.ui.ModalDialogue;
   import flash.events.Event;
   
   public class TransferSearchScreen extends Screen
   {
      
      protected var player:Player;
      
      protected var playersInfo:TransferPlayerInfo;
      
      public function TransferSearchScreen()
      {
         super();
      }
      
      protected function clickPlayerHandler(param1:PlayerEvent) : void
      {
         this.player = param1.player;
         this.showMakeOfferModal();
      }
      
      protected function addPlayerInfo(param1:int = 0, param2:int = 0) : void
      {
         this.playersInfo = new TransferPlayerInfo();
         this.playersInfo.x = param1;
         this.playersInfo.y = param2;
         addChild(this.playersInfo);
         this.playersInfo.addEventListener(TransferPlayerInfo.CLICKED_PLAYER_ACTION,this.clickPlayerHandler);
         this.playersInfo.addEventListener(TransferPlayerInfo.CLICKED_PLAYER_ACTION1,this.clickPlayerHandler);
      }
      
      private function showMakeOfferModal() : void
      {
         var _loc1_:Array = null;
         var _loc2_:ModalDialogue = null;
         var _loc3_:PlayerOfferBox = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         if(GameEngine.canTransfer(Main.currentGame))
         {
            if(Main.currentGame.playerClub.players.indexOf(this.player.id) >= 0)
            {
               _loc1_ = [CopyManager.getCopy("releasePlayer"),CopyManager.getCopy("cancel")];
               if(GameEngine.canTransfer(Main.currentGame))
               {
                  _loc1_.splice(0,0,CopyManager.getCopy("sellPlayer"));
               }
               _loc2_ = new ModalDialogue(CopyManager.getCopy("chooseAction"),CopyManager.getCopy("choosePlayerActionCopy").replace("{playerName}",this.player.name),_loc1_);
               Main.instance.addModal(_loc2_);
               _loc2_.addEventListener(ModalDialogue.MAKE_CHOICE,this.madeInitialChoiceHandler);
            }
            else
            {
               if(Main.currentGame.hasOfferOnPlayer(this.player))
               {
                  _loc4_ = CopyManager.getCopy("changeOffer?");
                  _loc5_ = CopyManager.getCopy("changeOfferCopy");
                  _loc5_ = _loc5_.replace("[playerName]",this.player.name);
                  _loc6_ = [CopyManager.getCopy("ok"),CopyManager.getCopy("cancelOffer"),CopyManager.getCopy("cancel")];
                  Main.currentGame.clubCash += Main.currentGame.getOfferOnPlayer(this.player).cashOff;
               }
               else
               {
                  if(Main.currentGame.playerClub.players.length + Main.currentGame.playerOffers.length >= 52)
                  {
                     _loc4_ = CopyManager.getCopy("squadLimitHeader");
                     _loc5_ = CopyManager.getCopy("squadLimitCopy");
                     _loc2_ = new ModalDialogue(_loc4_,_loc5_,[CopyManager.getCopy("ok")]);
                     addSimplyModal(_loc2_);
                     return;
                  }
                  _loc4_ = CopyManager.getCopy("makeOffer?");
                  _loc5_ = this.player.club ? CopyManager.getCopy("makeOfferCopy") : CopyManager.getCopy("makeOfferCopyNoClub");
                  _loc5_ = _loc5_.replace("[playerName]",this.player.name);
                  _loc5_ = _loc5_.replace("[position]",CopyManager.getCopy(this.player.basePostition));
                  _loc5_ = _loc5_.replace("{currentCash}",CopyManager.getCurrency() + TextHelper.prettifyNumber(Main.currentGame.clubCash));
                  _loc6_ = [CopyManager.getCopy("ok"),CopyManager.getCopy("cancel")];
                  if(this.player.club)
                  {
                     _loc5_ = _loc5_.replace("[clubname]",this.player.club.name);
                  }
               }
               _loc3_ = new PlayerOfferBox(_loc4_,_loc5_,_loc6_,this.player.club != null);
               Main.instance.addModal(_loc3_);
               _loc3_.addEventListener(ModalDialogue.MAKE_CHOICE,this.madeChoiceHandler);
            }
         }
      }
      
      protected function overPlayerHandler(param1:PlayerEvent) : void
      {
         this.playersInfo.setPlayer(param1.player);
      }
      
      private function madeChoiceHandler(param1:IntEvent) : void
      {
         var _loc3_:PlayerOffers = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:ModalDialogue = null;
         var _loc2_:PlayerOfferBox = PlayerOfferBox(param1.target);
         Main.instance.removeModal(_loc2_);
         _loc2_.removeEventListener(ModalDialogue.MAKE_CHOICE,this.madeChoiceHandler);
         if(param1.num == 0)
         {
            if(Main.currentGame.playerClub.players.indexOf(this.player.id) < 0)
            {
               if(Main.currentGame.hasOfferOnPlayer(this.player))
               {
                  Main.currentGame.removePlayerOffer(this.player);
               }
               _loc3_ = new PlayerOffers();
               _loc3_.player = this.player.id;
               _loc3_.cashOff = _loc2_.getTransferFee();
               Main.currentGame.playerOffers.push(_loc3_);
               Main.currentGame.clubCash -= _loc3_.cashOff;
               BudgetEventProxy.dispatchEvent(Game.DATA_CHANGED,null);
            }
         }
         else if(param1.num == 1)
         {
            if(Main.currentGame.playerClub.players.indexOf(this.player.id) >= 0)
            {
               _loc4_ = PlayerHelper.releasePlayerFine(this.player);
               if(Main.currentGame.clubCash >= _loc4_)
               {
                  _loc5_ = CopyManager.getCopy("sureReleasePlayer");
                  _loc5_ = _loc5_.replace("[playerName]",this.player.name);
                  _loc5_ = _loc5_.replace("[amount]",CopyManager.getCurrency() + TextHelper.prettifyNumber(_loc4_));
                  _loc6_ = new ModalDialogue(CopyManager.getCopy("areYouSure"),_loc5_,[CopyManager.getCopy("ok"),CopyManager.getCopy("cancel")]);
                  Main.instance.addModal(_loc6_);
                  _loc6_.addEventListener(ModalDialogue.MAKE_CHOICE,this.madeReleaseChoiceHandler);
               }
            }
            else if(Main.currentGame.hasOfferOnPlayer(this.player))
            {
               _loc3_ = Main.currentGame.getOfferOnPlayer(this.player);
               Main.currentGame.removePlayerOffer(this.player);
               BudgetEventProxy.dispatchEvent(Game.DATA_CHANGED,null);
            }
         }
         else if(param1.num == 2)
         {
            if(Main.currentGame.hasOfferOnPlayer(this.player))
            {
               Main.currentGame.clubCash -= Main.currentGame.getOfferOnPlayer(this.player).cashOff;
            }
         }
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
      
      private function clickPlayerAction1(param1:PlayerEvent) : void
      {
         var _loc2_:PlayerOffers = Main.currentGame.getOfferOnPlayer(param1.player);
         if(_loc2_)
         {
            Main.currentGame.removePlayerOffer(param1.player);
            BudgetEventProxy.dispatchEvent(Game.DATA_CHANGED,null);
         }
      }
      
      override public function cleanUp() : void
      {
         super.cleanUp();
         this.playersInfo.removeEventListener(TransferPlayerInfo.CLICKED_PLAYER_ACTION,this.clickPlayerHandler);
         this.playersInfo.removeEventListener(TransferPlayerInfo.CLICKED_PLAYER_ACTION1,this.clickPlayerHandler);
      }
   }
}

