package com.utterlySuperb.ui.buttons
{
   import com.utterlySuperb.ui.Tooltip;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class GenericButton extends MovieClip
   {
      
      public static const BUTTON_CLICK:String = "genButtonClick";
      
      public static const BUTTON_OVER:String = "genButtonOver";
      
      public static const BUTTON_OUT:String = "genButtonOut";
      
      public var tooltip:String;
      
      public var bWidth:int = 300;
      
      public var bHeight:int = 27;
      
      public var hit:Sprite;
      
      public function GenericButton()
      {
         super();
      }
      
      protected function hideTooltip() : void
      {
         Tooltip.hideTip();
      }
      
      public function get right() : int
      {
         return x + width;
      }
      
      protected function showTooltip() : void
      {
         Tooltip.showTip(this.tooltip);
      }
      
      protected function click(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(BUTTON_CLICK));
      }
      
      protected function rollOver(param1:MouseEvent) : void
      {
         if(Boolean(this.tooltip) && this.tooltip.length > 0)
         {
            this.showTooltip();
         }
         dispatchEvent(new Event(BUTTON_OVER));
         this.rollOverFunc();
      }
      
      public function deactivate(param1:Boolean = false) : void
      {
         var _loc2_:Sprite = this.hit ? this.hit : this;
         if(_loc2_.buttonMode)
         {
            _loc2_.buttonMode = false;
            _loc2_.removeEventListener(MouseEvent.ROLL_OVER,this.rollOver);
            _loc2_.removeEventListener(MouseEvent.ROLL_OUT,this.rollOut);
            _loc2_.removeEventListener(MouseEvent.MOUSE_UP,this.click);
         }
         if(param1)
         {
            this.showInactive();
         }
      }
      
      protected function rollOverFunc() : void
      {
      }
      
      protected function showInactive() : void
      {
      }
      
      protected function rollOut(param1:MouseEvent) : void
      {
         if(Boolean(this.tooltip) && this.tooltip.length > 0)
         {
            this.hideTooltip();
         }
         dispatchEvent(new Event(BUTTON_OUT));
         this.rollOutFunc();
      }
      
      public function activate() : void
      {
         var _loc1_:Sprite = this.hit ? this.hit : this;
         if(!_loc1_.buttonMode)
         {
            _loc1_.mouseChildren = false;
            _loc1_.buttonMode = true;
            _loc1_.addEventListener(MouseEvent.ROLL_OVER,this.rollOver);
            _loc1_.addEventListener(MouseEvent.ROLL_OUT,this.rollOut);
            _loc1_.addEventListener(MouseEvent.MOUSE_UP,this.click);
            this.rollOut(null);
         }
      }
      
      protected function rollOutFunc() : void
      {
      }
      
      public function getHeight() : int
      {
         return height;
      }
      
      public function setHitArea(param1:Sprite) : void
      {
         this.hit = param1;
         if(buttonMode)
         {
            this.deactivate();
            mouseChildren = true;
            this.activate();
         }
      }
      
      public function get bottom() : int
      {
         return y + this.getHeight();
      }
   }
}

