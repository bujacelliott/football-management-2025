package com.utterlySuperb.chumpManager.view.ui.buttons.listButtons
{
   import com.utterlySuperb.text.TextHelper;
   import flash.text.TextField;
   
   public class CupTeamButton extends PlayerListButton
   {
      
      public function CupTeamButton()
      {
         super();
         bHeight = 30;
         mouseEnabled = false;
      }
      
      override protected function makeTextField() : void
      {
         tf = new TextField();
         addChild(tf);
         tf.y = 3;
         TextHelper.doTextField2(tf,Styles.MAIN_FONT,Styles.LIST_FONT_SIZE + 2,0);
      }
   }
}

