package com.utterlySuperb.chumpManager.view.screens
{
   import com.utterlySuperb.chumpManager.events.PlayerEvent;
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.StaticInfo;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.Match;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.MatchDetails;
   import com.utterlySuperb.chumpManager.view.panels.ShowFormationPanel;
   import com.utterlySuperb.chumpManager.view.ui.buttons.ChumpButton;
   import com.utterlySuperb.chumpManager.view.ui.widgets.PrematchStatDisplay;
   import flash.events.Event;
   import flash.filters.GlowFilter;
   
   public class PreMatchScreen extends Screen
   {
      
      private var yourFormationPanel:ShowFormationPanel;
      
      private var opponentFormationPanel:ShowFormationPanel;
      
      private var statDisplay:PrematchStatDisplay;
      
      public var setFormationButton:ChumpButton;
      
      public var startGameButtons:ChumpButton;
      
      public function PreMatchScreen()
      {
         var _loc1_:MatchDetails = null;
         var _loc2_:Match = null;
         var _loc3_:int = 0;
         super();
         makeBackButton();
         addStatus();
         if(!Main.currentGame.matchDetails)
         {
            _loc2_ = Main.currentGame.nextPlayerMatch;
            _loc1_ = new MatchDetails();
            Main.currentGame.matchDetails = _loc1_;
            _loc1_.match = _loc2_;
            _loc2_.beenPlayed = true;
            _loc1_.setFormations(_loc2_);
            _loc3_ = 0;
            while(_loc3_ < _loc2_.club0.club.players.length)
            {
               StaticInfo.getPlayer(_loc2_.club0.club.players[_loc3_]).form = StaticInfo.getPlayer(_loc2_.club0.club.players[_loc3_]).form + (10 + Math.random() * 10);
               _loc3_++;
            }
         }
         else
         {
            _loc1_ = Main.currentGame.matchDetails;
            _loc2_ = _loc1_.match;
         }
         this.yourFormationPanel = new ShowFormationPanel();
         this.yourFormationPanel.x = Globals.MARGIN_X;
         this.yourFormationPanel.y = Globals.belowStatus;
         addChild(this.yourFormationPanel);
         this.yourFormationPanel.setFormation(_loc1_.team0.formation,_loc2_.club0.club.name);
         this.yourFormationPanel.addEventListener(ShowFormationPanel.OVER_PLAYER,this.overPlayer);
         this.opponentFormationPanel = new ShowFormationPanel();
         this.opponentFormationPanel.x = Globals.GAME_WIDTH - Globals.MARGIN_X - 300;
         this.opponentFormationPanel.y = Globals.belowStatus;
         addChild(this.opponentFormationPanel);
         this.opponentFormationPanel.setFormation(_loc1_.team1.formation,_loc2_.club1.club.name);
         this.opponentFormationPanel.addEventListener(ShowFormationPanel.OVER_PLAYER,this.overPlayer);
         this.statDisplay = new PrematchStatDisplay();
         addChild(this.statDisplay);
         this.statDisplay.x = 300 + 2 * Globals.MARGIN_X;
         this.statDisplay.y = Globals.belowStatus;
         this.statDisplay.setPlayer(null);
         this.statDisplay.filters = [new GlowFilter(0,1,2,2,3,2)];
         this.setFormationButton = addButton(CopyManager.getCopy("tactics"),ChumpButton.SMALL_BUTTON,330,Globals.GAME_HEIGHT - Globals.MARGIN_Y - 70);
         this.setFormationButton.x = int(Globals.GAME_WIDTH - this.setFormationButton.bWidth) / 2;
         this.startGameButtons = addButton(CopyManager.getCopy("gotoMatch"),ChumpButton.SMALL_BUTTON,330,Globals.GAME_HEIGHT - Globals.MARGIN_Y - 30);
         this.startGameButtons.x = int(Globals.GAME_WIDTH - this.startGameButtons.bWidth) / 2;
         enabled = true;
      }
      
      private function overPlayer(param1:PlayerEvent) : void
      {
         this.statDisplay.setPlayer(param1.player);
      }
      
      override protected function clickButtonHandler(param1:Event) : void
      {
         if(param1.target == this.setFormationButton)
         {
            Main.instance.showScreen(Screen.PRE_MATCH_FORMATION);
         }
         else if(param1.target == this.startGameButtons)
         {
            Main.instance.showScreen(Screen.MATCH_SCREEN);
         }
      }
      
      override public function cleanUp() : void
      {
         super.cleanUp();
         this.yourFormationPanel.removeEventListener(ShowFormationPanel.OVER_PLAYER,this.overPlayer);
         this.opponentFormationPanel.removeEventListener(ShowFormationPanel.OVER_PLAYER,this.overPlayer);
      }
   }
}

