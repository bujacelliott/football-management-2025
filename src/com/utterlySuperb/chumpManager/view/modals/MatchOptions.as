package com.utterlySuperb.chumpManager.view.modals
{
   import com.utterlySuperb.chumpManager.engine.MatchEngine;
   import com.utterlySuperb.chumpManager.engine.SavesManager;
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.Game;
   import com.utterlySuperb.chumpManager.model.dataObjects.Settings;
   import com.utterlySuperb.chumpManager.view.ui.widgets.Slider;
   import com.utterlySuperb.events.BudgetEventProxy;
   import com.utterlySuperb.events.IntEvent;
   import com.utterlySuperb.text.TextHelper;
   import com.utterlySuperb.ui.Checkbox;
   import com.utterlySuperb.ui.ModalDialogue;
   import com.utterlySuperb.ui.dropDown.DropDown;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class MatchOptions extends ModalDialogue
   {
      
      private var speedSlider:Slider;
      
      private var checkBoxes:Vector.<Checkbox>;
      
      private var checkBoxsNames:Array = [MatchEngine.HALF_TIME,MatchEngine.GOAL,MatchEngine.INJURY,MatchEngine.RED_CARD,MatchEngine.YELLOW_CARD];
      
      private var infoShown:DropDown;
      
      public function MatchOptions(... rest)
      {
         super(CopyManager.getCopy("matchOptions"),CopyManager.getCopy("matchOptionsCopy"),[CopyManager.getCopy("close")]);
      }
      
      override protected function makeBox(param1:String, param2:String, param3:Array) : void
      {
         var _loc5_:TextField = null;
         box = new Sprite();
         addChild(box);
         makeTitle(param1);
         makeCopy(param2);
         var _loc4_:Settings = Main.instance.settings;
         this.speedSlider = new Slider();
         this.speedSlider.isCurrency = false;
         this.speedSlider.setTitle(CopyManager.getCopy("matchSpeed"));
         this.speedSlider.setSize(2,30);
         this.speedSlider.amountsCopy = [CopyManager.getCopy("verySlow"),CopyManager.getCopy("slow"),CopyManager.getCopy("medium"),CopyManager.getCopy("fast"),CopyManager.getCopy("veryFast")];
         this.speedSlider.setFilters(_loc4_.gameSpeed);
         this.speedSlider.x = 10;
         this.speedSlider.y = copyTF.y + copyTF.height + 7;
         box.addChild(this.speedSlider);
         this.speedSlider.activate();
         _loc5_ = new TextField();
         TextHelper.doTextField2(_loc5_,Styles.MAIN_FONT,Styles.COPY_FONT_SIZE,Styles.COPY_FONT_COLOR0,{
            "multiline":true,
            "wordWrap":true
         });
         _loc5_.htmlText = CopyManager.getCopy("matchOptionsAlertsCopy");
         _loc5_.width = 300;
         _loc5_.height = _loc5_.textHeight + 10;
         _loc5_.y = this.speedSlider.y + 40;
         box.addChild(_loc5_);
         this.checkBoxes = new Vector.<Checkbox>();
         var _loc6_:int = 0;
         while(_loc6_ < this.checkBoxsNames.length)
         {
            this.addCheckBox(CopyManager.getCopy(this.checkBoxsNames[_loc6_]),_loc4_.matchEvents[this.checkBoxsNames[_loc6_]]);
            _loc6_++;
         }
         _loc5_ = new TextField();
         TextHelper.doTextField2(_loc5_,Styles.MAIN_FONT,Styles.COPY_FONT_SIZE,Styles.COPY_FONT_COLOR0,{
            "multiline":true,
            "wordWrap":true
         });
         _loc5_.htmlText = CopyManager.getCopy("matchInfoShown");
         _loc5_.width = 300;
         _loc5_.height = _loc5_.textHeight + 10;
         _loc5_.y = box.height + 20;
         box.addChild(_loc5_);
         this.infoShown = new DropDown(Styles.getDropdownObject(300 - _loc5_.textWidth - 15,24));
         this.infoShown.easyMake();
         box.addChild(this.infoShown);
         this.infoShown.x = _loc5_.x + _loc5_.textWidth + 10;
         this.infoShown.y = _loc5_.y;
         this.infoShown.addItem(CopyManager.getCopy("fullInfo"));
         this.infoShown.addItem(CopyManager.getCopy("halfInfo"));
         this.infoShown.addItem(CopyManager.getCopy("minInfo"));
         this.infoShown.selectedNum = Main.instance.settings.matchFilter;
         this.infoShown.enable();
         makeButtons(param3);
         makeBoxGraphics();
      }
      
      private function addCheckBox(param1:String, param2:Boolean) : void
      {
         var _loc3_:Checkbox = new FilterCheckbox();
         _loc3_.ticked = param2;
         _loc3_.x = 10;
         var _loc4_:TextField = new TextField();
         TextHelper.doTextField2(_loc4_,Styles.MAIN_FONT,Styles.COPY_FONT_SIZE,Styles.COPY_FONT_COLOR0);
         _loc4_.htmlText = param1;
         _loc4_.x = 30;
         _loc3_.y = box.height + 25;
         _loc4_.y = _loc3_.y - 10;
         box.addChild(_loc3_);
         box.addChild(_loc4_);
         this.checkBoxes.push(_loc3_);
         _loc3_.activate();
      }
      
      override protected function makeChoiceHandler(param1:Event) : void
      {
         var _loc2_:Settings = Main.instance.settings;
         _loc2_.gameSpeed = int(this.speedSlider.amount);
         this.speedSlider.deactivate();
         var _loc3_:int = 0;
         while(_loc3_ < this.checkBoxes.length)
         {
            this.checkBoxes[_loc3_].deactivate();
            _loc2_.matchEvents[this.checkBoxsNames[_loc3_]] = this.checkBoxes[_loc3_].ticked;
            _loc3_++;
         }
         this.infoShown.disableButton();
         if(_loc2_.matchFilter != this.infoShown.selectedNum)
         {
            Main.currentGame.matchDetails.rebuildMessages = true;
            BudgetEventProxy.dispatchEvent(Game.DATA_CHANGED,null);
         }
         _loc2_.matchFilter = this.infoShown.selectedNum;
         SavesManager.saveSettings();
         dispatchEvent(new IntEvent(MAKE_CHOICE,buttons.indexOf(param1.target)));
      }
   }
}

