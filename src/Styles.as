package
{
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import flash.text.Font;
   
   public class Styles
   {
      
      private static var arialBlack:Class = Styles_arialBlack;
      
      private static var arial:Class = Styles_arial;
      
      public static const MAIN_FONT:String = "Arial";
      
      public static const BUTTON_FONT:String = "Arial Black";
      
      public static const HEADER_FONT:String = "Arial Black";
      
      public static const LIST_FONT:String = "Arial";
      
      public static const HEADER_FONT_SIZE:int = 29;
      
      public static const LIST_FONT_SIZE:int = 12;
      
      public static const COPY_FONT_SIZE:int = 14;
      
      public static const BUTTON_FONT_SIZE:int = 14;
      
      public static const HEADER_FONT_COLOR0:Number = 16777215;
      
      public static const COPY_FONT_COLOR0:Number = 16777215;
      
      public static const COPY_FONT_COLOR1:Number = 8239190;
      
      public static const PLAYER_CLUB_COLOR:Number = 13369412;
      
      public static const COPY_FONT_COLOR0_STRING:String = "#FFFFFF";
      
      public static const COPY_FONT_COLOR1_STRING:String = "#7DB856";
      
      public static const COPY_FONT_COLOR2_STRING:String = "#A8CF8D";
      
      public static const HEADER_ITEM_COL:Number = 10079487;
      
      public static const BUTTON_FONT_COLOR:Number = 16777215;
      
      public static const DROP_DOWN_OB:Object = {
         "font":Styles.MAIN_FONT,
         "width":140,
         "numRows":8
      };
      
      public function Styles()
      {
         super();
      }
      
      public static function getDropdownObject(param1:int = 140, param2:int = 8) : Object
      {
         return {
            "font":Styles.HEADER_FONT,
            "width":param1,
            "numRows":param2,
            "prompt":CopyManager.getCopy("pleaseSelect")
         };
      }
      
      public static function initFonts() : void
      {
         Font.registerFont(arialBlack);
         Font.registerFont(arial);
      }
   }
}

