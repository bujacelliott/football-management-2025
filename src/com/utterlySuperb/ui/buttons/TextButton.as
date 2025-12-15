package com.utterlySuperb.ui.buttons
{
   import com.utterlySuperb.text.TextHelper;
   import flash.text.TextField;
   
   public class TextButton extends GenericButton
   {
      
      protected var tf:TextField;
      
      public function TextButton()
      {
         super();
         this.makeTextField();
      }
      
      protected function makeTextField() : void
      {
         this.tf = new TextField();
         addChild(this.tf);
         this.tf.selectable = false;
      }
      
      public function setText(param1:String) : void
      {
         this.tf.text = param1;
         TextHelper.fitTextField(this.tf);
      }
   }
}

