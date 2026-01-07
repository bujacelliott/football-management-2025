package com.utterlySuperb.chumpManager.view.ui.buttons
{
   import com.greensock.TweenLite;
   import com.utterlySuperb.chumpManager.view.panels.BGPanel;
   import com.utterlySuperb.text.TextHelper;
   import flash.filters.BevelFilter;
   import flash.filters.DropShadowFilter;
   import flash.text.TextField;
   import flash.text.TextFormatAlign;
   
   public class TabButton extends ChumpButton
   {
      
      private static const INACTIVE_BG:uint = 0x0F3B2E;
      
      private static const ACTIVE_BG:uint = 0xE7C94F;
      
      private static const ACTIVE_TEXT:uint = 0x000000;
      
      private var bg:BGPanel;
      
      private var active:Boolean = false;
      
      public function TabButton(param1:String, param2:int = 120, param3:int = 28)
      {
         super();
         bWidth = param2;
         bHeight = param3;
         this.setText(param1);
         this.setActive(false);
      }
      
      override public function setText(param1:String) : void
      {
         TextHelper.doTextField2(tf,Styles.HEADER_FONT,14,16777215,{
            "align":TextFormatAlign.CENTER
         });
         tf.htmlText = param1;
         tf.width = bWidth - 10;
         tf.height = tf.textHeight + 5;
         tf.x = 5;
         tf.y = (bHeight - tf.textHeight - 5) / 2;
         if(this.bg)
         {
            removeChild(this.bg);
         }
         this.bg = new BGPanel(bWidth,bHeight,16777215,INACTIVE_BG,0.9,10);
         addChildAt(this.bg,0);
         filters = [new BevelFilter(2,45,16777215,0.6,0,0.6),new DropShadowFilter(6,45,0,0.6)];
      }
      
      public function setActive(param1:Boolean) : void
      {
         this.active = param1;
         if(this.bg)
         {
            this.bg.alpha = 1;
            this.bg.graphics.clear();
            this.bg.graphics.lineStyle(2,16777215);
            this.bg.graphics.beginFill(param1 ? ACTIVE_BG : INACTIVE_BG,0.9);
            this.bg.graphics.drawRoundRect(0,0,bWidth,bHeight,10,10);
         }
         tf.textColor = param1 ? ACTIVE_TEXT : 16777215;
      }
      
      override protected function rollOverFunc() : void
      {
         if(!this.active)
         {
            TweenLite.to(this.bg,0.2,{"alpha":1});
         }
      }
      
      override protected function rollOutFunc() : void
      {
         if(!this.active)
         {
            TweenLite.to(this.bg,0.2,{"alpha":0.9});
         }
      }
   }
}
