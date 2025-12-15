package com.utterlySuperb.chumpManager.view.panels
{
   import com.utterlySuperb.chumpManager.engine.GameHelper;
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.Game;
   import com.utterlySuperb.text.TextHelper;
   import flash.text.TextField;
   
   public class StatDisplayPanel extends Panel
   {
      
      private var tf:TextField;
      
      public var bHeight:int = 240;
      
      public function StatDisplayPanel()
      {
         super();
      }
      
      override protected function init() : void
      {
         makeBox(340,this.bHeight);
         this.tf = new TextField();
         TextHelper.doTextField2(this.tf,Styles.MAIN_FONT,14,16777215,{"multiline":true});
         this.tf.x = 20;
         this.tf.y = 5;
         this.tf.width = boxWidth - 20;
         addChild(this.tf);
         this.update();
      }
      
      override protected function update(param1:Object = null) : void
      {
         var _loc2_:Game = Main.currentGame;
         var _loc3_:* = this.makeTextBig(CopyManager.getCopy("finances"),22) + "<br>";
         _loc3_ += CopyManager.getCopy("currentBalance") + this.makeTextBig(CopyManager.getCurrency() + TextHelper.prettifyNumber(_loc2_.clubCash)) + "<br>";
         _loc3_ += CopyManager.getCopy("matchesLeft") + this.makeTextBig(GameHelper.getMatchesLeft().toString()) + "<br>";
         _loc3_ += CopyManager.getCopy("incomeAt50") + this.makeTextBig(CopyManager.getCurrency() + TextHelper.prettifyNumber(GameHelper.getExpectedIncome())) + "<br>";
         _loc3_ += CopyManager.getCopy("meritPayment") + this.makeTextBig(CopyManager.getCurrency() + TextHelper.prettifyNumber(GameHelper.getMeritPayment())) + "<br>";
         this.tf.htmlText = _loc3_;
      }
      
      private function makeTextBig(param1:String, param2:int = 14) : String
      {
         return "<font face=\'Arial Black\' size=\'" + param2 + "\'>" + param1 + "</font>";
      }
   }
}

