package com.utterlySuperb.chumpManager.view.ui.buttons.listButtons
{
   import com.utterlySuperb.chumpManager.view.ui.buttons.ListButton;
   import com.utterlySuperb.text.TextHelper;
   import flash.text.TextField;
   
   public class CupRoundHeader extends ListButton
   {
      
      public function CupRoundHeader()
      {
         super();
      }
      
      override protected function makeTextField() : void
      {
         tf = new TextField();
         addChild(tf);
         tf.y = 3;
         TextHelper.doTextField2(tf,Styles.HEADER_FONT,Styles.LIST_FONT_SIZE + 2,0);
      }
   }
}

