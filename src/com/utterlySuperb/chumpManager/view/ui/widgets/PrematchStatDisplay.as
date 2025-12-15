package com.utterlySuperb.chumpManager.view.ui.widgets
{
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.Player;
   import com.utterlySuperb.text.TextHelper;
   
   public class PrematchStatDisplay extends PlayerStatsDisplay
   {
      
      public function PrematchStatDisplay()
      {
         super();
         barsSprite.scaleX = barsSprite.scaleY = 0.9;
         TextHelper.doTextField2(tf,Styles.HEADER_FONT,12,Styles.COPY_FONT_COLOR0,{
            "multiline":true,
            "wordWrap":true
         });
         barsSprite.y = 40;
         tf.width = 120;
         makePreMatch();
      }
      
      override public function setPlayer(param1:Player) : void
      {
         if(param1)
         {
            visible = true;
            tf.htmlText = param1.name + "<br>" + CopyManager.getPlayerPostionString(param1.positions);
            barsSprite.y = tf.textHeight + 10;
            makeBars(param1);
         }
         else
         {
            visible = false;
         }
      }
   }
}

