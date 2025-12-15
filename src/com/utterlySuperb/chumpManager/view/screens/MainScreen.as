package com.utterlySuperb.chumpManager.view.screens
{
   import com.utterlySuperb.chumpManager.engine.GameEngine;
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.view.panels.LeagueTablePanel;
   import com.utterlySuperb.chumpManager.view.panels.NextRoundMatchesPanel;
   import com.utterlySuperb.chumpManager.view.panels.WeekNumPanel;
   import com.utterlySuperb.chumpManager.view.panels.universalPanels.StatusPanel;
   import com.utterlySuperb.chumpManager.view.ui.buttons.BigButton;
   import com.utterlySuperb.chumpManager.view.ui.buttons.ChumpButton;
   import com.utterlySuperb.chumpManager.view.ui.buttons.MediumButton;
   import com.utterlySuperb.chumpManager.view.ui.menus.MainMenu;
   import com.utterlySuperb.events.IntEvent;
   import com.utterlySuperb.ui.ModalDialogue;
   import flash.events.Event;
   
   public class MainScreen extends Screen
   {
      
      private var showTableButton:ChumpButton;
      
      private var nextButton:ChumpButton;
      
      private var leaguePanel:LeagueTablePanel;
      
      private var nextPanel:NextRoundMatchesPanel;
      
      private var weekNumPanel:WeekNumPanel;
      
      private var clubButton:BigButton;
      
      private var managerButton:BigButton;
      
      private var continueButton:BigButton;
      
      private var optionButton:MediumButton;
      
      private var nextSeasonButton:MediumButton;
      
      public function MainScreen()
      {
         super();
         var _loc1_:StatusPanel = new StatusPanel();
         addChild(_loc1_);
         this.clubButton = new BigButton(CopyManager.getCopy("club"),CopyManager.getCopy("clubButtonInfo"));
         this.clubButton.x = Globals.MARGIN_X;
         this.clubButton.y = Globals.HEADER_OFFSET + StatusPanel.HEIGHT + 50;
         addMadeButton(this.clubButton);
         this.managerButton = new BigButton(CopyManager.getCopy("managersOffice"),CopyManager.getCopy("managersOfficeInfo"));
         this.managerButton.x = Globals.MARGIN_X;
         this.managerButton.y = this.clubButton.y + 110;
         addMadeButton(this.managerButton);
         this.continueButton = new BigButton(CopyManager.getCopy("continue"),CopyManager.getCopy("continueInfo"));
         this.continueButton.x = Globals.MARGIN_X;
         this.continueButton.y = this.managerButton.y + 110;
         addMadeButton(this.continueButton);
         this.optionButton = new MediumButton(CopyManager.getCopy("options"));
         this.optionButton.x = 540;
         this.optionButton.y = Globals.GAME_HEIGHT - 70;
         addMadeButton(this.optionButton);
         this.nextPanel = new NextRoundMatchesPanel();
         this.nextPanel.x = Globals.GAME_WIDTH / 2 + Globals.MARGIN_X / 2;
         this.nextPanel.y = 120;
         addChild(this.nextPanel);
         Main.currentGame.matchDetails = null;
         enabled = true;
      }
      
      override protected function menuClick(param1:IntEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:ModalDialogue = null;
         var _loc4_:Array = null;
         if(param1.num == MainMenu.NEXT_ROUND)
         {
            GameEngine.nextRound(Main.currentGame);
         }
         else if(param1.num == MainMenu.OPTIONS)
         {
            _loc2_ = [CopyManager.getCopy("resumeGame"),CopyManager.getCopy("quitGame")];
            _loc3_ = new ModalDialogue(CopyManager.getCopy("options"),"",_loc2_);
            Main.instance.addModal(_loc3_);
            _loc3_.addEventListener(ModalDialogue.MAKE_CHOICE,this.madeOptionsChoiceHandler);
         }
         else
         {
            _loc4_ = [];
            _loc4_[MainMenu.TEAM] = Screen.TEAM_SCREEN;
            _loc4_[MainMenu.FORMATION] = Screen.FORMATION_SCREEN;
            _loc4_[MainMenu.TRANSFERS] = Screen.TRANSFERS_SCREEN;
            _loc4_[MainMenu.TRAINING] = Screen.TRAINING_SCREEN;
            _loc4_[MainMenu.STATS] = Screen.STATS_SCREEN;
            Main.instance.showScreen(_loc4_[param1.num]);
         }
      }
      
      private function madeOptionsChoiceHandler(param1:IntEvent) : void
      {
         var _loc2_:ModalDialogue = ModalDialogue(param1.target);
         Main.instance.removeModal(_loc2_);
         switch(param1.num)
         {
            case 1:
               Main.instance.showScreen(Screen.START_SCREEN);
         }
      }
      
      override protected function clickButtonHandler(param1:Event) : void
      {
         var _loc2_:Array = null;
         var _loc3_:ModalDialogue = null;
         switch(param1.target)
         {
            case this.optionButton:
               _loc2_ = [CopyManager.getCopy("resumeGame"),CopyManager.getCopy("quitGame")];
               _loc3_ = new ModalDialogue(CopyManager.getCopy("options"),"",_loc2_);
               Main.instance.addModal(_loc3_);
               _loc3_.addEventListener(ModalDialogue.MAKE_CHOICE,this.madeOptionsChoiceHandler);
               break;
            case this.clubButton:
               Main.instance.showScreen(Screen.CLUB_SCREEN);
               break;
            case this.managerButton:
               Main.instance.showScreen(Screen.MANAGERS_SCREEN);
               break;
            case this.continueButton:
               GameEngine.nextRound(Main.currentGame);
               break;
            case this.nextSeasonButton:
               Main.instance.showScreen(Screen.END_SEASON);
         }
         if(param1.target == this.showTableButton)
         {
            if(this.leaguePanel.visible)
            {
               this.leaguePanel.visible = false;
               this.nextPanel.visible = true;
               this.showTableButton.setText(CopyManager.getCopy("leagueTable"));
            }
            else
            {
               this.leaguePanel.visible = true;
               this.nextPanel.visible = false;
               this.showTableButton.setText(CopyManager.getCopy("upcomingMatches"));
            }
         }
         else if(param1.target == this.nextButton)
         {
            GameEngine.nextRound(Main.currentGame);
         }
      }
   }
}

