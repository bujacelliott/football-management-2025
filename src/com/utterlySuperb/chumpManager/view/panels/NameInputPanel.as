package com.utterlySuperb.chumpManager.view.panels
{
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.text.TextHelper;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.text.TextFormatAlign;
   
   public class NameInputPanel extends Panel
   {
      
      private var nameInput:TextField;
      
      public function NameInputPanel()
      {
         super();
      }
      
      override protected function init() : void
      {
         var _loc1_:TextField = new TextField();
         TextHelper.doTextField2(_loc1_,Styles.HEADER_FONT,28,16711680);
         _loc1_.htmlText = CopyManager.getCopy("enterName");
         addChild(_loc1_);
         _loc1_.x = -_loc1_.textWidth / 2;
         this.nameInput = new TextField();
         TextHelper.doTextField2(this.nameInput,Styles.MAIN_FONT,18,16777215,{
            "align":TextFormatAlign.CENTER,
            "type":TextFieldType.INPUT,
            "autoSize":TextFieldAutoSize.NONE
         });
         this.nameInput.width = 300;
         this.nameInput.height = 30;
         this.nameInput.border = true;
         this.nameInput.x = -this.nameInput.width / 2;
         this.nameInput.y = 40;
         addChild(this.nameInput);
      }
   }
}

