package com.utterlySuperb.chumpManager.view.panels.universalPanels
{
   import com.utterlySuperb.chumpManager.engine.GameHelper;
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.Game;
   import com.utterlySuperb.chumpManager.view.panels.Panel;
   import com.utterlySuperb.text.TextHelper;
   import flash.text.TextField;
   import flash.text.TextFormatAlign;
   
   public class StatusPanel extends Panel
   {
      
      public static const WIDTH:int = 600;
      
      public static const HEIGHT:int = 60;
      
      private var title:TextField;
      
      private var copy:TextField;
      
      public function StatusPanel()
      {
         super();
      }
      
      override protected function init() : void
      {
         makeBox(WIDTH,HEIGHT);
         this.title = new TextField();
         TextHelper.doTextField2(this.title,Styles.HEADER_FONT,18,Styles.COPY_FONT_COLOR0,{});
         addChild(this.title);
         this.title.width = this.title.textWidth + 5;
         this.copy = new TextField();
         TextHelper.doTextField2(this.copy,Styles.MAIN_FONT,16,Styles.COPY_FONT_COLOR0,{
            "multiline":true,
            "wordWrap":true,
            "leading":-2,
            "align":TextFormatAlign.CENTER
         });
         addChild(this.copy);
         this.copy.width = WIDTH - 10;
         this.copy.x = 5;
         x = (Globals.GAME_WIDTH - WIDTH) / 2;
         y = Globals.MARGIN_Y;
         this.update();
      }
      
      override protected function update(param1:Object = null) : void
      {
         var _loc2_:Game = Main.currentGame;
         this.title.htmlText = _loc2_.getWeekString() + " " + _loc2_.getRoundDate().toDateString();
         this.title.x = (boxWidth - this.title.textWidth) / 2;
         var _loc3_:* = _loc2_.playerClub.name + ": " + CopyManager.getCopy("leaguePosition") + GameHelper.getPlayerLeaguePosition() + ". " + CopyManager.getCopy("clubCash") + CopyManager.getCurrency() + TextHelper.prettifyNumber(_loc2_.clubCash) + ".";
         this.copy.htmlText = _loc3_;
         this.copy.height = this.copy.textHeight + 5;
         this.title.y = (HEIGHT - (this.copy.textHeight + this.title.textHeight + 15)) / 2;
         this.copy.y = this.title.y + this.title.textHeight + 5;
      }
   }
}

