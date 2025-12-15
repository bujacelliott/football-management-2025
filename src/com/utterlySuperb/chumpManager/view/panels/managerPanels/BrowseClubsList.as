package com.utterlySuperb.chumpManager.view.panels.managerPanels
{
   import com.utterlySuperb.chumpManager.engine.GameHelper;
   import com.utterlySuperb.chumpManager.view.panels.Panel;
   import com.utterlySuperb.chumpManager.view.ui.ChumpListBox;
   import com.utterlySuperb.chumpManager.view.ui.buttons.ListButton;
   import com.utterlySuperb.events.IntEvent;
   import com.utterlySuperb.ui.ListBox;
   
   public class BrowseClubsList extends Panel
   {
      
      private var clubList:ChumpListBox;
      
      private var currentBtn:int;
      
      private const listWidth:int = 240;
      
      public function BrowseClubsList()
      {
         super();
      }
      
      override protected function init() : void
      {
         var _loc2_:int = 0;
         var _loc3_:ListButton = null;
         makeBox(780,Globals.GAME_HEIGHT - Globals.belowStatus - 10,-10,-60);
         this.clubList = new ChumpListBox(this.listWidth,Globals.GAME_HEIGHT - y - 30);
         addChild(this.clubList);
         this.clubList.addEventListener(ListBox.CLICK_ITEM,this.clickListItemHandler);
         var _loc1_:Array = GameHelper.getCoreClubs();
         _loc2_ = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = new ListButton();
            _loc3_.bWidth = this.listWidth;
            _loc3_.setText(_loc1_[_loc2_].club.name);
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
         while(_loc1_ < Main.currentGame.leagues[0].entrants.length)
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

