package com.utterlySuperb.chumpManager.view.panels
{
import com.utterlySuperb.chumpManager.engine.GameEngine;
import com.utterlySuperb.chumpManager.engine.TransferBudgetHelper;
   import com.utterlySuperb.chumpManager.engine.TeamHelper;
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.Club;
   import com.utterlySuperb.chumpManager.model.dataObjects.competitions.League;
   import com.utterlySuperb.chumpManager.view.ui.buttons.TeamButton;
   import com.utterlySuperb.text.TextHelper;
   import com.utterlySuperb.ui.buttons.GenericButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormatAlign;
   
   public class SelectTeamPanel extends Panel
   {
      
      private var forwardScores:Array;
      
      private var midfieldScores:Array;
      
      private var defenceScores:Array;
      
      private var league:League;
      
      private var infoTextField:TextField;
      
      private var countryGroups:Array;
      
      private var countryIndex:int = 0;
      
      private var leagueIndex:int = 0;
      
      private var countryTextField:TextField;
      
      private var leagueTextField:TextField;
      
      private var countryPrevArrow:Sprite;
      
      private var countryNextArrow:Sprite;
      
      private var leaguePrevArrow:Sprite;
      
      private var leagueNextArrow:Sprite;
      
      private var currentIndex:int = 0;
      
      private var mainTeam:TeamButton;
      
      private var nextTeam:TeamButton;
      
      private var prevTeam:TeamButton;
      
      private var sortedClubs:Array;
      
      private const MAIN_X:int = 0;
      
      private const MAIN_Y:int = 150;
      
      private const SIDE_SCALE:Number = 0.75;
      
      private const SIDE_OFFSET_X:int = 220;
      
      private const SIDE_OFFSET_Y:int = 150;
      
      private const TEAM_BOX_W:int = 180;
      
      private const TEAM_BOX_H:int = 200;
      
      private const STATS_BOX_W:int = 360;
      
      private const STATS_BOX_H:int = 140;
      
      private var leftBox:BGPanel;
      
      private var centerBox:BGPanel;
      
      private var rightBox:BGPanel;
      
      private var statsBox:BGPanel;
      
      private var leftLabel:TextField;
      
      private var centerLabel:TextField;
      
      private var rightLabel:TextField;
      
      private var nextArrow:Sprite;
      
      private var prevArrow:Sprite;
      
      public function SelectTeamPanel()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.buildTeamBoxes();
         this.statsBox = makeBox(this.STATS_BOX_W,this.STATS_BOX_H,-this.STATS_BOX_W / 2,380);
         this.infoTextField = new TextField();
         TextHelper.doTextField2(this.infoTextField,Styles.MAIN_FONT,18,16777215,{
            "multiline":true,
            "align":TextFormatAlign.CENTER
         });
         this.infoTextField.x = -this.STATS_BOX_W / 2 + 10;
         this.infoTextField.y = this.statsBox.y + 15;
         this.infoTextField.width = this.STATS_BOX_W - 20;
         addChild(this.infoTextField);
         this.buildCountryGroups();
         this.buildCountryLeagueSelector();
         this.countryIndex = 0;
         this.leagueIndex = 0;
         this.showSelectedLeague();
      }

      private function buildTeamBoxes() : void
      {
         var _loc1_:int = this.MAIN_Y - 10;
         this.centerBox = new BGPanel(this.TEAM_BOX_W,this.TEAM_BOX_H,16777215,0x0F3B2E,0.6,10);
         this.centerBox.x = -this.TEAM_BOX_W / 2;
         this.centerBox.y = _loc1_;
         addChild(this.centerBox);
         this.leftBox = new BGPanel(this.TEAM_BOX_W,this.TEAM_BOX_H,16777215,0x0F3B2E,0.6,10);
         this.leftBox.x = -this.SIDE_OFFSET_X - this.TEAM_BOX_W / 2;
         this.leftBox.y = _loc1_;
         addChild(this.leftBox);
         this.rightBox = new BGPanel(this.TEAM_BOX_W,this.TEAM_BOX_H,16777215,0x0F3B2E,0.6,10);
         this.rightBox.x = this.SIDE_OFFSET_X - this.TEAM_BOX_W / 2;
         this.rightBox.y = _loc1_;
         addChild(this.rightBox);
         this.centerLabel = this.makeBoxLabel("Chosen Team",this.centerBox.x,this.centerBox.y);
         this.leftLabel = this.makeBoxLabel("Left Team",this.leftBox.x,this.leftBox.y);
         this.rightLabel = this.makeBoxLabel("Right Team",this.rightBox.x,this.rightBox.y);
      }

      private function makeBoxLabel(param1:String, param2:int, param3:int) : TextField
      {
         var _loc4_:TextField = new TextField();
         TextHelper.doTextField2(_loc4_,Styles.MAIN_FONT,14,16777215,{"align":TextFormatAlign.CENTER});
         _loc4_.text = param1;
         _loc4_.width = this.TEAM_BOX_W;
         _loc4_.x = param2;
         _loc4_.y = param3 + 6;
         addChild(_loc4_);
         return _loc4_;
      }

      private function buildCountryGroups() : void
      {
         var _loc1_:Object = {};
         var _loc2_:int = 0;
         while(_loc2_ < Main.currentGame.leagues.length)
         {
            if(Main.currentGame.leagues[_loc2_])
            {
               var _loc3_:String = this.getCountryForLeague(Main.currentGame.leagues[_loc2_]);
               if(_loc3_)
               {
                  if(!_loc1_[_loc3_])
                  {
                     _loc1_[_loc3_] = [];
                  }
                  _loc1_[_loc3_].push(Main.currentGame.leagues[_loc2_]);
               }
            }
            _loc2_++;
         }
         this.countryGroups = [];
         var _loc4_:Array = ["England","Italy","Spain","Germany","France"];
         _loc2_ = 0;
         while(_loc2_ < _loc4_.length)
         {
            if(_loc1_[_loc4_[_loc2_]])
            {
               this.countryGroups.push({
                  "name":_loc4_[_loc2_],
                  "leagues":_loc1_[_loc4_[_loc2_]]
               });
            }
            _loc2_++;
         }
         for(var _loc5_:* in _loc1_)
         {
            if(_loc4_.indexOf(_loc5_) == -1)
            {
               this.countryGroups.push({
                  "name":_loc5_,
                  "leagues":_loc1_[_loc5_]
               });
            }
         }
         var _loc6_:Array = ["premierLeague","championship","leagueOne","leagueTwo","serieA","laLigue","bundesleague","ligue1"];
         _loc2_ = 0;
         while(_loc2_ < this.countryGroups.length)
         {
            this.countryGroups[_loc2_].leagues.sort(function(a:League, b:League) : Number
            {
               return _loc6_.indexOf(a.name) - _loc6_.indexOf(b.name);
            });
            _loc2_++;
         }
      }

      private function getCountryForLeague(param1:League) : String
      {
         switch(param1.name)
         {
            case "premierLeague":
            case "championship":
            case "leagueOne":
            case "leagueTwo":
               return "England";
            case "serieA":
               return "Italy";
            case "laLigue":
               return "Spain";
            case "bundesleague":
               return "Germany";
            case "ligue1":
               return "France";
         }
         return "";
      }

      private function buildCountryLeagueSelector() : void
      {
         this.countryTextField = new TextField();
         TextHelper.doTextField2(this.countryTextField,Styles.MAIN_FONT,18,16777215,{"align":TextFormatAlign.CENTER});
         this.countryTextField.y = 15;
         addChild(this.countryTextField);
         this.leagueTextField = new TextField();
         TextHelper.doTextField2(this.leagueTextField,Styles.MAIN_FONT,18,16777215,{"align":TextFormatAlign.CENTER});
         this.leagueTextField.y = 45;
         addChild(this.leagueTextField);
         this.countryPrevArrow = this.makeArrow(true);
         this.countryNextArrow = this.makeArrow(false);
         this.leaguePrevArrow = this.makeArrow(true);
         this.leagueNextArrow = this.makeArrow(false);
         this.countryPrevArrow.addEventListener(MouseEvent.CLICK,this.prevCountry);
         this.countryNextArrow.addEventListener(MouseEvent.CLICK,this.nextCountry);
         this.leaguePrevArrow.addEventListener(MouseEvent.CLICK,this.prevLeague);
         this.leagueNextArrow.addEventListener(MouseEvent.CLICK,this.nextLeague);
         addChild(this.countryPrevArrow);
         addChild(this.countryNextArrow);
         addChild(this.leaguePrevArrow);
         addChild(this.leagueNextArrow);
         this.updateCountryLeagueUI();
      }

      private function updateCountryLeagueUI() : void
      {
         if(!this.countryGroups || this.countryGroups.length == 0)
         {
            return;
         }
         var _loc1_:Object = this.countryGroups[this.countryIndex];
         this.countryTextField.text = "League: " + _loc1_.name;
         this.countryTextField.width = this.countryTextField.textWidth + 10;
         this.countryTextField.x = -this.countryTextField.width / 2;
         var _loc2_:League = _loc1_.leagues[this.leagueIndex];
         this.leagueTextField.text = "Division: " + CopyManager.getCopy(_loc2_.name);
         this.leagueTextField.width = this.leagueTextField.textWidth + 10;
         this.leagueTextField.x = -this.leagueTextField.width / 2;
         this.countryPrevArrow.x = this.countryTextField.x - 40;
         this.countryPrevArrow.y = this.countryTextField.y + 2;
         this.countryNextArrow.x = this.countryTextField.x + this.countryTextField.width + 20;
         this.countryNextArrow.y = this.countryTextField.y + 2;
         this.leaguePrevArrow.x = this.leagueTextField.x - 40;
         this.leaguePrevArrow.y = this.leagueTextField.y + 2;
         this.leagueNextArrow.x = this.leagueTextField.x + this.leagueTextField.width + 20;
         this.leagueNextArrow.y = this.leagueTextField.y + 2;
         var _loc3_:Boolean = _loc1_.leagues.length > 1;
         this.setArrowEnabled(this.leaguePrevArrow,_loc3_);
         this.setArrowEnabled(this.leagueNextArrow,_loc3_);
      }

      private function setArrowEnabled(param1:Sprite, param2:Boolean) : void
      {
         param1.mouseEnabled = param2;
         param1.alpha = param2 ? 1 : 0.3;
      }

      private function prevCountry(param1:Event) : void
      {
         if(!this.countryGroups || this.countryGroups.length == 0)
         {
            return;
         }
         this.countryIndex = (this.countryIndex - 1 + this.countryGroups.length) % this.countryGroups.length;
         this.leagueIndex = 0;
         this.updateCountryLeagueUI();
         this.showSelectedLeague();
      }

      private function nextCountry(param1:Event) : void
      {
         if(!this.countryGroups || this.countryGroups.length == 0)
         {
            return;
         }
         this.countryIndex = (this.countryIndex + 1) % this.countryGroups.length;
         this.leagueIndex = 0;
         this.updateCountryLeagueUI();
         this.showSelectedLeague();
      }

      private function prevLeague(param1:Event) : void
      {
         var _loc1_:Array = this.countryGroups[this.countryIndex].leagues;
         if(_loc1_.length <= 1)
         {
            return;
         }
         this.leagueIndex = (this.leagueIndex - 1 + _loc1_.length) % _loc1_.length;
         this.updateCountryLeagueUI();
         this.showSelectedLeague();
      }

      private function nextLeague(param1:Event) : void
      {
         var _loc1_:Array = this.countryGroups[this.countryIndex].leagues;
         if(_loc1_.length <= 1)
         {
            return;
         }
         this.leagueIndex = (this.leagueIndex + 1) % _loc1_.length;
         this.updateCountryLeagueUI();
         this.showSelectedLeague();
      }

      private function showSelectedLeague() : void
      {
         var _loc1_:League = this.countryGroups[this.countryIndex].leagues[this.leagueIndex];
         this.showTeamButtons(_loc1_);
      }
      
      private function showTeamButtons(param1:League) : void
      {
         this.cleanUpTeams();
         this.forwardScores = [];
         this.midfieldScores = [];
         this.defenceScores = [];
         this.league = param1;
         this.sortedClubs = [];
         var _loc3_:int = 0;
         while(_loc3_ < this.league.entrants.length)
         {
            this.sortedClubs.push(this.league.entrants[_loc3_].club);
            _loc3_++;
         }
         this.sortedClubs.sort(function(a:Club, b:Club) : Number
         {
            var _loc1_:String = a.name.toLowerCase();
            var _loc2_:String = b.name.toLowerCase();
            if(_loc1_ < _loc2_)
            {
               return -1;
            }
            if(_loc1_ > _loc2_)
            {
               return 1;
            }
            return 0;
         });
         _loc3_ = 0;
         while(_loc3_ < this.sortedClubs.length)
         {
            var _loc4_:Object = TeamHelper.getUnitStarBreakdown(this.sortedClubs[_loc3_]);
            this.forwardScores[_loc3_] = _loc4_.forwards;
            this.midfieldScores[_loc3_] = _loc4_.midfield;
            this.defenceScores[_loc3_] = _loc4_.defence;
            _loc3_++;
         }
         this.buildCarousel();
         this.currentIndex = 0;
         this.refreshCarousel();
      }
      
      private function buildCarousel() : void
      {
         this.mainTeam = new TeamButton();
         this.prevTeam = new TeamButton();
         this.nextTeam = new TeamButton();
         this.addChild(this.prevTeam);
         this.addChild(this.nextTeam);
         this.addChild(this.mainTeam);
         this.mainTeam.x = this.MAIN_X;
         this.mainTeam.y = this.MAIN_Y;
         this.prevTeam.scaleX = this.prevTeam.scaleY = this.SIDE_SCALE;
         this.nextTeam.scaleX = this.nextTeam.scaleY = this.SIDE_SCALE;
         this.prevTeam.x = -this.SIDE_OFFSET_X;
         this.prevTeam.y = this.SIDE_OFFSET_Y;
         this.nextTeam.x = this.SIDE_OFFSET_X;
         this.nextTeam.y = this.SIDE_OFFSET_Y;
         this.prevTeam.addEventListener(GenericButton.BUTTON_CLICK,this.selectTeamHandler);
         this.nextTeam.addEventListener(GenericButton.BUTTON_CLICK,this.selectTeamHandler);
         this.mainTeam.addEventListener(GenericButton.BUTTON_CLICK,this.selectTeamHandler);
         this.prevTeam.activate();
         this.nextTeam.activate();
         this.mainTeam.activate();
         this.prevArrow = this.makeArrow(true,40);
         this.nextArrow = this.makeArrow(false,40);
         this.prevArrow.x = -Globals.GAME_WIDTH / 2 + 35;
         this.prevArrow.y = this.MAIN_Y + 40;
         this.nextArrow.x = Globals.GAME_WIDTH / 2 - 35;
         this.nextArrow.y = this.MAIN_Y + 40;
         this.prevArrow.addEventListener(MouseEvent.CLICK,this.prevClub);
         this.nextArrow.addEventListener(MouseEvent.CLICK,this.nextClub);
         addChild(this.prevArrow);
         addChild(this.nextArrow);
      }
      
      private function makeArrow(param1:Boolean, param2:int = 20) : Sprite
      {
         var _loc2_:Sprite = new Sprite();
         _loc2_.graphics.beginFill(16777215);
         if(param1)
         {
            _loc2_.graphics.moveTo(param2,0);
            _loc2_.graphics.lineTo(0,param2);
            _loc2_.graphics.lineTo(param2,param2 * 2);
         }
         else
         {
            _loc2_.graphics.moveTo(0,0);
            _loc2_.graphics.lineTo(param2,param2);
            _loc2_.graphics.lineTo(0,param2 * 2);
         }
         _loc2_.graphics.endFill();
         _loc2_.buttonMode = true;
         _loc2_.mouseChildren = false;
         return _loc2_;
      }
      
      private function prevClub(param1:Event) : void
      {
         this.currentIndex = (this.currentIndex - 1 + this.sortedClubs.length) % this.sortedClubs.length;
         this.refreshCarousel();
      }
      
      private function nextClub(param1:Event) : void
      {
         this.currentIndex = (this.currentIndex + 1) % this.sortedClubs.length;
         this.refreshCarousel();
      }
      
      private function refreshCarousel() : void
      {
         if(!this.sortedClubs || this.sortedClubs.length == 0)
         {
            return;
         }
         var _loc1_:int = this.currentIndex;
         var _loc2_:int = (this.currentIndex - 1 + this.sortedClubs.length) % this.sortedClubs.length;
         var _loc3_:int = (this.currentIndex + 1) % this.sortedClubs.length;
         this.mainTeam.x = this.MAIN_X;
         this.mainTeam.y = this.MAIN_Y;
         this.mainTeam.scaleX = this.mainTeam.scaleY = 1;
         this.prevTeam.x = -this.SIDE_OFFSET_X;
         this.prevTeam.y = this.SIDE_OFFSET_Y;
         this.prevTeam.scaleX = this.prevTeam.scaleY = this.SIDE_SCALE;
         this.nextTeam.x = this.SIDE_OFFSET_X;
         this.nextTeam.y = this.SIDE_OFFSET_Y;
         this.nextTeam.scaleX = this.nextTeam.scaleY = this.SIDE_SCALE;
         this.mainTeam.setTeam(this.sortedClubs[_loc1_],true);
         this.prevTeam.setTeam(this.sortedClubs[_loc2_],true);
         this.nextTeam.setTeam(this.sortedClubs[_loc3_],true);
         this.updateInfo(_loc1_);
      }
      
      private function updateInfo(param1:int) : void
      {
         var _loc2_:Club = this.sortedClubs[param1];
         var _loc3_:* = this.makeTextBig(_loc2_.name,22) + "<br>";
         _loc3_ = _loc3_ + (CopyManager.getCopy("clubProfile") + this.makeTextBig(_loc2_.profile.toString()) + "<br>");
         _loc3_ = _loc3_ + ("Forwards: " + this.makeTextBig(this.forwardScores[param1].toString()) + "★<br>");
         _loc3_ = _loc3_ + ("Midfield: " + this.makeTextBig(this.midfieldScores[param1].toString()) + "★<br>");
         _loc3_ = _loc3_ + ("Defence: " + this.makeTextBig(this.defenceScores[param1].toString()) + "★<br>");
         _loc3_ = _loc3_ + (CopyManager.getCopy("scoreMult:") + this.makeTextBig(_loc2_.scoreMultiplier.toString()));
         this.infoTextField.htmlText = _loc3_;
      }
      
      private function makeTextBig(param1:String, param2:int = 18) : String
      {
         return "<font face=\'Arial Black\' size=\'" + param2 + "\'>" + param1 + "</font>";
      }
      
      private function selectTeamHandler(param1:Event) : void
      {
         var _loc2_:Club = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param1.currentTarget == this.mainTeam || param1.currentTarget == this.nextTeam || param1.currentTarget == this.prevTeam)
         {
            _loc2_ = TeamButton(param1.currentTarget).club;
         }
         else
         {
            _loc2_ = TeamButton(param1.target).club;
         }
         Main.currentGame.setPlayerclub(_loc2_);
         _loc3_ = Main.currentGame.leagues.indexOf(this.league);
         if(_loc3_ < 0 && this.league)
         {
            _loc3_ = 0;
            while(_loc3_ < Main.currentGame.leagues.length)
            {
               if(Main.currentGame.leagues[_loc3_] && Main.currentGame.leagues[_loc3_].name == this.league.name)
               {
                  break;
               }
               _loc3_++;
            }
         }
         Main.currentGame.mainLeagueNum = _loc3_;
         _loc4_ = TransferBudgetHelper.getBudget(this.league ? this.league.name : "",_loc2_.name);
         if(_loc4_ <= 0)
         {
            _loc4_ = TransferBudgetHelper.getBudget(this.league ? this.league.name : "",_loc2_.shortName);
         }
         if(_loc4_ <= 0)
         {
            _loc4_ = TransferBudgetHelper.getBudget("Premier League",_loc2_.name);
            if(_loc4_ <= 0)
            {
               _loc4_ = TransferBudgetHelper.getBudget("Championship",_loc2_.name);
            }
            if(_loc4_ <= 0)
            {
               _loc4_ = TransferBudgetHelper.getBudget("League One",_loc2_.name);
            }
            if(_loc4_ <= 0)
            {
               _loc4_ = TransferBudgetHelper.getBudget("League Two",_loc2_.name);
            }
            if(_loc4_ <= 0)
            {
               _loc4_ = TransferBudgetHelper.getBudget("Bundesliga",_loc2_.name);
            }
            if(_loc4_ <= 0)
            {
               _loc4_ = TransferBudgetHelper.getBudget("La Liga",_loc2_.name);
            }
            if(_loc4_ <= 0)
            {
               _loc4_ = TransferBudgetHelper.getBudget("Serie A",_loc2_.name);
            }
            if(_loc4_ <= 0)
            {
               _loc4_ = TransferBudgetHelper.getBudget("Ligue 1",_loc2_.name);
            }
         }
         if(_loc4_ > 0)
         {
            Main.currentGame.clubCash = _loc4_;
         }
         GameEngine.initSeason(Main.currentGame);
      }
      
      private function cleanUpTeams() : void
      {
         if(this.mainTeam)
         {
            this.mainTeam.deactivate();
            this.nextTeam.deactivate();
            this.prevTeam.deactivate();
            if(contains(this.mainTeam))
            {
               removeChild(this.mainTeam);
            }
            if(contains(this.nextTeam))
            {
               removeChild(this.nextTeam);
            }
            if(contains(this.prevTeam))
            {
               removeChild(this.prevTeam);
            }
            if(this.prevArrow && contains(this.prevArrow))
            {
               removeChild(this.prevArrow);
            }
            if(this.nextArrow && contains(this.nextArrow))
            {
               removeChild(this.nextArrow);
            }
         }
      }
      
      override protected function cleanUp() : void
      {
         this.cleanUpTeams();
         if(this.countryPrevArrow)
         {
            this.countryPrevArrow.removeEventListener(MouseEvent.CLICK,this.prevCountry);
         }
         if(this.countryNextArrow)
         {
            this.countryNextArrow.removeEventListener(MouseEvent.CLICK,this.nextCountry);
         }
         if(this.leaguePrevArrow)
         {
            this.leaguePrevArrow.removeEventListener(MouseEvent.CLICK,this.prevLeague);
         }
         if(this.leagueNextArrow)
         {
            this.leagueNextArrow.removeEventListener(MouseEvent.CLICK,this.nextLeague);
         }
      }
   }
}

