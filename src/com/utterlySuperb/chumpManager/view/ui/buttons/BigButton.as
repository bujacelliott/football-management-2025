package com.utterlySuperb.chumpManager.view.ui.buttons
{
   import com.greensock.TweenLite;
   import com.utterlySuperb.chumpManager.view.panels.BGPanel;
   import com.utterlySuperb.text.TextHelper;
   import flash.filters.BevelFilter;
   import flash.filters.DropShadowFilter;
   import flash.text.TextField;
   import flash.text.TextFormatAlign;
   
   public class BigButton extends ChumpButton
   {
      
      private var bg:BGPanel;
      
      public function BigButton(param1:String, param2:String, param3:int = 340, param4:int = 80)
      {
         super();
         this.bg = new BGPanel(param3,param4,16777215,1118566,0.8,20);
         addChild(this.bg);
         tf = new TextField();
         TextHelper.doTextField2(tf,Styles.HEADER_FONT,18,16777215,{
            "multiline":true,
            "wordWrap":true,
            "align":TextFormatAlign.CENTER
         });
         tf.htmlText = param1 + "<br><font size=\'12\' fontFace=\'Arial\'>" + param2;
         tf.width = param3 - 10;
         tf.height = tf.textHeight + 5;
         tf.x = 5;
         tf.y = (param4 - tf.textHeight - 5) / 2;
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

