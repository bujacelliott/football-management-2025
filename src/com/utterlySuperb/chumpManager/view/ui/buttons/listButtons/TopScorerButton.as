package com.utterlySuperb.chumpManager.view.ui.buttons.listButtons
{
   import com.utterlySuperb.chumpManager.model.dataObjects.Player;
   import com.utterlySuperb.chumpManager.view.ui.buttons.ListButton;
   import com.utterlySuperb.text.TextHelper;
   import flash.text.TextField;
   
   public class TopScorerButton extends ListButton
   {
      
      public function TopScorerButton()
      {
         super();
         bHeight = 22;
         mouseEnabled = mouseChildren = false;
      }
      
      public function setScore(param1:Player, param2:String, param3:int) : void
      {
         var _loc5_:TextField = null;
         TextHelper.doTextField2(tf,Styles.MAIN_FONT,12,16777215);
         tf.htmlText = param2;
         TextHelper.fitTextField(tf);
         tf.x = 5;
         var _loc4_:TextField = new TextField();
         TextHelper.doTextField2(_loc4_,Styles.MAIN_FONT,12,16777215);
         _loc4_.htmlText = param1.name;
         TextHelper.fitTextField(_loc4_);
         _loc4_.x = 30;
         addChild(_loc4_);
         _loc5_ = new TextField();
         TextHelper.doTextField2(_loc5_,Styles.MAIN_FONT,12,16777215);
         _loc5_.htmlText = param3.toString();
         TextHelper.fitTextField(_loc5_);
         _loc5_.x = bWidth - 30;
         addChild(_loc5_);
         tf.y = _loc4_.y = _loc5_.y = 2;
      }
   }
}

