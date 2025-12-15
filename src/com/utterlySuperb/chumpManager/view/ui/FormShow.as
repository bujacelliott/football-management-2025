package com.utterlySuperb.chumpManager.view.ui
{
   import com.utterlySuperb.chumpManager.model.dataObjects.Player;
   import flash.display.Sprite;
   
   public class FormShow extends Sprite
   {
      
      public function FormShow()
      {
         super();
      }
      
      public function setPlayer(param1:Player) : void
      {
         var _loc2_:Array = [15597568,15614976,14540032,4517376,60928];
         graphics.clear();
         graphics.beginFill(_loc2_[Math.floor(param1.form / 100 * 5)]);
         graphics.drawCircle(6,6,6);
      }
   }
}

