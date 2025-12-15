package com.utterlySuperb.chumpManager.view.ui.menus
{
   import com.utterlySuperb.chumpManager.model.CopyManager;
   
   public class MainMenu extends ChumpMenu
   {
      
      public static const TEAM:int = 0;
      
      public static const FORMATION:int = 1;
      
      public static const TRANSFERS:int = 2;
      
      public static const TRAINING:int = 3;
      
      public static const STATS:int = 4;
      
      public static const NEXT_ROUND:int = 9;
      
      public static const CUPS:int = 9;
      
      public static const OPTIONS:int = 5;
      
      public function MainMenu(param1:int = 0, param2:int = 0)
      {
         super(param1,param2);
         centerAlign = false;
         makeButton(CopyManager.getCopy("team page"));
         makeButton(CopyManager.getCopy("tactics"));
         makeButton(CopyManager.getCopy("transfers page"));
         makeButton(CopyManager.getCopy("training page"));
         makeButton(CopyManager.getCopy("statistics page"));
      }
   }
}

