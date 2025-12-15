package com.utterlySuperb.ui
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class IntScrollBar extends MovieClip
   {
      
      public static const VALUE_CHANGED:String = "valueChanged";
      
      public var upScrollButton:MovieClip;
      
      public var downScrollButton:MovieClip;
      
      public var scroller:MovieClip;
      
      public var bg:MovieClip;
      
      private var target:DisplayObject;
      
      private var _id:Number;
      
      public var scrollStep:Number;
      
      public var scrollStart:Number;
      
      public var scrollDist:Number;
      
      public var scrollDir:Number;
      
      private var scrollerPosition:Number;
      
      public var currentVal:int;
      
      public var isEnabled:Boolean;
      
      public var group:String;
      
      private var vs_min:Number;
      
      private var vs_max:Number;
      
      private var scrollAmount:Number;
      
      private var vt_min:Number;
      
      private var vt_max:Number;
      
      public function IntScrollBar()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.scrollStep = 2;
         this.scrollerPosition = 0;
      }
      
      public function cleanUp() : void
      {
         this.disable_scrollButtons();
      }
      
      public function enable() : void
      {
         this.enable_scrollButtons();
         this.setScrollerPosition();
      }
      
      public function disable() : void
      {
         this.disable_scrollButtons();
      }
      
      private function enable_scrollButtons() : void
      {
         if(this.upScrollButton)
         {
            this.upScrollButton.addEventListener(MouseEvent.MOUSE_DOWN,this.scrollUp);
            this.upScrollButton.addEventListener(MouseEvent.MOUSE_UP,this.stopScrollBtn);
         }
         if(this.downScrollButton)
         {
            this.downScrollButton.addEventListener(MouseEvent.MOUSE_DOWN,this.scrollDown);
            this.downScrollButton.addEventListener(MouseEvent.MOUSE_UP,this.stopScrollBtn);
         }
         if(Boolean(this.scroller) && !this.scroller.buttonMode)
         {
            this.scroller.buttonMode = true;
            this.scroller.addEventListener(MouseEvent.MOUSE_DOWN,this.startScroll);
         }
         this.target.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
      }
      
      private function disable_scrollButtons() : void
      {
         if(this.upScrollButton)
         {
            this.upScrollButton.removeEventListener(MouseEvent.MOUSE_DOWN,this.scrollUp);
            this.upScrollButton.removeEventListener(MouseEvent.MOUSE_UP,this.stopScrollBtn);
         }
         if(this.downScrollButton)
         {
            this.downScrollButton.removeEventListener(MouseEvent.MOUSE_DOWN,this.scrollDown);
            this.downScrollButton.removeEventListener(MouseEvent.MOUSE_UP,this.stopScrollBtn);
         }
         if(Boolean(this.scroller) && this.scroller.buttonMode)
         {
            this.scroller.buttonMode = false;
            this.scroller.removeEventListener(MouseEvent.MOUSE_DOWN,this.startScroll);
            this.scroller.removeEventListener(MouseEvent.MOUSE_UP,this.stopScroll);
         }
         if(hasEventListener(Event.ENTER_FRAME))
         {
            removeEventListener(Event.ENTER_FRAME,this.doScroll);
         }
         if(this.scroller.hasEventListener(Event.ENTER_FRAME))
         {
            this.scroller.removeEventListener(Event.ENTER_FRAME,this.doScroll);
         }
         this.target.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
      }
      
      public function quickSetup(param1:int = 20, param2:int = 100) : void
      {
         this.bg = new MovieClip();
         this.bg.graphics.beginFill(0,0.4);
         this.bg.graphics.drawRect(0,0,param1,param2);
         addChild(this.bg);
         this.scroller = new MovieClip();
         this.scroller.graphics.beginFill(16711680,1);
         this.scroller.graphics.drawRect(0,0,param1,param1);
         addChild(this.scroller);
      }
      
      public function setScrollerSize(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:Number = param3 / param2;
         var _loc5_:int = param1;
         if(this.upScrollButton)
         {
            _loc5_ -= this.upScrollButton.height;
         }
         if(this.downScrollButton)
         {
            _loc5_ -= this.downScrollButton.height;
         }
         this.scroller.height = _loc5_ * _loc4_;
      }
      
      public function setScrollerRange(param1:Number, param2:DisplayObject) : void
      {
         this.bg.height = Math.floor(param1);
         this.target = param2;
         this.scrollStart = 0;
         this.scrollDist = param1 - Math.floor(this.scroller.height);
         if(this.upScrollButton)
         {
            this.scrollStart = Math.floor(this.upScrollButton.height);
            this.scrollDist -= Math.floor(this.upScrollButton.height);
            this.upScrollButton.y = 0;
         }
         if(this.downScrollButton)
         {
            this.scrollDist -= Math.floor(this.downScrollButton.height);
            this.downScrollButton.y = param1 - this.downScrollButton.height;
         }
      }
      
      private function scrollUp(param1:Event) : void
      {
         this.scrollDir = -this.scrollStep;
         addEventListener(Event.ENTER_FRAME,this.doScrollBtn);
      }
      
      private function scrollDown(param1:Event) : void
      {
         this.scrollDir = this.scrollStep;
         addEventListener(Event.ENTER_FRAME,this.doScrollBtn);
      }
      
      private function doScrollBtn(param1:Event) : void
      {
         this._scrollerPosition += this.scrollDir;
         this.setScrollerPosition();
      }
      
      private function stopScrollBtn() : void
      {
         delete this.scroller.onEnterFrame;
      }
      
      private function startScroll(param1:MouseEvent) : void
      {
         stage.addEventListener(MouseEvent.MOUSE_UP,this.stopScroll,true);
         this.scroller.addEventListener(Event.ENTER_FRAME,this.doScroll);
         this.scroller.startDrag(false,new Rectangle(this.scroller.x,this.scrollStart,0,this.scrollDist));
      }
      
      private function stopScroll(param1:MouseEvent) : void
      {
         param1.stopPropagation();
         if(stage)
         {
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.stopScroll,true);
         }
         this.scroller.removeEventListener(Event.ENTER_FRAME,this.doScroll);
         this.scroller.stopDrag();
      }
      
      private function doScroll(param1:Event) : void
      {
         this._scrollerPosition = 100 / this.scrollDist * (this.scroller.y - this.scrollStart);
         dispatchEvent(new Event(IntScrollBar.VALUE_CHANGED));
      }
      
      public function onMouseWheel(param1:MouseEvent) : void
      {
         this.setValue(this._scrollerPosition - param1.delta * this.scrollStep);
         dispatchEvent(new Event(IntScrollBar.VALUE_CHANGED));
      }
      
      public function setValue(param1:Number) : void
      {
         this._scrollerPosition = param1;
         this.setScrollerPosition();
      }
      
      public function setScrollerPosition() : void
      {
         this.scroller.y = this._scrollerPosition / 100 * this.scrollDist + this.scrollStart;
         dispatchEvent(new Event(IntScrollBar.VALUE_CHANGED));
      }
      
      public function get _scrollerPosition() : Number
      {
         return this.scrollerPosition;
      }
      
      public function set _scrollerPosition(param1:Number) : void
      {
         param1 = Math.min(param1,100);
         param1 = Math.max(param1,0);
         this.scrollerPosition = param1;
      }
   }
}

