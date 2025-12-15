package com.utterlySuperb.chumpManager.view.ui.widgets
{
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class PlayerStatBar extends Sprite
   {
      
      public var theMask:Sprite;
      
      public var fixedNum:int = 0;
      
      public var amount:TextField;
      
      public var maxVal:int = 100;
      
      public var tf0:TextField;
      
      public var tf1:TextField;
      
      public function PlayerStatBar()
      {
         super();
      }
      
      public function setAmount(param1:int) : void
      {
         this.amount.text = param1.toFixed(this.fixedNum);
         this.theMask.scaleX = param1 / this.maxVal;
      }
      
      public function setVals(param1:int = 100, param2:int = 0) : void
      {
         this.maxVal = param1;
         this.fixedNum = param2;
      }
      
      public function setStat(param1:String) : void
      {
         this.tf0.htmlText = this.tf1.htmlText = param1;
      }
   }
}

