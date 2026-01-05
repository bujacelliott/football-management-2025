package com.utterlySuperb.chumpManager.view.panels.managerPanels
{
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.competitions.League;
   import com.utterlySuperb.chumpManager.view.panels.Panel;
   import com.utterlySuperb.chumpManager.view.ui.ChumpListBox;
   import com.utterlySuperb.chumpManager.view.ui.buttons.ListButton;
   import com.utterlySuperb.events.IntEvent;
   import com.utterlySuperb.ui.ListBox;
   
   public class BrowseLeaguesList extends Panel
   {
      
      private var leaguesList:ChumpListBox;
      
      public var currentBtn:int = 0;
      
      private const listWidth:int = 240;
      
      public function BrowseLeaguesList()
      {
         super();
      }
      
      override protected function init() : void
      {
         var _loc3_:ListButton = null;
         this.leaguesList = new ChumpListBox(this.listWidth,120);
         addChild(this.leaguesList);
         this.leaguesList.addEventListener(ListBox.CLICK_ITEM,this.clickListItemHandler);
         var _loc1_:int = 0;
         // Include all built leagues (no longer need to drop the last slot)
         while(_loc1_ < Main.currentGame.leagues.length)
         {
            if(Main.currentGame.leagues[_loc1_])
            {
               _loc3_ = new ListButton();
               _loc3_.bWidth = this.listWidth;
               _loc3_.setText(this.getLeagueName(Main.currentGame.leagues[_loc1_]));
               this.leaguesList.addItem(_loc3_);
               _loc3_.setBG(_loc1_ % 2 == 0);
               if(_loc1_ == this.currentBtn)
               {
                  _loc3_.setInTeam();
               }
               else
               {
                  _loc3_.setDefault();
               }
            }
            _loc1_++;
         }
         this.leaguesList.enable();
      }
      
      private function getLeagueName(param1:League) : String
      {
         var _loc2_:String = CopyManager.getCopy(param1.name);
         if(!_loc2_)
         {
            _loc2_ = param1.name;
         }
         return _loc2_;
      }
      
      public function setCurrentBtn(param1:int) : void
      {
         this.currentBtn = Math.max(0,Math.min(param1,this.leaguesList ? this.leaguesList.numItems - 1 : param1));
         if(this.leaguesList)
         {
            this.setBtns();
         }
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
         while(_loc1_ < this.leaguesList.numItems)
         {
            if(_loc1_ == this.currentBtn)
            {
               ListButton(this.leaguesList.getButtonAt(_loc1_)).setInTeam();
            }
            else
            {
               ListButton(this.leaguesList.getButtonAt(_loc1_)).setDefault();
            }
            _loc1_++;
         }
      }
      
      override protected function cleanUp() : void
      {
         this.leaguesList.removeEventListener(ListBox.CLICK_ITEM,this.clickListItemHandler);
         this.leaguesList.disable();
      }
   }
}
