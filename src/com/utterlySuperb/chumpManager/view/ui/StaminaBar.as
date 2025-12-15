package com.utterlySuperb.chumpManager.view.ui
{
   import com.utterlySuperb.chumpManager.model.dataObjects.Player;
   import flash.display.Sprite;
   
   public class StaminaBar extends Sprite
   {
      
      public function StaminaBar()
      {
         super();
      }
      
      public function setPlayer(param1:Player) : void
      {
         var _loc2_:int = 30;
         var _loc3_:int = 10;
         graphics.beginFill(0);
         graphics.drawRect(0,0,_loc2_,_loc3_);
         graphics.beginFill(3403298);
         graphics.drawRect(0,0,param1.stamina / param1.maxStamina * _loc2_,_loc3_);
      }
   }
}

