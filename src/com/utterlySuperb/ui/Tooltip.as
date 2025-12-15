package com.utterlySuperb.ui
{
   import com.greensock.TweenLite;
   import com.utterlySuperb.text.TextHelper;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class Tooltip extends Sprite
   {
      
      private static var instance:Tooltip;
      
      public var buffer:int = 5;
      
      public var outlineColor:Number;
      
      public var maxWidth:int;
      
      public var outlineAlpha:Number;
      
      public var outLineThickness:Number;
      
      public var screenWidth:int = 0;
      
      public var bgAlpha:Number;
      
      public var bgColor:Number;
      
      public var xOffset:int = 0;
      
      public var yOffset:int = 0;
      
      protected var tf:TextField;
      
      public function Tooltip(param1:int = 200, param2:Number = 3373004, param3:Number = 0.8, param4:Number = 0, param5:Number = 0.9, param6:Number = 1)
      {
         super();
         this.maxWidth = param1;
         this.bgColor = param2;
         this.bgAlpha = param3;
         this.outlineColor = param4;
         this.outlineAlpha = param5;
         this.outLineThickness = param6;
         this.mouseChildren = this.mouseEnabled = false;
         instance = this;
         visible = false;
         addEventListener(Event.ADDED_TO_STAGE,this.addedToStage);
      }
      
      public static function hideTip() : void
      {
         if(instance)
         {
            instance.hideTooltip();
         }
      }
      
      public static function exists() : Boolean
      {
         return instance != null;
      }
      
      public static function showTip(param1:String) : void
      {
         if(instance)
         {
            instance.showTooltip(param1);
         }
      }
      
      public function showTooltip(param1:String) : void
      {
         this.tf.width = this.maxWidth;
         this.tf.htmlText = param1;
         TextHelper.fitTextField(this.tf);
         graphics.clear();
         graphics.lineStyle(this.outLineThickness,this.outlineColor,this.outlineAlpha);
         graphics.beginFill(this.bgColor,this.bgAlpha);
         graphics.drawRect(-this.buffer,-this.buffer,Math.min(this.maxWidth,this.tf.textWidth) + this.buffer * 2 + 2,this.tf.textHeight + (this.buffer * 2 + 3));
         x = int(stage.mouseX + this.xOffset);
         if(x + width > this.screenWidth)
         {
            x = int(this.screenWidth - width);
         }
         y = int(stage.mouseY - height + this.yOffset);
         if(y < 0)
         {
            int(y = stage.mouseY);
         }
         TweenLite.killTweensOf(this);
         if(alpha == 0)
         {
            TweenLite.to(this,0.3,{
               "autoAlpha":1,
               "delay":0.5
            });
         }
         else
         {
            visible = true;
            TweenLite.to(this,0.3,{"autoAlpha":1});
         }
      }
      
      public function hideTooltip() : void
      {
         TweenLite.killTweensOf(this);
         TweenLite.to(this,0.5,{"autoAlpha":0});
      }
      
      private function addedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.addedToStage);
         if(!this.screenWidth > 0)
         {
            this.screenWidth = stage.stageWidth;
         }
      }
      
      public function addTextField(param1:TextField) : void
      {
         this.tf = param1;
         param1.multiline = param1.wordWrap = true;
         addChild(param1);
         param1.width = this.maxWidth;
      }
   }
}

