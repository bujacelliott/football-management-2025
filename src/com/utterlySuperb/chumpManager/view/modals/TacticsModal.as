package com.utterlySuperb.chumpManager.view.modals
{
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.Formation;
   import com.utterlySuperb.chumpManager.view.ui.widgets.Slider;
   import com.utterlySuperb.events.IntEvent;
   import com.utterlySuperb.text.TextHelper;
   import com.utterlySuperb.ui.ModalDialogue;
   import com.utterlySuperb.ui.dropDown.DropDown;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class TacticsModal extends ModalDialogue
   {
      
      public static const CHANGE_FORMATION:String = "changeFormation";
      
      private var tacticsDropDown:DropDown;
      
      private var attackingSlider:Slider;
      
      public function TacticsModal(... rest)
      {
         super(CopyManager.getCopy("tacticsOptions"),CopyManager.getCopy("tacticsOptionsBody"),[CopyManager.getCopy("close")]);
      }
      
      override protected function makeBox(param1:String, param2:String, param3:Array) : void
      {
         var _loc5_:int = 0;
         fadeDelay = 0;
         fadeSpeed = 0.3;
         box = new Sprite();
         addChild(box);
         makeTitle(param1);
         makeCopy(param2);
         var _loc4_:TextField = new TextField();
         TextHelper.doTextField2(_loc4_,Styles.MAIN_FONT,Styles.COPY_FONT_SIZE,Styles.COPY_FONT_COLOR0,{
            "multiline":true,
            "wordWrap":true
         });
         _loc4_.htmlText = CopyManager.getCopy("setFormation");
         _loc4_.width = 300;
         _loc4_.height = copyTF.textHeight + 10;
         _loc4_.y = box.height + 10;
         box.addChild(_loc4_);
         this.tacticsDropDown = new DropDown(Styles.getDropdownObject());
         this.tacticsDropDown.easyMake();
         while(_loc5_ < Formation.FORMATIONS.length)
         {
            this.tacticsDropDown.addItem(Formation.FORMATIONS[_loc5_]);
            _loc5_++;
         }
         this.tacticsDropDown.y = box.height + 14;
         box.addChild(this.tacticsDropDown);
         this.tacticsDropDown.addEventListener(DropDown.DROP_DOWN_CLICK,this.changeFormationHandler);
         this.tacticsDropDown.enable();
         _loc4_ = new TextField();
         TextHelper.doTextField2(_loc4_,Styles.MAIN_FONT,Styles.COPY_FONT_SIZE,Styles.COPY_FONT_COLOR0,{
            "multiline":true,
            "wordWrap":true
         });
         _loc4_.htmlText = CopyManager.getCopy("howAttacking");
         _loc4_.width = 300;
         _loc4_.height = copyTF.textHeight + 10;
         _loc4_.y = box.height + 20;
         box.addChild(_loc4_);
         this.attackingSlider = new Slider();
         this.attackingSlider.setSize(0,10);
         this.attackingSlider.x = 5;
         this.attackingSlider.y = box.height;
         this.attackingSlider.amountsCopy = [CopyManager.getCopy("veryDefensive"),CopyManager.getCopy("defensive"),CopyManager.getCopy("balanced"),CopyManager.getCopy("attacking"),CopyManager.getCopy("veryAttacking")];
         box.addChild(this.attackingSlider);
         this.attackingSlider.activate();
         makeButtons(param3);
         makeBoxGraphics();
      }
      
      private function changeFormationHandler(param1:Event) : void
      {
         dispatchEvent(new IntEvent(CHANGE_FORMATION,this.tacticsDropDown.selectedNum));
      }
      
      override protected function makeChoiceHandler(param1:Event) : void
      {
         this.attackingSlider.deactivate();
         this.tacticsDropDown.removeEventListener(DropDown.DROP_DOWN_CLICK,this.changeFormationHandler);
         this.tacticsDropDown.disableButton();
         super.makeChoiceHandler(param1);
      }
      
      public function get attackingScore() : int
      {
         return this.attackingSlider.amount;
      }
      
      public function set attackingScore(param1:int) : void
      {
         this.attackingSlider.setFilters(param1);
      }
   }
}

