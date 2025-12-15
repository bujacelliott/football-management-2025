package com.utterlySuperb.chumpManager.view.screens
{
   import com.utterlySuperb.chumpManager.view.panels.CupsPanel;
   import com.utterlySuperb.chumpManager.view.panels.StatDisplayPanel;
   import com.utterlySuperb.chumpManager.view.panels.TopScorersPanel;
   
   public class StatsScreen extends Screen
   {
      
      public function StatsScreen()
      {
         super();
         makeBackButton();
         var _loc1_:CupsPanel = new CupsPanel();
         _loc1_.x = 360;
         _loc1_.y = Globals.HEADER_OFFSET;
         addChild(_loc1_);
         var _loc2_:StatDisplayPanel = new StatDisplayPanel();
         _loc2_.x = Globals.MARGIN_X;
         _loc2_.y = Globals.HEADER_OFFSET;
         addChild(_loc2_);
         var _loc3_:TopScorersPanel = new TopScorersPanel();
         _loc3_.x = Globals.MARGIN_X;
         _loc3_.y = _loc2_.y + _loc2_.bHeight + Globals.MARGIN_Y;
         addChild(_loc3_);
         enabled = true;
      }
   }
}

