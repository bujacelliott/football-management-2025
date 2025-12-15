package com.utterlySuperb.ui.dropDown
{
   import com.utterlySuperb.events.StringEvent;
   import com.utterlySuperb.text.TextHelper;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class DropDownItem extends Sprite
   {
      
      public static const CLICK_DROPDOWN_ITEM:String = "clickDropdownItem";
      
      private var tf:TextField;
      
      private var settings:DropDownSettings;
      
      public function DropDownItem(param1:DropDownSettings)
      {
         super();
         this.settings = param1;
         if(this.settings.itemBg)
         {
            addChild(this.settings.itemBg);
            this.settings.itemBg.width = this.settings.width;
            this.settings.itemBg.height = this.settings.height;
         }
         this.tf = new TextField();
         this.tf.width = this.settings.width;
         this.tf.height = this.settings.height;
         TextHelper.doTextField2(this.tf,this.settings.font,this.settings.fontSize,this.settings.defFontColor);
         this.tf.y = -Math.floor(this.settings.fontSize / 14);
         addChild(this.tf);
         this.showDefault(null);
         this.enable();
      }
      
      public function setVal(param1:String, param2:Boolean, param3:Boolean) : void
      {
         this.tf.htmlText = param1;
         if(!param3)
         {
            this.disable();
            if(param2)
            {
               this.showOver(null);
            }
            else
            {
               this.showDefault(null);
            }
         }
         else
         {
            this.enable();
            this.showDefault(null);
         }
      }
      
      public function enable() : void
      {
         if(!buttonMode)
         {
            addEventListener(MouseEvent.MOUSE_UP,this.clickMe);
            addEventListener(MouseEvent.MOUSE_OVER,this.showOver);
            addEventListener(MouseEvent.MOUSE_OUT,this.showDefault);
            buttonMode = true;
         }
         this.showOver(null);
      }
      
      public function disable() : void
      {
         if(buttonMode)
         {
            removeEventListener(MouseEvent.MOUSE_UP,this.clickMe);
            removeEventListener(MouseEvent.MOUSE_OVER,this.showOver);
            removeEventListener(MouseEvent.MOUSE_OUT,this.showDefault);
            buttonMode = false;
         }
      }
      
      private function clickMe(param1:MouseEvent) : void
      {
         dispatchEvent(new StringEvent(CLICK_DROPDOWN_ITEM,this.tf.text));
      }
      
      private function showDefault(param1:MouseEvent) : void
      {
         graphics.clear();
         graphics.lineStyle(this.settings.defLineThickness,this.settings.defLineColor,this.settings.defLineAlpha);
         graphics.beginFill(this.settings.defBgColor,this.settings.defBgAlpha);
         graphics.drawRect(0,0,this.settings.width,this.settings.height);
         this.tf.textColor = this.settings.defFontColor;
      }
      
      private function showOver(param1:MouseEvent) : void
      {
         graphics.clear();
         graphics.lineStyle(this.settings.overLineThickness,this.settings.overLineColor,this.settings.overLineAlpha);
         graphics.beginFill(this.settings.overBgColor,this.settings.overBgAlpha);
         graphics.drawRect(0,0,this.settings.width,this.settings.height);
         this.tf.textColor = this.settings.overFontColor;
      }
   }
}

