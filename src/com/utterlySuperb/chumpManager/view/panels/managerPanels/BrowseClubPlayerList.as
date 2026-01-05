package com.utterlySuperb.chumpManager.view.panels.managerPanels
{
   import com.utterlySuperb.chumpManager.events.PlayerEvent;
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.Club;
   import com.utterlySuperb.chumpManager.model.dataObjects.Game;
   import com.utterlySuperb.chumpManager.model.dataObjects.Player;
   import com.utterlySuperb.chumpManager.model.dataObjects.StaticInfo;
   import com.utterlySuperb.chumpManager.view.panels.Panel;
   import com.utterlySuperb.chumpManager.view.ui.ChumpListBox;
   import com.utterlySuperb.chumpManager.view.ui.buttons.listButtons.PlayerListButton;
   import com.utterlySuperb.chumpManager.view.ui.buttons.listButtons.TransferListButton;
   import com.utterlySuperb.events.IntEvent;
   import com.utterlySuperb.ui.ListBox;
   import com.utterlySuperb.ui.dropDown.DropDown;
   import flash.events.Event;
   
   public class BrowseClubPlayerList extends Panel
   {
      
      private var playerList:ChumpListBox;
      
      private var sortBy:int = 0;
      
      private var filteredPlayers:Array;
      
      private var sortByList:DropDown;
      
      public var playerType:int = 0;
      
      public var currentClub:Club;
      
      private const maxItems:int = 100;
      
      private const listWidth:int = 215;
      
      public function BrowseClubPlayerList()
      {
         super();
      }
      
      override protected function init() : void
      {
         // Start near top (y=30) and stretch so bottom aligns with club list bottom (Globals.GAME_HEIGHT - 30)
         var playerListHeight:int = Globals.GAME_HEIGHT - this.y - 60;
         this.playerList = new ChumpListBox(this.listWidth,playerListHeight);
         addChild(this.playerList);
         this.playerList.y = 30;
         this.playerList.addEventListener(ListBox.CLICK_ITEM,this.clickListItemHandler);
         this.playerList.addEventListener(ListBox.OVER_ITEM,this.overListItemHandler);
         this.sortByList = new DropDown(Styles.getDropdownObject(120,24));
         this.sortByList.easyMake();
         addChild(this.sortByList);
         this.sortByList.addEventListener(DropDown.DROP_DOWN_CLICK,this.dropDownSelectHandler);
         var _loc1_:int = 0;
         while(_loc1_ < Player.PLAYER_STATS.length)
         {
            this.sortByList.addItem(CopyManager.getCopy(Player.PLAYER_STATS[_loc1_]));
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < Player.KEEPER_STATS.length)
         {
            this.sortByList.addItem(CopyManager.getCopy(Player.KEEPER_STATS[_loc1_]));
            _loc1_++;
         }
         this.sortByList.addItem(CopyManager.getCopy("age"));
         this.sortByList.addItem(CopyManager.getCopy("playerRating"));
         this.sortByList.selectedNum = 0;
         this.update();
      }
      
      private function dropDownSelectHandler(param1:Event) : void
      {
         if(param1.target == this.sortByList)
         {
            this.sortBy = this.sortByList.selectedNum;
         }
         this.update();
      }
      
      private function overListItemHandler(param1:IntEvent) : void
      {
         dispatchEvent(new PlayerEvent(PlayerEvent.OVER_PLAYER,PlayerListButton(this.playerList.getButtonAt(param1.num)).player));
      }
      
      private function clickListItemHandler(param1:IntEvent) : void
      {
         dispatchEvent(new PlayerEvent(PlayerEvent.CLICK_PLAYER,PlayerListButton(this.playerList.getButtonAt(param1.num)).player));
      }
      
      public function setClub(param1:Club, param2:Boolean = true) : void
      {
         this.currentClub = param1;
         if(param2 && this.playerList)
         {
            this.update();
         }
      }
      
      override protected function cleanUp() : void
      {
         this.playerList.removeEventListener(ListBox.CLICK_ITEM,this.clickListItemHandler);
         this.playerList.removeEventListener(ListBox.OVER_ITEM,this.overListItemHandler);
         this.playerList.disable();
         this.sortByList.disableButton();
         this.sortByList.removeEventListener(DropDown.DROP_DOWN_CLICK,this.dropDownSelectHandler);
      }
      
      override protected function update(param1:Object = null) : void
      {
         this.makePlayers();
         this.filteredPlayers = this.filteredPlayers.sort(this.sortFunction);
         this.populateList();
      }
      
      private function makePlayers() : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc1_:Game = Main.currentGame;
         if(this.currentClub)
         {
            this.filteredPlayers = this.currentClub.getPlayersList();
         }
         else
         {
            this.filteredPlayers = new Array();
            _loc2_ = StaticInfo.getPlayerList();
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               if(_loc2_[_loc3_].active && this.filteredPlayers.indexOf(_loc2_[_loc3_]) < 0 && (!_loc2_[_loc3_].club || _loc1_.getMainLeague().hasClub(_loc2_[_loc3_].club)))
               {
                  this.filteredPlayers.push(_loc2_[_loc3_]);
               }
               _loc3_++;
            }
         }
      }
      
      private function populateList() : void
      {
         var _loc2_:TransferListButton = null;
         if(!this.playerList)
         {
            return;
         }
         if(!this.filteredPlayers)
         {
            this.filteredPlayers = [];
         }
         this.playerList.depopulate();
         var _loc1_:int = 0;
         while(_loc1_ < Math.min(this.filteredPlayers.length,this.maxItems))
         {
            _loc2_ = new TransferListButton();
            _loc2_.bWidth = this.listWidth;
            _loc2_.setPlayer(this.filteredPlayers[_loc1_]);
            this.playerList.addItem(_loc2_);
            _loc2_.setBG(_loc1_ % 2 == 0);
            if(Main.currentGame.playerClub.players.indexOf(_loc2_.player.id) >= 0)
            {
               _loc2_.setInTeam();
            }
            else if(Main.currentGame.hasOfferOnPlayer(_loc2_.player))
            {
               _loc2_.setInSubs();
            }
            _loc1_++;
         }
         this.playerList.enable();
      }
      
      private function sortFunction(param1:Player, param2:Player) : Number
      {
         var _loc3_:Number = 0;
         if(this.sortBy < Player.PLAYER_STATS.length)
         {
            if(!param2.isKeeper() && !param1.isKeeper())
            {
               _loc3_ = param2.currentStats[this.sortBy] > param1.currentStats[this.sortBy] ? 1 : -1;
            }
            else if(param2.isKeeper())
            {
               _loc3_ = -1;
            }
            else
            {
               _loc3_ = 1;
            }
         }
         else if(this.sortBy < Player.KEEPER_STATS.length + Player.PLAYER_STATS.length)
         {
            if(param2.isKeeper() && param1.isKeeper())
            {
               _loc3_ = param2.currentStats[this.sortBy - Player.PLAYER_STATS.length] > param1.currentStats[this.sortBy - Player.PLAYER_STATS.length] ? 1 : -1;
            }
            else if(param2.isKeeper())
            {
               _loc3_ = 1;
            }
            else
            {
               _loc3_ = -1;
            }
         }
         else if(this.isAgeSort())
         {
            _loc3_ = param2.age < param1.age ? 1 : -1;
         }
         else if(this.isRatingSort())
         {
            _loc3_ = param2.playerRating > param1.playerRating ? 1 : -1;
         }
         return _loc3_;
      }
      
      private function isAgeSort() : Boolean
      {
         return this.sortBy == Player.KEEPER_STATS.length + Player.PLAYER_STATS.length;
      }
      
      private function isRatingSort() : Boolean
      {
         return this.sortBy == Player.KEEPER_STATS.length + Player.PLAYER_STATS.length + 1;
      }
   }
}

