package com.utterlySuperb.chumpManager.view.screens.transfers
{
   import com.utterlySuperb.chumpManager.events.PlayerEvent;
   import com.utterlySuperb.chumpManager.view.panels.Panel;
   import com.utterlySuperb.chumpManager.view.panels.managerPanels.BrowseClubPlayerList;
   import com.utterlySuperb.chumpManager.view.panels.managerPanels.TransferPlayerInfo;
   import com.utterlySuperb.chumpManager.view.screens.Screen;
   import com.utterlySuperb.chumpManager.view.ui.widgets.TeamPlayerStatsDisplay;
   
   public class SellPlayersScreen extends TransferSearchScreen
   {
      
      private var playersList:BrowseClubPlayerList;
      
      private var playerDisplay:TeamPlayerStatsDisplay;
      
      public function SellPlayersScreen()
      {
         super();
         makeBackButton();
         makeHomeButton();
         Main.instance.backOverride = Screen.TRANSFERS_SCREEN;
         addStatus();
         var _loc1_:Panel = new Panel();
         addChild(_loc1_);
         _loc1_.makeBox(780,Globals.GAME_HEIGHT - Globals.belowStatus - 10,-10,-60);
         _loc1_.x = Globals.MARGIN_X;
         _loc1_.y = Globals.belowStatus + 50;
         this.playersList = new BrowseClubPlayerList();
         this.playersList.x = Globals.MARGIN_X + 20;
         this.playersList.y = Globals.belowStatus + 10;
         this.playersList.currentClub = Main.currentGame.playerClub;
         addChild(this.playersList);
         this.playersList.addEventListener(PlayerEvent.OVER_PLAYER,this.overPlayerHandler);
         this.playersList.addEventListener(PlayerEvent.CLICK_PLAYER,clickPlayerHandler);
         this.playerDisplay = new TeamPlayerStatsDisplay();
         this.playerDisplay.x = this.playersList.x + 310;
         this.playerDisplay.y = this.playersList.y;
         addChild(this.playerDisplay);
         this.playerDisplay.addEventListener(TransferPlayerInfo.CLICKED_PLAYER_ACTION,clickPlayerHandler);
         this.playerDisplay.addEventListener(TransferPlayerInfo.CLICKED_PLAYER_ACTION1,clickPlayerHandler);
         enabled = true;
      }
      
      override protected function overPlayerHandler(param1:PlayerEvent) : void
      {
         this.playerDisplay.setPlayer(param1.player);
      }
      
      override public function cleanUp() : void
      {
         enabled = false;
         this.playerDisplay.removeEventListener(TransferPlayerInfo.CLICKED_PLAYER_ACTION,clickPlayerHandler);
         this.playerDisplay.removeEventListener(TransferPlayerInfo.CLICKED_PLAYER_ACTION1,clickPlayerHandler);
         this.playersList.removeEventListener(PlayerEvent.OVER_PLAYER,this.overPlayerHandler);
         this.playersList.removeEventListener(PlayerEvent.CLICK_PLAYER,clickPlayerHandler);
      }
   }
}

