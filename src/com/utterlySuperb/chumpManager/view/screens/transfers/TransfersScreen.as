package com.utterlySuperb.chumpManager.view.screens.transfers
{
   import com.utterlySuperb.chumpManager.engine.GameEngine;
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.view.panels.universalPanels.StatusPanel;
   import com.utterlySuperb.chumpManager.view.screens.Screen;
   import com.utterlySuperb.chumpManager.view.ui.buttons.BigButton;
   import com.utterlySuperb.text.TextHelper;
   import flash.events.Event;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   
   public class TransfersScreen extends Screen
   {
      
      private var playerSearchBtn:BigButton;
      
      private var browseClubBtn:BigButton;
      
      private var sellPlayerBtn:BigButton;
      
      private var backBtn2:BigButton;
      
      public function TransfersScreen()
      {
         super();
         makeBackButton();
         makeHomeButton();
         Main.instance.backOverride = Screen.MANAGERS_SCREEN;
         var _loc1_:TextField = new TextField();
         TextHelper.doTextField2(_loc1_,Styles.HEADER_FONT,20,16777215);
         _loc1_.htmlText = GameEngine.canTransfer(Main.currentGame) ? CopyManager.getCopy("transferOpen") : CopyManager.getCopy("transferClosed");
         _loc1_.x = (Globals.GAME_WIDTH - _loc1_.textWidth) / 2;
         _loc1_.y = Globals.belowStatus;
         addChild(_loc1_);
         this.playerSearchBtn = new BigButton(CopyManager.getCopy("playerSearch"),CopyManager.getCopy("playerSearchInfo"));
         this.playerSearchBtn.x = Globals.MARGIN_X;
         this.playerSearchBtn.y = _loc1_.y + 50;
         addMadeButton(this.playerSearchBtn);
         this.browseClubBtn = new BigButton(CopyManager.getCopy("browseClubs"),CopyManager.getCopy("browseClubsInfo"));
         this.browseClubBtn.x = Globals.MARGIN_X;
         this.browseClubBtn.y = this.playerSearchBtn.y + 100;
         addMadeButton(this.browseClubBtn);
         this.sellPlayerBtn = new BigButton(CopyManager.getCopy("sellPlayer"),CopyManager.getCopy("sellPlayerInfo"));
         this.sellPlayerBtn.x = Globals.MARGIN_X;
         this.sellPlayerBtn.y = this.browseClubBtn.y + 100;
         addMadeButton(this.sellPlayerBtn);
         this.backBtn2 = new BigButton(CopyManager.getCopy("back"),CopyManager.getCopy("backToManagerInfo"));
         this.backBtn2.x = Globals.MARGIN_X;
         this.backBtn2.y = this.sellPlayerBtn.y + 100;
         addMadeButton(this.backBtn2);
         var _loc2_:TransferImage = new TransferImage();
         _loc2_.x = 410;
         _loc2_.y = this.playerSearchBtn.y;
         addChild(_loc2_);
         _loc2_.filters = [new GlowFilter(16777215,1,2,2,5,3),new DropShadowFilter(4,45,0,0.5)];
         enabled = true;
         var _loc3_:StatusPanel = new StatusPanel();
         addChild(_loc3_);
      }
      
      override protected function clickButtonHandler(param1:Event) : void
      {
         switch(param1.target)
         {
            case this.playerSearchBtn:
               Main.instance.showScreen(Screen.PLAYER_SEARCH_SCREEN);
               break;
            case this.browseClubBtn:
               Main.instance.showScreen(Screen.BROWSE_CLUBS_SCREEN);
               break;
            case this.sellPlayerBtn:
               Main.instance.showScreen(Screen.SELL_PLAYERS_SCREEN);
               break;
            case this.backBtn2:
               Main.instance.showScreen(Screen.MANAGERS_SCREEN);
         }
      }
   }
}

