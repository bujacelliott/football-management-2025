package com.utterlySuperb.chumpManager.view.ui.widgets
{
   import com.utterlySuperb.chumpManager.engine.GameEngine;
   import com.utterlySuperb.chumpManager.engine.TransfersEngine;
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.Game;
   import com.utterlySuperb.chumpManager.model.dataObjects.Player;
   import com.utterlySuperb.chumpManager.model.dataObjects.StatusEffect;
   import com.utterlySuperb.chumpManager.view.modals.SellPlayerBox;
   import com.utterlySuperb.chumpManager.view.ui.buttons.ChumpButton;
   import com.utterlySuperb.events.BudgetEventProxy;
   import com.utterlySuperb.events.IntEvent;
   import com.utterlySuperb.text.TextHelper;
   import com.utterlySuperb.ui.ModalDialogue;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TeamPlayerStatsDisplay extends PlayerStatsDisplay
   {
      
      public static const CLICKED_SELL_PLAYER:String = "clickedPlayerAction";
      
      public static const CLICKED_RELEASE_PLAYER:String = "clickedPlayerAction1";
      
      protected var tf1:TextField;
      
      private var actionButton0:ChumpButton;
      
      private var actionButton1:ChumpButton;
      
      private var modal:ModalDialogue;
      
      private var player:Player;
      
      private var noTransferTF:TextField;
      
      public function TeamPlayerStatsDisplay()
      {
         super();
         tf.width = 210;
         barsSprite.scaleX = barsSprite.scaleY = 1.1;
         TextHelper.doTextField2(tf,Styles.HEADER_FONT,14,Styles.COPY_FONT_COLOR0,{"multiline":true});
         barsSprite.y = 75;
         this.tf1 = new TextField();
         addChild(this.tf1);
         this.tf1.x = 210;
         TextHelper.doTextField2(this.tf1,Styles.HEADER_FONT,14,Styles.COPY_FONT_COLOR0,{
            "multiline":true,
            "wordWrap":true
         });
         this.tf1.width = 200;
         this.actionButton0 = ChumpButton.getButton("");
         this.actionButton0.setText(CopyManager.getCopy("releasePlayer"));
         this.actionButton0.x = barsSprite.x;
         this.actionButton0.y = barsSprite.height + barsSprite.y + 5;
         addChild(this.actionButton0);
         this.actionButton0.addEventListener(MouseEvent.CLICK,this.clickactionButton0);
         this.actionButton0.activate();
         var _loc1_:TextField = new TextField();
         TextHelper.doTextField2(_loc1_,Styles.MAIN_FONT,12,Styles.COPY_FONT_COLOR0);
         _loc1_.htmlText = CopyManager.getCopy("releaseInfo");
         _loc1_.x = this.actionButton0.x;
         _loc1_.y = this.actionButton0.y + 23;
         addChild(_loc1_);
         _loc1_ = new TextField();
         TextHelper.doTextField2(_loc1_,Styles.MAIN_FONT,12,Styles.COPY_FONT_COLOR0);
         _loc1_.x = this.actionButton0.x;
         addChild(_loc1_);
         if(GameEngine.canTransfer(Main.currentGame))
         {
            this.actionButton1 = ChumpButton.getButton("");
            this.actionButton1.setText(CopyManager.getCopy("sellPlayer"));
            this.actionButton1.x = this.actionButton0.x;
            this.actionButton1.y = this.actionButton0.y + this.actionButton0.height + 25;
            addChild(this.actionButton1);
            this.actionButton1.addEventListener(MouseEvent.CLICK,this.clickactionButton1);
            this.actionButton1.activate();
            _loc1_.htmlText = CopyManager.getCopy("sellInfo");
            _loc1_.y = this.actionButton1.y + 23;
         }
         else
         {
            _loc1_.htmlText = CopyManager.getCopy("onlySellWhen");
            _loc1_.y = this.actionButton0.y + this.actionButton0.height + 25;
         }
      }
      
      public function setWidthAllowed(param1:int) : void
      {
         this.tf1.width = tf.width = param1 / 2 - 5;
         this.tf1.x = param1 / 2 + 5;
      }
      
      override public function setPlayer(param1:Player) : void
      {
         var _loc2_:int = 0;
         if(param1)
         {
            this.player = param1;
            visible = true;
            tf.htmlText = param1.squadNumber + "<br>" + param1.name + "<br>" + CopyManager.getPlayerPostionString(param1.positions) + "<br>";
            makeBars(param1);
            this.tf1.htmlText = CopyManager.getCopy("age") + ":" + param1.age;
            this.tf1.htmlText += CopyManager.getCopy("estimatedValue") + ":" + CopyManager.getCurrency() + TextHelper.prettifyNumber(param1.transferValue);
            this.tf1.htmlText += "<br>" + CopyManager.getCopy("seasonStats");
            this.tf1.htmlText += CopyManager.getCopy("appearances") + param1.seasonStats[param1.seasonStats.length - 1].appearances;
            this.tf1.htmlText += CopyManager.getCopy("subAppearances") + param1.seasonStats[param1.seasonStats.length - 1].subsAppearances;
            this.tf1.htmlText += CopyManager.getCopy("goals") + param1.seasonStats[param1.seasonStats.length - 1].goals;
            this.tf1.htmlText += CopyManager.getCopy("yellowCards") + param1.seasonStats[param1.seasonStats.length - 1].yellowCards;
            this.tf1.htmlText += CopyManager.getCopy("redCards") + param1.seasonStats[param1.seasonStats.length - 1].redCards;
            if(param1.statusEffects.length > 0)
            {
               this.tf1.htmlText += "<br>";
               _loc2_ = 0;
               while(_loc2_ < param1.statusEffects.length)
               {
                  if(param1.statusEffects[_loc2_].type == StatusEffect.INJURY)
                  {
                     this.tf1.htmlText += CopyManager.getCopy("isInjured").replace("{numWeeks}",CopyManager.getNumCopy(param1.statusEffects[_loc2_].time,"week"));
                  }
                  else if(param1.statusEffects[_loc2_].type == StatusEffect.SUSPENSION)
                  {
                     this.tf1.htmlText += CopyManager.getCopy("isSuspended").replace("{numWeeks}",CopyManager.getNumCopy(param1.statusEffects[_loc2_].time,"week"));
                  }
                  _loc2_++;
               }
            }
         }
         else
         {
            visible = false;
         }
      }
      
      private function clickactionButton1(param1:MouseEvent) : void
      {
         if(GameEngine.canTransfer(Main.currentGame))
         {
            this.modal = new SellPlayerBox("","",[],this.player);
         }
         else
         {
            this.modal = new ModalDialogue(CopyManager.getCopy("transferClosed"),CopyManager.getCopy("onlySellWhen"),[CopyManager.getCopy("ok")]);
         }
         Main.instance.addModal(this.modal);
         this.modal.addEventListener(ModalDialogue.MAKE_CHOICE,this.madeSellChoiceHandler);
      }
      
      private function clickactionButton0(param1:MouseEvent) : void
      {
         var _loc2_:String = CopyManager.getCopy("reallyReleasePlayer").replace("{playerName}",this.player.name);
         this.modal = new ModalDialogue(CopyManager.getCopy("areYouSure"),_loc2_,[CopyManager.getCopy("ok"),CopyManager.getCopy("cancel")]);
         Main.instance.addModal(this.modal);
         this.modal.addEventListener(ModalDialogue.MAKE_CHOICE,this.madeReleaseChoiceHandler);
      }
      
      private function madeSellChoiceHandler(param1:Event) : void
      {
         Main.instance.removeModal(this.modal);
         this.modal.removeEventListener(ModalDialogue.MAKE_CHOICE,this.madeSellChoiceHandler);
         this.modal = null;
      }
      
      private function madeReleaseChoiceHandler(param1:IntEvent) : void
      {
         this.modal.removeEventListener(ModalDialogue.MAKE_CHOICE,this.madeReleaseChoiceHandler);
         Main.instance.removeModal(this.modal);
         this.modal = null;
         if(param1.num == 0)
         {
            Main.currentGame.playerClub.removePlayer(this.player.id);
            this.player.club = null;
            this.player = null;
            Main.currentGame.playerClub.getFormation().removeSoldPlayers(Main.currentGame.playerClub.players);
            BudgetEventProxy.dispatchEvent(Game.DATA_CHANGED,null);
         }
      }
   }
}

