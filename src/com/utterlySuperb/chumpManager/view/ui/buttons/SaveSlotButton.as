package com.utterlySuperb.chumpManager.view.ui.buttons
{
   import com.utterlySuperb.chumpManager.model.dataObjects.Game;
   import com.utterlySuperb.chumpManager.view.panels.BGPanel;
   import com.utterlySuperb.text.TextHelper;
   import flash.text.TextField;
   import flash.text.TextFormatAlign;
   
   public class SaveSlotButton extends ChumpButton
   {
      
      private var bg:BGPanel;
      
      private var slotLabel:String = "";
      
      private var isEnabled:Boolean = true;
      
      public function SaveSlotButton(param1:int = 250, param2:int = 50)
      {
         super();
         bWidth = param1;
         bHeight = param2;
         this.setText("");
      }
      
      override protected function makeTextField() : void
      {
         tf = new TextField();
         addChild(tf);
      }
      
      override public function setText(param1:String) : void
      {
         TextHelper.doTextField2(tf,Styles.MAIN_FONT,14,16777215,{
            "multiline":true,
            "wordWrap":true,
            "align":TextFormatAlign.LEFT
         });
         tf.htmlText = param1;
         tf.width = bWidth - 10;
         tf.height = bHeight - 10;
         tf.x = 5;
         tf.y = 5;
         if(this.bg)
         {
            removeChild(this.bg);
         }
         this.bg = new BGPanel(bWidth,bHeight,16777215,0x113822,0.9,8);
         addChildAt(this.bg,0);
      }
      
      public function setGame(param1:Game, param2:int) : void
      {
         this.slotLabel = "Slot " + (param2 + 1);
         if(param1)
         {
            this.setText(this.slotLabel + " - Existing<br>" + param1.playerClub.name + "<br>" + param1.currentDate.toDateString());
            this.setEnabled(true);
         }
         else
         {
            this.setText(this.slotLabel + " - Empty");
         }
      }
      
      public function setEnabled(param1:Boolean) : void
      {
         this.isEnabled = param1;
         alpha = param1 ? 1 : 0.4;
         mouseEnabled = param1;
         mouseChildren = param1;
      }
      
      override public function activate() : void
      {
         if(!this.isEnabled)
         {
            return;
         }
         super.activate();
      }
   }
}
