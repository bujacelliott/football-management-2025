package com.utterlySuperb.chumpManager.view.panels
{
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.Club;
   import com.utterlySuperb.chumpManager.model.dataObjects.Game;
   import com.utterlySuperb.chumpManager.model.dataObjects.competitions.Cup;
   import com.utterlySuperb.chumpManager.view.ui.ChumpListBox;
   import com.utterlySuperb.chumpManager.view.ui.buttons.listButtons.CupRoundHeader;
   import com.utterlySuperb.chumpManager.view.ui.buttons.listButtons.CupTeamButton;
   import com.utterlySuperb.chumpManager.view.ui.buttons.listButtons.MatchListButton;
   import com.utterlySuperb.text.TextHelper;
   import com.utterlySuperb.ui.dropDown.DropDown;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class CupsPanel extends Panel
   {
      
      private var cupsBox:ChumpListBox;
      
      public var currentCup:int;
      
      public var showType:Boolean;
      
      public var cupDropdown:DropDown;
      
      public var typeDropdown:DropDown;
      
      private var infoField:TextField;
      
      public function CupsPanel()
      {
         super();
      }
      
      override protected function init() : void
      {
         var _loc1_:int = 420;
         makeBox(Globals.GAME_WIDTH - x - Globals.MARGIN_X,Globals.usableHeight);
         var _loc2_:Game = Main.currentGame;
         var _loc3_:TextField = new TextField();
         TextHelper.doTextField2(_loc3_,Styles.HEADER_FONT,16,16777215);
         _loc3_.htmlText = CopyManager.getCopy("competition");
         _loc3_.x = 20;
         _loc3_.y = 10;
         addChild(_loc3_);
         _loc3_ = new TextField();
         TextHelper.doTextField2(_loc3_,Styles.HEADER_FONT,16,16777215);
         _loc3_.htmlText = CopyManager.getCopy("information");
         _loc3_.x = 220;
         _loc3_.y = 10;
         addChild(_loc3_);
         this.cupDropdown = new DropDown(Styles.getDropdownObject(180));
         this.cupDropdown.easyMake();
         addChild(this.cupDropdown);
         this.cupDropdown.addEventListener(DropDown.DROP_DOWN_CLICK,this.dropDownSelectHandler);
         this.cupDropdown.x = 20;
         this.cupDropdown.y = 40;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.fixtureList.cups.length)
         {
            this.cupDropdown.addItem(CopyManager.getCopy(_loc2_.fixtureList.cups[_loc4_].name));
            _loc4_++;
         }
         this.typeDropdown = new DropDown(Styles.getDropdownObject(180));
         this.typeDropdown.easyMake();
         addChild(this.typeDropdown);
         this.typeDropdown.addEventListener(DropDown.DROP_DOWN_CLICK,this.dropDownSelectHandler);
         this.typeDropdown.addItem(CopyManager.getCopy("upcomingMatches"));
         this.typeDropdown.addItem(CopyManager.getCopy("entrants"));
         this.typeDropdown.x = 220;
         this.typeDropdown.y = 40;
         this.cupsBox = new ChumpListBox(boxWidth - 55,Globals.usableHeight - 140);
         addChild(this.cupsBox);
         this.cupsBox.drawFrame();
         this.cupsBox.x = 20;
         this.cupsBox.y = 70;
         this.infoField = new TextField();
         TextHelper.doTextField2(this.infoField,Styles.MAIN_FONT,14,16777215,{"multiline":true});
         this.infoField.x = 20;
         this.infoField.y = this.cupsBox.y + this.cupsBox.height + 5;
         this.infoField.width = boxWidth - 40;
         addChild(this.infoField);
         this.cupDropdown.selectedNum = this.typeDropdown.selectedNum = 0;
         enable();
         this.currentCup = 0;
         this.update();
      }
      
      private function dropDownSelectHandler(param1:Event) : void
      {
         this.update();
      }
      
      override protected function update(param1:Object = null) : void
      {
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:CupRoundHeader = null;
         var _loc7_:int = 0;
         var _loc8_:MatchListButton = null;
         var _loc9_:CupTeamButton = null;
         this.cupsBox.depopulate();
         var _loc2_:Cup = Main.currentGame.fixtureList.cups[this.cupDropdown.selectedNum];
         var _loc3_:Club = Main.currentGame.playerClub;
         if(this.typeDropdown.selectedNum == 0)
         {
            _loc4_ = _loc2_.getNextMatches();
            _loc5_ = _loc2_.getNextMatchesRound(Main.currentGame.weekNum);
            _loc6_ = new CupRoundHeader();
            _loc6_.bWidth = boxWidth - 55;
            _loc6_.setBGCol(Styles.HEADER_ITEM_COL);
            this.cupsBox.addHeaderItem(_loc6_);
            if(_loc4_.length > 0)
            {
               _loc6_.setText(CopyManager.getCopy("matchWeeknum").replace(CopyManager.WEEKNUM_REPLACE,_loc5_ + 1));
               _loc7_ = 0;
               while(_loc7_ < _loc4_.length)
               {
                  _loc8_ = new MatchListButton();
                  _loc8_.bWidth = boxWidth - 55;
                  _loc8_.setBG(_loc7_ % 2 == 0);
                  _loc8_.setMatch(_loc4_[_loc7_]);
                  this.cupsBox.addItem(_loc8_);
                  if(_loc4_[_loc7_].club0.club == _loc3_ || _loc4_[_loc7_].club1.club == _loc3_)
                  {
                     _loc8_.setInTeam();
                  }
                  _loc7_++;
               }
            }
            else
            {
               _loc6_.setText(CopyManager.getCopy("cupFinished").replace("{cupName}",CopyManager.getCopy(_loc2_.name)));
            }
         }
         else
         {
            _loc7_ = 0;
            while(_loc7_ < _loc2_.entrants.length)
            {
               _loc9_ = new CupTeamButton();
               _loc9_.bWidth = boxWidth - 55;
               _loc9_.setBG(_loc7_ % 2 == 0);
               _loc9_.setText(_loc2_.entrants[_loc7_].club.name);
               this.cupsBox.addItem(_loc9_);
               if(_loc2_.entrants[_loc7_].club == _loc3_)
               {
                  _loc9_.setInTeam();
               }
               _loc7_++;
            }
         }
         if(_loc2_.isFinished())
         {
            if(_loc2_.entrants[0].club == _loc3_)
            {
               this.infoField.htmlText = CopyManager.getCopy("youHaveWonCup");
            }
            else
            {
               this.infoField.htmlText = CopyManager.getCopy("cupWonCopy").replace(CopyManager.CLUB_NAME_REPLACE,_loc2_.entrants[0].club.name);
            }
         }
         else if(_loc2_.playerIsStillIn())
         {
            this.infoField.htmlText = CopyManager.getCopy("yourNextMatch").replace(CopyManager.WEEKNUM_REPLACE,_loc2_.getNextPlayerRound(Main.currentGame.weekNum) + 1);
         }
         else
         {
            this.infoField.htmlText = CopyManager.getCopy("youHaveBeenKnockedOutCup");
         }
         this.cupsBox.enable();
      }
      
      override protected function clickButtonHandler(param1:Event) : void
      {
         this.currentCup = buttons.indexOf(param1.target);
         this.update();
      }
      
      override protected function cleanUp() : void
      {
         removeAllButtons();
         this.cupsBox.disable();
         this.cupDropdown.removeEventListener(DropDown.DROP_DOWN_CLICK,this.dropDownSelectHandler);
         this.cupDropdown.disableButton();
         this.typeDropdown.removeEventListener(DropDown.DROP_DOWN_CLICK,this.dropDownSelectHandler);
         this.typeDropdown.disableButton();
      }
   }
}

