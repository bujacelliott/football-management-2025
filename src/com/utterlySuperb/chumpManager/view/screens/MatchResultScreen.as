package com.utterlySuperb.chumpManager.view.screens
{
   import com.utterlySuperb.chumpManager.engine.GameEngine;
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.Player;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.MatchDetails;
   import com.utterlySuperb.chumpManager.view.panels.matchPanels.MatchPlayerReviewPanel;
   import com.utterlySuperb.chumpManager.view.panels.matchPanels.MatchScorePanel;
   import com.utterlySuperb.chumpManager.view.panels.matchPanels.MatchTeamResultPanel;
   import com.utterlySuperb.chumpManager.view.ui.buttons.ChumpButton;
   import com.utterlySuperb.chumpManager.view.ui.buttons.MediumButton;
   import com.utterlySuperb.chumpManager.view.ui.buttons.listButtons.PlayerResultListButton;
   import com.utterlySuperb.events.IntEvent;
   import com.utterlySuperb.ui.ListBox;
   import flash.events.Event;
   
   public class MatchResultScreen extends Screen
   {
      
      private var playerResults:MatchPlayerReviewPanel;
      
      private var teamPanel0:MatchTeamResultPanel;
      
      private var teamPanel1:MatchTeamResultPanel;
      
      public function MatchResultScreen()
      {
         super();
         var _loc1_:MatchScorePanel = new MatchScorePanel();
         _loc1_.x = Globals.MARGIN_X;
         _loc1_.y = Globals.HEADER_OFFSET;
         addChild(_loc1_);
         GameEngine.storePlayerMatch(Main.currentGame);
         var _loc2_:MatchDetails = Main.currentGame.matchDetails;
         var _loc3_:Array = new Array();
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.team0.squad.length)
         {
            if(_loc2_.team0.squad[_loc4_].timeCameOut.length > 0)
            {
               _loc3_.push(_loc2_.team0.squad[_loc4_]);
            }
            _loc4_++;
         }
         this.teamPanel0 = new MatchTeamResultPanel();
         addChild(this.teamPanel0);
         this.teamPanel0.setTeam(_loc3_);
         this.teamPanel0.x = 20;
         this.teamPanel0.y = Globals.HEADER_OFFSET + 120;
         this.teamPanel0.addEventListener(ListBox.OVER_ITEM,this.overPlayerHandler);
         this.teamPanel0.addEventListener(ListBox.OUT_ITEM,this.outPlayerHandler);
         _loc3_ = new Array();
         _loc4_ = 0;
         while(_loc4_ < _loc2_.team1.squad.length)
         {
            if(_loc2_.team1.squad[_loc4_].timeCameOut.length > 0)
            {
               _loc3_.push(_loc2_.team1.squad[_loc4_]);
            }
            _loc4_++;
         }
         this.teamPanel1 = new MatchTeamResultPanel();
         addChild(this.teamPanel1);
         this.teamPanel1.setTeam(_loc3_);
         this.teamPanel1.x = Globals.GAME_WIDTH - 300;
         this.teamPanel1.y = this.teamPanel0.y;
         this.teamPanel1.addEventListener(ListBox.OVER_ITEM,this.overPlayerHandler);
         this.teamPanel1.addEventListener(ListBox.OUT_ITEM,this.outPlayerHandler);
         this.playerResults = new MatchPlayerReviewPanel();
         this.playerResults.x = this.teamPanel0.x + this.teamPanel0.boxWidth + 10;
         this.playerResults.y = this.teamPanel0.y;
         addChild(this.playerResults);
         var _loc5_:ChumpButton = new MediumButton(CopyManager.getCopy("continue"));
         _loc5_.x = (Globals.GAME_WIDTH - 120) / 2;
         _loc5_.y = Globals.GAME_HEIGHT - (Globals.MARGIN_Y + 50);
         addMadeButton(_loc5_);
         enabled = true;
      }
      
      private function outPlayerHandler(param1:Event) : void
      {
         this.playerResults.showMatch();
      }
      
      private function overPlayerHandler(param1:IntEvent) : void
      {
         var _loc2_:Player = PlayerResultListButton(ListBox(param1.target).getButtonAt(param1.num)).player;
         this.playerResults.setPlayer(Main.currentGame.matchDetails.getPlayerDetails(_loc2_));
      }
      
      override protected function clickButtonHandler(param1:Event) : void
      {
         Main.instance.showScreen(Screen.ROUND_RESULTS_SCREEN);
      }
      
      override public function cleanUp() : void
      {
         super.cleanUp();
         this.teamPanel0.removeEventListener(ListBox.OVER_ITEM,this.overPlayerHandler);
         this.teamPanel0.removeEventListener(ListBox.OUT_ITEM,this.outPlayerHandler);
         this.teamPanel1.removeEventListener(ListBox.OVER_ITEM,this.overPlayerHandler);
         this.teamPanel1.removeEventListener(ListBox.OUT_ITEM,this.outPlayerHandler);
      }
   }
}

