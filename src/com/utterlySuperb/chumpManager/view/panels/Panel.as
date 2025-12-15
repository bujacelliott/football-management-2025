package com.utterlySuperb.chumpManager.view.panels
{
   import com.utterlySuperb.chumpManager.model.dataObjects.Game;
   import com.utterlySuperb.chumpManager.view.modals.TutorialPanel;
   import com.utterlySuperb.chumpManager.view.ui.buttons.ChumpButton;
   import com.utterlySuperb.events.BudgetEventProxy;
   import com.utterlySuperb.text.TextHelper;
   import com.utterlySuperb.ui.ModalDialogue;
   import com.utterlySuperb.ui.buttons.GenericButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.BevelFilter;
   import flash.filters.DropShadowFilter;
   import flash.text.TextField;
   
   public class Panel extends Sprite
   {
      
      protected var titleTF:TextField;
      
      protected var buttons:Array;
      
      protected var tutorialStr:String;
      
      public var boxWidth:int;
      
      public var boxHeight:int;
      
      public function Panel()
      {
         super();
         this.tutorialStr = "";
         this.buttons = [];
         addEventListener(Event.ADDED_TO_STAGE,this.addedToStage);
      }
      
      private function addedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.addedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.removedFromStage);
         addEventListener(MouseEvent.ROLL_OVER,this.rollOverPanelHandler);
         BudgetEventProxy.addEventListener(Game.DATA_CHANGED,this.update);
         this.init();
      }
      
      private function rollOverPanelHandler(param1:MouseEvent) : void
      {
         var _loc2_:TutorialPanel = null;
         if(this.tutorialStr.length > 0)
         {
            if(TutorialPanel.shouldShow(this.tutorialStr))
            {
               _loc2_ = new TutorialPanel(this.tutorialStr,"",[]);
               Main.instance.addModal(_loc2_);
            }
         }
      }
      
      private function removedFromStage(param1:Event) : void
      {
         var _loc2_:GenericButton = null;
         removeEventListener(Event.REMOVED_FROM_STAGE,this.removedFromStage);
         BudgetEventProxy.removeEventListener(Game.DATA_CHANGED,this.update);
         this.disable();
         for each(_loc2_ in this.buttons)
         {
            _loc2_.removeEventListener(GenericButton.BUTTON_CLICK,this.clickButtonHandler);
            _loc2_.removeEventListener(GenericButton.BUTTON_OVER,this.overButtonHandler);
            _loc2_.removeEventListener(GenericButton.BUTTON_OUT,this.outButtonHandler);
         }
         removeEventListener(MouseEvent.ROLL_OVER,this.rollOverPanelHandler);
         this.cleanUp();
      }
      
      protected function makeTitle(param1:String, param2:int = 0, param3:int = 0) : void
      {
         if(Boolean(this.titleTF) && contains(this.titleTF))
         {
            removeChild(this.titleTF);
         }
         this.titleTF = new TextField();
         TextHelper.doTextField2(this.titleTF,Styles.HEADER_FONT,Styles.HEADER_FONT_SIZE,Styles.HEADER_FONT_COLOR0);
         this.titleTF.htmlText = param1;
         this.titleTF.filters = [new DropShadowFilter(4,45,0,0.9,5,5)];
         TextHelper.fitTextField(this.titleTF);
         addChild(this.titleTF);
         this.titleTF.x = param2;
         this.titleTF.y = param3;
      }
      
      protected function addTextButton(param1:String, param2:int, param3:int, param4:String = "") : ChumpButton
      {
         var _loc5_:ChumpButton = ChumpButton.getButton(param4);
         _loc5_.setText(param1);
         _loc5_.x = param2;
         _loc5_.y = param3;
         this.buttons.push(_loc5_);
         _loc5_.addEventListener(GenericButton.BUTTON_CLICK,this.clickButtonHandler);
         _loc5_.addEventListener(GenericButton.BUTTON_OVER,this.overButtonHandler);
         _loc5_.addEventListener(GenericButton.BUTTON_OUT,this.outButtonHandler);
         addChild(_loc5_);
         return _loc5_;
      }
      
      protected function addButton(param1:GenericButton) : void
      {
         this.buttons.push(param1);
         param1.addEventListener(GenericButton.BUTTON_CLICK,this.clickButtonHandler);
         param1.addEventListener(GenericButton.BUTTON_OVER,this.overButtonHandler);
         param1.addEventListener(GenericButton.BUTTON_OUT,this.outButtonHandler);
         addChild(param1);
      }
      
      protected function removeButton(param1:GenericButton) : void
      {
         var _loc2_:int = int(this.buttons.indexOf(param1));
         if(_loc2_ >= 0)
         {
            this.buttons.splice(param1,1);
         }
         if(contains(param1))
         {
            removeChild(param1);
         }
         param1.removeEventListener(GenericButton.BUTTON_CLICK,this.clickButtonHandler);
         param1.removeEventListener(GenericButton.BUTTON_OVER,this.overButtonHandler);
         param1.removeEventListener(GenericButton.BUTTON_OUT,this.outButtonHandler);
         param1.deactivate();
      }
      
      protected function removeAllButtons() : void
      {
         while(this.buttons.length > 0)
         {
            this.removeButton(this.buttons[0]);
         }
      }
      
      protected function addTextField(param1:int, param2:int, param3:int = 120, param4:Boolean = false, param5:String = "left") : TextField
      {
         var _loc6_:TextField = new TextField();
         TextHelper.doTextField2(_loc6_,Styles.MAIN_FONT,Styles.COPY_FONT_SIZE,Styles.COPY_FONT_COLOR0,{
            "multiline":param4,
            "wordWrap":param4,
            "align":param5,
            "leading":-2
         });
         addChild(_loc6_);
         _loc6_.x = param1;
         _loc6_.y = param2;
         _loc6_.width = param3;
         return _loc6_;
      }
      
      public function makeBox(param1:int, param2:int, param3:int = 0, param4:int = 0, param5:Number = 16777215, param6:Number = 1118566, param7:Number = 0.8, param8:int = 20) : BGPanel
      {
         var _loc9_:BGPanel = new BGPanel(param1,param2,param5,param6,param7,param8);
         _loc9_.x = param3;
         _loc9_.y = param4;
         addChild(_loc9_);
         _loc9_.filters = [new BevelFilter(3,45,16777215,0.6,0,0.6),new DropShadowFilter(10,45,0,0.8)];
         this.boxWidth = param1;
         this.boxHeight = param2;
         return _loc9_;
      }
      
      protected function makeTextLine(param1:String, param2:String, param3:Boolean = true) : String
      {
         var _loc4_:String = param3 ? "<br>" : "";
         return _loc4_ + ("<font color=\'" + Styles.COPY_FONT_COLOR1_STRING + "\'>" + param1 + "</font>" + param2);
      }
      
      protected function outButtonHandler(param1:Event) : void
      {
      }
      
      protected function overButtonHandler(param1:Event) : void
      {
      }
      
      protected function clickButtonHandler(param1:Event) : void
      {
      }
      
      public function enable() : void
      {
         var _loc1_:GenericButton = null;
         for each(_loc1_ in this.buttons)
         {
            _loc1_.activate();
         }
      }
      
      public function disable() : void
      {
         var _loc1_:GenericButton = null;
         for each(_loc1_ in this.buttons)
         {
            _loc1_.deactivate();
         }
      }
      
      protected function init() : void
      {
      }
      
      protected function update(param1:Object = null) : void
      {
      }
      
      protected function get topY() : int
      {
         return this.titleTF ? int(this.titleTF.textHeight + 10) : 0;
      }
      
      protected function addSimplyModal(param1:ModalDialogue) : void
      {
         Main.instance.addModal(param1);
         param1.addEventListener(ModalDialogue.MAKE_CHOICE,this.removeSimpleDialogue);
      }
      
      private function removeSimpleDialogue(param1:Event) : void
      {
         var _loc2_:ModalDialogue = param1.target as ModalDialogue;
         Main.instance.removeModal(_loc2_);
         _loc2_.addEventListener(ModalDialogue.MAKE_CHOICE,this.removeSimpleDialogue);
      }
      
      protected function cleanUp() : void
      {
         this.disable();
      }
   }
}

