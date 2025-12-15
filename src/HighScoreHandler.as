package
{
   import flash.events.*;
   import flash.net.*;
   
   public class HighScoreHandler
   {
      
      public function HighScoreHandler()
      {
         super();
      }
      
      public static function handleScoreEvent(param1:int, param2:String) : void
      {
         var _loc3_:URLRequest = new URLRequest("http://www.mousebreaker.com/games/ultimatefootballmanager/highscores_ultimatefootballmanager.php");
         var _loc4_:URLLoader = new URLLoader();
         var _loc5_:URLVariables = new URLVariables();
         _loc4_.addEventListener(Event.COMPLETE,handleLoadSuccessful);
         _loc4_.addEventListener(IOErrorEvent.IO_ERROR,handleLoadError);
         _loc4_.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
         _loc5_.score = param1;
         _loc5_.playerName = param2;
         _loc3_.method = URLRequestMethod.POST;
         _loc3_.data = _loc5_;
         _loc4_.load(_loc3_);
      }
      
      private static function securityErrorHandler(param1:SecurityErrorEvent) : void
      {
      }
      
      public static function handleLoadSuccessful(param1:Event) : void
      {
      }
      
      public static function handleLoadError(param1:IOErrorEvent) : void
      {
      }
   }
}

