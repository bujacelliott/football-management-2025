package com.utterlySuperb.chumpManager.view.ui.widgets
{
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.text.TextHelper;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class Slider extends Sprite
   {
      
      public static const AMOUNT_CHANGE:String = "amountChange";
      
      public var amount:Number;
      
      private var hardMin:Number;
      
      private var hardMax:Number;
      
      private var filterSize:Number;
      
      private var drawFactor:Number;
      
      private var handle:Sprite;
      
      private var usedBit:Sprite;
      
      private var size:int;
      
      private var barHeight:int = 10;
      
      private var yOffset:int = 20;
      
      public var jump:int = 1;
      
      private var titleTF:TextField;
      
      private var amountTF:TextField;
      
      public var isCurrency:Boolean = true;
      
      public var amountsCopy:Array;
      
      public function Slider()
      {
         super();
         this.usedBit = new Sprite();
         addChild(this.usedBit);
         this.handle = new SliderHandlerMC();
         addChild(this.handle);
         this.handle.y = 5 + this.yOffset;
         this.amount = 0;
         this.titleTF = new TextField();
         TextHelper.doTextField2(this.titleTF,Styles.HEADER_FONT,12,Styles.COPY_FONT_COLOR0);
         addChild(this.titleTF);
         this.amountTF = new TextField();
         TextHelper.doTextField2(this.amountTF,Styles.HEADER_FONT,12,Styles.COPY_FONT_COLOR0);
         addChild(this.amountTF);
         this.amountTF.y = this.yOffset - 5;
      }
      
      public function setTitle(param1:String) : void
      {
         this.titleTF.htmlText = param1.toUpperCase();
         this.titleTF.mouseEnabled = false;
      }
      
      private function draw() : void
      {
         var _loc1_:Number = NaN;
         this.usedBit.graphics.clear();
         this.usedBit.graphics.lineStyle(1,2236962);
         this.usedBit.graphics.beginFill(3381759);
         this.usedBit.graphics.drawRoundRect(-5,0 + this.yOffset,this.handle.x + 10,this.barHeight,10,10);
         if(this.amountsCopy)
         {
            _loc1_ = (this.amount - this.hardMin) / (this.hardMax - this.hardMin) * (this.amountsCopy.length - 1);
            this.amountTF.htmlText = this.amountsCopy[Math.round(_loc1_)];
         }
         else
         {
            this.amountTF.htmlText = this.isCurrency ? CopyManager.getCurrency() + TextHelper.prettifyNumber(this.amount) : TextHelper.prettifyNumber(this.amount);
         }
      }
      
      public function setSize(param1:Number, param2:Number, param3:int = 120) : void
      {
         this.size = param3;
         this.hardMin = param1;
         this.hardMax = param2;
         this.amount = Math.max(this.amount,param1);
         this.amount = Math.min(this.amount,param2);
         this.amountTF.x = param3 + 12;
         this.filterSize = param2 - param1;
         this.drawFactor = param3 / this.filterSize;
         graphics.lineStyle(1,2236962);
         graphics.beginFill(6710886);
         graphics.drawRoundRect(-5,0 + this.yOffset,param3 + 10,this.barHeight,10,10);
      }
      
      public function setFilters(param1:Number) : void
      {
         this.amount = param1;
         this.handle.x = this.drawFactor * (param1 - this.hardMin);
         this.draw();
      }
      
      public function activate() : void
      {
         if(!this.handle.hasEventListener(MouseEvent.MOUSE_DOWN))
         {
            this.handle.addEventListener(MouseEvent.MOUSE_DOWN,this.sliderPressHandler);
            this.handle.buttonMode = true;
         }
      }
      
      public function deactivate() : void
      {
         if(this.handle.hasEventListener(MouseEvent.MOUSE_DOWN))
         {
            this.handle.removeEventListener(MouseEvent.MOUSE_DOWN,this.sliderPressHandler);
            this.handle.buttonMode = true;
         }
      }
      
      private function sliderPressHandler(param1:MouseEvent) : void
      {
         addEventListener(Event.ENTER_FRAME,this.mouseMoveHandler);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.stageReleaseHandler);
      }
      
      private function stageReleaseHandler(param1:MouseEvent) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.mouseMoveHandler);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.stageReleaseHandler);
      }
      
      private function mouseMoveHandler(param1:Event) : void
      {
         this.handle.x = Math.min(mouseX,this.size);
         this.handle.x = Math.max(this.handle.x,0);
         this.amount = this.hardMin + this.handle.x / this.drawFactor;
         this.amount = Math.floor(this.amount / this.jump) * this.jump;
         this.draw();
         dispatchEvent(new Event(AMOUNT_CHANGE));
      }
   }
}

