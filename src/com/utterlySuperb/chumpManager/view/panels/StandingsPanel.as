package com.utterlySuperb.chumpManager.view.panels
{
   import com.utterlySuperb.chumpManager.model.dataObjects.competitions.League;
   import com.utterlySuperb.chumpManager.view.ui.ChumpListBox;
   import com.utterlySuperb.chumpManager.view.ui.buttons.listButtons.LeagueCompactRowListButton;
   import com.utterlySuperb.text.TextHelper;
   import flash.text.TextField;
   
   public class StandingsPanel extends Panel
   {
      
      private var leagueList:ChumpListBox;
      
      private var titleText:String;
      
      private var header:TextField;
      
      private var league:League;
      
      private var listWidth:int;
      
      private var listHeight:int;
      
      public function StandingsPanel(param1:int = 260, param2:int = 360, param3:String = "Standings")
      {
         this.titleText = param3;
         this.listWidth = param1 - 30;
         this.listHeight = param2 - 60;
         super();
         this.boxWidth = param1;
         this.boxHeight = param2;
      }
      
      override protected function init() : void
      {
         makeBox(this.boxWidth,this.boxHeight,0,0);
         this.header = new TextField();
         TextHelper.doTextField2(this.header,Styles.HEADER_FONT,18,16777215);
         this.header.htmlText = this.titleText;
         this.header.x = (this.boxWidth - this.header.textWidth) / 2;
         this.header.y = 5;
         TextHelper.fitTextField(this.header);
         addChild(this.header);
         this.leagueList = new ChumpListBox(this.listWidth,this.listHeight);
         this.leagueList.x = 15;
         this.leagueList.y = 35;
         this.leagueList.drawFrame();
         addChild(this.leagueList);
         this.update();
      }
      
      public function setLeague(param1:League) : void
      {
         this.league = param1;
         if(this.leagueList)
         {
            this.update();
         }
      }
      
      public function setTitle(param1:String) : void
      {
         this.titleText = param1;
         if(this.header)
         {
            this.header.htmlText = this.titleText;
            TextHelper.fitTextField(this.header);
            this.header.x = (this.boxWidth - this.header.textWidth) / 2;
         }
      }
      
      override protected function update(param1:Object = null) : void
      {
         var _loc2_:Array = null;
         var _loc3_:LeagueCompactRowListButton = null;
         if(!this.leagueList)
         {
            return;
         }
         if(!this.league)
         {
            this.league = Main.currentGame.getMainLeague();
         }
         if(!this.league)
         {
            return;
         }
         this.leagueList.depopulate();
         _loc2_ = this.league.getStandings();
         _loc3_ = new LeagueCompactRowListButton();
         _loc3_.bWidth = this.listWidth;
         _loc3_.applySimpleLayout();
         _loc3_.bHeight = 26;
         _loc3_.setBG(false);
         _loc3_.makeLabels();
         this.leagueList.addHeaderItem(_loc3_);
         _loc3_.setBGCol(Styles.HEADER_ITEM_COL);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc3_ = new LeagueCompactRowListButton();
            _loc3_.bWidth = this.listWidth;
            _loc3_.applySimpleLayout();
            _loc3_.bHeight = 24;
            _loc3_.setBG(_loc4_ % 2 == 0);
            _loc3_.setInfo(_loc2_[_loc4_]);
            this.leagueList.addItem(_loc3_);
            if(_loc2_[_loc4_].club == Main.currentGame.playerClub)
            {
               _loc3_.setBGCol(13369412);
            }
            _loc4_++;
         }
         this.leagueList.enable();
      }
      
      override protected function cleanUp() : void
      {
         if(this.leagueList)
         {
            this.leagueList.disable();
         }
      }
   }
}
