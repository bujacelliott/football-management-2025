package com.utterlySuperb.chumpManager.view.ui.buttons.listButtons
{
   import com.utterlySuperb.chumpManager.view.ui.buttons.ListButton;
   import com.utterlySuperb.text.TextHelper;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFormatAlign;
   
   public class MatchMessageButton extends ListButton
   {
      
      public function MatchMessageButton()
      {
         super();
         colors = [16777130,15658632];
         bHeight = 30;
         mouseEnabled = false;
      }
      
      override protected function makeTextField() : void
      {
         tf = new TextField();
         addChild(tf);
         TextHelper.doTextField2(tf,Styles.LIST_FONT,Styles.LIST_FONT_SIZE + 2,0,{
            "align":TextFormatAlign.LEFT,
            "multiline":true,
            "wordWrap":true
         });
      }
      
      override public function setText(param1:String) : void
      {
         tf.width = bWidth - 10;
         tf.htmlText = param1;
         tf.height = tf.textHeight + 5;
         bHeight = tf.height + 10;
         tf.x = int((bWidth - tf.textWidth) / 2);
         tf.y = 5;
      }
      
      public function setType(param1:String) : void
      {
         var _loc2_:MovieClip = new MatchInfoIcons();
         try
         {
            _loc2_.gotoAndStop(param1);
         }
         catch(err:Error)
         {
         }
         _loc2_.x = 5;
         addChild(_loc2_);
         tf.width = bWidth - 40;
         tf.height = tf.textHeight + 5;
         bHeight = tf.height + 10;
         tf.x = int((bWidth - tf.textWidth) / 2) + 20;
         _loc2_.y = (bHeight - _loc2_.height) / 2;
      }
   }
}

