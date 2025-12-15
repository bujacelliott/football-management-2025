package com.utterlySuperb.chumpManager.view.ui.buttons.listButtons
{
   import com.utterlySuperb.chumpManager.model.dataObjects.Player;
   import com.utterlySuperb.chumpManager.view.ui.RatingStar;
   import com.utterlySuperb.text.TextHelper;
   
   public class TransferListButton extends PlayerListButton
   {
      
      private var star:RatingStar;
      
      public function TransferListButton()
      {
         super();
         this.star = new RatingStar();
         addChild(this.star);
         this.star.y = 3;
      }
      
      override public function setPlayer(param1:Player) : void
      {
         this.player = param1;
         setText(param1.name);
         tf.x = 40;
         basePostions.htmlText = param1.basePostition;
         TextHelper.fitTextField(basePostions);
         basePostions.x = 5;
         tf.y = basePostions.y = 5;
         this.star.setPlayer(param1);
         this.star.x = bWidth - this.star.width - 4;
      }
   }
}

