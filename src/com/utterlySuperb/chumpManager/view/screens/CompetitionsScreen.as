package com.utterlySuperb.chumpManager.view.screens
{
import com.utterlySuperb.chumpManager.model.dataObjects.competitions.League;
import com.utterlySuperb.chumpManager.view.panels.LeagueTablePanel;
   import com.utterlySuperb.chumpManager.view.panels.TopScorersPanel;
   import com.utterlySuperb.chumpManager.view.ui.buttons.SmallButton;
   import com.utterlySuperb.text.TextHelper;
   import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class CompetitionsScreen extends Screen
   {
      
      private var leaguePanel:LeagueTablePanel;
      
      private var scorersPanel:TopScorersPanel;
      
      private var leagues:Array;
      
      private var leagueIndex:int = 0;
      
      private var leagueLeft:Sprite;
      
      private var leagueRight:Sprite;
      
      private var statsLeft:Sprite;
      
      private var statsRight:Sprite;
      
      private var backButton:SmallButton;
      
      public function CompetitionsScreen()
      {
         super();
         this.leagues = [];
         var _loc0_:int = 0;
         while(_loc0_ < Main.currentGame.leagues.length)
         {
            if(Main.currentGame.leagues[_loc0_])
            {
               this.leagues.push(Main.currentGame.leagues[_loc0_]);
            }
            _loc0_++;
         }
         this.leagueIndex = Math.max(0,Math.min(this.leagues.length - 1,Main.currentGame.mainLeagueNum));
         var _loc1_:TextField = new TextField();
         TextHelper.doTextField2(_loc1_,Styles.HEADER_FONT,22,16777215);
         _loc1_.text = "Competitions";
         _loc1_.x = Globals.MARGIN_X;
         _loc1_.y = Globals.MARGIN_Y;
         addChild(_loc1_);
         this.backButton = new SmallButton("Back",80,30);
         this.backButton.x = Globals.GAME_WIDTH - this.backButton.bWidth - Globals.MARGIN_X;
         this.backButton.y = Globals.MARGIN_Y;
         addMadeButton(this.backButton);
         this.leaguePanel = new LeagueTablePanel();
         this.leaguePanel.x = Globals.MARGIN_X;
         this.leaguePanel.y = Globals.HEADER_OFFSET + 40;
         this.leaguePanel.aHeight = 420;
         addChild(this.leaguePanel);
         this.scorersPanel = new TopScorersPanel();
         this.scorersPanel.x = Globals.GAME_WIDTH - TopScorersPanel.BOX_WIDTH - Globals.MARGIN_X;
         this.scorersPanel.y = this.leaguePanel.y;
         addChild(this.scorersPanel);
         this.leagueLeft = this.makeArrow(true);
         this.leagueRight = this.makeArrow(false);
         this.leagueLeft.x = this.leaguePanel.x + 10;
         this.leagueLeft.y = this.leaguePanel.y + 10;
         this.leagueRight.x = this.leaguePanel.x + this.leaguePanel.boxWidth - 20;
         this.leagueRight.y = this.leaguePanel.y + 10;
         addChild(this.leagueLeft);
         addChild(this.leagueRight);
         this.leagueLeft.addEventListener(MouseEvent.CLICK,this.prevLeague);
         this.leagueRight.addEventListener(MouseEvent.CLICK,this.nextLeague);
         this.statsLeft = this.makeArrow(true);
         this.statsRight = this.makeArrow(false);
         this.statsLeft.x = this.scorersPanel.x + 10;
         this.statsLeft.y = this.scorersPanel.y + 10;
         this.statsRight.x = this.scorersPanel.x + TopScorersPanel.BOX_WIDTH - 20;
         this.statsRight.y = this.scorersPanel.y + 10;
         addChild(this.statsLeft);
         addChild(this.statsRight);
         this.statsLeft.addEventListener(MouseEvent.CLICK,this.toggleStats);
         this.statsRight.addEventListener(MouseEvent.CLICK,this.toggleStats);
         this.refreshLeague();
         enabled = true;
      }
      
      override protected function clickButtonHandler(param1:Event) : void
      {
         if(param1.target == this.backButton)
         {
            Main.instance.showScreen(Screen.OFFICE_SCREEN);
         }
      }
      
      private function prevLeague(param1:Event) : void
      {
         if(!this.leagues || this.leagues.length == 0)
         {
            return;
         }
         this.leagueIndex = (this.leagueIndex - 1 + this.leagues.length) % this.leagues.length;
         this.refreshLeague();
      }
      
      private function nextLeague(param1:Event) : void
      {
         if(!this.leagues || this.leagues.length == 0)
         {
            return;
         }
         this.leagueIndex = (this.leagueIndex + 1) % this.leagues.length;
         this.refreshLeague();
      }
      
      private function refreshLeague() : void
      {
         var _loc1_:League = this.leagues[this.leagueIndex];
         this.leaguePanel.setLeague(_loc1_);
         this.scorersPanel.setLeague(_loc1_);
      }
      
      private function toggleStats(param1:Event) : void
      {
         var _loc2_:int = this.scorersPanel.getMode() == TopScorersPanel.MODE_GOALS ? TopScorersPanel.MODE_ASSISTS : TopScorersPanel.MODE_GOALS;
         this.scorersPanel.setMode(_loc2_);
      }
      
      private function makeArrow(param1:Boolean) : Sprite
      {
         var _loc2_:Sprite = new Sprite();
         _loc2_.graphics.beginFill(16777215);
         if(param1)
         {
            _loc2_.graphics.moveTo(12,0);
            _loc2_.graphics.lineTo(0,10);
            _loc2_.graphics.lineTo(12,20);
         }
         else
         {
            _loc2_.graphics.moveTo(0,0);
            _loc2_.graphics.lineTo(12,10);
            _loc2_.graphics.lineTo(0,20);
         }
         _loc2_.graphics.endFill();
         _loc2_.buttonMode = true;
         _loc2_.mouseChildren = false;
         return _loc2_;
      }
   }
}
