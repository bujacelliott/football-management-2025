package com.utterlySuperb.chumpManager.view.ui.buttons.listButtons
{
   import com.utterlySuperb.chumpManager.view.ui.buttons.ListButton;
   import flash.text.TextFieldAutoSize;
   
   public class TransferSummaryListButton extends ListButton
   {
      
      private var maxScrollH:int = 0;

      private var padding:int = 6;

      private var viewWidth:int = 0;
      
      public function TransferSummaryListButton()
      {
         super();
      }
      
      override public function setText(param1:String) : void
      {
         tf.autoSize = TextFieldAutoSize.NONE;
         tf.wordWrap = false;
         tf.multiline = false;
         this.viewWidth = bWidth - this.padding * 2;
         tf.width = this.viewWidth;
         tf.htmlText = param1;
         tf.height = bHeight;
         tf.x = this.padding;
         tf.y = (bHeight - tf.textHeight) / 2;
         tf.width = Math.max(tf.width, int(tf.textWidth) + 5);
         this.maxScrollH = Math.max(0,tf.width - this.viewWidth);
         tf.x = this.padding;
      }
      
      public function setScrollPercent(param1:Number) : void
      {
         if(this.maxScrollH <= 0)
         {
            return;
         }
         tf.x = this.padding - Math.round(this.maxScrollH * param1);
      }
      
      public function setMaxScrollH(param1:int) : void
      {
         this.maxScrollH = Math.max(0,param1);
         tf.width = Math.max(tf.width, this.viewWidth + this.maxScrollH);
         tf.x = this.padding;
      }
      
      public function hasOverflow() : Boolean
      {
         return this.maxScrollH > 0;
      }

      public function get maxScroll() : int
      {
         return this.maxScrollH;
      }
   }
}
