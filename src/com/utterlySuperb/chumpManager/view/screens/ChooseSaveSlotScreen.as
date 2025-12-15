package com.utterlySuperb.chumpManager.view.screens
{
   import com.utterlySuperb.chumpManager.engine.GameEngine;
   import com.utterlySuperb.chumpManager.engine.SavesManager;
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.Game;
   import com.utterlySuperb.chumpManager.view.modals.PleaseWaitModal;
   import com.utterlySuperb.chumpManager.view.ui.buttons.LoadGameButton;
   import com.utterlySuperb.events.BudgetEventProxy;
   import com.utterlySuperb.events.IntEvent;
   import com.utterlySuperb.text.TextHelper;
   import com.utterlySuperb.ui.ModalDialogue;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class ChooseSaveSlotScreen extends Screen
   {
      
      private var selectedSlot:int;
      
      private var pleaseWait:ModalDialogue;
      
      public function ChooseSaveSlotScreen()
      {
         var _loc3_:LoadGameButton = null;
         var _loc4_:int = 0;
         super();
         makeBackButton();
         Main.instance.backOverride = Screen.START_SCREEN;
         SavesManager.getSavedStates();
         var _loc1_:TextField = new TextField();
         TextHelper.doTextField2(_loc1_,Styles.HEADER_FONT,24,16777215);
         _loc1_.htmlText = CopyManager.getCopy("chooseSaveSlot");
         _loc1_.y = Globals.HEADER_OFFSET + 40;
         _loc1_.x = (Globals.GAME_WIDTH - _loc1_.textWidth) / 2;
         addChild(_loc1_);
         var _loc2_:int = 0;
         while(_loc2_ < 3)
         {
            _loc3_ = new LoadGameButton();
            _loc4_ = (Globals.GAME_WIDTH - 4 * Globals.MARGIN_X - 3 * _loc3_.width) / 2;
            _loc3_.setGame(SavesManager.games[_loc2_]);
            buttons.push(_loc3_);
            addChild(_loc3_);
            _loc3_.y = Globals.HEADER_OFFSET + (Globals.usableHeight - _loc3_.height) / 2;
            _loc3_.x = _loc2_ == 0 ? Globals.MARGIN_X * 2 : buttons[_loc2_ - 1].x + buttons[_loc2_ - 1].width + _loc4_;
            _loc2_++;
         }
         enabled = true;
      }
      
      override protected function clickButtonHandler(param1:Event) : void
      {
         var _loc2_:ModalDialogue = null;
         this.selectedSlot = buttons.indexOf(param1.target);
         if(SavesManager.games[this.selectedSlot])
         {
            _loc2_ = new ModalDialogue(CopyManager.getCopy("areYouSure"),CopyManager.getCopy("overwriteSave"),[CopyManager.getCopy("ok"),CopyManager.getCopy("cancel")]);
            Main.instance.addModal(_loc2_);
            _loc2_.addEventListener(ModalDialogue.MAKE_CHOICE,this.makeModalChoiceHandler);
         }
         else
         {
            this.makeGame();
         }
      }
      
      private function makeModalChoiceHandler(param1:IntEvent) : void
      {
         Main.instance.removeModal(ModalDialogue(param1.target));
         if(param1.num == 0)
         {
            this.makeGame();
         }
      }
      
      private function makeGame() : void
      {
         this.pleaseWait = new PleaseWaitModal(CopyManager.getCopy("pleaseWait"),"building game",[]);
         Main.instance.addModal(this.pleaseWait);
         BudgetEventProxy.addEventListener(GameEngine.GAME_MADE,this.showSelect);
         var _loc1_:Game = GameEngine.makeGame();
      }
      
      private function showSelect(param1:Object = null) : void
      {
         BudgetEventProxy.removeEventListener(GameEngine.GAME_MADE,this.showSelect);
         Main.instance.removeModal(this.pleaseWait);
         this.pleaseWait = null;
         SavesManager.games[this.selectedSlot] = Main.currentGame;
         Main.currentGame.slotNumber = this.selectedSlot;
         Main.instance.showScreen(Screen.SELECT_TEAM_SCREEN);
      }
   }
}

