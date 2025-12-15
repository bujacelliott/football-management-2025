package com.utterlySuperb.chumpManager.view.ui.buttons
{
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.Game;
   
   public class LoadGameButton extends ChumpButton
   {
      
      private var ball:LoadButtonBall;
      
      public function LoadGameButton()
      {
         super();
         this.ball = new LoadButtonBall();
         addChild(this.ball);
      }
      
      public function setGame(param1:Game) : void
      {
         if(param1)
         {
            this.ball.tf.htmlText = param1.playerClub.name + "<br>" + param1.currentDate.toDateString();
         }
         else
         {
            this.ball.tf.htmlText = CopyManager.getCopy("empty");
         }
      }
   }
}

