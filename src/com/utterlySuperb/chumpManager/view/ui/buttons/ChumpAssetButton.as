package com.utterlySuperb.chumpManager.view.ui.buttons
{
   import flash.display.Sprite;
   
   public class ChumpAssetButton extends MediumButton
   {
      
      public function ChumpAssetButton(param1:String = "", param2:int = 120, param3:int = 55)
      {
         super(param1,param2,param3);
      }
      
      public function addAsset(param1:Sprite) : void
      {
         addChild(param1);
         param1.mouseEnabled = false;
         param1.y = 10;
         param1.x = width - 45;
         param1.width = param1.height = 30;
         tf.width = width - 55;
         tf.x = 5;
      }
      
      public function overrideTextY(param1:int) : void
      {
         tf.y = param1;
      }
   }
}

