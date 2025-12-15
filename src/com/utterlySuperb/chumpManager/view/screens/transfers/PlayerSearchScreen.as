package com.utterlySuperb.chumpManager.view.screens.transfers
{
   import com.utterlySuperb.chumpManager.events.PlayerEvent;
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.Game;
   import com.utterlySuperb.chumpManager.model.dataObjects.Player;
   import com.utterlySuperb.chumpManager.view.panels.FiltersPanel;
   import com.utterlySuperb.chumpManager.view.panels.managerPanels.TransferPlayerList;
   import com.utterlySuperb.chumpManager.view.panels.universalPanels.StatusPanel;
   import com.utterlySuperb.chumpManager.view.screens.Screen;
   import com.utterlySuperb.events.BudgetEventProxy;
   import com.utterlySuperb.text.TextHelper;
   import com.utterlySuperb.ui.dropDown.DropDown;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class PlayerSearchScreen extends TransferSearchScreen
   {
      
      private var filtersPanel:FiltersPanel;
      
      private var posDropDown:DropDown;
      
      private var playersList:TransferPlayerList;
      
      public function PlayerSearchScreen()
      {
         super();
         makeBackButton();
         makeHomeButton();
         Main.instance.backOverride = Screen.TRANSFERS_SCREEN;
         var _loc1_:StatusPanel = new StatusPanel();
         addChild(_loc1_);
         var _loc2_:TextField = new TextField();
         TextHelper.doTextField2(_loc2_,Styles.HEADER_FONT,16,Styles.HEADER_FONT_COLOR0);
         _loc2_.x = Globals.MARGIN_X;
         _loc2_.y = Globals.belowStatus + 10;
         _loc2_.htmlText = CopyManager.getCopy("show");
         addChild(_loc2_);
         this.posDropDown = new DropDown(Styles.getDropdownObject(160));
         this.posDropDown.easyMake();
         this.posDropDown.addItem(CopyManager.getCopy("allPlayers"));
         var _loc3_:int = 0;
         while(_loc3_ < Player.BASE_POSITIONS.length)
         {
            this.posDropDown.addItem(CopyManager.getCopy(Player.BASE_POSITIONS[_loc3_] + "_copy"));
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < Player.POSITIONS.length - 1)
         {
            this.posDropDown.addItem(CopyManager.getCopy(Player.POSITIONS[_loc3_] + "_copy"));
            _loc3_++;
         }
         this.posDropDown.x = _loc2_.x + _loc2_.textWidth + 10;
         this.posDropDown.y = _loc2_.y + 2;
         addChild(this.posDropDown);
         this.posDropDown.selectedNum = 0;
         this.posDropDown.addEventListener(DropDown.DROP_DOWN_CLICK,this.dropDownchangeHandler);
         this.posDropDown.enable();
         var _loc4_:TextField = new TextField();
         TextHelper.doTextField2(_loc4_,Styles.HEADER_FONT,16,Styles.HEADER_FONT_COLOR0);
         _loc4_.x = this.posDropDown.x + this.posDropDown.width + 5;
         _loc4_.y = _loc2_.y;
         _loc4_.htmlText = CopyManager.getCopy("withAttributes");
         addChild(_loc4_);
         this.filtersPanel = new FiltersPanel();
         this.filtersPanel.x = Globals.MARGIN_X;
         this.filtersPanel.y = _loc2_.y + 50;
         addChildAt(this.filtersPanel,0);
         this.playersList = new TransferPlayerList();
         this.playersList.x = this.filtersPanel.x + 350;
         this.playersList.y = this.filtersPanel.y - 20;
         this.playersList.filterPanel = this.filtersPanel;
         addChild(this.playersList);
         this.playersList.addEventListener(PlayerEvent.OVER_PLAYER,overPlayerHandler);
         this.playersList.addEventListener(PlayerEvent.CLICK_PLAYER,clickPlayerHandler);
         addPlayerInfo(this.playersList.x + 240,this.filtersPanel.y);
         enabled = true;
      }
      
      private function dropDownchangeHandler(param1:Event) : void
      {
         this.playersList.playerType = this.posDropDown.selectedNum;
         BudgetEventProxy.dispatchEvent(Game.DATA_CHANGED,null);
      }
      
      override public function cleanUp() : void
      {
         super.cleanUp();
         this.playersList.removeEventListener(PlayerEvent.OVER_PLAYER,overPlayerHandler);
         this.playersList.removeEventListener(PlayerEvent.CLICK_PLAYER,clickPlayerHandler);
         this.posDropDown.removeEventListener(DropDown.DROP_DOWN_CLICK,clickPlayerHandler);
         this.posDropDown.disableButton();
      }
   }
}

