package com.utterlySuperb.chumpManager.view.panels
{
   import com.utterlySuperb.chumpManager.engine.MatchHelper;
   import com.utterlySuperb.chumpManager.engine.TeamHelper;
   import com.utterlySuperb.chumpManager.events.PlayerEvent;
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.Club;
   import com.utterlySuperb.chumpManager.model.dataObjects.Formation;
   import com.utterlySuperb.chumpManager.model.dataObjects.Player;
   import com.utterlySuperb.chumpManager.model.dataObjects.StaticInfo;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.MatchDetails;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.MatchPlayerDetails;
   import com.utterlySuperb.chumpManager.view.modals.TacticsModal;
   import com.utterlySuperb.chumpManager.view.screens.Screen;
   import com.utterlySuperb.chumpManager.view.ui.ChumpListBox;
   import com.utterlySuperb.chumpManager.view.ui.buttons.ChumpButton;
   import com.utterlySuperb.chumpManager.view.ui.buttons.listButtons.PlayerListButton;
   import com.utterlySuperb.chumpManager.view.ui.buttons.listButtons.PlayerListFormationButton;
   import com.utterlySuperb.chumpManager.view.ui.widgets.FormationDiagram;
   import com.utterlySuperb.chumpManager.view.ui.widgets.PlayerStatsDisplay;
   import com.utterlySuperb.chumpManager.view.ui.widgets.Slider;
   import com.utterlySuperb.events.IntEvent;
   import com.utterlySuperb.ui.ListBox;
   import com.utterlySuperb.ui.ModalDialogue;
   import com.utterlySuperb.ui.dropDown.DropDown;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class SetFormationPanel extends Panel
   {
      
      public static const NON_MATCH:String = "nonMatch";
      
      public static const PRE_MATCH:String = "preMatch";
      
      public static const IN_MATCH:String = "inMatch";
      
      private var panel0:BGPanel;
      
      private var panel1:BGPanel;
      
      private var formationDiagram:FormationDiagram;
      
      private var playerBox:ChumpListBox;
      
      private var subsBox:ChumpListBox;
      
      private var playerDisplay:PlayerStatsDisplay;
      
      private var otherPlayerDisplay:PlayerStatsDisplay;
      
      private var usedTeamPlayerSelected:Player;
      
      private var teamPlayerSelected:Player;
      
      private var selectedPlayer:Player;
      
      private var overPlayer:Player;
      
      private var usedPlayers:Array;
      
      private var okButton:ChumpButton;
      
      private var undoButton:ChumpButton;
      
      private var autoFillButton:ChumpButton;
      
      private var doneButton:ChumpButton;
      
      private var optionsButton:ChumpButton;
      
      private var selectedBox:ListBox;
      
      public var state:String;
      
      private var clubFormation:Formation;
      
      private var club:Club;
      
      private var tempPlayers:Array;
      
      private var tempSquad:Array;
      
      private var attackingScore:int;
      
      private var numSubs:int;
      
      private var tacticsDropDown:DropDown;
      
      private var attackingSlider:Slider;
      
      public function SetFormationPanel()
      {
         super();
      }
      
      override protected function init() : void
      {
         var _loc6_:PlayerListFormationButton = null;
         var _loc1_:int = 370;
         this.panel0 = makeBox(_loc1_,Globals.usableHeight,20,0);
         this.panel0.addEventListener(MouseEvent.CLICK,this.clickPanelHandler);
         this.panel1 = makeBox(_loc1_,Globals.usableHeight,410,0);
         this.panel1.addEventListener(MouseEvent.CLICK,this.clickPanelHandler);
         this.club = Main.currentGame.playerClub;
         if(this.state == PRE_MATCH || this.state == IN_MATCH)
         {
            this.clubFormation = Main.currentGame.matchDetails.playerTeam.formation.clone();
         }
         else
         {
            this.clubFormation = Main.currentGame.playerFormation.clone();
         }
         this.attackingScore = this.clubFormation.attackingScore;
         if(this.state == IN_MATCH)
         {
            this.tempPlayers = Main.currentGame.matchDetails.playerTeam.players.slice();
            this.tempSquad = Main.currentGame.matchDetails.playerTeam.squad.slice();
            this.numSubs = Main.currentGame.matchDetails.playerTeam.subs.length;
         }
         this.clubFormation.setPositions();
         if(this.clubFormation.prefferedPlayersID.length == 0)
         {
            this.usedPlayers = TeamHelper.getBestPlayers(this.clubFormation,this.club.getPlayersList(),this.state != NON_MATCH);
            this.clubFormation.setPrefferedPlayers(this.usedPlayers.slice());
            Main.currentGame.playerFormation = this.clubFormation.clone();
         }
         else
         {
            this.usedPlayers = this.clubFormation.getPrefferedPlayers();
         }
         this.formationDiagram = new FormationDiagram();
         addChild(this.formationDiagram);
         this.formationDiagram.isMovable = true;
         this.formationDiagram.setFormation(this.clubFormation);
         this.formationDiagram.addEventListener(FormationDiagram.OVER_PLAYER,this.overDiagramPlayerHandler);
         this.formationDiagram.addEventListener(FormationDiagram.CLICK_PLAYER,this.clickDiagramPlayerHandler);
         this.formationDiagram.addEventListener(FormationDiagram.CLICK_BG,this.clickPanelHandler);
         this.formationDiagram.x = 40;
         this.formationDiagram.y = 20;
         var _loc2_:int = this.state == IN_MATCH ? 120 : 160;
         this.playerBox = new ChumpListBox(_loc1_ - 55,_loc2_);
         this.playerBox.drawFrame();
         addChild(this.playerBox);
         this.playerBox.x = 430;
         this.playerBox.y = this.state == IN_MATCH ? 50 : 20;
         this.playerBox.addEventListener(ListBox.CLICK_PRESS,this.pressPlayerHandler);
         this.playerBox.addEventListener(ListBox.OVER_ITEM,this.overPlayerHander);
         var _loc3_:int = this.state == IN_MATCH ? Main.currentGame.matchDetails.playerTeam.squad.length - 11 : int(this.club.players.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc6_ = new PlayerListFormationButton();
            _loc6_.bWidth = _loc1_ - 55;
            _loc6_.panelState = this.state;
            _loc6_.setBG(_loc4_ % 2 == 0);
            this.playerBox.addItem(_loc6_);
            _loc4_++;
         }
         _loc2_ = this.state == IN_MATCH ? 210 : int(Globals.usableHeight - this.formationDiagram.height - 110);
         this.subsBox = new ChumpListBox(_loc1_ - 55,_loc2_);
         this.subsBox.drawFrame();
         addChild(this.subsBox);
         this.subsBox.x = 40;
         this.subsBox.y = this.state == IN_MATCH ? this.formationDiagram.height + 40 : this.formationDiagram.height + 50;
         this.subsBox.addEventListener(ListBox.CLICK_PRESS,this.pressSubsHandler);
         this.subsBox.addEventListener(ListBox.OVER_ITEM,this.overSubsHander);
         _loc3_ = this.state == IN_MATCH ? 11 : 18;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc6_ = new PlayerListFormationButton();
            _loc6_.setBG(_loc4_ % 2 == 0);
            _loc6_.panelState = this.state;
            _loc6_.bWidth = _loc1_ - 55;
            this.subsBox.addItem(_loc6_);
            if(_loc4_ < 11)
            {
               _loc6_.setInTeam();
            }
            else
            {
               _loc6_.setInSubs();
            }
            _loc4_++;
         }
         var _loc5_:Object = Styles.getDropdownObject(130);
         _loc5_.prompt = CopyManager.getCopy("formation");
         this.tacticsDropDown = new DropDown(_loc5_);
         this.tacticsDropDown.easyMake();
         _loc4_ = 0;
         while(_loc4_ < Formation.FORMATIONS.length)
         {
            this.tacticsDropDown.addItem(Formation.FORMATIONS[_loc4_]);
            _loc4_++;
         }
         this.tacticsDropDown.x = 40;
         this.tacticsDropDown.y = this.subsBox.y - 25;
         addChild(this.tacticsDropDown);
         this.tacticsDropDown.addEventListener(DropDown.DROP_DOWN_CLICK,this.setFormationHandler);
         this.tacticsDropDown.enable();
         this.attackingSlider = new Slider();
         this.attackingSlider.setSize(0,10,80);
         this.attackingSlider.x = 185;
         this.attackingSlider.y = this.tacticsDropDown.y - 15;
         this.attackingSlider.amountsCopy = [CopyManager.getCopy("veryDefensive"),CopyManager.getCopy("defensive"),CopyManager.getCopy("balanced"),CopyManager.getCopy("attacking"),CopyManager.getCopy("veryAttacking")];
         addChild(this.attackingSlider);
         this.attackingSlider.setFilters(this.attackingScore);
         this.attackingSlider.activate();
         this.playerDisplay = new PlayerStatsDisplay();
         this.playerDisplay.x = 430;
         this.playerDisplay.y = this.playerBox.y + this.playerBox.height + 10;
         this.playerDisplay.addEventListener(MouseEvent.CLICK,this.clickPanelHandler);
         addChild(this.playerDisplay);
         this.otherPlayerDisplay = new PlayerStatsDisplay();
         this.otherPlayerDisplay.x = 620;
         this.otherPlayerDisplay.y = this.playerDisplay.y;
         this.otherPlayerDisplay.addEventListener(MouseEvent.CLICK,this.clickPanelHandler);
         addChild(this.otherPlayerDisplay);
         switch(this.state)
         {
            case PRE_MATCH:
               this.setPrematch();
               break;
            case IN_MATCH:
               this.setDuringMatch();
               break;
            case NON_MATCH:
               this.setDefault();
         }
         enable();
         this.update(null);
      }
      
      private function clickPanelHandler(param1:Event) : void
      {
         this.deselectPlayers();
      }
      
      public function setPrematch() : void
      {
         this.undoButton = addTextButton(CopyManager.getCopy("undoChanges"),40,this.subsBox.y + this.subsBox.height + 10);
         this.autoFillButton = addTextButton(CopyManager.getCopy("autofill"),this.undoButton.x + this.undoButton.width + 30,this.undoButton.y);
         this.doneButton = addTextButton(CopyManager.getCopy("done"),this.autoFillButton.x + this.autoFillButton.width + 30,this.undoButton.y);
         this.playerDisplay.makePreMatch();
         this.otherPlayerDisplay.makePreMatch();
      }
      
      public function setDuringMatch() : void
      {
         this.undoButton = addTextButton(CopyManager.getCopy("undoChanges"),430,15);
         this.doneButton = addTextButton(CopyManager.getCopy("done"),this.undoButton.x + this.undoButton.width + 30,15);
         this.playerDisplay.makeForMatch();
         this.otherPlayerDisplay.makeForMatch();
      }
      
      public function setDefault() : void
      {
         this.undoButton = addTextButton(CopyManager.getCopy("undoChanges"),40,this.subsBox.y + this.subsBox.height + 10);
         this.autoFillButton = addTextButton(CopyManager.getCopy("autofill"),this.undoButton.x + this.undoButton.width + 30,this.undoButton.y);
         this.doneButton = addTextButton(CopyManager.getCopy("done"),this.autoFillButton.x + this.autoFillButton.width + 30,this.undoButton.y);
      }
      
      public function deselectPlayers() : void
      {
         this.selectPlayer(null);
      }
      
      override protected function clickButtonHandler(param1:Event) : void
      {
         var _loc2_:Formation = null;
         var _loc3_:String = null;
         var _loc4_:TacticsModal = null;
         switch(param1.target)
         {
            case this.undoButton:
               this.reset();
               this.update(null);
               if(this.state == IN_MATCH)
               {
                  this.numSubs = Main.currentGame.matchDetails.playerTeam.subs.length;
               }
               break;
            case this.okButton:
               break;
            case this.autoFillButton:
               _loc2_ = this.formationDiagram.getFormation();
               _loc2_.setPositions();
               this.usedPlayers = TeamHelper.getBestPlayers(_loc2_,this.club.getPlayersList(),this.state != NON_MATCH);
               this.update(null);
               break;
            case this.doneButton:
               this.saveFormation();
               _loc3_ = Main.instance.backOverride;
               if(_loc3_)
               {
                  Main.instance.showScreen(_loc3_);
                  break;
               }
               Main.instance.showScreen(Screen.MAIN_SCREEN);
               break;
            case this.optionsButton:
               _loc4_ = new TacticsModal();
               Main.instance.addModal(_loc4_);
               _loc4_.addEventListener(ModalDialogue.MAKE_CHOICE,this.closeTacticsModalHandler);
               _loc4_.addEventListener(TacticsModal.CHANGE_FORMATION,this.changeFormationHandler);
               _loc4_.attackingScore = this.attackingScore;
         }
      }
      
      private function closeTacticsModalHandler(param1:Event) : void
      {
         var _loc2_:TacticsModal = TacticsModal(param1.target);
         Main.instance.removeModal(_loc2_);
         this.attackingScore = _loc2_.attackingScore;
         _loc2_.removeEventListener(TacticsModal.CHANGE_FORMATION,this.changeFormationHandler);
         _loc2_.removeEventListener(ModalDialogue.MAKE_CHOICE,this.closeTacticsModalHandler);
      }
      
      private function changeFormationHandler(param1:IntEvent) : void
      {
         this.clubFormation.setStandardFormation(Formation.FORMATIONS[param1.num]);
         this.formationDiagram.setFormation(this.clubFormation);
      }
      
      private function setFormationHandler(param1:Event) : void
      {
         if(this.tacticsDropDown.selectedNum < 0)
         {
            return;
         }
         this.clubFormation.setStandardFormation(Formation.FORMATIONS[this.tacticsDropDown.selectedNum]);
         this.formationDiagram.setFormation(this.clubFormation);
         this.tacticsDropDown.selectedNum = -1;
      }
      
      private function saveFormation() : void
      {
         var _loc1_:Formation = this.formationDiagram.getFormation();
         _loc1_.attackingScore = this.attackingSlider.amount;
         _loc1_.setPrefferedPlayers(this.usedPlayers.slice());
         _loc1_.setPositions();
         switch(this.state)
         {
            case NON_MATCH:
               Main.currentGame.playerFormation = _loc1_;
               break;
            case PRE_MATCH:
               Main.currentGame.matchDetails.setPlayerFormation(_loc1_);
               break;
            case IN_MATCH:
               Main.currentGame.matchDetails.adjustFormation(_loc1_,this.tempPlayers);
         }
      }
      
      private function overDiagramPlayerHandler(param1:PlayerEvent) : void
      {
         this.showPlayer(param1.player);
      }
      
      private function clickDiagramPlayerHandler(param1:PlayerEvent) : void
      {
         this.selectPlayer(param1.player);
      }
      
      private function reset() : void
      {
         this.usedPlayers = this.clubFormation.getPrefferedPlayers();
         this.formationDiagram.setFormation(this.clubFormation);
         if(this.state == IN_MATCH)
         {
            this.tempPlayers = Main.currentGame.matchDetails.playerTeam.players.slice();
            this.tempSquad = Main.currentGame.matchDetails.playerTeam.squad.slice();
            this.numSubs = Main.currentGame.matchDetails.playerTeam.subs.length;
         }
      }
      
      override protected function update(param1:Object = null) : void
      {
         var _loc3_:MatchDetails = null;
         var _loc4_:Array = null;
         var _loc5_:PlayerListButton = null;
         var _loc6_:int = 0;
         var _loc7_:Player = null;
         var _loc2_:Club = Main.currentGame.playerClub;
         if(this.state == IN_MATCH)
         {
            _loc3_ = Main.currentGame.matchDetails;
            _loc6_ = 0;
            while(_loc6_ < this.tempPlayers.length)
            {
               _loc5_ = PlayerListButton(this.subsBox.getButtonAt(_loc6_));
               _loc5_.setInTeam();
               _loc5_.setPlayer(this.tempPlayers[_loc6_].player);
               _loc6_++;
            }
            _loc4_ = MatchHelper.getSubs(this.tempSquad,this.tempPlayers);
            _loc6_ = 0;
            while(_loc6_ < _loc4_.length)
            {
               _loc5_ = PlayerListButton(this.playerBox.getButtonAt(_loc6_));
               _loc5_.setPlayer(_loc4_[_loc6_]);
               if(!_loc3_.playerTeam.playerHasPlayed(_loc4_[_loc6_]))
               {
                  _loc5_.setInSubs();
               }
               else
               {
                  _loc5_.setUnavailable();
               }
               _loc6_++;
            }
         }
         else
         {
            _loc6_ = 0;
            while(_loc6_ < _loc2_.players.length)
            {
               _loc7_ = StaticInfo.getPlayer(_loc2_.players[_loc6_]);
               PlayerListButton(this.playerBox.getButtonAt(_loc6_)).setPlayer(_loc7_);
               _loc6_++;
            }
            _loc6_ = 0;
            while(_loc6_ < this.usedPlayers.length)
            {
               PlayerListButton(this.subsBox.getButtonAt(_loc6_)).setPlayer(this.usedPlayers[_loc6_]);
               _loc6_++;
            }
            _loc4_ = this.usedPlayers.slice(11,this.usedPlayers.length);
            this.playerBox.setInSubs(_loc4_);
            this.subsBox.setInSubs(_loc4_);
         }
         this.subsBox.enable();
         this.playerBox.enable();
         this.playerBox.setInTeamPlayers(this.usedPlayers.slice(0,11));
         this.formationDiagram.setPlayers(this.usedPlayers);
      }
      
      private function pressPlayerHandler(param1:IntEvent) : void
      {
         var _loc2_:Player = PlayerListButton(this.playerBox.getButtonAt(param1.num)).player;
         if(this.state == IN_MATCH && Main.currentGame.matchDetails.playerTeam.playerHasPlayed(_loc2_))
         {
            return;
         }
         if(this.selectedBox == this.playerBox)
         {
         }
         if(!this.trySwitch(_loc2_))
         {
            this.selectPlayer(_loc2_);
         }
         this.selectedBox = this.playerBox;
      }
      
      private function pressSubsHandler(param1:IntEvent) : void
      {
         var _loc2_:Player = PlayerListButton(this.subsBox.getButtonAt(param1.num)).player;
         if(this.selectedBox == this.subsBox)
         {
         }
         if(!this.trySwitch(_loc2_))
         {
            this.selectPlayer(_loc2_);
         }
         this.selectedBox = this.subsBox;
      }
      
      private function overPlayerHander(param1:IntEvent) : void
      {
         this.showPlayer(PlayerListButton(this.playerBox.getButtonAt(param1.num)).player);
      }
      
      private function overSubsHander(param1:IntEvent) : void
      {
         this.showPlayer(PlayerListButton(this.subsBox.getButtonAt(param1.num)).player);
      }
      
      private function showPlayer(param1:Player) : void
      {
         this.overPlayer = param1;
         this.playerDisplay.setPlayer(param1);
      }
      
      private function trySwitch(param1:Player) : Boolean
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:MatchPlayerDetails = null;
         var _loc7_:MatchPlayerDetails = null;
         var _loc8_:int = 0;
         var _loc2_:Boolean = false;
         var _loc3_:MatchDetails = Main.currentGame.matchDetails;
         if(Boolean(this.selectedPlayer) && this.selectedPlayer != param1)
         {
            if(this.usedPlayers.indexOf(this.selectedPlayer) >= 0 || this.usedPlayers.indexOf(param1) >= 0)
            {
               _loc2_ = true;
               if(this.selectedPlayer.positions == "gk" || param1.positions == "gk")
               {
                  if(this.selectedPlayer.positions == "gk" && param1.positions != "gk" || this.selectedPlayer.positions != "gk" && param1.positions == "gk")
                  {
                     _loc2_ = false;
                  }
               }
               if(this.usedPlayers.indexOf(param1) > 10 && this.usedPlayers.indexOf(this.selectedPlayer) > 10)
               {
                  _loc2_ = false;
               }
               if(this.state == IN_MATCH)
               {
                  if(_loc3_.playerTeam.playerHasPlayed(param1) && _loc3_.playerTeam.playerHasPlayed(this.selectedPlayer))
                  {
                     _loc2_ = false;
                  }
                  if(_loc3_.getPlayerDetails(param1).redCards > 0 || _loc3_.getPlayerDetails(this.selectedPlayer).redCards > 0)
                  {
                     _loc2_ = false;
                  }
                  if(this.numSubs >= 5)
                  {
                     _loc2_ = false;
                  }
               }
               if(_loc2_)
               {
                  if(this.selectedBox == this.playerBox)
                  {
                  }
                  if(_loc4_ >= 0 || _loc5_ >= 0)
                  {
                     _loc4_ = int(this.usedPlayers.indexOf(this.selectedPlayer));
                     _loc5_ = int(this.usedPlayers.indexOf(param1));
                     if(this.state == IN_MATCH)
                     {
                        _loc6_ = _loc3_.getPlayerDetails(param1);
                        _loc7_ = _loc3_.getPlayerDetails(this.selectedPlayer);
                        if(!(this.tempPlayers.indexOf(_loc6_) >= 0 && this.tempPlayers.indexOf(_loc7_) >= 0))
                        {
                           ++this.numSubs;
                           if(this.tempPlayers.indexOf(_loc6_) >= 0)
                           {
                              _loc8_ = int(this.tempPlayers.indexOf(_loc6_));
                              this.tempPlayers[_loc8_] = _loc7_;
                              this.usedPlayers[_loc5_] = this.selectedPlayer;
                              this.usedPlayers[_loc4_] = param1;
                           }
                           else
                           {
                              _loc8_ = int(this.tempPlayers.indexOf(_loc7_));
                              this.tempPlayers[_loc8_] = _loc6_;
                              this.usedPlayers[_loc4_] = param1;
                              this.usedPlayers[_loc5_] = this.selectedPlayer;
                           }
                        }
                     }
                     else
                     {
                        if(_loc4_ >= 0)
                        {
                           this.usedPlayers[_loc4_] = param1;
                        }
                        if(_loc5_ >= 0)
                        {
                           this.usedPlayers[_loc5_] = this.selectedPlayer;
                        }
                     }
                  }
                  this.selectPlayer(null);
                  this.update();
               }
            }
         }
         return _loc2_;
      }
      
      private function selectPlayer(param1:Player) : void
      {
         this.selectedPlayer = param1;
         this.otherPlayerDisplay.setPlayer(param1);
         this.formationDiagram.setPlayerSelected(param1);
         this.playerBox.selectPlayer(param1);
         this.subsBox.selectPlayer(param1);
      }
      
      override protected function cleanUp() : void
      {
         removeAllButtons();
         this.formationDiagram.removeEventListener(FormationDiagram.OVER_PLAYER,this.overDiagramPlayerHandler);
         this.formationDiagram.removeEventListener(FormationDiagram.CLICK_PLAYER,this.clickDiagramPlayerHandler);
         this.formationDiagram.removeEventListener(FormationDiagram.CLICK_BG,this.clickPanelHandler);
         this.formationDiagram.cleanUp();
         this.panel0.removeEventListener(MouseEvent.CLICK,this.clickPanelHandler);
         this.panel1.removeEventListener(MouseEvent.CLICK,this.clickPanelHandler);
         this.playerDisplay.removeEventListener(MouseEvent.CLICK,this.clickPanelHandler);
         this.otherPlayerDisplay.removeEventListener(MouseEvent.CLICK,this.clickPanelHandler);
         this.tacticsDropDown.removeEventListener(DropDown.DROP_DOWN_CLICK,this.setFormationHandler);
         this.tacticsDropDown.disableButton();
         this.playerBox.removeEventListener(ListBox.CLICK_PRESS,this.pressPlayerHandler);
         this.playerBox.removeEventListener(ListBox.OVER_ITEM,this.overPlayerHander);
         this.playerBox.disable();
         this.subsBox.removeEventListener(ListBox.CLICK_PRESS,this.pressSubsHandler);
         this.subsBox.removeEventListener(ListBox.OVER_ITEM,this.overSubsHander);
         this.subsBox.disable();
         this.playerDisplay.removeEventListener(MouseEvent.CLICK,this.clickPanelHandler);
         this.otherPlayerDisplay.removeEventListener(MouseEvent.CLICK,this.clickPanelHandler);
      }
   }
}

