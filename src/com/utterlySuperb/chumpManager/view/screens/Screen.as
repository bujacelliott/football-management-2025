package com.utterlySuperb.chumpManager.view.screens
{
   import com.utterlySuperb.chumpManager.engine.GameEngine;
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.view.panels.universalPanels.StatusPanel;
   import com.utterlySuperb.chumpManager.view.screens.transfers.PlayerSearchScreen;
   import com.utterlySuperb.chumpManager.view.screens.transfers.SellPlayersScreen;
   import com.utterlySuperb.chumpManager.view.screens.transfers.TransfersScreen;
   import com.utterlySuperb.chumpManager.view.ui.buttons.ChumpButton;
   import com.utterlySuperb.chumpManager.view.ui.buttons.SmallButton;
   import com.utterlySuperb.events.IntEvent;
   import com.utterlySuperb.ui.Menu;
   import com.utterlySuperb.ui.ModalDialogue;
   import com.utterlySuperb.ui.buttons.GenericButton;
   import com.utterlySuperb.ui.buttons.TextButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class Screen extends Sprite
   {
      
      public static const START_SCREEN:String = "startScreen";
      
      public static const MAIN_SCREEN:String = "mainScreen";
      
      public static const OPTIONS:String = "options";
      
      public static const SAVE_GAME:String = "saveGame";
      
      public static const LOAD_GAME:String = "loadGame";
      
      public static const END_GAME:String = "endGame";
      
      public static const CHOOSE_SAVE_SCREEN:String = "chooseSaveSlotScreen";
      
      public static const SELECT_TEAM_SCREEN:String = "selectTeamScreenScreen";
      
      public static const TEAM_SCREEN:String = "teamScreen";
      
      public static const FORMATION_SCREEN:String = "formationScreen";
      
      public static const TRAINING_SCREEN:String = "trainingScreen";
      
      public static const TRANSFERS_SCREEN:String = "transfersScreen";
      
      public static const STATS_SCREEN:String = "statsScreen";
      
      public static const CUPS_SCREEN:String = "cupsScreen";
      
      public static const PRE_MATCH_SCREEN:String = "preMatchScreen";
      
      public static const ROUND_RESULTS_SCREEN:String = "roundResultsScreen";
      
      public static const PRE_MATCH_FORMATION:String = "prematchFormationScreen";
      
      public static const MATCH_SCREEN:String = "matchScreen";
      
      public static const MATCH_FORMATION:String = "matchFormationScreen";
      
      public static const MATCH_RESULT_SCREEN:String = "matchResultScreen";
      
      public static const CLUB_SCREEN:String = "clubScreen";
      
      public static const MANAGERS_SCREEN:String = "managersScreen";
      
      public static const COMPETITIONS_SCREEN:String = "competitionsScreen";
      
      public static const PLAYER_SEARCH_SCREEN:String = "playerSearchScreen";
      
      public static const BROWSE_CLUBS_SCREEN:String = "browseClubsScreen";
      
      public static const SELL_PLAYERS_SCREEN:String = "sellPlayersScreen";
      
      public static const FINANCE_SCREEN:String = "financeScreen";
      
      public static const END_SEASON:String = "endScreen";
      
      public static const HEADER_OFFSET:int = 50;
      
      protected var buttons:Vector.<TextButton>;
      
      protected var menus:Vector.<Menu>;
      
      private var backButton:ChumpButton;
      
      private var homeButton:ChumpButton;
      
      protected var titleTF:TextField;
      
      private var _enabled:Boolean;
      
      protected var menu:Menu;
      
      public function Screen()
      {
         super();
         this.buttons = new Vector.<TextButton>();
         this.menus = new Vector.<Menu>();
      }
      
      public static function getScreen(param1:String) : Screen
      {
         var _loc2_:Screen = null;
         Main.instance.backOverride = null;
         switch(param1)
         {
            case START_SCREEN:
               _loc2_ = new StartScreen();
               Main.instance.setBlurBG(false);
               break;
            case CHOOSE_SAVE_SCREEN:
               _loc2_ = new ChooseSaveSlotScreen();
               Main.instance.setBlurBG(true);
               break;
            case SELECT_TEAM_SCREEN:
               _loc2_ = new SelectTeamScreen();
               break;
            case TEAM_SCREEN:
               _loc2_ = new SellPlayersScreen();
               Main.instance.backOverride = Screen.CLUB_SCREEN;
               break;
            case FORMATION_SCREEN:
               _loc2_ = new FormationScreen();
               break;
            case MAIN_SCREEN:
               _loc2_ = new MainScreen();
               GameEngine.checkMessages();
               break;
            case TRAINING_SCREEN:
               _loc2_ = new TrainingScreen();
               break;
            case STATS_SCREEN:
               _loc2_ = new StatsScreen();
               break;
            case CUPS_SCREEN:
               _loc2_ = new StatsScreen();
               break;
            case TRANSFERS_SCREEN:
               _loc2_ = new TransfersScreen();
               break;
            case PRE_MATCH_SCREEN:
               _loc2_ = new PreMatchScreen();
               GameEngine.checkMessages();
               break;
            case PRE_MATCH_FORMATION:
               _loc2_ = new PreMatchFormationScreen();
               break;
            case MATCH_SCREEN:
               _loc2_ = new MatchScreen();
               break;
            case MATCH_FORMATION:
               _loc2_ = new MatchFormationScreen();
               break;
            case MATCH_RESULT_SCREEN:
               _loc2_ = new MatchResultScreen();
               break;
            case ROUND_RESULTS_SCREEN:
               _loc2_ = new RoundResultsScreen();
               break;
            case LOAD_GAME:
               _loc2_ = new LoadGameScreen();
               Main.instance.setBlurBG(true);
               break;
            case CLUB_SCREEN:
               _loc2_ = new ClubScreen();
               break;
            case MANAGERS_SCREEN:
               _loc2_ = new ManagersScreen();
               break;
            case COMPETITIONS_SCREEN:
               _loc2_ = new CompetitionsScreen();
               break;
            case PLAYER_SEARCH_SCREEN:
               _loc2_ = new PlayerSearchScreen();
               break;
            case BROWSE_CLUBS_SCREEN:
               _loc2_ = new BrowseClubsScreen();
               break;
            case SELL_PLAYERS_SCREEN:
               _loc2_ = new SellPlayersScreen();
               break;
            case FINANCE_SCREEN:
               _loc2_ = new FinanceScreen();
               break;
            case END_SEASON:
               _loc2_ = new SeasonEndScreen();
         }
         return _loc2_;
      }
      
      protected function addMenu(param1:Menu) : void
      {
         param1.addEventListener(Menu.MENU_CLICK,this.menuClick);
         addChild(param1);
         this.menus.push(param1);
         param1.tweenIn();
      }
      
      protected function addStatus() : void
      {
         var _loc1_:StatusPanel = new StatusPanel();
         addChild(_loc1_);
      }
      
      protected function makeTitle(param1:String) : void
      {
      }
      
      protected function menuClick(param1:IntEvent) : void
      {
      }
      
      protected function makeBackButton(param1:String = "") : void
      {
         this.backButton = new SmallButton(CopyManager.getCopy("back"));
         this.backButton.x = Globals.GAME_WIDTH - this.backButton.bWidth - Globals.MARGIN_X;
         this.backButton.y = Globals.MARGIN_Y;
         addChild(this.backButton);
         if(this.enabled)
         {
            this.backButton.addEventListener(GenericButton.BUTTON_CLICK,this.clickBackHandler);
            this.backButton.activate();
         }
      }
      
      protected function makeHomeButton(param1:String = "") : void
      {
         this.homeButton = new SmallButton(CopyManager.getCopy("home"));
         this.homeButton.x = Globals.MARGIN_X;
         this.homeButton.y = Globals.MARGIN_Y;
         addChild(this.homeButton);
         if(this.enabled)
         {
            this.homeButton.addEventListener(GenericButton.BUTTON_CLICK,this.clickHomeHandler);
            this.homeButton.activate();
         }
      }
      
      protected function addButton(param1:String = "", param2:String = "", param3:int = 0, param4:int = 0) : ChumpButton
      {
         var _loc5_:ChumpButton = ChumpButton.getButton(param2);
         _loc5_.setText(param1);
         _loc5_.x = param3;
         _loc5_.y = param4;
         addChild(_loc5_);
         this.buttons.push(_loc5_);
         if(this.enabled)
         {
            this.activateBtn(_loc5_);
         }
         return _loc5_;
      }
      
      protected function addMadeButton(param1:ChumpButton) : void
      {
         addChild(param1);
         this.buttons.push(param1);
         if(this.enabled)
         {
            this.activateBtn(param1);
         }
      }
      
      public function activateBtn(param1:GenericButton) : void
      {
         if(!param1.hasEventListener(GenericButton.BUTTON_CLICK))
         {
            param1.addEventListener(GenericButton.BUTTON_CLICK,this.clickButtonHandler);
            param1.addEventListener(GenericButton.BUTTON_OVER,this.overButtonHandler);
            param1.addEventListener(GenericButton.BUTTON_OUT,this.outButtonHandler);
            param1.activate();
         }
      }
      
      public function deactivateBtn(param1:GenericButton) : void
      {
         if(param1.hasEventListener(GenericButton.BUTTON_CLICK))
         {
            param1.removeEventListener(GenericButton.BUTTON_CLICK,this.clickButtonHandler);
            param1.removeEventListener(GenericButton.BUTTON_OVER,this.overButtonHandler);
            param1.removeEventListener(GenericButton.BUTTON_OUT,this.outButtonHandler);
            param1.deactivate();
         }
      }
      
      protected function clickBackHandler(param1:Event) : void
      {
         var _loc2_:String = Main.instance.backOverride;
         if(_loc2_)
         {
            Main.instance.showScreen(_loc2_);
         }
         else
         {
            Main.instance.showScreen(Screen.MAIN_SCREEN);
         }
      }
      
      private function clickHomeHandler(param1:Event) : void
      {
         Main.instance.showScreen(Screen.MAIN_SCREEN);
      }
      
      public function cleanUp() : void
      {
         this.enabled = false;
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         var _loc3_:ChumpButton = null;
         var _loc2_:Boolean = this._enabled;
         this._enabled = param1;
         if(_loc2_ != this._enabled)
         {
            if(this._enabled)
            {
               for each(_loc3_ in this.buttons)
               {
                  this.activateBtn(_loc3_);
               }
               if(Boolean(this.backButton) && !this.backButton.hasEventListener(GenericButton.BUTTON_CLICK))
               {
                  this.backButton.addEventListener(GenericButton.BUTTON_CLICK,this.clickBackHandler);
                  this.backButton.activate();
               }
               if(Boolean(this.homeButton) && !this.homeButton.hasEventListener(GenericButton.BUTTON_CLICK))
               {
                  this.homeButton.addEventListener(GenericButton.BUTTON_CLICK,this.clickHomeHandler);
                  this.homeButton.activate();
               }
            }
            else
            {
               for each(_loc3_ in this.buttons)
               {
                  this.deactivateBtn(_loc3_);
               }
               if(Boolean(this.backButton) && this.backButton.hasEventListener(GenericButton.BUTTON_CLICK))
               {
                  this.backButton.removeEventListener(GenericButton.BUTTON_CLICK,this.clickBackHandler);
                  this.backButton.deactivate();
               }
               if(Boolean(this.homeButton) && this.homeButton.hasEventListener(GenericButton.BUTTON_CLICK))
               {
                  this.homeButton.removeEventListener(GenericButton.BUTTON_CLICK,this.clickHomeHandler);
                  this.homeButton.deactivate();
               }
            }
         }
      }
      
      protected function outButtonHandler(param1:Event) : void
      {
      }
      
      protected function clickButtonHandler(param1:Event) : void
      {
      }
      
      protected function overButtonHandler(param1:Event) : void
      {
      }
      
      protected function addSimplyModal(param1:ModalDialogue) : void
      {
         Main.instance.addModal(param1);
         param1.addEventListener(ModalDialogue.MAKE_CHOICE,this.removeSimpleDialogue);
      }
      
      private function removeSimpleDialogue(param1:Event) : void
      {
         var _loc2_:ModalDialogue = param1.target as ModalDialogue;
         Main.instance.removeModal(_loc2_);
         _loc2_.addEventListener(ModalDialogue.MAKE_CHOICE,this.removeSimpleDialogue);
      }
   }
}

