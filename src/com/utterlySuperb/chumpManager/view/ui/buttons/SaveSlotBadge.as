package com.utterlySuperb.chumpManager.view.ui.buttons
{
   import com.utterlySuperb.chumpManager.view.panels.BGPanel;
   import com.utterlySuperb.text.TextHelper;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFormatAlign;
   
   public class SaveSlotBadge extends Sprite
   {
      
      private var bg:BGPanel;
      
      private var tf:TextField;
      
      private var boxWidth:int;
      
      private var boxHeight:int;
      
      public function SaveSlotBadge(param1:int = 50, param2:int = 50)
      {
         super();
         this.boxWidth = param1;
         this.boxHeight = param2;
         this.bg = new BGPanel(this.boxWidth,this.boxHeight,16777215,0x0F3B2E,0.9,8);
         addChild(this.bg);
         this.tf = new TextField();
         TextHelper.doTextField2(this.tf,Styles.HEADER_FONT,14,16777215,{"align":TextFormatAlign.CENTER});
         this.tf.width = this.boxWidth;
         this.tf.height = this.boxHeight;
         addChild(this.tf);
      }
      
      public function setText(param1:String) : void
      {
         this.tf.text = param1;
         this.tf.y = (this.boxHeight - this.tf.textHeight - 5) / 2;
      }
   }
}
