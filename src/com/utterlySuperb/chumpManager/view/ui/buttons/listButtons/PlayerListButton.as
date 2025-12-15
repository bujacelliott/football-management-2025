package com.utterlySuperb.chumpManager.view.ui.buttons.listButtons
{
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.Player;
   import com.utterlySuperb.chumpManager.view.ui.buttons.ListButton;
   import com.utterlySuperb.text.TextHelper;
   import flash.text.TextField;
   import flash.text.TextFormatAlign;
   
   public class PlayerListButton extends ListButton
   {
      
      protected var playerNumber:TextField;
      
      protected var basePostions:TextField;
      
      public var player:Player;
      
      public function PlayerListButton()
      {
         super();
         bHeight = 25;
         bWidth = 300;
         this.playerNumber = new TextField();
         addChild(this.playerNumber);
         TextHelper.doTextField2(this.playerNumber,Styles.LIST_FONT,Styles.LIST_FONT_SIZE,Styles.BUTTON_FONT_COLOR,{"align":TextFormatAlign.LEFT});
         this.basePostions = new TextField();
         addChild(this.basePostions);
         TextHelper.doTextField2(this.basePostions,Styles.LIST_FONT,Styles.LIST_FONT_SIZE,Styles.BUTTON_FONT_COLOR,{"align":TextFormatAlign.LEFT});
         makeTextField();
      }
      
      public function setPlayer(param1:Player) : void
      {
         this.player = param1;
         this.playerNumber.htmlText = param1.squadNumber.toString();
         this.playerNumber.x = 10;
         TextHelper.fitTextField(this.playerNumber);
         setText(param1.name);
         tf.x = 35;
         this.basePostions.htmlText = CopyManager.getCopy(param1.basePostition).toUpperCase();
         TextHelper.fitTextField(this.basePostions);
         this.basePostions.x = 250 - this.basePostions.textWidth / 2;
         tf.y = this.playerNumber.y = this.basePostions.y = 2;
      }
   }
}

