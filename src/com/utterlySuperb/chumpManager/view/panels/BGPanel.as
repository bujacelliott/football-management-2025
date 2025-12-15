package com.utterlySuperb.chumpManager.view.panels
{
   import flash.display.Sprite;
   
   public class BGPanel extends Sprite
   {
      
      public function BGPanel(param1:int, param2:int, param3:Number = 16777215, param4:Number = 16777215, param5:Number = 0.2, param6:int = 20)
      {
         super();
         graphics.lineStyle(2,param3);
         graphics.beginFill(param4,param5);
         graphics.drawRoundRect(0,0,param1,param2,param6,param6);
      }
   }
}

