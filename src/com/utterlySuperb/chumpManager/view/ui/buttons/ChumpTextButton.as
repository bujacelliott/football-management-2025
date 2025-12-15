package com.utterlySuperb.chumpManager.view.ui.buttons
{
   import com.greensock.TweenLite;
   import flash.filters.GlowFilter;
   
   public class ChumpTextButton extends ChumpButton
   {
      
      public function ChumpTextButton()
      {
         super();
         filters = [new GlowFilter(0,1,2,2,3,2)];
      }
      
      override protected function rollOverFunc() : void
      {
         TweenLite.to(tf,0.3,{"tint":16755370});
      }
      
      override protected function rollOutFunc() : void
      {
         TweenLite.to(tf,0.3,{"tint":null});
      }
   }
}

