package com.utterlySuperb.chumpManager.view.ui.menus
{
   import com.utterlySuperb.chumpManager.view.ui.buttons.ChumpButton;
   import com.utterlySuperb.ui.Menu;
   
   public class ChumpMenu extends Menu
   {
      
      public function ChumpMenu(param1:int = 0, param2:int = 0)
      {
         super(param1,param2);
         tweenDelay = 0;
         tweenTime = 0;
         ySpacing = 5;
         centerAlign = true;
         buttonClass = ChumpButton;
      }
   }
}

