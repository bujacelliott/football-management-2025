package com.utterlySuperb.chumpManager.view.panels.matchPanels
{
   import com.utterlySuperb.chumpManager.view.panels.Panel;
   import com.utterlySuperb.text.TextHelper;
   import flash.text.TextField;
   import flash.text.TextFormatAlign;
   
   public class MatchTimePanel extends Panel
   {
      
      private var tf:TextField;
      
      public var bWidth:int = 80;
      
      public function MatchTimePanel()
      {
         super();
      }
      
      override protected function init() : void
      {
         makeBox(this.bWidth,40,0,0);
         makeBox(this.bWidth - 10,30,5,5,13421738,16777164);
         this.tf = new TextField();
         TextHelper.doTextField2(this.tf,Styles.HEADER_FONT,18,3355443,{"align":TextFormatAlign.CENTER});
         this.tf.width = this.bWidth - 10;
         this.tf.x = this.tf.y = 5;
         addChild(this.tf);
         this.update(null);
      }
      
      override protected function update(param1:Object = null) : void
      {
         this.tf.htmlText = Main.currentGame.matchDetails.getTimeString();
      }
      
      private function formatNum(param1:int) : String
      {
         var _loc2_:String = param1.toString();
         return _loc2_.length == 1 ? "0" + _loc2_ : _loc2_;
      }
   }
}

