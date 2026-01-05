package com.utterlySuperb.chumpManager.view.screens
{
   import com.utterlySuperb.chumpManager.events.PlayerEvent;
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.view.panels.managerPanels.BrowseClubPlayerList;
   import com.utterlySuperb.chumpManager.view.panels.managerPanels.BrowseClubsList;
   import com.utterlySuperb.chumpManager.view.panels.managerPanels.BrowseLeaguesList;
   import com.utterlySuperb.chumpManager.view.screens.transfers.TransferSearchScreen;
   import com.utterlySuperb.events.IntEvent;
   import com.utterlySuperb.text.TextHelper;
   import com.utterlySuperb.ui.ListBox;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class BrowseClubsScreen extends TransferSearchScreen
   {
      
      private var playersList:BrowseClubPlayerList;
      
      private var clubsList:BrowseClubsList;
      
      private var leaguesList:BrowseLeaguesList;
      
      private var tf0:TextField;

      private var clubIndex:int = 0;
      
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
         this.leaguesList = new BrowseLeaguesList();
         this.leaguesList.x = Globals.MARGIN_X;
         this.leaguesList.y = this.tf0.y + 40;
         addChildAt(this.leaguesList,0);
         this.leaguesList.addEventListener(ListBox.CLICK_ITEM,this.changeLeagueHandler);
         this.leaguesList.setCurrentBtn(Main.currentGame.mainLeagueNum);
         this.clubsList = new BrowseClubsList();
         this.clubsList.x = this.leaguesList.x;
         this.clubsList.y = this.leaguesList.y;
         addChildAt(this.clubsList,0);
         this.clubsList.addEventListener(ListBox.CLICK_ITEM,this.changeClubHandler);
         this.playersList = new BrowseClubPlayerList();
         this.playersList.x = this.clubsList.x + 300;
         this.playersList.y = this.clubsList.y;
         addChild(this.playersList);
         this.playersList.addEventListener(PlayerEvent.OVER_PLAYER,overPlayerHandler);
         this.playersList.addEventListener(PlayerEvent.CLICK_PLAYER,clickPlayerHandler);
         addPlayerInfo(this.playersList.x + 260,this.playersList.y);
         this.leaguesList.currentBtn = Main.currentGame.mainLeagueNum;
         this.clubsList.changeLeague(this.leaguesList.currentBtn);
         this.changeClubHandler(new IntEvent(ListBox.CLICK_ITEM,0));
         enabled = true;
      }
      
      private function changeLeagueHandler(param1:IntEvent) : void
      {
         this.clubsList.changeLeague(param1.num);
         if(this.clubIndex >= 0)
         {
            this.clubIndex = Math.min(this.clubIndex,Main.currentGame.leagues[this.leaguesList.currentBtn].entrants.length - 1);
            this.changeClubHandler(new IntEvent(ListBox.CLICK_ITEM,this.clubIndex));
         }
      }
      
      private function changeClubHandler(param1:IntEvent) : void
      {
         this.clubIndex = param1.num;
         if(!Main.currentGame.leagues[this.leaguesList.currentBtn] || !Main.currentGame.leagues[this.leaguesList.currentBtn].entrants || Main.currentGame.leagues[this.leaguesList.currentBtn].entrants.length == 0)
         {
            return;
         }
         this.clubIndex = Math.max(0,Math.min(this.clubIndex,Main.currentGame.leagues[this.leaguesList.currentBtn].entrants.length - 1));
         var _loc2_:* = Main.currentGame.leagues[this.leaguesList.currentBtn].entrants[this.clubIndex].club;
         this.playersList.setClub(_loc2_);
         this.tf0.htmlText = CopyManager.getCopy("showClubPlayers") + " " + _loc2_.name;
      }
      
      override public function cleanUp() : void
      {
         super.cleanUp();
         this.leaguesList.removeEventListener(ListBox.CLICK_ITEM,this.changeLeagueHandler);
         this.clubsList.removeEventListener(ListBox.CLICK_ITEM,this.changeClubHandler);
         this.playersList.removeEventListener(PlayerEvent.OVER_PLAYER,overPlayerHandler);
         this.playersList.removeEventListener(PlayerEvent.CLICK_PLAYER,clickPlayerHandler);
      }
   }
}

