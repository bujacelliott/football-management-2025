package com.utterlySuperb.chumpManager.view.ui.buttons
{
   import com.greensock.TweenLite;
   import com.utterlySuperb.chumpManager.view.panels.BGPanel;
   import com.utterlySuperb.text.TextHelper;
   import flash.filters.BevelFilter;
   import flash.filters.DropShadowFilter;
   import flash.text.TextField;
   import flash.text.TextFormatAlign;
   
   public class MediumButton extends ChumpButton
   {
      
      private var bg:BGPanel;
      
      public function MediumButton(param1:String = "", param2:int = 120, param3:int = 50)
      {
         super();
         bWidth = param2;
         bHeight = param3;
         if(param1.length > 0)
         {
            this.setText(param1);
         }
      }
      
      override public function setText(param1:String) : void
      {
         this.bg = new BGPanel(bWidth,bHeight,16777215,1118566,0.8,20);
         addChild(this.bg);
         tf = new TextField();
         TextHelper.doTextField2(tf,Styles.HEADER_FONT,18,16777215,{
            "multiline":true,
            "wordWrap":true,
            "align":TextFormatAlign.CENTER,
            "leading":-2
         });
         tf.htmlText = param1;
         tf.width = bWidth - 10;
         tf.height = tf.textHeight + 5;
         tf.x = 5;
         tf.y = (bHeight - tf.textHeight - 5) / 2;
         addChild(tf);
         filters = [new BevelFilter(3,45,16777215,0.6,0,0.6),new DropShadowFilter(10,45,0,0.8)];
      }
      
      override protected function rollOverFunc() : void
      {
         TweenLite.to(tf,0.3,{"tint":0});
         TweenLite.to(this.bg,0.3,{"colorTransform":{
            "tint":16777113,
            "tintAmount":0.6
         }});
      }
      
      override protected function rollOutFunc() : void
      {
         TweenLite.to(tf,0.3,{"tint":null});
         TweenLite.to(this.bg,0.3,{"colorTransform":{
            "tint":16777113,
            "tintAmount":0
         }});
      }
   }
}

