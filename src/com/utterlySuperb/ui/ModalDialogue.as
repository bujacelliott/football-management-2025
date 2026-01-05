package com.utterlySuperb.ui
{
   import com.greensock.TweenLite;
   import com.utterlySuperb.chumpManager.view.ui.buttons.ModalButton;
   import com.utterlySuperb.events.IntEvent;
   import com.utterlySuperb.text.TextHelper;
   import com.utterlySuperb.ui.buttons.GenericButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.DropShadowFilter;
   import flash.text.TextField;
   
   public class ModalDialogue extends Sprite
   {
      
      public static var modalShowing:Boolean;
      
      public static const MAKE_CHOICE:String = "makeChoice";
      
      protected var titleTF:TextField;
      
      protected var copyTF:TextField;
      
      protected var buttons:Array;
      
      protected var box:Sprite;
      
      protected var buttonOffset:int = 0;
      
      protected var fadeSpeed:Number = 0.6;
      
      protected var fadeDelay:Number = 0.5;
      
      public function ModalDialogue(param1:String, param2:String, param3:Array)
      {
         super();
         this.makeBox(param1,param2,param3);
      }
      
      protected function makeBox(param1:String, param2:String, param3:Array) : void
      {
         this.box = new Sprite();
         addChild(this.box);
         this.makeTitle(param1);
         this.makeCopy(param2);
         this.makeButtons(param3);
         this.makeBoxGraphics();
      }
      
      protected function makeTitle(param1:String) : void
      {
         this.titleTF = new TextField();
         this.box.addChild(this.titleTF);
         TextHelper.doTextField2(this.titleTF,Styles.HEADER_FONT,18,Styles.HEADER_FONT_COLOR0);
         this.titleTF.htmlText = param1;
         this.titleTF.y = 10;
         TextHelper.fitTextField(this.titleTF);
      }
      
      protected function makeCopy(param1:String) : void
      {
         this.copyTF = new TextField();
         this.box.addChild(this.copyTF);
         TextHelper.doTextField2(this.copyTF,Styles.MAIN_FONT,Styles.COPY_FONT_SIZE,Styles.COPY_FONT_COLOR0,{
            "multiline":true,
            "wordWrap":true
         });
         this.copyTF.htmlText = param1;
         this.copyTF.width = 300;
         this.copyTF.height = this.copyTF.textHeight + 10;
         this.copyTF.y = this.titleTF.textHeight + 10;
      }
      
      protected function makeButtons(param1:Array) : void
      {
         var _loc3_:ModalButton = null;
         this.buttons = [];
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = new ModalButton();
            _loc3_.setText(param1[_loc2_]);
            _loc3_.y = this.box.height + 20 + this.buttonOffset;
            this.box.addChild(_loc3_);
            _loc3_.addEventListener(GenericButton.BUTTON_CLICK,this.makeChoiceHandler);
            _loc3_.activate();
            this.buttons.push(_loc3_);
            _loc2_++;
         }
      }
      
      protected function makeBoxGraphics() : void
      {
         this.box.graphics.beginFill(0x0d2f1b,0.9);
         this.box.graphics.lineStyle(2,16777215);
         this.box.graphics.drawRoundRect(-10,0,width + 20,height + 20,20,20);
         this.box.x = int(Globals.GAME_WIDTH / 2 - this.box.width / 2);
         this.box.y = int(Globals.GAME_HEIGHT / 2 - this.box.height / 2);
         graphics.beginFill(0,0);
         graphics.drawRect(0,0,Globals.GAME_WIDTH,Globals.GAME_HEIGHT + 50);
         filters = [new DropShadowFilter(10,45,0,0.8,7,7)];
         TweenLite.from(this.box,this.fadeSpeed,{
            "alpha":0,
            "delay":this.fadeDelay
         });
      }
      
      protected function remakeBox(param1:String, param2:String, param3:Array) : void
      {
         var _loc5_:ModalButton = null;
         this.box.graphics.clear();
         this.titleTF.htmlText = param1;
         TextHelper.fitTextField(this.titleTF);
         this.copyTF.htmlText = param2;
         this.copyTF.width = 300;
         this.copyTF.height = this.copyTF.textHeight + 10;
         this.copyTF.y = this.titleTF.textHeight + 10;
         this.buttons = [];
         var _loc4_:int = 0;
         while(_loc4_ < param3.length)
         {
            _loc5_ = new ModalButton();
            _loc5_.setText(param3[_loc4_]);
            _loc5_.y = this.box.height + 20;
            this.box.addChild(_loc5_);
            _loc5_.addEventListener(GenericButton.BUTTON_CLICK,this.makeChoiceHandler);
            _loc5_.activate();
            this.buttons.push(_loc5_);
            _loc4_++;
         }
         this.box.graphics.beginFill(0x0d2f1b,0.9);
         this.box.graphics.lineStyle(2,16777215);
         this.box.graphics.drawRoundRect(-10,0,this.box.width + 20,this.box.height + 20,20,20);
      }
      
      protected function makeChoiceHandler(param1:Event) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.buttons.length)
         {
            this.buttons[_loc2_].removeEventListener(GenericButton.BUTTON_CLICK,this.makeChoiceHandler);
            this.buttons[_loc2_].deactivate();
            _loc2_++;
         }
         dispatchEvent(new IntEvent(MAKE_CHOICE,this.buttons.indexOf(param1.target)));
      }
   }
}

