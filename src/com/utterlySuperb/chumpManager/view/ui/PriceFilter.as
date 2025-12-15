package com.utterlySuperb.chumpManager.view.ui
{
   import com.utterlySuperb.chumpManager.engine.TransfersEngine;
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.text.TextHelper;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class PriceFilter extends FilterSlider
   {
      
      public function PriceFilter()
      {
         super();
         limitsTF.y = yOffset + 10;
      }
      
      override public function setSize(param1:Number, param2:Number, param3:int = 120) : void
      {
         super.setSize(param1,param2,param3);
         limitsTF.x = -5;
      }
      
      override protected function draw() : void
      {
         super.draw();
         var _loc1_:* = CopyManager.getCurrency() + TextHelper.prettifyNumber(max);
         if(max == 100000000)
         {
            _loc1_ += "+";
         }
         limitsTF.htmlText = CopyManager.getCurrency() + TextHelper.prettifyNumber(int(min)) + "-" + _loc1_;
      }
      
      override protected function stageReleaseHandler(param1:MouseEvent) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.mouseMoveHandler);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.stageReleaseHandler);
         minHandle.x = drawFactor * (min - hardMin);
         maxHandle.x = drawFactor * (max - hardMin);
         this.draw();
      }
      
      override protected function mouseMoveHandler(param1:Event) : void
      {
         if(movingHandler == maxHandle)
         {
            maxHandle.x = Math.min(mouseX,size);
            if(maxHandle.x < minHandle.x + 10)
            {
               minHandle.x = Math.max(0,maxHandle.x - 10);
               maxHandle.x = minHandle.x + 10;
            }
         }
         else
         {
            minHandle.x = Math.max(0,mouseX);
            if(minHandle.x > maxHandle.x - 10)
            {
               maxHandle.x = Math.min(size,minHandle.x + 10);
               minHandle.x = maxHandle.x - 10;
            }
         }
         min = hardMin + minHandle.x / drawFactor;
         max = hardMin + maxHandle.x / drawFactor;
         min = this.getClosest(min);
         max = this.getClosest(max);
         if(min == max)
         {
            if(min == 0)
            {
               max = TransfersEngine.TRANSFER_SLOTS[1];
            }
            else
            {
               min = TransfersEngine.TRANSFER_SLOTS[TransfersEngine.TRANSFER_SLOTS.indexOf(max) - 1];
            }
         }
         this.draw();
         dispatchEvent(new Event(FILTER_CHANGE));
      }
      
      private function getClosest(param1:int) : int
      {
         var _loc4_:int = 0;
         var _loc2_:int = 1000000000;
         var _loc3_:int = 0;
         while(_loc3_ < TransfersEngine.TRANSFER_SLOTS.length)
         {
            if(Math.abs(TransfersEngine.TRANSFER_SLOTS[_loc3_] - param1) < _loc2_)
            {
               _loc2_ = Math.abs(TransfersEngine.TRANSFER_SLOTS[_loc3_] - param1);
               _loc4_ = int(TransfersEngine.TRANSFER_SLOTS[_loc3_]);
            }
            _loc3_++;
         }
         return _loc4_;
      }
   }
}

