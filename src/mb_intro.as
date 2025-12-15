package
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol158")]
   public dynamic class mb_intro extends MovieClip
   {
      
      public var exp:MovieClip;
      
      public function mb_intro()
      {
         super();
         addFrameScript(207,frame208);
      }
      
      internal function frame208() : *
      {
         stop();
         dispatchEvent(new Event(Event.COMPLETE));
      }
   }
}

