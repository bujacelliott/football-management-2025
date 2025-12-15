package com.utterlySuperb.chumpManager.view.modals
{
   import com.utterlySuperb.chumpManager.engine.TransfersEngine;
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.view.ui.widgets.Slider;
   import com.utterlySuperb.ui.ModalDialogue;
   import com.utterlySuperb.ui.dropDown.DropDown;
   import flash.display.Sprite;
   
   public class PlayerOfferBox extends ModalDialogue
   {
      
      private var transferFeeSlider:Slider;
      
      private var salaryOffered:Slider;
      
      private var contractLengthDD:DropDown;
      
      public var needsTransfer:Boolean;
      
      public function PlayerOfferBox(param1:String, param2:String, param3:Array, param4:Boolean = true)
      {
         this.needsTransfer = param4;
         super(param1,param2,param3);
      }
      
      override protected function makeBox(param1:String, param2:String, param3:Array) : void
      {
         box = new Sprite();
         addChild(box);
         makeTitle(param1);
         makeCopy(param2);
         if(this.needsTransfer)
         {
            this.transferFeeSlider = new Slider();
            box.addChild(this.transferFeeSlider);
            this.transferFeeSlider.y = box.height + 5;
            this.transferFeeSlider.setTitle(CopyManager.getCopy("feeOffered"));
            this.transferFeeSlider.jump = 100000;
            this.transferFeeSlider.setSize(50000,Math.min(TransfersEngine.MAX_TRANSFER,Main.currentGame.clubCash),200);
            this.transferFeeSlider.activate();
         }
         makeButtons(param3);
         makeBoxGraphics();
      }
      
      public function getTransferFee() : int
      {
         return this.transferFeeSlider ? int(this.transferFeeSlider.amount) : 0;
      }
      
      public function getContractLength() : int
      {
         return this.contractLengthDD.selectedNum + 1;
      }
   }
}

