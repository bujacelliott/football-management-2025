package com.utterlySuperb.chumpManager.view.panels
{
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.view.ui.ChumpListBox;
   import com.utterlySuperb.chumpManager.view.ui.buttons.listButtons.LeagueRowListButton;
   import com.utterlySuperb.text.TextHelper;
   import flash.text.TextField;
   
   public class LeagueTablePanel extends Panel
   {
      
      public static const BOX_WIDTH:int = 400;
      
      private var leagueList:ChumpListBox;
      
      public var aHeight:int = 300;
      
      public function LeagueTablePanel()
      {
         super();
      }
      
      override protected function init() : void
      {
         makeBox(BOX_WIDTH,this.aHeight,0,0);
         var _loc1_:TextField = new TextField();
         TextHelper.doTextField2(_loc1_,Styles.HEADER_FONT,18,16777215);
         _loc1_.htmlText = CopyManager.getCopy("leagueTable");
         _loc1_.x = (360 - _loc1_.textWidth) / 2;
         _loc1_.y = 5;
         TextHelper.fitTextField(_loc1_);
         addChild(_loc1_);
         this.leagueList = new ChumpListBox(345,boxHeight - 70);
         this.leagueList.x = 20;
         this.leagueList.y = 40;
         this.leagueList.drawFrame();
         addChild(this.leagueList);
         this.update(null);
      }
      
      override protected function update(param1:Object = null) : void
      {
         var _loc2_:String = null;
         var _loc4_:LeagueRowListButton = null;
         var _loc3_:Array = Main.currentGame.getMainLeague().getStandings();
         _loc4_ = new LeagueRowListButton();
         _loc4_.bWidth = 345;
         _loc4_.bHeight = 30;
         _loc4_.setBG(false);
         _loc4_.makeLabels();
         this.leagueList.addHeaderItem(_loc4_);
         _loc4_.setBGCol(Styles.HEADER_ITEM_COL);
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.length)
         {
            _loc4_ = new LeagueRowListButton();
            _loc4_.bWidth = 345;
            _loc4_.bHeight = 25;
            _loc4_.setBG(_loc5_ % 2 == 0);
            _loc4_.setInfo(_loc3_[_loc5_]);
            this.leagueList.addItem(_loc4_);
            if(_loc3_[_loc5_].club == Main.currentGame.playerClub)
            {
               _loc4_.setBGCol(13369412);
            }
            _loc5_++;
         }
         this.leagueList.enable();
      }
      
      override protected function cleanUp() : void
      {
         this.leagueList.disable();
      }
   }
}

