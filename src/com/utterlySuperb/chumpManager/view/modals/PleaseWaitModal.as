package com.utterlySuperb.chumpManager.view.modals
{
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.ui.ModalDialogue;
   import flash.display.Sprite;
   
   public class PleaseWaitModal extends ModalDialogue
   {
      
      public function PleaseWaitModal(param1:String, param2:String, param3:Array)
      {
         param2 = param2 + "<br><br><font face=\'" + Styles.HEADER_FONT + "\'>" + CopyManager.getCopy("gameTip") + "</font><br>" + CopyManager.getMatchTip();
         super(CopyManager.getCopy("pleaseWait"),param2,param3);
      }
      
      override protected function makeBox(param1:String, param2:String, param3:Array) : void
      {
         fadeDelay = 0;
         fadeSpeed = 0.3;
         box = new Sprite();
         addChild(box);
         makeTitle(param1);
         makeCopy(param2);
         var _loc4_:Sprite = new PleaseWaitSpinner();
         _loc4_.x = box.width / 2;
         _loc4_.y = box.height + 10 + _loc4_.height / 2;
         box.addChild(_loc4_);
         makeBoxGraphics();
      }
   }
}

