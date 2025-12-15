package com.utterlySuperb.chumpManager.view.ui
{
   import com.utterlySuperb.text.TextHelper;
   import com.utterlySuperb.ui.Checkbox;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class FilterPositionCheck extends Sprite
   {
      
      private var tf:TextField;
      
      private var checkbox:Checkbox;
      
      public function FilterPositionCheck()
      {
         super();
         this.tf = new TextField();
         TextHelper.doTextField2(this.tf,Styles.HEADER_FONT,12,16777215);
         addChild(this.tf);
         this.tf.mouseEnabled = false;
         this.tf.text = "hello";
         this.checkbox = new FilterCheckbox();
         addChild(this.checkbox);
         this.checkbox.y = this.tf.textHeight + 10;
         this.tf.text = "";
      }
      
      public function setText(param1:String) : void
      {
         this.tf.htmlText = param1.toUpperCase();
         this.tf.width = this.tf.textWidth + 5;
         this.tf.x = -int(this.tf.textWidth / 2);
      }
      
      public function activate() : void
      {
         this.checkbox.activate();
         this.checkbox.addEventListener(Checkbox.CHECK_CLICKED,this.boxClickedHandler);
      }
      
      public function deactivate() : void
      {
         this.checkbox.deactivate();
         this.checkbox.removeEventListener(Checkbox.CHECK_CLICKED,this.boxClickedHandler);
      }
      
      private function boxClickedHandler(param1:Event) : void
      {
         dispatchEvent(new Event(Checkbox.CHECK_CLICKED));
      }
      
      public function isChecked() : Boolean
      {
         return this.checkbox.ticked;
      }
   }
}

