package com.utterlySuperb.chumpManager.view.panels
{
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.Game;
   import com.utterlySuperb.chumpManager.model.dataObjects.Player;
   import com.utterlySuperb.chumpManager.view.ui.FilterPositionCheck;
   import com.utterlySuperb.chumpManager.view.ui.FilterSlider;
   import com.utterlySuperb.chumpManager.view.ui.PriceFilter;
   import com.utterlySuperb.chumpManager.view.ui.buttons.ChumpButton;
   import com.utterlySuperb.events.BudgetEventProxy;
   import com.utterlySuperb.ui.Checkbox;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class FiltersPanel extends Panel
   {
      
      public static const APPLY_FILTERS:String = "applyFilters";
      
      public static const HIDE_FILTERS:String = "hideFilters";
      
      public var filtersList:Vector.<FilterSlider>;
      
      public var postionsChecks:Vector.<FilterPositionCheck>;
      
      private var filtersMC:Sprite;
      
      public var useFiltersCheckBox:Checkbox;
      
      private var applyFiltersButton:ChumpButton;
      
      private var hideFiltersButton:ChumpButton;
      
      public function FiltersPanel()
      {
         super();
      }
      
      override protected function init() : void
      {
         var _loc6_:FilterPositionCheck = null;
         makeBox(780,Globals.GAME_HEIGHT - Globals.belowStatus - 10,-10,-60);
         var _loc1_:int = 35;
         this.filtersMC = new Sprite();
         addChild(this.filtersMC);
         this.filtersList = new Vector.<FilterSlider>();
         var _loc2_:int = 0;
         while(_loc2_ < Player.PLAYER_STATS.length)
         {
            this.makeFilter(CopyManager.getCopy(Player.PLAYER_STATS[_loc2_]),0,_loc2_ * _loc1_);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < Player.KEEPER_STATS.length)
         {
            this.makeFilter(CopyManager.getCopy(Player.KEEPER_STATS[_loc2_]),200,_loc2_ * _loc1_);
            _loc2_++;
         }
         var _loc3_:FilterSlider = this.makeFilter(CopyManager.getCopy("age"),200,_loc2_ * _loc1_);
         _loc3_.setSize(Player.MIN_AGE,Player.MAX_KEEPER_AGE,80);
         var _loc4_:FilterSlider = this.makeFilter(CopyManager.getCopy("playerRating"),200,(_loc2_ + 1) * _loc1_);
         _loc4_.setSize(1,10,80);
         var _loc5_:PriceFilter = new PriceFilter();
         this.filtersMC.addChild(_loc5_);
         _loc5_.setTitle(CopyManager.getCopy("price"));
         _loc5_.x = int(this.filtersList.length / 10) * 180;
         _loc5_.y = this.filtersList.length % 10 * 35;
         this.filtersList.push(_loc5_);
         _loc5_.setSize(0,100000000,80);
         _loc5_.setFilters(0,100000000);
         _loc5_.activate();
         this.postionsChecks = new Vector.<FilterPositionCheck>();
         _loc2_ = 0;
         while(_loc2_ < Player.POSITIONS.length)
         {
            _loc6_ = new FilterPositionCheck();
            _loc6_.x = 220 + 80 * (_loc2_ % 2);
            _loc6_.y = this.filtersList[this.filtersList.length - 1].y + 40 + 40 * Math.floor(_loc2_ / 2);
            _loc6_.setText(Player.POSITIONS[_loc2_]);
            _loc6_.activate();
            this.postionsChecks.push(_loc6_);
            _loc2_++;
         }
         this.applyFiltersButton = ChumpButton.getButton("");
         this.applyFiltersButton.setText(CopyManager.getCopy("applyFilters"));
         addChild(this.applyFiltersButton);
         this.applyFiltersButton.y = 10 * _loc1_ + 15 + this.filtersMC.y;
         this.applyFiltersButton.activate();
         this.applyFiltersButton.addEventListener(MouseEvent.MOUSE_UP,this.clickApplyFiltersHandler);
         dispatchEvent(new Event(APPLY_FILTERS));
      }
      
      private function clickHideFiltersHandler(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(HIDE_FILTERS));
      }
      
      private function clickApplyFiltersHandler(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(APPLY_FILTERS));
         BudgetEventProxy.dispatchEvent(Game.DATA_CHANGED,null);
      }
      
      private function makeFilter(param1:String, param2:int, param3:int) : FilterSlider
      {
         var _loc4_:FilterSlider = new FilterSlider();
         this.filtersMC.addChild(_loc4_);
         _loc4_.setTitle(param1);
         _loc4_.x = int(this.filtersList.length / 10) * 170;
         _loc4_.y = this.filtersList.length % 10 * 35;
         this.filtersList.push(_loc4_);
         _loc4_.setSize(0,100,80);
         _loc4_.setFilters(0,100);
         _loc4_.activate();
         return _loc4_;
      }
      
      public function useFilters() : Boolean
      {
         return true;
      }
      
      override protected function cleanUp() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.filtersList.length)
         {
            this.filtersList[_loc1_].deactivate();
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.postionsChecks.length)
         {
            this.postionsChecks[_loc1_].deactivate();
            _loc1_++;
         }
         this.applyFiltersButton.deactivate();
         this.applyFiltersButton.removeEventListener(MouseEvent.MOUSE_UP,this.clickApplyFiltersHandler);
      }
   }
}

