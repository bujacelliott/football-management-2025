package com.utterlySuperb.ui
{
   import com.utterlySuperb.events.IntEvent;
   import com.utterlySuperb.ui.buttons.GenericButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ListBox extends Sprite
   {
      
      public static const OVER_ITEM:String = "overItem";
      
      public static const OUT_ITEM:String = "outItem";
      
      public static const CLICK_ITEM:String = "clickItem";
      
      public static const CLICK_PRESS:String = "clickPress";
      
      public static var debug:Boolean = false;
      
      protected var items:Array;
      
      private var scrollY:int;
      
      private var maxScrollY:int;
      
      protected var offsetY:int;
      
      protected var maxHeight:int;
      
      protected var maxWidth:int;
      
      protected var holder:Sprite;
      
      private var itemsMask:Sprite;
      
      protected var scroller:IntScrollBar;
      
      private var headerItem:GenericButton;
      
      private var enabled:Boolean;
      
      public function ListBox(param1:int, param2:int)
      {
         super();
         this.items = [];
         this.scrollY = this.offsetY = 0;
         this.maxWidth = param1;
         this.maxHeight = param2;
         this.holder = new Sprite();
         addChild(this.holder);
         this.itemsMask = new Sprite();
         addChild(this.itemsMask);
         this.itemsMask.graphics.beginFill(0,1);
         this.itemsMask.graphics.drawRect(0,0,this.maxWidth,this.maxHeight);
         this.holder.mask = this.itemsMask;
         if(debug)
         {
            this.displayBorder();
         }
      }
      
      public function addHeaderItem(param1:GenericButton) : void
      {
         this.headerItem = param1;
         addChild(param1);
         this.offsetY = this.holder.y = param1.getHeight();
         this.maxHeight -= this.offsetY;
      }
      
      public function addItem(param1:GenericButton) : void
      {
         if(this.items.length > 0)
         {
            param1.y = this.items[this.items.length - 1].y + this.items[this.items.length - 1].getHeight();
         }
         this.items.push(param1);
         this.maxScrollY = param1.y + param1.getHeight() - this.maxHeight;
         if(this.maxScrollY > 0 && !this.scroller)
         {
            this.addScroller();
         }
         if(this.enabled)
         {
            this.activateButton(param1);
         }
         this.display();
      }
      
      public function addItemAtTop(param1:GenericButton) : void
      {
         this.items.splice(0,0,param1);
         this.arrangeItems();
         if(this.enabled)
         {
            this.activateButton(param1);
         }
         this.display();
      }
      
      public function addItemAt(param1:GenericButton, param2:uint) : void
      {
         this.items.splice(Math.min(param2,this.items.length),0,param1);
         this.arrangeItems();
         if(this.enabled)
         {
            this.activateButton(param1);
         }
         this.display();
      }
      
      public function moveItemTo(param1:GenericButton, param2:uint) : void
      {
         if(param2 < 0)
         {
            return;
         }
         var _loc3_:int = int(this.items.indexOf(param1));
         if(_loc3_ >= 0)
         {
            if(_loc3_ == param2 || param2 > this.items.length - 1)
            {
               return;
            }
            this.items.splice(_loc3_,1);
            this.items.splice(param2,0,param1);
            this.arrangeItems();
            this.display();
         }
         else if(param2 <= this.items.length)
         {
            this.addItemAt(param1,param2);
         }
      }
      
      public function removeItem(param1:GenericButton) : void
      {
         var _loc2_:int = int(this.items.indexOf(param1));
         if(_loc2_ >= 0)
         {
            this.items.splice(_loc2_,1);
            this.deactivateButton(param1);
            if(this.holder.contains(param1))
            {
               this.holder.removeChild(param1);
            }
         }
         this.arrangeItems();
      }
      
      public function depopulate() : void
      {
         var _loc1_:GenericButton = null;
         this.scrollY = this.offsetY = 0;
         this.maxHeight = this.itemsMask.height;
         this.disable();
         if(this.headerItem)
         {
            removeChild(this.headerItem);
         }
         this.headerItem = null;
         for each(_loc1_ in this.items)
         {
            if(this.holder.contains(_loc1_))
            {
               this.holder.removeChild(_loc1_);
            }
         }
         this.items = [];
         this.removeScroller();
      }
      
      private function arrangeItems() : void
      {
         var _loc1_:GenericButton = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.items.length)
         {
            GenericButton(this.items[_loc2_]).y = _loc1_ ? _loc1_.y + _loc1_.bHeight : 0;
            _loc1_ = this.items[_loc2_];
            _loc2_++;
         }
         this.maxScrollY = this.items.length * _loc1_.bHeight - this.maxHeight;
         if(this.maxScrollY > 0)
         {
            if(!this.scroller)
            {
               this.addScroller();
            }
         }
         else
         {
            this.removeScroller();
         }
      }
      
      public function setScroller() : void
      {
         if(this.scroller)
         {
            this.scroller.setScrollerSize(this.scroller.bg.height,this.items[this.items.length - 1].y + this.items[this.items.length - 1].bHeight,this.scroller.bg.height);
            this.scroller.setScrollerRange(this.maxHeight,this.holder);
         }
      }

      public function setScrollPercent(param1:Number) : void
      {
         if(this.scroller)
         {
            this.scroller.setValue(param1);
         }
      }

      public function isScrollable() : Boolean
      {
         return this.scroller != null;
      }

      public function getItems() : Array
      {
         return this.items;
      }
      
      protected function addScroller() : void
      {
         this.scroller = new IntScrollBar();
         this.scroller.quickSetup();
         this.scroller.setScrollerRange(this.maxHeight,this.holder);
         this.scroller.addEventListener(IntScrollBar.VALUE_CHANGED,this.scrollerHanlder);
         this.scroller.enable();
         addChild(this.scroller);
         this.scroller.x = this.maxWidth;
      }
      
      private function removeScroller() : void
      {
         if(this.scroller)
         {
            this.scroller.disable();
            this.scroller.removeEventListener(IntScrollBar.VALUE_CHANGED,this.scrollerHanlder);
            this.scroller = null;
         }
      }
      
      protected function scrollerHanlder(param1:Event) : void
      {
         this.scrollY = int(this.maxScrollY * this.scroller._scrollerPosition / 100);
         this.holder.y = -this.scrollY + this.offsetY;
         this.display();
      }
      
      private function display() : void
      {
         var _loc3_:GenericButton = null;
         var _loc1_:int = this.scrollY + this.maxHeight;
         var _loc2_:int = 0;
         while(_loc2_ < this.items.length)
         {
            _loc3_ = this.items[_loc2_];
            if(_loc3_.y < _loc1_ && _loc3_.y + _loc3_.getHeight() > this.scrollY)
            {
               if(!this.holder.contains(_loc3_))
               {
                  this.holder.addChild(_loc3_);
               }
            }
            else if(this.holder.contains(_loc3_))
            {
               this.holder.removeChild(_loc3_);
            }
            _loc2_++;
         }
      }
      
      private function itemOverHandler(param1:MouseEvent) : void
      {
         dispatchEvent(new IntEvent(OVER_ITEM,this.items.indexOf(param1.target)));
      }
      
      private function itemOutHandler(param1:MouseEvent) : void
      {
         dispatchEvent(new IntEvent(OUT_ITEM,this.items.indexOf(param1.target)));
      }
      
      private function itemClickHandler(param1:MouseEvent) : void
      {
         dispatchEvent(new IntEvent(CLICK_ITEM,this.items.indexOf(param1.target)));
      }
      
      private function itemPressHandler(param1:MouseEvent) : void
      {
         dispatchEvent(new IntEvent(CLICK_PRESS,this.items.indexOf(param1.target)));
      }
      
      public function enable() : void
      {
         this.enabled = true;
         this.setScroller();
         var _loc1_:int = 0;
         while(_loc1_ < this.items.length)
         {
            this.activateButton(this.items[_loc1_]);
            _loc1_++;
         }
         if(this.scroller)
         {
            this.scroller.addEventListener(IntScrollBar.VALUE_CHANGED,this.scrollerHanlder);
            this.scroller.enable();
         }
         this.display();
      }
      
      private function activateButton(param1:GenericButton) : void
      {
         if(!param1.hasEventListener(MouseEvent.MOUSE_OVER))
         {
            param1.addEventListener(MouseEvent.MOUSE_OVER,this.itemOverHandler);
            param1.addEventListener(MouseEvent.MOUSE_OUT,this.itemOutHandler);
            param1.addEventListener(MouseEvent.CLICK,this.itemClickHandler);
            param1.addEventListener(MouseEvent.MOUSE_DOWN,this.itemPressHandler);
         }
         param1.activate();
      }
      
      public function disable() : void
      {
         this.enabled = false;
         var _loc1_:int = 0;
         while(_loc1_ < this.items.length)
         {
            this.deactivateButton(this.items[_loc1_]);
            _loc1_++;
         }
         if(this.scroller)
         {
            this.scroller.disable();
            this.scroller.removeEventListener(IntScrollBar.VALUE_CHANGED,this.scrollerHanlder);
            if(contains(this.scroller))
            {
               removeChild(this.scroller);
            }
         }
      }
      
      private function deactivateButton(param1:GenericButton) : void
      {
         if(param1.hasEventListener(MouseEvent.MOUSE_OVER))
         {
            param1.removeEventListener(MouseEvent.MOUSE_OVER,this.itemOverHandler);
            param1.removeEventListener(MouseEvent.MOUSE_OUT,this.itemOutHandler);
            param1.removeEventListener(MouseEvent.CLICK,this.itemClickHandler);
            param1.removeEventListener(MouseEvent.MOUSE_DOWN,this.itemPressHandler);
         }
         param1.deactivate();
      }
      
      public function displayBorder() : void
      {
         graphics.clear();
         graphics.lineStyle(1);
         graphics.drawRect(0,0,this.maxWidth,this.maxHeight);
      }
      
      public function getButtonAt(param1:int) : GenericButton
      {
         return this.items[param1];
      }
      
      public function getButtonIndex(param1:GenericButton) : int
      {
         return this.items.indexOf(param1);
      }
      
      public function deselectAll() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.items.length)
         {
            this.items[_loc1_].removeSelected();
            _loc1_++;
         }
      }
      
      public function get numItems() : int
      {
         return this.items.length;
      }
   }
}

