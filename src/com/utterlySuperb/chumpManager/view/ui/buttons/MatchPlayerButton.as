package com.utterlySuperb.chumpManager.view.ui.buttons
{
   import flash.filters.DropShadowFilter;
   
   public class MatchPlayerButton extends PlayerButton
   {
      
      public function MatchPlayerButton()
      {
         super();
         mc = new MatchDiagramPlayerButton();
         addChild(mc);
         setNormal();
         filters[new DropShadowFilter(4,45,0,0,6)];
      }
      
      public function setStamina(param1:int) : void
      {
         MatchDiagramPlayerButton(mc).stamina.gotoAndStop(param1);
      }
   }
}

