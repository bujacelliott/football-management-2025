package com.utterlySuperb.chumpManager.view.ui
{
   import com.utterlySuperb.text.TextHelper;
   import com.utterlySuperb.ui.Checkbox;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class FilterSlider extends Sprite
   {
      
      public static const FILTER_CHANGE:String = "filterChange";
      
      public var min:Number;
      
      public var max:Number;
      
      protected var hardMin:Number;
      
      protected var hardMax:Number;
      
      protected var filterSize:Number;
      
      protected var drawFactor:Number;
      
      protected var handlesBuffer:int;
      
      protected var checkbox:Checkbox;
      
      protected var minHandle:Sprite;
      
      protected var maxHandle:Sprite;
      
      protected var usedBit:Sprite;
      
      protected var size:int;
      
      protected var movingHandler:Sprite;
      
      private var barHeight:int = 10;
      
      protected var yOffset:int = 20;
      
      private var titleTF:TextField;
      
      protected var limitsTF:TextField;
      
      public function FilterSlider()
      {
         super();
         this.usedBit = new Sprite();
         addChild(this.usedBit);
         this.minHandle = new SliderHandlerMC();
         addChild(this.minHandle);
         this.minHandle.y = 5 + this.yOffset;
         this.maxHandle = new SliderHandlerMC();
         addChild(this.maxHandle);
         this.maxHandle.y = 5 + this.yOffset;
         this.handlesBuffer = this.maxHandle.width;
         this.checkbox = new FilterCheckbox();
         addChild(this.checkbox);
         this.checkbox.y = this.barHeight / 2 + this.yOffset;
         this.checkbox.ticked = true;
         this.titleTF = new TextField();
         TextHelper.doTextField2(this.titleTF,Styles.HEADER_FONT,12,Styles.COPY_FONT_COLOR0);
         addChild(this.titleTF);
         this.limitsTF = new TextField();
         TextHelper.doTextField2(this.limitsTF,Styles.HEADER_FONT,12,Styles.COPY_FONT_COLOR0);
         addChild(this.limitsTF);
         this.limitsTF.y = this.yOffset - 5;
      }
      
      public function setTitle(param1:String) : void
      {
         this.titleTF.htmlText = param1.toUpperCase();
         this.titleTF.mouseEnabled = false;
      }
      
      protected function draw() : void
      {
         this.usedBit.graphics.clear();
         this.usedBit.graphics.lineStyle(1,2236962);
         this.usedBit.graphics.beginFill(3381759);
         this.usedBit.graphics.drawRect(this.minHandle.x,0 + this.yOffset,this.maxHandle.x - this.minHandle.x,this.barHeight);
         this.limitsTF.htmlText = int(this.min).toString() + "-" + int(this.max).toString();
      }
      
      public function setSize(param1:Number, param2:Number, param3:int = 120) : void
      {
         this.size = param3;
         this.hardMin = param1;
         this.hardMax = param2;
         this.min = Math.max(this.min,param1);
         this.max = Math.min(this.max,param2);
         this.checkbox.x = param3 + 15;
         this.limitsTF.x = param3 + 30;
         this.filterSize = param2 - param1;
         this.drawFactor = param3 / this.filterSize;
         graphics.lineStyle(1,2236962);
         graphics.beginFill(6710886);
         graphics.drawRoundRect(-5,0 + this.yOffset,param3 + 10,this.barHeight,10,10);
         this.draw();
      }
      
      public function setFilters(param1:Number, param2:Number) : void
      {
         this.min = param1;
         this.max = param2;
         this.minHandle.x = this.drawFactor * (param1 - this.hardMin);
         this.maxHandle.x = this.drawFactor * (param2 - this.hardMin);
         this.draw();
      }
      
      public function activate() : void
      {
         if(!this.minHandle.hasEventListener(MouseEvent.MOUSE_DOWN))
         {
            this.minHandle.addEventListener(MouseEvent.MOUSE_DOWN,this.sliderPressHandler);
            this.maxHandle.addEventListener(MouseEvent.MOUSE_DOWN,this.sliderPressHandler);
            this.minHandle.buttonMode = this.maxHandle.buttonMode = true;
            this.checkbox.activate();
            this.checkbox.addEventListener(Checkbox.CHECK_CLICKED,this.checkChangedHandler);
         }
      }
      
      public function deactivate() : void
      {
         if(this.minHandle.hasEventListener(MouseEvent.MOUSE_DOWN))
         {
            this.minHandle.removeEventListener(MouseEvent.MOUSE_DOWN,this.sliderPressHandler);
            this.maxHandle.removeEventListener(MouseEvent.MOUSE_DOWN,this.sliderPressHandler);
            this.minHandle.buttonMode = this.maxHandle.buttonMode = true;
            this.checkbox.deactivate();
            this.checkbox.removeEventListener(Checkbox.CHECK_CLICKED,this.checkChangedHandler);
         }
      }
      
      public function isActive() : Boolean
      {
         return this.checkbox.ticked;
      }
      
      private function checkChangedHandler(param1:Event) : void
      {
         dispatchEvent(new Event(FILTER_CHANGE));
      }
      
      private function sliderPressHandler(param1:MouseEvent) : void
      {
         addEventListener(Event.ENTER_FRAME,this.mouseMoveHandler);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.stageReleaseHandler);
         this.movingHandler = Sprite(param1.target);
      }
      
      protected function stageReleaseHandler(param1:MouseEvent) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.mouseMoveHandler);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.stageReleaseHandler);
      }
      
      protected function mouseMoveHandler(param1:Event) : void
      {
         if(this.movingHandler == this.maxHandle)
         {
            this.maxHandle.x = Math.min(mouseX,this.size);
            if(this.maxHandle.x < this.minHandle.x + 10)
            {
               this.minHandle.x = Math.max(0,this.maxHandle.x - 10);
               this.maxHandle.x = this.minHandle.x + 10;
            }
         }
         else
         {
            this.minHandle.x = Math.max(0,mouseX);
            if(this.minHandle.x > this.maxHandle.x - 10)
            {
               this.maxHandle.x = Math.min(this.size,this.minHandle.x + 10);
               this.minHandle.x = this.maxHandle.x - 10;
            }
         }
         this.min = this.hardMin + this.minHandle.x / this.drawFactor;
         this.max = this.hardMin + this.maxHandle.x / this.drawFactor;
         this.draw();
         dispatchEvent(new Event(FILTER_CHANGE));
      }
   }
}

