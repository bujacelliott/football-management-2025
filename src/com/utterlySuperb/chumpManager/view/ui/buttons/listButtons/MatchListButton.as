package com.utterlySuperb.chumpManager.view.ui.buttons.listButtons
{
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.Match;
   import com.utterlySuperb.chumpManager.view.ui.buttons.ListButton;
   import com.utterlySuperb.text.TextHelper;
   
   public class MatchListButton extends ListButton
   {
      
      public function MatchListButton()
      {
         super();
         mouseEnabled = mouseChildren = false;
      }
      
      public function setType(param1:String) : void
      {
         TextHelper.doTextField2(tf,Styles.HEADER_FONT,18,16777215);
         tf.htmlText = param1;
         setBGCol(15610624);
         TextHelper.fitTextField(tf);
         tf.x = (bWidth - tf.textWidth) / 2;
      }
      
      public function setMatch(param1:Match) : void
      {
         TextHelper.doTextField2(tf,Styles.LIST_FONT,14,Styles.BUTTON_FONT_COLOR);
         tf.htmlText = param1.club0.club.shortName + " - " + param1.club1.club.shortName;
         TextHelper.fitTextField(tf);
         tf.x = (bWidth - tf.textWidth) / 2;
         tf.y = 5;
      }
   }
}

