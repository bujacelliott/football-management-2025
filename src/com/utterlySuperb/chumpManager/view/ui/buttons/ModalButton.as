package com.utterlySuperb.chumpManager.view.ui.buttons
{
   import com.utterlySuperb.text.TextHelper;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class ModalButton extends ChumpButton
   {
      
      public function ModalButton()
      {
         super();
      }
      
      override protected function makeTextField() : void
      {
         tf = new TextField();
         addChild(tf);
         TextHelper.doTextField2(tf,Styles.MAIN_FONT,Styles.BUTTON_FONT_SIZE,Styles.BUTTON_FONT_COLOR);
      }
      
      override protected function rollOver(param1:MouseEvent) : void
      {
         super.rollOver(param1);
         tf.textColor = 16711680;
      }
      
      override protected function rollOut(param1:MouseEvent) : void
      {
         super.rollOut(param1);
         tf.textColor = 16777215;
      }
   }
}

