package com.utterlySuperb.chumpManager.view.ui.widgets
{
   import com.utterlySuperb.chumpManager.engine.TransfersEngine;
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.Player;
   import com.utterlySuperb.chumpManager.model.dataObjects.PlayerOffers;
   import com.utterlySuperb.text.TextHelper;
   import flash.text.TextField;
   
   public class TransferPlayerStat extends PlayerStatsDisplay
   {
      
      protected var tf1:TextField;
      
      public function TransferPlayerStat()
      {
         super();
         barsSprite.scaleX = barsSprite.scaleY = 1;
         TextHelper.doTextField2(tf,Styles.HEADER_FONT,12,Styles.COPY_FONT_COLOR0,{"multiline":true});
         tf.width = 210;
         barsSprite.y = 85;
      }
      
      override public function setPlayer(param1:Player) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:PlayerOffers = null;
         if(param1)
         {
            visible = true;
            _loc2_ = param1.name + "<br>" + param1.positions.toUpperCase() + "<br>";
            _loc2_ += param1.club ? param1.club.name : CopyManager.getCopy("playerFreeAgent");
            makeBars(param1);
            _loc2_ += "<br>" + CopyManager.getCopy("age") + ":" + param1.age;
            if(param1.club)
            {
               _loc3_ = param1.transferValue;
               _loc2_ += "<br>" + CopyManager.getCopy("estimatedValue") + ":" + "&#60;" + CopyManager.getCurrency() + TextHelper.prettifyNumber(TransfersEngine.getEstimateTransfer(_loc3_));
            }
            else
            {
               _loc2_ += "<br>" + CopyManager.getCopy("playerFreeAgent");
            }
            if(Main.currentGame.hasOfferOnPlayer(param1))
            {
               _loc4_ = Main.currentGame.getOfferOnPlayer(param1);
               _loc2_ += "<br>" + CopyManager.getCopy("youHaveOffer");
               _loc2_ += CopyManager.getCopy("feeOffered") + ":" + CopyManager.getCurrency() + TextHelper.prettifyNumber(_loc4_.cashOff);
            }
            tf.htmlText = _loc2_;
            tf.height = tf.textHeight + 5;
            barsSprite.y = tf.textHeight + 10;
         }
         else
         {
            visible = false;
         }
      }
   }
}

