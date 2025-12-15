package com.utterlySuperb.chumpManager.view.screens
{
   import com.utterlySuperb.chumpManager.engine.GameHelper;
   import com.utterlySuperb.chumpManager.events.PlayerEvent;
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.view.panels.managerPanels.BrowseClubPlayerList;
   import com.utterlySuperb.chumpManager.view.panels.managerPanels.BrowseClubsList;
   import com.utterlySuperb.chumpManager.view.screens.transfers.TransferSearchScreen;
   import com.utterlySuperb.events.IntEvent;
   import com.utterlySuperb.text.TextHelper;
   import com.utterlySuperb.ui.ListBox;
   import flash.text.TextField;
   
   public class BrowseClubsScreen extends TransferSearchScreen
   {
      
      private var playersList:BrowseClubPlayerList;
      
      private var clubsList:BrowseClubsList;
      
      private var tf0:TextField;
      
      public function BrowseClubsScreen()
      {
         super();
         makeBackButton();
         makeHomeButton();
         Main.instance.backOverride = Screen.TRANSFERS_SCREEN;
         addStatus();
         this.tf0 = new TextField();
         TextHelper.doTextField2(this.tf0,Styles.HEADER_FONT,16,Styles.HEADER_FONT_COLOR0);
         this.tf0.x = Globals.MARGIN_X;
         this.tf0.y = Globals.belowStatus + 10;
         this.tf0.htmlText = CopyManager.getCopy("showClubPlayers");
         addChild(this.tf0);
         this.clubsList = new BrowseClubsList();
         this.clubsList.x = Globals.MARGIN_X;
         this.clubsList.y = this.tf0.y + 40;
         addChildAt(this.clubsList,0);
         this.clubsList.addEventListener(ListBox.CLICK_ITEM,this.changeClubHandler);
         this.playersList = new BrowseClubPlayerList();
         this.playersList.x = this.clubsList.x + 300;
         this.playersList.y = this.clubsList.y;
         addChild(this.playersList);
         this.playersList.addEventListener(PlayerEvent.OVER_PLAYER,overPlayerHandler);
         this.playersList.addEventListener(PlayerEvent.CLICK_PLAYER,clickPlayerHandler);
         addPlayerInfo(this.playersList.x + 260,this.playersList.y);
         this.playersList.setClub(Main.currentGame.leagues[0].entrants[0].club,false);
         this.tf0.htmlText = CopyManager.getCopy("showClubPlayers") + " " + Main.currentGame.leagues[0].entrants[0].club.name;
         enabled = true;
      }
      
      private function changeClubHandler(param1:IntEvent) : void
      {
         this.playersList.setClub(GameHelper.getCoreClubs()[param1.num].club);
         this.tf0.htmlText = CopyManager.getCopy("showClubPlayers") + " " + Main.currentGame.leagues[0].entrants[param1.num].club.name;
      }
      
      override public function cleanUp() : void
      {
         super.cleanUp();
         this.clubsList.removeEventListener(ListBox.CLICK_ITEM,this.changeClubHandler);
         this.playersList.removeEventListener(PlayerEvent.OVER_PLAYER,overPlayerHandler);
         this.playersList.removeEventListener(PlayerEvent.CLICK_PLAYER,clickPlayerHandler);
      }
   }
}

