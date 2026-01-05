package com.utterlySuperb.chumpManager.view.panels.managerPanels
{
   import com.utterlySuperb.chumpManager.view.panels.Panel;
   import com.utterlySuperb.chumpManager.view.ui.ChumpListBox;
   import com.utterlySuperb.chumpManager.view.ui.buttons.ListButton;
   import com.utterlySuperb.events.IntEvent;
   import com.utterlySuperb.ui.ListBox;
   
   public class BrowseClubsList extends Panel
   {
      
      private var clubList:ChumpListBox;
      
      private var currentBtn:int;
      public var currentLeagueIndex:int = 0;
      private var currentLeague:int = 0;
      
      private const listWidth:int = 240;
      
      public function BrowseClubsList()
      {
         super();
      }
      
      override protected function init() : void
      {
         makeBox(780,Globals.GAME_HEIGHT - Globals.belowStatus - 10,-10,-60);
         this.clubList = new ChumpListBox(this.listWidth,Globals.GAME_HEIGHT - y - 160);
         addChild(this.clubList);
         this.clubList.y = 130;
         this.clubList.addEventListener(ListBox.CLICK_ITEM,this.clickListItemHandler);
         this.changeLeague(this.currentLeagueIndex);
         this.clubList.enable();
      }
      
      public function changeLeague(param1:int) : void
      {
         this.currentLeagueIndex = param1;
         this.currentLeague = param1;
         if(!this.clubList)
         {
            return;
         }
         this.currentBtn = 0;
         this.rebuildList();
      }
      
      private function rebuildList() : void
      {
         var _loc3_:ListButton = null;
         this.clubList.depopulate();
         if(!Main.currentGame.leagues[this.currentLeague] || !Main.currentGame.leagues[this.currentLeague].entrants || Main.currentGame.leagues[this.currentLeague].entrants.length == 0)
         {
            this.currentBtn = 0;
            return;
         }
         this.currentBtn = Math.max(0,Math.min(this.currentBtn,Main.currentGame.leagues[this.currentLeague].entrants.length - 1));
         var _loc2_:int = 0;
         while(_loc2_ < Main.currentGame.leagues[this.currentLeague].entrants.length)
         {
            _loc3_ = new ListButton();
            _loc3_.bWidth = this.listWidth;
            _loc3_.setText(Main.currentGame.leagues[this.currentLeague].entrants[_loc2_].club.name);
            this.clubList.addItem(_loc3_);
            _loc3_.setBG(_loc2_ % 2 == 0);
            if(_loc2_ == this.currentBtn)
            {
               _loc3_.setInTeam();
            }
            else
            {
               _loc3_.setDefault();
            }
            _loc2_++;
         }
         this.setBtns();
         this.clubList.enable();
      }
      
      private function clickListItemHandler(param1:IntEvent) : void
      {
         this.currentBtn = param1.num;
         dispatchEvent(param1);
         this.setBtns();
      }
      
      private function setBtns() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.clubList.numItems)
         {
            if(_loc1_ == this.currentBtn)
            {
               ListButton(this.clubList.getButtonAt(_loc1_)).setInTeam();
            }
            else
            {
               ListButton(this.clubList.getButtonAt(_loc1_)).setDefault();
            }
            _loc1_++;
         }
      }
      
      override protected function cleanUp() : void
      {
         this.clubList.removeEventListener(ListBox.CLICK_ITEM,this.clickListItemHandler);
         this.clubList.disable();
      }
   }
}

