package com.utterlySuperb.chumpManager.view.ui.buttons.listButtons
{
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.MatchPlayerDetails;
   
   public class PlayerResultListButton extends PlayerListButton
   {
      
      public function PlayerResultListButton()
      {
         super();
         bWidth = 225;
      }
      
      public function setPlayerDetails(param1:MatchPlayerDetails) : void
      {
         setPlayer(param1.player);
         basePostions.htmlText = param1.averageRating.toFixed(1);
         basePostions.x = 225 - basePostions.textWidth - 10;
      }
   }
}

