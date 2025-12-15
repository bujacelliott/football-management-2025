package
{
   import com.utterlySuperb.chumpManager.view.panels.universalPanels.StatusPanel;
   
   public class Globals
   {
      
      public static const GAME_WIDTH:int = 800;
      
      public static const GAME_HEIGHT:int = 600;
      
      public static const SAVE_VOLUME:int = 500000;
      
      public static const SAVE_VOLUME_OPTIONS:int = 1000;
      
      public static const MARGIN_X:int = 20;
      
      public static const MARGIN_Y:int = 20;
      
      public static const HEADER_OFFSET:int = 50;
      
      public static const VERSION_NUMBER:String = "v1.0.9";
      
      public function Globals()
      {
         super();
      }
      
      public static function get belowStatus() : int
      {
         return MARGIN_Y + StatusPanel.HEIGHT + MARGIN_Y;
      }
      
      public static function get usableHeight() : int
      {
         return GAME_HEIGHT - belowStatus - MARGIN_Y;
      }
   }
}

