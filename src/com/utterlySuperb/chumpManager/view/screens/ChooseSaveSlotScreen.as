package com.utterlySuperb.chumpManager.view.screens
{
import com.utterlySuperb.chumpManager.engine.GameEngine;
import com.utterlySuperb.chumpManager.engine.SavesManager;
import com.utterlySuperb.chumpManager.model.CopyManager;
import com.utterlySuperb.chumpManager.model.dataObjects.Game;
   import com.utterlySuperb.chumpManager.view.modals.PleaseWaitModal;
import com.utterlySuperb.chumpManager.view.panels.BGPanel;
import com.utterlySuperb.chumpManager.view.ui.buttons.SaveSlotBadge;
import com.utterlySuperb.chumpManager.view.ui.buttons.SaveSlotButton;
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
         var _loc6_:SaveSlotBadge = null;
         var _loc7_:SaveSlotButton = null;
         super();
         makeBackButton();
         Main.instance.backOverride = Screen.START_SCREEN;
         SavesManager.getSavedStates();
         var _loc1_:BGPanel = new BGPanel(180,50,16777215,0x0F3B2E,0.9,8);
         _loc1_.x = (Globals.GAME_WIDTH - _loc1_.width) / 2;
         _loc1_.y = Globals.HEADER_OFFSET + 20;
         addChild(_loc1_);
         var _loc2_:TextField = new TextField();
         TextHelper.doTextField2(_loc2_,Styles.HEADER_FONT,24,16777215);
         _loc2_.htmlText = "New";
         _loc2_.x = _loc1_.x + (_loc1_.width - _loc2_.textWidth) / 2;
         _loc2_.y = _loc1_.y + 10;
         addChild(_loc2_);
         var _loc3_:int = 50;
         var _loc4_:int = 240;
         var _loc5_:int = 10;
         var _loc8_:int = _loc3_ + _loc5_ + _loc4_;
         var _loc9_:int = 40;
         var _loc10_:int = _loc8_ * 2 + _loc9_;
         var _loc11_:int = (Globals.GAME_WIDTH - _loc10_) / 2;
         var _loc12_:int = _loc1_.y + _loc1_.height + 30;
         var _loc13_:int = 20;
         var _loc14_:int = 0;
         while(_loc14_ < 6)
         {
            _loc6_ = new SaveSlotBadge(_loc3_,_loc3_);
            _loc6_.setText((_loc14_ + 1).toString());
            _loc7_ = new SaveSlotButton(_loc4_,_loc3_);
            _loc7_.setGame(SavesManager.games[_loc14_],_loc14_);
            buttons.push(_loc7_);
            addChild(_loc6_);
            addChild(_loc7_);
            var _loc15_:int = _loc14_ % 2;
            var _loc16_:int = int(_loc14_ / 2);
            var _loc17_:int = _loc11_ + _loc15_ * (_loc8_ + _loc9_);
            var _loc18_:int = _loc12_ + _loc16_ * (_loc3_ + _loc13_);
            _loc6_.x = _loc17_;
            _loc6_.y = _loc18_;
            _loc7_.x = _loc17_ + _loc3_ + _loc5_;
            _loc7_.y = _loc18_;
            _loc14_++;
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

