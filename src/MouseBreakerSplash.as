package
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol122")]
   public class MouseBreakerSplash extends MovieClip
   {
      
      public static const FINISH_SPLASH:String = "finishSplash";
      
      public var doneTimer:Boolean = true;
      
      public var doneAnimation:Boolean = false;
      
      private var stayTime:int;
      
      private var bgColour:Number;
      
      public var mc:MovieClip;
      
      public function MouseBreakerSplash(param1:Number = 13056, param2:int = 0)
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,init);
         this.bgColour = param1;
         this.stayTime = param2;
      }
      
      private function init(param1:Event) : void
      {
         var _loc2_:Timer = null;
         removeEventListener(Event.ADDED_TO_STAGE,init);
         graphics.beginFill(bgColour);
         graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
         mc = new mb_intro();
         addChild(mc);
         mc.x = stage.stageWidth / 2;
         mc.y = stage.stageHeight / 2;
         mc.addEventListener(Event.COMPLETE,finishAnimationHandler);
         if(stayTime > 0)
         {
            doneTimer = false;
            _loc2_ = new Timer(stayTime,1);
            _loc2_.addEventListener(TimerEvent.TIMER_COMPLETE,finishTimerHandler);
            _loc2_.start();
         }
      }
      
      private function finishTimerHandler(param1:TimerEvent) : void
      {
         param1.target.removeEventListener(TimerEvent.TIMER_COMPLETE,finishTimerHandler);
         doneTimer = true;
         if(doneAnimation)
         {
            dispatchEvent(new Event(FINISH_SPLASH));
         }
      }
      
      private function finishAnimationHandler(param1:Event) : void
      {
         mc.removeEventListener(Event.COMPLETE,finishAnimationHandler);
         doneAnimation = true;
         if(doneTimer)
         {
            dispatchEvent(new Event(FINISH_SPLASH));
         }
      }
   }
}

