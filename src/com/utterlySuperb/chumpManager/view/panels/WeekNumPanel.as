package com.utterlySuperb.chumpManager.view.panels
{
   import com.utterlySuperb.chumpManager.model.dataObjects.Game;
   import com.utterlySuperb.text.TextHelper;
   import flash.text.TextField;
   
   public class WeekNumPanel extends Panel
   {
      
      private var weekNumTF:TextField;
      
      private var dateTF:TextField;
      
      public function WeekNumPanel()
      {
         super();
         makeBox(Globals.GAME_WIDTH / 2 - Globals.MARGIN_X * 1.5,70);
         this.weekNumTF = new TextField();
         TextHelper.doTextField2(this.weekNumTF,Styles.HEADER_FONT,24,16777215);
         this.weekNumTF.y = 5;
         addChild(this.weekNumTF);
         this.dateTF = new TextField();
         TextHelper.doTextField2(this.dateTF,Styles.MAIN_FONT,16,16777215);
         this.dateTF.y = 40;
         addChild(this.dateTF);
         this.update(null);
      }
      
      override protected function update(param1:Object = null) : void
      {
         var _loc2_:Game = Main.currentGame;
         this.weekNumTF.htmlText = _loc2_.getWeekString();
         this.dateTF.htmlText = _loc2_.getRoundDate().toDateString();
         this.weekNumTF.x = (boxWidth - this.weekNumTF.textWidth) / 2;
         this.dateTF.x = (boxWidth - this.dateTF.textWidth) / 2;
      }
   }
}

