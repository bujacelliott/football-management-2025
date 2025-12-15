package com.utterlySuperb.ui
{
   import com.utterlySuperb.ui.buttons.GenericButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class Checkbox extends GenericButton
   {
      
      public static const CHECK_CLICKED:String = "checkboxClicked";
      
      public var tick:Sprite;
      
      public function Checkbox()
      {
         super();
      }
      
      public function set ticked(param1:Boolean) : void
      {
         this.tick.visible = param1;
      }
      
      public function get ticked() : Boolean
      {
         return this.tick.visible;
      }
      
      override protected function click(param1:MouseEvent) : void
      {
         this.ticked = !this.ticked;
         super.click(param1);
         dispatchEvent(new Event(CHECK_CLICKED));
      }
   }
}

