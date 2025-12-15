package com.utterlySuperb.chumpManager.view.modals
{
   import com.utterlySuperb.chumpManager.engine.TransfersEngine;
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.Club;
   import com.utterlySuperb.chumpManager.model.dataObjects.Game;
   import com.utterlySuperb.chumpManager.model.dataObjects.Player;
   import com.utterlySuperb.chumpManager.view.ui.buttons.ChumpButton;
   import com.utterlySuperb.events.BudgetEventProxy;
   import com.utterlySuperb.events.IntEvent;
   import com.utterlySuperb.text.TextHelper;
   import com.utterlySuperb.ui.ModalDialogue;
   import com.utterlySuperb.ui.buttons.GenericButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class SellPlayerBox extends ModalDialogue
   {
      
      private var player:Player;
      
      private var buyClubs:Array;
      
      private var acceptButtons:Vector.<ChumpButton>;
      
      public function SellPlayerBox(param1:String, param2:String, param3:Array, param4:Player)
      {
         this.player = param4;
         super(CopyManager.getCopy("sellPlayer"),CopyManager.getCopy("trySellPlayer").replace("{playerName}",param4.name),[CopyManager.getCopy("close")]);
      }
      
      override protected function makeBox(param1:String, param2:String, param3:Array) : void
      {
         var _loc5_:Club = null;
         var _loc6_:TextField = null;
         var _loc7_:String = null;
         var _loc8_:ChumpButton = null;
         box = new Sprite();
         addChild(box);
         makeTitle(param1);
         makeCopy(param2);
         this.buyClubs = new Array();
         this.acceptButtons = new Vector.<ChumpButton>();
         var _loc4_:int = 0;
         while(_loc4_ < 3)
         {
            _loc5_ = TransfersEngine.getInterestedClub(this.player,this.buyClubs);
            if(_loc5_)
            {
               this.buyClubs.push(_loc5_);
               _loc6_ = new TextField();
               TextHelper.doTextField2(_loc6_,Styles.MAIN_FONT,14,16777215);
               _loc7_ = CopyManager.getCopy("clubOfferForPlayer").replace("{clubName}",_loc5_.name).replace("{amount}",TextHelper.prettifyNumber(TransfersEngine.getPlayerOffer(_loc5_,this.player)));
               _loc6_.htmlText = _loc7_;
               _loc8_ = new ChumpButton();
               _loc8_.setText(CopyManager.getCopy("accept"));
               _loc8_.activate();
               _loc8_.addEventListener(GenericButton.BUTTON_CLICK,this.acceptOfferHandler);
               this.acceptButtons.push(_loc8_);
               _loc6_.y = box.height + 9;
               _loc8_.y = _loc6_.y - 2;
               _loc8_.x = _loc6_.textWidth + 5;
               box.addChild(_loc6_);
               box.addChild(_loc8_);
            }
            _loc4_++;
         }
         makeButtons(param3);
         makeBoxGraphics();
      }
      
      private function acceptOfferHandler(param1:Event) : void
      {
         var _loc2_:Club = this.buyClubs[this.acceptButtons.indexOf(param1.target)];
         Main.currentGame.clubCash += TransfersEngine.getPlayerOffer(_loc2_,this.player);
         TransfersEngine.transferPlayer(this.player,_loc2_,Main.currentGame.playerClub);
         this.makeChoiceHandler(null);
         BudgetEventProxy.dispatchEvent(Game.DATA_CHANGED,null);
      }
      
      override protected function makeChoiceHandler(param1:Event) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < buttons.length)
         {
            buttons[_loc2_].removeEventListener(GenericButton.BUTTON_CLICK,this.makeChoiceHandler);
            buttons[_loc2_].deactivate();
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.acceptButtons.length)
         {
            this.acceptButtons[_loc2_].removeEventListener(GenericButton.BUTTON_CLICK,this.acceptOfferHandler);
            this.acceptButtons[_loc2_].deactivate();
            _loc2_++;
         }
         dispatchEvent(new IntEvent(MAKE_CHOICE,0));
      }
   }
}

