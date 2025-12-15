package com.utterlySuperb.chumpManager.view.modals
{
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.text.TextHelper;
   import com.utterlySuperb.ui.ModalDialogue;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   
   public class SubmitScoreModal extends ModalDialogue
   {
      
      public var inputField:TextField;
      
      public function SubmitScoreModal(... rest)
      {
         super(CopyManager.getCopy("submitScore"),CopyManager.getCopy("enterName"),[CopyManager.getCopy("ok"),CopyManager.getCopy("cancel")]);
      }
      
      override protected function makeBox(param1:String, param2:String, param3:Array) : void
      {
         box = new Sprite();
         addChild(box);
         makeTitle(param1);
         makeCopy(param2);
         this.inputField = new TextField();
         TextHelper.doTextField2(this.inputField,Styles.HEADER_FONT,14,Styles.COPY_FONT_COLOR0,{
            "type":TextFieldType.INPUT,
            "mouseEnabled":true,
            "selectable":true,
            "autoSize":TextFieldAutoSize.NONE
         });
         this.inputField.text = "";
         this.inputField.width = 200;
         this.inputField.height = 25;
         this.inputField.maxChars = 18;
         this.inputField.borderColor = 16777215;
         this.inputField.border = true;
         this.inputField.restrict = "a-z A-Z";
         this.inputField.width = 300;
         this.inputField.htmlText = "2";
         this.inputField.height = this.inputField.textHeight + 5;
         this.inputField.htmlText = "";
         box.addChild(this.inputField);
         this.inputField.y = copyTF.y + copyTF.textHeight + 15;
         Main.instance.stage.focus = copyTF;
         makeButtons(param3);
         makeBoxGraphics();
      }
      
      override protected function makeChoiceHandler(param1:Event) : void
      {
         if(buttons.indexOf(param1.target) == 0 && !TextHelper.stringOK(this.inputField.text))
         {
            copyTF.textColor = 16711680;
         }
         else
         {
            super.makeChoiceHandler(param1);
         }
      }
   }
}

