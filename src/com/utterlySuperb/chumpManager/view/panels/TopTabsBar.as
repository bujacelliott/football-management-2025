package com.utterlySuperb.chumpManager.view.panels
{
   import com.utterlySuperb.chumpManager.view.ui.buttons.TabButton;
   import com.utterlySuperb.events.IntEvent;
   import com.utterlySuperb.ui.buttons.GenericButton;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class TopTabsBar extends Sprite
   {
      
      private var hit:Sprite;
      
      public static const TAB_CONTROL:int = 0;
      
      public static const TAB_SQUAD:int = 1;
      
      public static const TAB_TRANSFERS:int = 2;
      
      public static const TAB_ACADEMY:int = 3;
      
      public static const TAB_OFFICE:int = 4;
      
      public static const TAB_CLICK:String = "tabClick";
      
      private var tabs:Array;
      
      private var activeIndex:int = 0;
      
      public function TopTabsBar(param1:int = 0)
      {
         super();
         this.tabs = [];
         this.activeIndex = param1;
         this.buildTabs();
      }
      
      private function buildTabs() : void
      {
         var _loc4_:int = 0;
         var _loc5_:TabButton = null;
         var _loc1_:Array = ["Control","Squad","Transfers","Academy","Office"];
         var _loc2_:int = 120;
         var _loc3_:int = 8;
         var _loc6_:int = _loc1_.length * _loc2_ + (_loc1_.length - 1) * _loc3_;
         var _loc7_:int = (Globals.GAME_WIDTH - _loc6_) / 2;
         this.hit = new Sprite();
         this.hit.graphics.beginFill(0,0);
         this.hit.graphics.drawRect(_loc7_,0,_loc6_,30);
         this.hit.graphics.endFill();
         this.hit.mouseEnabled = false;
         this.hit.mouseChildren = true;
         addChild(this.hit);
         _loc4_ = 0;
         while(_loc4_ < _loc1_.length)
         {
            _loc5_ = new TabButton(_loc1_[_loc4_],_loc2_,28);
            _loc5_.x = _loc7_ + _loc4_ * (_loc2_ + _loc3_);
            _loc5_.y = 0;
            _loc5_.addEventListener(GenericButton.BUTTON_CLICK,this.clickTabHandler);
            addChild(_loc5_);
            _loc5_.activate();
            this.tabs.push(_loc5_);
            _loc4_++;
         }
         this.setActive(this.activeIndex);
      }
      
      private function clickTabHandler(param1:Event) : void
      {
         var _loc2_:int = this.tabs.indexOf(param1.currentTarget);
         if(_loc2_ >= 0)
         {
            dispatchEvent(new IntEvent(TAB_CLICK,_loc2_));
         }
      }
      
      public function setActive(param1:int) : void
      {
         var _loc2_:int = 0;
         this.activeIndex = param1;
         _loc2_ = 0;
         while(_loc2_ < this.tabs.length)
         {
            TabButton(this.tabs[_loc2_]).setActive(_loc2_ == param1);
            _loc2_++;
         }
      }
   }
}
