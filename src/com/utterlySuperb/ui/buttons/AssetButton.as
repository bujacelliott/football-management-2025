package com.utterlySuperb.ui.buttons
{
   import com.greensock.TweenLite;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class AssetButton extends GenericButton
   {
      
      public static const LEFT:String = "left";
      
      public static const RIGHT:String = "right";
      
      public static const CENTER:String = "center";
      
      private var asset:DisplayObject;
      
      public function AssetButton(param1:DisplayObject, param2:String = "center")
      {
         super();
         this.asset = param1;
         addChild(param1);
         if(param2 == CENTER)
         {
            param1.x = -param1.width / 2;
            param1.y = -param1.height / 2;
         }
         else if(param2 == RIGHT)
         {
            param1.x = -param1.width;
         }
      }
      
      override protected function rollOver(param1:MouseEvent) : void
      {
         TweenLite.to(this,0.3,{
            "scaleX":1.1,
            "scaleY":1.1
         });
      }
      
      override protected function rollOut(param1:MouseEvent) : void
      {
         TweenLite.to(this,0.3,{
            "scaleX":1,
            "scaleY":1
         });
      }
      
      override protected function click(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(GenericButton.BUTTON_CLICK));
      }
   }
}

