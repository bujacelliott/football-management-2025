package com.utterlySuperb.chumpManager.view.ui.buttons
{
   import com.greensock.TweenLite;
   import com.utterlySuperb.chumpManager.view.panels.BGPanel;
   import com.utterlySuperb.text.TextHelper;
   import flash.filters.BevelFilter;
   import flash.filters.DropShadowFilter;
   
   public class SmallButton extends ChumpButton
   {
      
      private var bg:BGPanel;
      
      public function SmallButton(param1:String = "", param2:int = 70, param3:int = 30)
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
         TextHelper.doTextField2(tf,Styles.HEADER_FONT,14,16777215);
         tf.htmlText = param1;
         bWidth = Math.max(bWidth,tf.textWidth + 15);
         tf.width = bWidth - 10;
         tf.height = tf.textHeight + 5;
         tf.x = (bWidth - tf.width) / 2;
         tf.y = (bHeight - tf.textHeight - 5) / 2;
         addChild(tf);
         filters = [new BevelFilter(3,45,16777215,0.6,0,0.6),new DropShadowFilter(10,45,0,0.8)];
         if(this.bg)
         {
            removeChild(this.bg);
         }
         this.bg = new BGPanel(bWidth,bHeight,16777215,1118566,0.8,20);
         addChildAt(this.bg,0);
         bWidth = bWidth;
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

