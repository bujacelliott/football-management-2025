package com.utterlySuperb.chumpManager.view.ui.buttons
{
   import com.greensock.TweenLite;
   import com.utterlySuperb.chumpManager.model.dataObjects.competitions.League;
   import com.utterlySuperb.text.TextHelper;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   
   public class LeagueButton extends ChumpButton
   {
      
      public var league:League;
      
      public function LeagueButton()
      {
         super();
      }
      
      override protected function makeTextField() : void
      {
         tf = new TextField();
         addChild(tf);
         TextHelper.doTextField2(tf,Styles.BUTTON_FONT,Styles.BUTTON_FONT_SIZE + 6,Styles.BUTTON_FONT_COLOR);
         tf.antiAliasType = AntiAliasType.NORMAL;
      }
      
      override public function setText(param1:String) : void
      {
         tf.text = param1;
         TextHelper.fitTextField(tf);
         tf.x = -tf.width / 2;
         tf.y = -tf.textHeight / 2;
      }
      
      override protected function showInactive() : void
      {
         TweenLite.killTweensOf(this);
         scaleX = scaleY = 1.2;
      }
      
      override protected function rollOverFunc() : void
      {
         TweenLite.to(this,0.3,{
            "scaleX":1.1,
            "scaleY":1.1
         });
      }
      
      override protected function rollOutFunc() : void
      {
         TweenLite.to(this,0.3,{
            "scaleX":1,
            "scaleY":1
         });
      }
   }
}

