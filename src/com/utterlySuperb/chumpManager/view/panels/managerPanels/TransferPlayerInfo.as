package com.utterlySuperb.chumpManager.view.panels.managerPanels
{
   import com.utterlySuperb.chumpManager.engine.GameEngine;
   import com.utterlySuperb.chumpManager.events.PlayerEvent;
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.Player;
   import com.utterlySuperb.chumpManager.view.panels.Panel;
   import com.utterlySuperb.chumpManager.view.ui.buttons.ChumpButton;
   import com.utterlySuperb.chumpManager.view.ui.widgets.PlayerStatsDisplay;
   import com.utterlySuperb.chumpManager.view.ui.widgets.TransferPlayerStat;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TransferPlayerInfo extends Panel
   {
      
      public static const CLICKED_PLAYER_ACTION:String = "clickedPlayerAction";
      
      public static const CLICKED_PLAYER_ACTION1:String = "clickedPlayerAction1";
      
      private var statDisplay:PlayerStatsDisplay;
      
      private var actionButton0:ChumpButton;
      
      private var actionButton1:ChumpButton;
      
      public var player:Player;
      
      private var noTransferTF:TextField;
      
      public function TransferPlayerInfo()
      {
         super();
         this.statDisplay = new TransferPlayerStat();
         addChild(this.statDisplay);
         this.actionButton0 = ChumpButton.getButton("");
         this.actionButton0.y = this.statDisplay.y + this.statDisplay.height + 10;
         addChild(this.actionButton0);
         this.actionButton0.addEventListener(MouseEvent.CLICK,this.clickactionButton0);
         this.actionButton0.activate();
         this.actionButton1 = ChumpButton.getButton("");
         this.actionButton1.y = this.actionButton0.y + this.actionButton0.height + 15;
         addChild(this.actionButton1);
         this.actionButton1.addEventListener(MouseEvent.CLICK,this.clickactionButton1);
         this.actionButton1.activate();
         if(!GameEngine.canTransfer(Main.currentGame))
         {
            this.actionButton0.y += 20;
            this.actionButton0.visible = this.actionButton1.visible = false;
         }
      }
      
      private function clickactionButton0(param1:MouseEvent) : void
      {
         if(this.player)
         {
            dispatchEvent(new PlayerEvent(CLICKED_PLAYER_ACTION,this.player));
         }
      }
      
      private function clickactionButton1(param1:MouseEvent) : void
      {
         if(this.player)
         {
            dispatchEvent(new PlayerEvent(CLICKED_PLAYER_ACTION1,this.player));
         }
      }
      
      override protected function update(param1:Object = null) : void
      {
         if(this.player)
         {
            this.setPlayer(this.player);
         }
      }
      
      public function setPlayer(param1:Player) : void
      {
         this.player = param1;
         this.statDisplay.setPlayer(param1);
         if(Main.currentGame.playerClub.players.indexOf(param1.id) >= 0)
         {
            this.actionButton0.setText(CopyManager.getCopy("changeContract"));
         }
         else if(Main.currentGame.hasOfferOnPlayer(param1))
         {
            this.actionButton0.setText(CopyManager.getCopy("changeOffer"));
            this.actionButton1.setText("");
            this.actionButton1.visible = true;
         }
         else
         {
            this.actionButton0.setText(CopyManager.getCopy("makeOffer"));
            this.actionButton1.visible = false;
         }
         this.actionButton0.y = this.statDisplay.y + this.statDisplay.height + 10;
         this.actionButton1.y = this.actionButton0.y + this.actionButton0.height + 15;
      }
      
      override protected function cleanUp() : void
      {
         this.actionButton0.removeEventListener(MouseEvent.CLICK,this.clickactionButton0);
         this.actionButton0.deactivate();
         this.actionButton1.removeEventListener(MouseEvent.CLICK,this.clickactionButton1);
         this.actionButton1.deactivate();
      }
   }
}

