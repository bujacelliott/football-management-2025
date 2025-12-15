package com.utterlySuperb.chumpManager.view.ui
{
   import com.utterlySuperb.chumpManager.model.dataObjects.Player;
   import flash.display.Sprite;
   
   public class RatingStar extends Sprite
   {
      
      private var star:RatingStarMC;
      
      public function RatingStar()
      {
         super();
         this.star = new RatingStarMC();
         addChild(this.star);
      }
      
      public function setPlayer(param1:Player) : void
      {
         try
         {
            this.star.gotoAndStop(param1.playerStars);
         }
         catch(err:Error)
         {
         }
      }
   }
}

