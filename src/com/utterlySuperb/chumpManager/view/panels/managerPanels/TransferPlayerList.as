package com.utterlySuperb.chumpManager.view.panels.managerPanels
{
   import com.utterlySuperb.chumpManager.events.PlayerEvent;
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.Game;
   import com.utterlySuperb.chumpManager.model.dataObjects.Player;
   import com.utterlySuperb.chumpManager.model.dataObjects.StaticInfo;
   import com.utterlySuperb.chumpManager.view.panels.FiltersPanel;
   import com.utterlySuperb.chumpManager.view.panels.Panel;
   import com.utterlySuperb.chumpManager.view.ui.ChumpListBox;
   import com.utterlySuperb.chumpManager.view.ui.FilterSlider;
   import com.utterlySuperb.chumpManager.view.ui.buttons.listButtons.PlayerListButton;
   import com.utterlySuperb.chumpManager.view.ui.buttons.listButtons.TransferListButton;
   import com.utterlySuperb.chumpManager.view.ui.widgets.PagingWidget;
   import com.utterlySuperb.events.IntEvent;
   import com.utterlySuperb.ui.ListBox;
   import com.utterlySuperb.ui.dropDown.DropDown;
   import flash.events.Event;
   
   public class TransferPlayerList extends Panel
   {
      
      private var playerList:ChumpListBox;
      
      private var paging:PagingWidget;
      
      private var pageNum:int = 0;
      
      private var sortBy:int = 0;
      
      private var showState:int = -1;
      
      private var filteredPlayers:Array;
      
      private var sortByList:DropDown;
      
      public var filterPanel:FiltersPanel;
      
      public var playerType:int = 0;
      
      private const maxItems:int = 100;
      
      private const listWidth:int = 215;
      
      public function TransferPlayerList()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.playerList = new ChumpListBox(this.listWidth,Globals.GAME_HEIGHT - y - 60);
         addChild(this.playerList);
         this.playerList.y = 30;
         this.playerList.addEventListener(ListBox.CLICK_ITEM,this.clickListItemHandler);
         this.playerList.addEventListener(ListBox.OVER_ITEM,this.overListItemHandler);
         this.paging = new PagingWidget();
         this.paging.x = 130;
         addChild(this.paging);
         this.paging.addEventListener(PagingWidget.GOTO_PAGE,this.changePageHandler);
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
      
      override protected function cleanUp() : void
      {
         this.paging.cleanUp();
         this.paging.removeEventListener(PagingWidget.GOTO_PAGE,this.changePageHandler);
         this.playerList.removeEventListener(ListBox.CLICK_ITEM,this.clickListItemHandler);
         this.playerList.removeEventListener(ListBox.OVER_ITEM,this.overListItemHandler);
         this.playerList.disable();
         this.sortByList.disableButton();
         this.sortByList.removeEventListener(DropDown.DROP_DOWN_CLICK,this.dropDownSelectHandler);
         this.filterPanel = null;
      }
      
      private function changePageHandler(param1:IntEvent) : void
      {
         this.pageNum = param1.num;
         this.populateList();
      }
      
      public function setFilters(param1:FiltersPanel) : void
      {
         this.filterPanel = param1;
         this.update();
      }
      
      override protected function update(param1:Object = null) : void
      {
         this.makePlayers();
         this.pageNum = 0;
         this.filteredPlayers = this.filteredPlayers.sort(this.sortFunction);
         this.populateList();
         this.showState = this.sortBy;
      }
      
      private function makePlayers() : void
      {
         var _loc4_:FilterSlider = null;
         var _loc5_:FilterSlider = null;
         var _loc6_:FilterSlider = null;
         var _loc7_:* = false;
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         var _loc10_:Array = null;
         var _loc11_:Boolean = false;
         var _loc1_:Game = Main.currentGame;
         this.filteredPlayers = new Array();
         var _loc2_:Array = StaticInfo.getPlayerList();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_].active && this.filteredPlayers.indexOf(_loc2_[_loc3_]) < 0 && !(_loc2_[_loc3_].club && !_loc2_[_loc3_].club.isCore))
            {
               this.filteredPlayers.push(_loc2_[_loc3_]);
            }
            _loc3_++;
         }
         if(this.filterPanel.useFilters())
         {
            _loc4_ = this.filterPanel.filtersList[Player.PLAYER_STATS.length + Player.KEEPER_STATS.length];
            _loc5_ = this.filterPanel.filtersList[Player.PLAYER_STATS.length + Player.KEEPER_STATS.length + 1];
            _loc6_ = this.filterPanel.filtersList[Player.PLAYER_STATS.length + Player.KEEPER_STATS.length + 2];
            _loc3_ = 0;
            while(_loc3_ < this.filteredPlayers.length)
            {
               _loc7_ = !this.filteredPlayers[_loc3_].active;
               if(!_loc7_ && Boolean(this.filteredPlayers[_loc3_].isKeeper()))
               {
                  _loc8_ = int(Player.PLAYER_STATS.length);
                  while(_loc8_ < Player.PLAYER_STATS.length + Player.KEEPER_STATS.length)
                  {
                     _loc9_ = Number(this.filteredPlayers[_loc3_].currentStats[_loc8_ - Player.PLAYER_STATS.length]);
                     if(this.filterPanel.filtersList[_loc8_].isActive() && (_loc9_ < this.filterPanel.filtersList[_loc8_].min || _loc9_ > this.filterPanel.filtersList[_loc8_].max))
                     {
                        _loc7_ = true;
                        break;
                     }
                     _loc8_++;
                  }
               }
               else if(!_loc7_)
               {
                  _loc8_ = 0;
                  while(_loc8_ < Player.PLAYER_STATS.length)
                  {
                     _loc9_ = Number(this.filteredPlayers[_loc3_].currentStats[_loc8_]);
                     if(this.filterPanel.filtersList[_loc8_].isActive() && (_loc9_ < this.filterPanel.filtersList[_loc8_].min || _loc9_ > this.filterPanel.filtersList[_loc8_].max))
                     {
                        _loc7_ = true;
                        break;
                     }
                     _loc8_++;
                  }
               }
               if(!_loc7_ && _loc4_.isActive() && (this.filteredPlayers[_loc3_].age > _loc4_.max || this.filteredPlayers[_loc3_].age < _loc4_.min))
               {
                  _loc7_ = true;
               }
               if(!_loc7_ && _loc5_.isActive() && (this.filteredPlayers[_loc3_].playerStars > int(_loc5_.max) || this.filteredPlayers[_loc3_].playerStars < int(_loc5_.min)))
               {
                  _loc7_ = true;
               }
               if(!_loc7_ && _loc6_.isActive())
               {
                  if(this.filteredPlayers[_loc3_].transferValue > int(_loc6_.max) && _loc6_.max < 100000000 || this.filteredPlayers[_loc3_].transferValue < int(_loc6_.min))
                  {
                     _loc7_ = true;
                  }
               }
               if(!_loc7_ && this.playerType > 0)
               {
                  if(this.playerType < 5)
                  {
                     _loc10_ = ["gk"];
                     switch(Player.BASE_POSITIONS[this.playerType - 1])
                     {
                        case "def":
                           _loc10_ = ["cb","fb","wb"];
                           break;
                        case "mid":
                           _loc10_ = ["dm","cm","sm"];
                           break;
                        case "fwd":
                           _loc10_ = ["cf","wf"];
                     }
                     _loc11_ = false;
                     _loc8_ = 0;
                     while(_loc8_ < _loc10_.length)
                     {
                        if(this.filteredPlayers[_loc3_].positions.indexOf(_loc10_[_loc8_]) >= 0)
                        {
                           _loc11_ = true;
                        }
                        _loc8_++;
                     }
                     if(!_loc11_)
                     {
                        _loc7_ = true;
                     }
                  }
                  else if(this.filteredPlayers[_loc3_].positions.indexOf(Player.POSITIONS[this.playerType - 5]) < 0)
                  {
                     _loc7_ = true;
                  }
               }
               if(_loc7_)
               {
                  this.filteredPlayers.splice(_loc3_,1);
                  _loc3_--;
               }
               _loc3_++;
            }
         }
      }
      
      private function populateList() : void
      {
         var _loc2_:TransferListButton = null;
         this.playerList.depopulate();
         var _loc1_:int = this.pageNum * this.maxItems;
         while(_loc1_ < Math.min(this.filteredPlayers.length,this.maxItems + this.pageNum * this.maxItems))
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
         this.paging.setValues(this.pageNum,Math.ceil(this.filteredPlayers.length / this.maxItems),0);
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

