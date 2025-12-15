package com.utterlySuperb.chumpManager.view.screens
{
   import com.utterlySuperb.chumpManager.engine.MatchEngine;
   import com.utterlySuperb.chumpManager.engine.MatchHelper;
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.Game;
   import com.utterlySuperb.chumpManager.model.dataObjects.Settings;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.MatchAction;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.MatchDetails;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.MatchEvent;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.MatchMessage;
   import com.utterlySuperb.chumpManager.view.modals.MatchOptions;
   import com.utterlySuperb.chumpManager.view.panels.matchPanels.MatchFormationPanel;
   import com.utterlySuperb.chumpManager.view.panels.matchPanels.MatchScorePanel;
   import com.utterlySuperb.chumpManager.view.panels.matchPanels.MatchStatsPanel;
   import com.utterlySuperb.chumpManager.view.panels.matchPanels.MatchTextInfoPanel;
   import com.utterlySuperb.chumpManager.view.panels.matchPanels.MatchTimePanel;
   import com.utterlySuperb.chumpManager.view.ui.buttons.ChumpButton;
   import com.utterlySuperb.events.BudgetEventProxy;
   import com.utterlySuperb.ui.ModalDialogue;
   import flash.events.Event;
   
   public class MatchScreen extends Screen
   {
      
      private var scorePanel:MatchScorePanel;
      
      private var formationPanel:MatchFormationPanel;
      
      private var matchTextInfoPanel:MatchTextInfoPanel;
      
      private var makeChangeButton:ChumpButton;
      
      private var matchOptionsButton:ChumpButton;
      
      private var actionsButton:ChumpButton;
      
      private var timePanel:MatchTimePanel;
      
      private var efCount:int;
      
      private var AIMatchInterval:int = 5;
      
      public function MatchScreen()
      {
         super();
         MatchEngine.initMatch(Main.currentGame);
         this.scorePanel = new MatchScorePanel();
         this.scorePanel.x = Globals.MARGIN_X;
         this.scorePanel.y = Globals.HEADER_OFFSET;
         addChild(this.scorePanel);
         this.formationPanel = new MatchFormationPanel();
         this.formationPanel.x = Globals.MARGIN_X;
         this.formationPanel.y = Globals.HEADER_OFFSET + 120;
         addChild(this.formationPanel);
         this.matchTextInfoPanel = new MatchTextInfoPanel();
         this.matchTextInfoPanel.x = 290 + Globals.MARGIN_X * 2;
         this.matchTextInfoPanel.y = this.formationPanel.y;
         addChild(this.matchTextInfoPanel);
         this.timePanel = new MatchTimePanel();
         addChild(this.timePanel);
         this.timePanel.x = Globals.GAME_WIDTH / 2 - this.timePanel.bWidth / 2;
         this.timePanel.y = Globals.HEADER_OFFSET + 60;
         this.makeChangeButton = addButton(CopyManager.getCopy("makeChange"),"",this.matchTextInfoPanel.x,this.matchTextInfoPanel.y + this.matchTextInfoPanel.getHeight() + 5);
         this.actionsButton = addButton(CopyManager.getCopy("makeChange"),"",this.matchTextInfoPanel.x,this.makeChangeButton.y + 36);
         this.matchOptionsButton = addButton(CopyManager.getCopy("matchOptions"),"",this.matchTextInfoPanel.x,this.actionsButton.y + 36);
         var _loc1_:MatchStatsPanel = new MatchStatsPanel();
         addChild(_loc1_);
         _loc1_.x = Globals.GAME_WIDTH - Globals.MARGIN_X - 180;
         _loc1_.y = this.matchTextInfoPanel.y + this.matchTextInfoPanel.getHeight() + 5;
         this.actionsButton.visible = false;
         enabled = true;
         this.efCount = 0;
         BudgetEventProxy.addEventListener(MatchEngine.MATCH_EVENT,this.matchEventHandler);
         if(Main.currentGame.matchDetails.gameBreak)
         {
            this.matchEventHandler({"event":Main.currentGame.matchDetails.gameBreak});
         }
         else
         {
            addEventListener(Event.ENTER_FRAME,this.efHandler);
         }
      }
      
      override protected function clickButtonHandler(param1:Event) : void
      {
         var _loc2_:MatchOptions = null;
         var _loc3_:MatchDetails = null;
         var _loc4_:String = null;
         var _loc5_:MatchMessage = null;
         if(param1.target == this.makeChangeButton)
         {
            Main.instance.showScreen(Screen.MATCH_FORMATION);
         }
         else if(param1.target == this.matchOptionsButton)
         {
            if(hasEventListener(Event.ENTER_FRAME))
            {
               removeEventListener(Event.ENTER_FRAME,this.efHandler);
            }
            _loc2_ = new MatchOptions();
            Main.instance.addModal(_loc2_);
            _loc2_.addEventListener(ModalDialogue.MAKE_CHOICE,this.closeOptionsHandler);
         }
         else if(param1.target == this.actionsButton)
         {
            _loc3_ = Main.currentGame.matchDetails;
            switch(_loc3_.gameBreak)
            {
               case MatchEngine.HALF_TIME:
                  MatchEngine.startMatch(Main.currentGame);
                  addEventListener(Event.ENTER_FRAME,this.efHandler);
                  this.actionsButton.visible = false;
                  break;
               case MatchEngine.FULL_TIME:
                  Main.instance.showScreen(Screen.MATCH_RESULT_SCREEN);
                  break;
               case MatchEngine.BEFORE_GAME:
                  MatchEngine.startMatch(Main.currentGame);
                  addEventListener(Event.ENTER_FRAME,this.efHandler);
                  this.actionsButton.visible = false;
                  break;
               case MatchEngine.GOAL:
                  MatchEngine.restartMatchGoal();
                  addEventListener(Event.ENTER_FRAME,this.efHandler);
                  this.actionsButton.visible = false;
                  break;
               case MatchEngine.RED_CARD:
                  addEventListener(Event.ENTER_FRAME,this.efHandler);
                  this.actionsButton.visible = false;
                  break;
               case MatchEngine.YELLOW_CARD:
                  addEventListener(Event.ENTER_FRAME,this.efHandler);
                  this.actionsButton.visible = false;
                  break;
               case MatchEvent.INJURY:
                  addEventListener(Event.ENTER_FRAME,this.efHandler);
                  this.actionsButton.visible = false;
                  break;
               case MatchEngine.PENALTIES:
                  this.actionsButton.setText(CopyManager.getCopy("continue"));
                  MatchEngine.doPenalties(_loc3_.match);
                  _loc4_ = MatchHelper.getMatchCopy(CopyManager.PENALTIES_RESULT);
                  if(_loc3_.match.penaltiesScore0 > _loc3_.match.penaltiesScore1)
                  {
                     _loc4_ = _loc4_.replace("{winClub}",_loc3_.match.club0.club.name).replace("{loseClub}",_loc3_.match.club1.club.name);
                  }
                  else
                  {
                     _loc4_ = _loc4_.replace("{winClub}",_loc3_.match.club1.club.name).replace("{loseClub}",_loc3_.match.club0.club.name);
                  }
                  _loc4_ = _loc4_.replace("{score0}",_loc3_.match.penaltiesScore0).replace("{score1}",_loc3_.match.penaltiesScore1);
                  _loc5_ = new MatchMessage(_loc4_);
                  _loc5_.type = MatchAction.PENALTY;
                  _loc3_.messages.push(_loc5_);
                  BudgetEventProxy.dispatchEvent(Game.DATA_CHANGED,null);
            }
            _loc3_.gameBreak = _loc3_.gameBreak == MatchEngine.PENALTIES ? MatchEngine.FULL_TIME : null;
         }
      }
      
      private function closeOptionsHandler(param1:Event) : void
      {
         var _loc2_:MatchOptions = MatchOptions(param1.target);
         Main.instance.removeModal(_loc2_);
         _loc2_.removeEventListener(ModalDialogue.MAKE_CHOICE,this.closeOptionsHandler);
         if(!Main.currentGame.matchDetails.gameBreak)
         {
            addEventListener(Event.ENTER_FRAME,this.efHandler);
         }
      }
      
      override public function cleanUp() : void
      {
         super.cleanUp();
         if(hasEventListener(Event.ENTER_FRAME))
         {
            removeEventListener(Event.ENTER_FRAME,this.efHandler);
         }
         BudgetEventProxy.removeEventListener(MatchEngine.MATCH_EVENT,this.matchEventHandler);
      }
      
      private function matchEventHandler(param1:Object) : void
      {
         var _loc3_:MatchDetails = null;
         var _loc4_:MatchMessage = null;
         var _loc2_:Settings = Main.instance.settings;
         _loc3_ = Main.currentGame.matchDetails;
         switch(param1.event)
         {
            case MatchEngine.HALF_TIME:
               if(_loc2_.matchEvents[MatchEngine.HALF_TIME])
               {
                  removeEventListener(Event.ENTER_FRAME,this.efHandler);
                  this.actionsButton.setText(CopyManager.getCopy("beginNextHalf"));
                  this.actionsButton.visible = true;
                  break;
               }
               MatchEngine.startMatch(Main.currentGame);
               if(!hasEventListener(Event.ENTER_FRAME))
               {
                  addEventListener(Event.ENTER_FRAME,this.efHandler);
               }
               break;
            case MatchEngine.FULL_TIME:
               removeEventListener(Event.ENTER_FRAME,this.efHandler);
               this.actionsButton.visible = true;
               this.makeChangeButton.visible = this.matchOptionsButton.visible = false;
               if(_loc3_.match.needsWinner && _loc3_.team0.getGoals() == _loc3_.team1.getGoals())
               {
                  this.actionsButton.setText(CopyManager.getCopy("doPenalties"));
                  _loc3_.gameBreak = MatchEngine.PENALTIES;
                  _loc4_ = new MatchMessage(MatchHelper.getMatchCopy(CopyManager.NOW_PENALTIES));
                  _loc3_.messages.push(_loc4_);
                  BudgetEventProxy.dispatchEvent(Game.DATA_CHANGED,null);
                  break;
               }
               this.actionsButton.setText(CopyManager.getCopy("continue"));
               break;
            case MatchEngine.BEFORE_GAME:
               removeEventListener(Event.ENTER_FRAME,this.efHandler);
               this.actionsButton.setText(CopyManager.getCopy("startMatch"));
               this.actionsButton.visible = true;
               break;
            case MatchEngine.GOAL:
               if(_loc2_.matchEvents[MatchEngine.GOAL])
               {
                  removeEventListener(Event.ENTER_FRAME,this.efHandler);
                  this.actionsButton.setText(CopyManager.getCopy("restartMatch"));
                  this.actionsButton.visible = true;
                  break;
               }
               MatchEngine.restartMatchGoal();
               if(!hasEventListener(Event.ENTER_FRAME))
               {
                  addEventListener(Event.ENTER_FRAME,this.efHandler);
               }
               break;
            case MatchEvent.INJURY:
               if(_loc2_.matchEvents[MatchEngine.INJURY])
               {
                  removeEventListener(Event.ENTER_FRAME,this.efHandler);
                  this.actionsButton.setText(CopyManager.getCopy("restartMatch"));
                  this.actionsButton.visible = true;
                  _loc3_.gameBreak = MatchEngine.INJURY;
                  break;
               }
               _loc3_.gameBreak = "";
               break;
            case MatchEngine.RED_CARD:
               if(_loc2_.matchEvents[MatchEngine.RED_CARD])
               {
                  removeEventListener(Event.ENTER_FRAME,this.efHandler);
                  this.actionsButton.setText(CopyManager.getCopy("restartMatch"));
                  this.actionsButton.visible = true;
                  break;
               }
               _loc3_.gameBreak = "";
               break;
            case MatchEngine.YELLOW_CARD:
               if(_loc2_.matchEvents[MatchEngine.YELLOW_CARD])
               {
                  removeEventListener(Event.ENTER_FRAME,this.efHandler);
                  this.actionsButton.setText(CopyManager.getCopy("restartMatch"));
                  this.actionsButton.visible = true;
                  break;
               }
               _loc3_.gameBreak = "";
               break;
            case MatchEngine.SUBSTITUTION:
               if(_loc2_.matchEvents[MatchEngine.SUBSTITUTION])
               {
                  removeEventListener(Event.ENTER_FRAME,this.efHandler);
                  this.actionsButton.setText(CopyManager.getCopy("restartMatch"));
                  this.actionsButton.visible = true;
                  break;
               }
               _loc3_.gameBreak = "";
               break;
            default:
               this.actionsButton.setText(CopyManager.getCopy("restartMatch"));
               this.actionsButton.visible = true;
         }
      }
      
      private function efHandler(param1:Event) : void
      {
         MatchEngine.processMatch(Main.currentGame);
      }
   }
}

