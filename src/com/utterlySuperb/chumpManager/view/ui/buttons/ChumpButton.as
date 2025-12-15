package com.utterlySuperb.chumpManager.view.ui.buttons
{
   import com.utterlySuperb.text.TextHelper;
   import com.utterlySuperb.ui.buttons.TextButton;
   import flash.text.TextField;
   
   public class ChumpButton extends TextButton
   {
      
      public static const SMALL_BUTTON:String = "smallButton";
      
      public static const MEDIUM_BUTTON:String = "mediumButton";
      
      public static const ASSET_BUTTON:String = "assetButton";
      
      public function ChumpButton()
      {
         super();
      }
      
      public static function getButton(param1:String) : ChumpButton
      {
         var _loc2_:ChumpButton = null;
         switch(param1)
         {
            case SMALL_BUTTON:
               _loc2_ = new SmallButton();
               break;
            case MEDIUM_BUTTON:
               _loc2_ = new MediumButton("",160);
               break;
            case ASSET_BUTTON:
               _loc2_ = new ChumpAssetButton("",200);
               break;
            default:
               _loc2_ = new ChumpTextButton();
         }
         return _loc2_;
      }
      
      override protected function makeTextField() : void
      {
         tf = new TextField();
         addChild(tf);
         TextHelper.doTextField2(tf,Styles.BUTTON_FONT,Styles.BUTTON_FONT_SIZE,Styles.BUTTON_FONT_COLOR);
      }
      
      override public function setText(param1:String) : void
      {
         super.setText(param1);
      }
      
      public function centerX() : void
      {
         x = int((Globals.GAME_WIDTH - width) / 2);
      }
   }
}

