package com.utterlySuperb.chumpManager.view.panels
{
   import com.utterlySuperb.chumpManager.engine.GameEngine;
   import com.utterlySuperb.chumpManager.engine.TeamHelper;
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.Club;
   import com.utterlySuperb.chumpManager.model.dataObjects.Formation;
   import com.utterlySuperb.chumpManager.model.dataObjects.competitions.League;
   import com.utterlySuperb.chumpManager.view.modals.PleaseWaitModal;
   import com.utterlySuperb.chumpManager.view.ui.buttons.LeagueButton;
   import com.utterlySuperb.chumpManager.view.ui.buttons.TeamButton;
   import com.utterlySuperb.text.TextHelper;
   import com.utterlySuperb.ui.ModalDialogue;
   import com.utterlySuperb.ui.buttons.GenericButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.text.TextFormatAlign;
   
   public class SelectTeamPanel extends Panel
   {
      
      private var leaguesSelectButtons:Vector.<LeagueButton>;
      
      private var teamButtons:Vector.<TeamButton>;
      
      private var teamsHolder:Sprite;
      
      private var leaguesHolder:Sprite;
      
      private var attackScores:Array;
      
      private var defenceScores:Array;
      
      private var league:League;
      
      private var pleaseWait:ModalDialogue;
      
      private var minX:int;
      
      private var maxX:int;
      
      private var vx:Number;
      
      private var buffer:int = 60;
      
      private var infoTextField:TextField;
      
      private var currentTeamBeingMade:int;
      
      private var doBuild:Boolean;
      
      public function SelectTeamPanel()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.leaguesHolder = new Sprite();
         addChild(this.leaguesHolder);
         this.leaguesSelectButtons = new Vector.<LeagueButton>();
         this.addLeagueButton(Main.currentGame.leagues[0]);
         this.showTeamButtons(Main.currentGame.leagues[0]);
         makeBox(400,200,-200,250);
         this.infoTextField = new TextField();
         TextHelper.doTextField2(this.infoTextField,Styles.MAIN_FONT,18,16777215,{
            "multiline":true,
            "align":TextFormatAlign.CENTER
         });
         this.infoTextField.x = -180;
         this.infoTextField.y = 270;
         this.infoTextField.width = 360;
         addChild(this.infoTextField);
      }
      
      private function addLeagueButton(param1:League) : void
      {
         var _loc2_:LeagueButton = new LeagueButton();
         _loc2_.setText(CopyManager.getCopy(param1.name));
         _loc2_.league = param1;
         _loc2_.addEventListener(GenericButton.BUTTON_CLICK,this.selectLeagueHandler);
         this.leaguesSelectButtons.push(_loc2_);
         this.leaguesHolder.addChild(_loc2_);
         if(this.leaguesSelectButtons.length > 1)
         {
            _loc2_.x = this.leaguesSelectButtons[this.leaguesSelectButtons.length - 2].x + this.leaguesSelectButtons[this.leaguesSelectButtons.length - 2].width + 20;
         }
         else
         {
            _loc2_.x = _loc2_.width / 2;
         }
         this.leaguesHolder.x = -this.leaguesHolder.width / 2;
      }
      
      private function selectLeagueHandler(param1:Event) : void
      {
         this.showTeamButtons(LeagueButton(param1.target).league);
      }
      
      private function showTeamButtons(param1:League) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.leaguesSelectButtons.length)
         {
            if(this.leaguesSelectButtons[_loc2_].league == param1)
            {
               this.leaguesSelectButtons[_loc2_].deactivate(true);
            }
            else
            {
               this.leaguesSelectButtons[_loc2_].activate();
            }
            _loc2_++;
         }
         this.cleanUpTeams();
         this.teamsHolder = new Sprite();
         addChild(this.teamsHolder);
         this.teamsHolder.y = 100;
         this.teamButtons = new Vector.<TeamButton>();
         this.attackScores = new Array();
         this.defenceScores = new Array();
         this.league = param1;
         this.pleaseWait = new PleaseWaitModal(CopyManager.getCopy("pleaseWait"),CopyManager.getCopy("buildingGame"),[]);
         Main.instance.addModal(this.pleaseWait);
         this.currentTeamBeingMade = 0;
         addEventListener(Event.ENTER_FRAME,this.makeTeam);
      }
      
      private function makeTeam(param1:Event) : void
      {
         var _loc3_:TeamButton = null;
         var _loc4_:Formation = null;
         var _loc5_:Array = null;
         if(!this.doBuild)
         {
            this.doBuild = true;
            return;
         }
         this.doBuild = false;
         var _loc2_:int = this.currentTeamBeingMade;
         if(this.currentTeamBeingMade++ < this.league.entrants.length)
         {
            _loc3_ = new TeamButton();
            _loc3_.setTeam(this.league.entrants[_loc2_].club);
            this.teamsHolder.addChild(_loc3_);
            _loc3_.x = _loc2_ > 0 ? Math.max(this.teamButtons[_loc2_ - 1].x + this.teamButtons[_loc2_ - 1].width + 10,110) : 0;
            this.teamButtons.push(_loc3_);
            _loc3_.addEventListener(GenericButton.BUTTON_CLICK,this.selectTeamHandler);
            _loc3_.addEventListener(GenericButton.BUTTON_OVER,this.overTeamHandler);
            _loc3_.activate();
            _loc4_ = this.league.entrants[_loc2_].club.getFormation(0);
            _loc5_ = TeamHelper.getBestPlayers(_loc4_,this.league.entrants[_loc2_].club.getPlayersList(),false);
            this.attackScores[_loc2_] = this.league.entrants[_loc2_].club.attackScore;
            this.defenceScores[_loc2_] = this.league.entrants[_loc2_].club.defendScore;
            if(this.teamsHolder.width >= Globals.GAME_WIDTH - this.buffer * 2)
            {
               this.maxX = -(Globals.GAME_WIDTH / 2 - this.buffer);
               this.minX = -this.teamsHolder.width + (Globals.GAME_WIDTH / 2 - this.buffer);
               addEventListener(Event.ENTER_FRAME,this.moveTeamsHandler);
               this.vx = 0;
            }
            this.teamsHolder.x = -this.teamsHolder.width / 2;
         }
         else
         {
            this.finishMakingTeams();
         }
      }
      
      private function finishMakingTeams() : void
      {
         Main.instance.removeModal(this.pleaseWait);
         this.pleaseWait = null;
         removeEventListener(Event.ENTER_FRAME,this.makeTeam);
      }
      
      private function overTeamHandler(param1:Event) : void
      {
         var _loc2_:int = int(this.teamButtons.indexOf(param1.target));
         var _loc3_:Club = TeamButton(param1.target).club;
         var _loc4_:* = this.makeTextBig(_loc3_.name,22) + "<br>";
         _loc4_ = _loc4_ + (CopyManager.getCopy("clubProfile") + this.makeTextBig(_loc3_.profile.toString()) + "<br>");
         _loc4_ = _loc4_ + (CopyManager.getCopy("attack:") + this.makeTextBig(this.attackScores[_loc2_]) + "<br>");
         _loc4_ = _loc4_ + (CopyManager.getCopy("defense:") + this.makeTextBig(this.defenceScores[_loc2_]) + "<br>");
         _loc4_ = _loc4_ + (CopyManager.getCopy("scoreMult:") + this.makeTextBig(_loc3_.scoreMultiplier.toString()));
         this.infoTextField.htmlText = _loc4_;
      }
      
      private function makeTextBig(param1:String, param2:int = 18) : String
      {
         return "<font face=\'Arial Black\' size=\'" + param2 + "\'>" + param1 + "</font>";
      }
      
      private function moveTeamsHandler(param1:Event) : void
      {
         this.vx *= 0.9;
         if(mouseX < -200)
         {
            this.vx -= (mouseX + 200) / 50;
         }
         else if(mouseX > 200)
         {
            this.vx -= (mouseX - 200) / 50;
         }
         this.teamsHolder.x += this.vx;
         if(this.teamsHolder.x > this.maxX)
         {
            this.teamsHolder.x = this.maxX;
            this.vx *= -0.5;
         }
         else if(this.teamsHolder.x < this.minX)
         {
            this.teamsHolder.x = this.minX;
            this.vx *= -0.5;
         }
      }
      
      private function selectTeamHandler(param1:Event) : void
      {
         var _loc2_:Club = TeamButton(param1.target).club;
         Main.currentGame.setPlayerclub(_loc2_);
         GameEngine.initSeason(Main.currentGame);
      }
      
      private function cleanUpTeams() : void
      {
         var _loc1_:int = 0;
         if(this.teamButtons)
         {
            _loc1_ = 0;
            while(_loc1_ < this.teamButtons.length)
            {
               this.teamButtons[_loc1_].deactivate();
               this.teamButtons[_loc1_].removeEventListener(GenericButton.BUTTON_CLICK,this.selectTeamHandler);
               _loc1_++;
            }
            removeChild(this.teamsHolder);
            if(hasEventListener(Event.ENTER_FRAME))
            {
               removeEventListener(Event.ENTER_FRAME,this.moveTeamsHandler);
            }
         }
      }
      
      override protected function cleanUp() : void
      {
         this.cleanUpTeams();
         var _loc1_:int = 0;
         while(_loc1_ < this.leaguesSelectButtons.length)
         {
            this.leaguesSelectButtons[_loc1_].deactivate();
            this.leaguesSelectButtons[_loc1_].removeEventListener(GenericButton.BUTTON_CLICK,this.selectLeagueHandler);
            _loc1_++;
         }
      }
   }
}

