package com.utterlySuperb.chumpManager.view.ui.buttons
{
   import com.greensock.TweenLite;
   
   public class PagingButton extends ChumpButton
   {
      
      public function PagingButton()
      {
         super();
      }
      
      override protected function showInactive() : void
      {
         alpha = 0.6;
      }
      
      override protected function rollOverFunc() : void
      {
         TweenLite.to(this,0.3,{"tint":16737894});
      }
      
      override protected function rollOutFunc() : void
      {
         alpha = 1;
         TweenLite.to(this,0.3,{"tint":null});
      }
   }
}

